# Cite

this code is programmed for sparse envelope spectrum. if you use it
 ,please cite   "L. Liang, L. Shan, F. Liu, B. Niu, G. Xu, Sparse Envelope  Spectra
 for Feature Extraction of Bearing Faults Based on NMF[J]. Applied
 Science-basel. 2019, 9(4): 755."

the nmf code was not designed by us, you can change the function by other algorithms.

so pay attention to cite it.

# Attention

The main code is 'STFT_nmf.m'，just open it and run.

the time-frequency analysis uses tftb toolbox, so you should install it before you use the code.

if functions missed and you cannot use, connect me and i will upload them.  

Just Testing , DONOT contact with me if any questions except missing functions.

English and programming are not very good, please don't laugh at me. HAHAHA



## son_function

myfft -> myfft(x,fs,plot_wave,plot_spectrum, plotWaveSpectrum in one fig, title), fft

mypulse -> mupulse(onepulse, Fs，1/Period)

slgetfile  -> readdata



# Use

after run the main code, you will get  w and h, you can choose right wi to analyse. you have 3 methods: 



1. it will give you a dialog, just input the number in the workspace;
2. use mouse to click the line in w, and it will be red if you succeed.
3. it will give you a suggestion if you gives the character frequency, just click yes.