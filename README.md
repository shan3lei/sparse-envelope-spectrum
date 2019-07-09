# sparse-envelope-spectrum
Test
this code is programmed for sparse envelope spectrum. if you use it
 ,please cite   "L. Liang, L. Shan, F. Liu, B. Niu, G. Xu, Sparse Envelope  Spectra
 for Feature Extraction of Bearing Faults Based on NMF[J]. Applied
 Science-basel. 2019, 9(4): 755."

the nmf code was not designed by us, you can change the function by other algorithms.

so pay attention to cite the algorithm if you just use the nmf in the stft_nmf file.



NMF code: 

% Reference:
%  [1] For using this software, please cite:
%          Jingu Kim and Haesun Park, Toward Faster Nonnegative Matrix Factorization: A New Algorithm and Comparisons,
%                 In Proceedings of the 2008 Eighth IEEE International Conference on Data Mining (ICDM'08), 353-362, 2008
%  [2] If you use 'nnls_solver'='as' (see below), please cite:
%          Hyunsoo Kim and Haesun Park, Nonnegative Matrix Factorization Based on Alternating Nonnegativity Constrained Least Squares and Active Set Method,
%                 SIAM Journal on Matrix Analysis and Applications, 2008, 30, 713-730
%
% Written by Jingu Kim (jingu@cc.gatech.edu)
% Copyright 2008-2009 by Jingu Kim and Haesun Park,
%                        School of Computational Science and Engineering,
%                        Georgia Institute of Technology