import os
import io
import time
import traceback
from pathlib import Path

import numpy as np
import matlab.engine
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import tensorflow as tf
print(tf.__version__)
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array

# ========== CONFIGURAZIONE FASTAPI + CORS ==========
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:4200"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ========== CONFIGURAZIONI GLOBALI ==========
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "GOAT.h5")

model = None
eng = None

# ========== CLASSI MODELLO ==========
class_names = [
    "Erlang/Rayleigh", "Gaussian", "Original", "Periodic",
    "Salt & Pepper", "Speckle", "Striping Horizontal",
    "Striping Vertical", "Uniform"
]

# ========== PATH MATLAB ==========
matlab_folder = Path(__file__).parent.parent / "Matlab" / "Codice"
matlab_path = str(matlab_folder.as_posix())
print(f"Percorso MATLAB: {matlab_path}")

# ========== MAPPATURA LABEL ==========
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

# ========== FUNZIONI DI SUPPORTO ==========
def get_model():
    global model
    if model is None:
        start = time.time()
        model = load_model(MODEL_PATH, compile=False)
        print(f"Modello caricato in {time.time() - start:.2f} secondi")
    return model

def get_matlab_engine():
    global eng
    if eng is None:
        eng = matlab.engine.start_matlab()
        eng.addpath(matlab_path, nargout=0)
    return eng

# ========== ENDPOINT /predict ==========
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()

    # Prepara immagine per il modello ML
    img = load_img(io.BytesIO(contents))
    arr_np = img_to_array(img).astype(np.uint8)

    model = get_model()
    _, H, W, _ = model.input_shape

    img_resized = load_img(io.BytesIO(contents), target_size=(H, W))
    arr_resized = img_to_array(img_resized).astype(np.uint8)
    arr_norm = arr_resized / 255.0
    arr_expanded = np.expand_dims(arr_norm, 0)

    # Predizione
    probs = model.predict(arr_expanded).flatten()
    top3 = np.argsort(probs)[-3:][::-1]
    top_label = class_names[top3[0]]
    matlab_label = label_map.get(top_label)

    # MATLAB
    matlab_output = None
    matlab_error_msg = None
    niqe_noise = None
    niqe_denoised = None

    try:
        eng = get_matlab_engine()
        matlab_output, niqe_noise, niqe_denoised = eng.noiseSelector(arr_np, matlab_label, nargout=3)
    except Exception:
        matlab_error_msg = traceback.format_exc()
        print("Errore durante l'esecuzione di MATLAB:")
        print(matlab_error_msg)

    return {
        "predictions": [
            {"label": class_names[i], "confidence": float(probs[i])}
            for i in top3
        ],
        "matlab_output": matlab_output,
        "matlab_error": matlab_error_msg,
        "niqe_noise": niqe_noise,
        "niqe_denoised": niqe_denoised
    }

# ========== AVVIO SERVER ==========
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
