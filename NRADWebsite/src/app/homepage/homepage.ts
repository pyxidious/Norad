import {Component} from '@angular/core';
import {DecimalPipe, NgClass, NgForOf, NgIf} from '@angular/common';
import { imageService, Prediction } from '../services/imageService'; // <-- importa qui


@Component({
  selector: 'app-homepage',
  imports: [
    NgIf,
    DecimalPipe,
    NgForOf,
    NgClass
  ],
  templateUrl: './homepage.html',
  styleUrls: ['./homepage.css', './inputimg.css', './loadingScreen.css', './outputimg.css'],
})
export class Homepage {
  selectedFile: File | null = null;
  imagePreviewUrl: string | null = null;
  predictions: Prediction[] | null = null;
  matlabOutputBase64: string | null = null;
  loadingMatlab = false;
  showMatlabResult = false;
  niqeNoise: number | null = null;
  niqeDenoised: number | null = null;
  private shouldScroll = false;

  constructor(private imageService: imageService) {}

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;

    if (input.files && input.files.length > 0) {
      this.selectedFile = input.files[0];
      const reader = new FileReader();
      reader.onload = () => {
        this.imagePreviewUrl = reader.result as string;
      };
      reader.readAsDataURL(this.selectedFile);
      this.predictions = null;
      this.loadingMatlab = false;
      this.matlabOutputBase64 = null;
      this.showMatlabResult = false;
    }
  }

  onEnhance(): void {
    if (this.selectedFile) {
      this.loadingMatlab = true;
      this.showMatlabResult = true;
      this.shouldScroll = true;

      setTimeout(() => {
        const section = document.getElementById('computingSection');
        if (section) {
          section.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }, 0);

      this.imageService.predictImage(this.selectedFile).subscribe({
        next: (res: {
          predictions: Prediction[] | null;
          matlab_output?: string | null;
          niqe_noise?: number;
          niqe_denoised?: number;
        }) => {          this.predictions = res.predictions;
          console.log('Predizioni ricevute:', this.predictions);
          this.matlabOutputBase64 = res.matlab_output || null;
          this.niqeNoise = res.niqe_noise ?? null;
          this.niqeDenoised = res.niqe_denoised ?? null;
          this.loadingMatlab = false;

          setTimeout(() => {
            const section2 = document.getElementById('results');
            if (section2) {
              section2.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
          }, 100);
        },
        error: (err: any) => {
          console.error('Errore durante la predizione:', err);
          this.predictions = null;
          this.matlabOutputBase64 = null;
          this.loadingMatlab = false;
        }
      });
    }
  }

  getNiqeWidth(score: number): number {
    const clamped = Math.min(Math.max(score, 0), 20);
    return ((20 - clamped) / 20) * 100;
  }

  getQualityClass(niqe: number): string {
    if (niqe < 3) return 'fa-solid fa-trophy quality-excellent';
    if (niqe < 5) return 'fa-solid fa-thumbs-up quality-good';
    if (niqe < 7) return 'fa-solid fa-eye quality-medium';
    if (niqe < 9) return 'fa-solid fa-triangle-exclamation quality-poor';
    return 'fa-solid fa-skull-crossbones quality-terrible';
  }


}
