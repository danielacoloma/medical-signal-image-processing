# Medical Signal and Image Processing — Lab Portfolio

Practical assignments from the **Procesado de Señal e Imagen Médica** course, Biomedical Engineering degree, Universidad de Valladolid (2024–2025).

All implementations are in MATLAB. Each practice folder contains the scripts and a brief description of methods and results.

---

## Contents

### P1 · Biomedical Signal Processing
**Techniques:** Independent Component Analysis (ICA), Higher-Order Spectral Analysis (HOSA), nonlinear signal analysis.

- Artefact removal from EEG recordings (19-channel, 200 Hz) using EEGLAB and ICA decomposition. Identification and elimination of ocular and muscular artefacts.
- Bispectrum and bicoherence analysis on synthetic signals with quadratic phase coupling (QPC) and on real EEG data from an Alzheimer's disease progression cohort (5 subjects: healthy control → severe dementia).
- Nonlinear parameter extraction: Sample Entropy (SampEn), Central Tendency Measure (CTM) and Multiscale Entropy (MSE) applied to synthetic chirp/sinusoidal signals and real EEG recordings. Analysis of entropy changes across cognitive decline stages.

**Data:** Real EEG signals at 500 Hz, 20 epochs × 5 s × 19 channels per subject.

---

### P2 · Medical Image Processing
**Techniques:** DICOM/NIFTI I/O, histogram operations, spatial filtering, Fourier-domain filtering, image segmentation.

- Loading and metadata extraction from DICOM (brain MRI T1) and NIFTI (ankle MRI, chest CT) formats using `dicomread`, `niftiread`, `niftiinfo`.
- Histogram visualisation, dynamic range analysis, Gaussian noise addition and NIFTI export.
- Brain atlas visualisation: segmentation overlay (grayscale and colour), hippocampus and ventricle volume estimation in mm³.
- Contrast enhancement: histogram equalisation (`histeq`), contrast stretching for lung and bone tissue.
- Spatial filtering: mean, weighted mean and Gaussian kernels (7×7); convolution with boundary condition analysis.
- Edge detection with Prewitt operators (horizontal + vertical), gradient magnitude reconstruction.
- Fourier-domain filtering: low-pass, high-pass and Gaussian filters; magnitude vs. phase reconstruction analysis.

---

### P3 · Feature Extraction and Neural Networks
**Techniques:** Region analysis, morphological descriptors, MLP classification.

**Bloque I — Feature extraction from medical images**
- Connected component labelling (`bwlabel`, `bwconncomp`) and region filling (`imfill`) on binary images.
- Morphological descriptor computation with `regionprops`: area, perimeter, major/minor axis length, eccentricity, equivalent diameter, Euler number, centroid, bounding box.
- Application to retinal fundus images: exudate and optic disc segmentation, mean intensity in the green channel within segmented regions.

**Bloque II — Neural network classification**
- MLP implementation in MATLAB Neural Network Toolbox: architecture design, activation functions (`logsig`, `tansig`), training algorithms (Levenberg-Marquardt, scaled conjugate gradient).
- Binary classification on the **Wisconsin Breast Cancer Dataset** (UCI ML Repository, 569 patients, 30 clinical features): train/test split, accuracy and error rate evaluation across different network configurations.

---

### Exam · Integrated Practical Exercise (May 2025)
End-of-course laboratory exam integrating the three blocks:
- EEG signal processing: ICA artefact removal, bicoherence analysis, phase-space attractor reconstruction (embedding dimension *m* = 3, delay *τ* = 20).
- Volumetric lung image segmentation (NIFTI), Gaussian noise robustness analysis, low-pass filtering pre-processing, segmentation quality metric computation.
- Image region analysis and MLP classification (30-node hidden layer, `logsig`, scaled conjugate gradient backpropagation) on the Wisconsin Breast Cancer dataset.

---

## Skills demonstrated

| Area | Tools / Methods |
|---|---|
| Signal processing | MATLAB, EEGLAB, ICA, bicoherence, SampEn, MSE, CTM |
| Image processing | DICOM, NIFTI, spatial/frequency filtering, segmentation, morphological descriptors |
| Machine learning | MLP, backpropagation, train/test evaluation, binary classification |
| Data | Real EEG (Alzheimer's cohort), brain/ankle/chest MRI, CT, retinal fundus images, clinical tabular data |

---

## Context

These labs are part of the 3th-year Biomedical Engineering curriculum at Universidad de Valladolid. They complement my Final Year Project on hospital occupancy prediction (XGBoost, SHAP, full-stack deployment at Hospital Universitario Río Hortega) and my Erasmus coursework in Machine Learning and ICT for Healthcare at Politecnico di Milano.
