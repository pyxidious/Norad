import os
import io
import traceback
from pathlib import Path

import numpy as np
import matlab.engine
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array

# Configura FastAPI + CORS
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:4200"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Carica modello ML una volta
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "GOAT.h5")
model = load_model(MODEL_PATH, compile=False)

# Classi e dimensione input
class_names = [
    "Erlang/Rayleigh", "Gaussian", "Original", "Periodic",
    "Salt & Pepper", "Speckle", "Striping Horizontal",
    "Striping Vertical", "Uniform"
]
_, H, W, _ = model.input_shape

# Avvia MATLAB engine e imposta il path
eng = matlab.engine.start_matlab()
matlab_folder = Path(__file__).parent.parent / "Matlab" / "Codice"
matlab_path = str(matlab_folder.as_posix())
print(f"Adding MATLAB path: {matlab_path}")
eng.addpath(matlab_path, nargout=0)

# Mappa etichette modello → argomenti noiseSelector
label_map = {
    "Erlang/Rayleigh": "erlang_rayleigh",
    "Gaussian": "gaussian",
    "Original": "original",
    "Periodic": "periodic",
    "Salt & Pepper": "salt_pepper",
    "Speckle": "speckle",
    "Striping Horizontal": "striping_horizontal",
    "Striping Vertical": "striping_vertical",
    "Uniform": "uniform"
}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    img_matlab = load_img(io.BytesIO(contents))
    arr_matlab_np = img_to_array(img_matlab).astype(np.uint8)  # converti PIL Image in numpy array uint8

    img = load_img(io.BytesIO(contents), target_size=(H, W))
    arr = img_to_array(img).astype(np.uint8)  # formato immagine
    arr_norm = arr / 255.0
    arr_expanded = np.expand_dims(arr_norm, 0)

    # Predizione modello ML
    probs = model.predict(arr_expanded).flatten()
    top3 = np.argsort(probs)[-3:][::-1]
    top_label = class_names[top3[0]]
    matlab_label = label_map.get(top_label)

    matlab_output = None
    matlab_error_msg = None

    try:
        arr_matlab_np = img_to_array(img_matlab).astype(np.uint8)  # converti PIL Image in numpy array uint8
        matlab_output = eng.noiseSelector(arr_matlab_np, matlab_label, nargout=1)
    except Exception:
        matlab_error_msg = traceback.format_exc()
        print("Errore durante l'aesecuzione di MATLAB:")
        print(matlab_error_msg)

    # Qui matlab_output è la stringa base64, passala direttamente
    return {
        "predictions": [
            {"label": class_names[i], "confidence": float(probs[i])}
            for i in top3
        ],
        "matlab_output": matlab_output,  # base64 stringa direttamente
        "matlab_error": matlab_error_msg,
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
