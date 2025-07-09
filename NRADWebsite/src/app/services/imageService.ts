import { Injectable } from '@angular/core';
import { HttpClient, HttpEvent, HttpEventType, HttpHeaders, HttpRequest } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Prediction {
  label: string;
  confidence: number;
}

export interface PredictResponse {
  predictions: Prediction[];
}

@Injectable({
  providedIn: 'root'
})
export class imageService {

  private apiUrl = 'http://localhost:8000/predict'; // URL della tua API FastAPI

  constructor(private http: HttpClient) { }

  predictImage(file: File): Observable<PredictResponse> {
    const formData = new FormData();
    formData.append('file', file, file.name);

    return this.http.post<PredictResponse>(this.apiUrl, formData);
  }
}
