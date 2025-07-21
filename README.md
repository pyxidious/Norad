# AI-Powered Image Denoising Platform

Welcome to the repository of our **Image Denoising** project.  
This platform allows users to upload a photo, automatically detect the type of noise using an AI model, and remove it using MATLAB-based denoising algorithms.

## 🧠 Project Overview

The system is built using three main components:

1. **Frontend Web (Angular)**  
   Provides a user interface for uploading images and displaying the denoised results.

2. **Backend (FastAPI in Python)**  
   Handles image uploads, uses a deep learning model to classify the type of noise (e.g., Gaussian, Poisson, Salt-and-Pepper), and communicates with MATLAB for the actual denoising.

3. **Denoising Engine (MATLAB)**  
   Applies the appropriate filtering technique based on the detected noise and returns the cleaned image.

## 🖼️ How It Works

1. The user uploads an image via the web interface.
2. The backend processes the image using a trained neural network to detect the noise type.
3. Based on the detected noise, MATLAB is triggered to apply the corresponding denoising algorithm.
4. The denoised image is returned and shown to the user.

## 🔧 Technologies Used

- **Frontend:** Angular
- **Backend:** Python + FastAPI
- **AI (Noise Classifier):** TensorFlow / Keras
- **Denoising Engine:** MATLAB
- **Python-MATLAB Communication:** `matlab.engine`
- **Web Server:** NGINX (for deployment)

## 🚀 Getting Started

### Prerequisites

- Python ≥ 3.8
- MATLAB with MATLAB Engine API for Python
- Node.js + Angular CLI
- Trained AI model (`.h5`)
- FastAPI backend setup

### Backend Setup

```bash
cd backend/
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
