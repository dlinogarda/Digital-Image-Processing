clc
clear all
close all
%Input image
% filename='coins_blurred.bmp';
filename='cameraman.tif';
% filename = 'rice.png';
%load image
f_ori=imread(filename);
SX = size(f_ori);
%Making odd pixels resolution
f = f_ori(1:SX(1)-1,1:SX(2)-1);
SX = size(f);
figure, imshow(f), title('original image');
%% Proof of the Gaussian to be Highpass Filter (Spatial Domain)
k = 1;
hgausmask = fspecial('laplacian',0)*k*(1/6);
hgausmask(2,2) = hgausmask(2,2)*-1/2;
%Result after convolution
gLP=imfilter(double(f),hgausmask,'conv');
%Shows blurred image
gLPshow = mat2gray(gLP);
figure, imshow(gLPshow), title('Gaussian Lowpass Filter (Gaussian (Wa))');
%Highpass Filter
gHP = double(f)-double(gLP);
%Shows Highpass image
gHPshow = mat2gray(gHP);
figure, imshow(gHPshow), title('Highpass Filter (from Gaussian (Wa))');

%% Proof of the Gaussian to be Lowpass Filter (Frequency Domain)
%Add Masking padding to M x N (Spatial Domain)
hmask_pad = padarray(hgausmask,[round(SX(1)/2-2),round(SX(2)/2-2)],0,'both');

%Tranform Original Image to frequencey domain
F=fftshift(fft2(f));
Fshow = sqrt(real(F).^2+imag(F).^2);
figure, imshow(uint8(10*log(Fshow+1))), title('Original Image Freq (Freq Domain)');

%Tranform Masking Image to frequencey domain
Hlp=fftshift(fft2(hmask_pad));
Hlpshow = sqrt(real(Hlp).^2+imag(Hlp).^2);
Hlpshow = mat2gray(Hlpshow);
figure, imshow(uint8(200*log(Hlpshow+1))), title('Masking Lowpass Filter (Freq Domain)');

%Lowpass Filter in Frequency Domain
Glp = F.*(Hlp);
Glpshow = sqrt(real(Glp).^2+imag(Glp).^2);
Glpshow = mat2gray(Glpshow);
figure, imshow(uint8(5000*log(Glpshow+1))), title('Lowpass Filter Image(Freq Domain)');

%Back to Spatial Domain (Lowpass Filter)
glp=fftshift(ifft2(ifftshift(Glp)));
figure, imshow(uint8(real(glp))), title('Inverse FFT of Lowpass Filter');

%% Proof of the Gaussian to be Highpass Filter (Frequency Domain)
%Tranform Masking Image to frequencey domain
Hlp=fftshift(fft2(fftshift(hmask_pad)));
Hlpshow = sqrt(real(Hlp).^2+imag(Hlp).^2);
Hlpshow = mat2gray(Hlpshow);
figure, imshow(uint8(200*log(Hlpshow+1))), title('Masking Lowpass Filter (Freq Domain)');

%Transform Masking Lowpass Filter to Masking Highpass Filter
Hhp = (1-real(Hlp));
Hhpshow = sqrt(real(Hhp).^2+imag(Hhp).^2);
Hhpshow = mat2gray(Hhpshow);
figure, imshow(uint8(500*log(Hhpshow+1))), title('Masking Highpass Filter (Freq Domain)');

%Highpass Filter in Frequency Domain
Ghp = F.*Hhp;
Ghpshow = sqrt(real(Ghp).^2+imag(Ghp).^2);
Ghpshow = mat2gray(Ghpshow);
figure, imshow(uint8(5000*log(Ghpshow+1))), title('Highpass Filter Image(Freq Domain)');

%Back to Spatial Domain (Highpass Filter)
gHP=(ifft2(ifftshift(Ghp)));
figure, imshow(mat2gray(real(gHP))), title('Inverse FFT of Highpass Filter');

