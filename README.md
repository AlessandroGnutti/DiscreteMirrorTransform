# The Mirror Transform

The Mirror Transform describes any finite-energy signal through a unique representation consisting of an ordered set of positions and a sparse set of signals. This is obtained by designing an iterative decomposition through a series of mirror operations around those positions. The purpose is to find at any step of the decomposition the location that provides for the maximum decoupling between the even and odd components of the signal with respect to it. By limiting such even and odd components on three separate information bearing support, the algorithm can be iterated at infinity determining a sequence of positions. The per location information determines the optimal energy decoupling strategy at each stage providing remarkable sparsity in the representation. The resulting transformation leads to a 1-to-1 mapping. The approach is easily extended to finite-energy sequences, and in particular for sequences of finite length N, at most N iterations of the decomposition are required. Thanks to the sparsity of the resulting representation, experimental simulations demonstrate superior approximation capabilities of this proposed non-linear Mirror Transform with potential application in many domains such as approximation and coding.

# About the code

There are 4 main scripts:

- *test2D.m*
- *testAudio.m*
- *testSeismic.m*
- *testECG.m*

Each of them launches the experimental comparison between the Discrete Mirror Transform (DMT), Discrete Cosine Transform (DCT), Discrete Wavelet Transform (DWT), Karhunen-Loeve Transform (KLT) and Sparse Orthonormal Transform (SOT) performed on image, audio, seismic and ECG datasets.

To compute the KLT basis for each dataset, you can run the following 4 scripts:

- *trainingImages.m*
- *trainingAudio.m*
- *trainingSeismic.m*
- *trainingECG.m*

Instead, to compute the SOT basis, you can run the code in the folder **SOT**. 