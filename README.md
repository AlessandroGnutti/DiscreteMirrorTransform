# The Mirror Transform

## Overview

The Mirror Transform describes any finite-energy signal through a unique representation consisting of an ordered set of positions and a sparse set of signals. This is obtained by designing an iterative decomposition through a series of mirror operations around those positions. The purpose is to find at any step of the decomposition the location that provides for the maximum decoupling between the even and odd components of the signal with respect to it. By limiting such even and odd components on three separate information bearing support, the algorithm can be iterated at infinity determining a sequence of positions. The per location information determines the optimal energy decoupling strategy at each stage providing remarkable sparsity in the representation. The resulting transformation leads to a 1-to-1 mapping. The approach is easily extended to finite-energy sequences, and in particular for sequences of finite length *N*, at most *N* iterations of the decomposition are required. Thanks to the sparsity of the resulting representation, experimental simulations demonstrate superior approximation capabilities of this proposed non-linear Mirror Transform with potential application in many domains such as approximation and coding.

## Algorithm

You can find the pseudo-code algorithm in the folder [**1-D algorithm**](https://github.com/AlessandroGnutti/DiscreteMirrorTransform/tree/main/1-D%20algorithm).

## Results

### Sparsity properties

The following figures show the sparsity ability of the Mirror Transform, displaying the PSNR/MSE curves in relation to the percentage of the transform coefficients retained for reconstruction, for each dataset.

- Image dataset:
<img src="https://raw.githubusercontent.com/AlessandroGnutti/DiscreteMirrorTransform/master/Results/db_image.jpg" width="400">

- Audio dataset:
<img src="https://raw.githubusercontent.com/AlessandroGnutti/DiscreteMirrorTransform/master/Results/db_audio.jpg" width="400">

- Seismic dataset:
<img src="https://raw.githubusercontent.com/AlessandroGnutti/DiscreteMirrorTransform/master/Results/db_seismic.jpg" width="400">

- ECG dataset:
<img src="https://raw.githubusercontent.com/AlessandroGnutti/DiscreteMirrorTransform/master/Results/db_ecg.jpg" width="400">

### One-wayness property

The following figures show the one-wayness property of the Mirror Transform (experiments performed on 5000 64-length sequences).

- Number of **tree collisions** at varying of the number of retained transform coefficients. The considered trees are the ones regenerated after the coefficients removal, and the comparison is carried out between each tree and all the others.
<img src="https://raw.githubusercontent.com/AlessandroGnutti/DiscreteMirrorTransform/master/Results/Collisions.jpg" width="400">

- Number of **non-changing trees** at varying of the SNR values (the noise is added to one transform coefficient). The comparison is carried out between the tree associated with the original sequence and the one associated with the same sequence but regenerated after the coefficient changing (for each sequence).
<img src="https://raw.githubusercontent.com/AlessandroGnutti/DiscreteMirrorTransform/master/Results/One-coeff-noise robustness.jpg" width="400">

- Number of **non-changing trees** at varying of the number of retained coefficients for different SNR values (the noise is added to the original sequence). The trees are the ones regenerated after the coefficients removal. The comparison is carried out between the tree associated with the original sequence and the one associated with the noised version of that sequence (for each sequence).
<img src="https://raw.githubusercontent.com/AlessandroGnutti/DiscreteMirrorTransform/master/Results/Noise robustness.jpg" width="400">

## About the code

### Sparsity experiments

There are 4 main scripts:

- ```test2D.m```
- ```testAudio.m```
- ```testSeismic.m```
- ```testECG.m```

Each of them launches the experimental comparison between the Discrete Mirror Transform (DMT), the Discrete Cosine Transform (DCT), the Discrete Wavelet Transform (DWT), the Karhunen-Loeve Transform (KLT) and the Sparse Orthonormal Transform (SOT), performed on image, audio, seismic and ECG datasets, respectively.

To compute the KLT basis for each dataset, you can run the following 4 scripts:

- ```trainingImages.m```
- ```trainingAudio.m```
- ```trainingSeismic.m```
- ```trainingECG.m```

Instead, to compute the SOT basis, you can run the code in the folder [**SOT**](https://github.com/AlessandroGnutti/DiscreteMirrorTransform/tree/main/SOT) (Copyright Osman G. Sezer and Onur G. Guleryuz 2015). However, you can find the KLT and SOT matrices already computed in the folder [**In**](https://github.com/AlessandroGnutti/DiscreteMirrorTransform/tree/main/In).

### One-wayness experiments

To reproduce the figures in **Results - One-wayness property**, you can run the three scripts in the folder [**One-wayness**](https://github.com/AlessandroGnutti/DiscreteMirrorTransform/tree/main/One-wayness):

- ```main_cripto.m``` and ```analysis_cripto.m``` which generate the first two figures. In particular, ```main_cripto.m``` creates (and saves) the file ```Data2.mat```,  which is then used in ```analysis_cripto.m``` to plot the figures.
- ```main_change_leaves.m``` which generates the third figure.

### Important functions

To generate the DMT of a generic 1-D or 2-D sequence you can call the function ```mirrorTransform2D_slow.m```, which receives the sequence as input and returns the entire tree structure as output. Alternately, you can call the faster implementation ```mirrorTransform2D_fast``` which concatenates the tail to one of the even or odd nodes. It receives the sequence as input and returns the transform coefficients and the optimal symmetry positions (without tree structure) as output.

## Contacts

For any information, please send an email to alessandro.gnutti@unibs.it
