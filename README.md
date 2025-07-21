# AI-Powered Image Denoising Platform

Benvenuto nel repository del nostro progetto di **Image Denoising**.  
Questa piattaforma consente a un utente di caricare un'immagine, identificare automaticamente il tipo di rumore presente tramite un modello di intelligenza artificiale, e rimuoverlo usando algoritmi di denoising sviluppati in MATLAB.

## 🧠 Descrizione del Progetto

Il sistema è composto da tre componenti principali:

1. **Frontend Web (Angular)**  
   Permette all’utente di caricare immagini e visualizzare i risultati del denoising.

2. **Backend (FastAPI in Python)**  
   Gestisce la ricezione delle immagini, elabora l'immagine con un modello IA per identificare il tipo di rumore (es. Gaussian, Poisson, Salt-and-Pepper), e comunica con MATLAB per l'applicazione del filtro adeguato.

3. **Motore Denoising (MATLAB)**  
   Implementa algoritmi specifici per ciascun tipo di rumore rilevato e restituisce l'immagine denoised al backend.

## 🖼️ Come Funziona

1. L'utente carica un’immagine tramite l’interfaccia web.
2. Il backend elabora l'immagine con un modello di deep learning addestrato a classificare il tipo di rumore presente.
3. Viene chiamato MATLAB per applicare il filtro di denoising appropriato (ad es. filtro Wiener, mediano, etc.).
4. L’immagine denoised viene restituita all’utente e visualizzata nel browser.

## 🔧 Tecnologie Utilizzate

- **Frontend:** Angular
- **Backend:** Python + FastAPI
- **IA (Image Noise Classifier):** TensorFlow / Keras
- **Denoising Engine:** MATLAB
- **Comunicazione Python-MATLAB:** `matlab.engine`
- **Server:** NGINX (per la versione distribuita)

## 🚀 Avvio del Progetto

### Prerequisiti

- Python ≥ 3.8
- MATLAB installato con il MATLAB Engine API per Python
- Node.js e Angular CLI
- Modello IA già addestrato (`.h5`)
- Server backend con FastAPI configurato

### Setup Backend

```bash
cd backend/
python -m venv venv
source venv/bin/activate  # Su Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
