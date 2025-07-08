import { Component } from '@angular/core';
import {NgIf} from '@angular/common';

@Component({
  selector: 'app-homepage',
  imports: [
    NgIf
  ],
  templateUrl: './homepage.html',
  styleUrl: './homepage.css'
})
export class Homepage {
  selectedFile: File | null = null;
  imagePreviewUrl: string | null = null;

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;

    if (input.files && input.files.length > 0) {
      this.selectedFile = input.files[0];

      // Optional: create preview
      const reader = new FileReader();
      reader.onload = () => {
        this.imagePreviewUrl = reader.result as string;
      };
      reader.readAsDataURL(this.selectedFile);

      console.log('Selected file:', this.selectedFile);
    }
  }

  onEnhance(): void {
    if (this.selectedFile) {
      console.log('Enhancement started for:', this.selectedFile.name);
      // Qui puoi inserire chiamata API, elaborazione, ecc.
    }
  }

}
