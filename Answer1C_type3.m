
clc
clear all
close all
%Input image
% filename='coins_blurred.bmp';
% filename='cameraman.tif';
filename = 'rice.png';
%load image
f_ori=imread(filename);
[M,N] = size(f_ori);
%Making odd pixels resolution
f = f_ori(1:M-1,1:N-1);
[M,N] = size(f);
figure, imshow(f), title('original image');
%% Spatial Domain (Direct Convolution)
%Gaussian Filter Mask 5 x 5
hmask = fspecial('gaussian',[5 5],9);
% hmask = rot90(hmask,2);
%Result after convolution
g=imfilter(double(f),hmask,'conv');
%Shows blurred image
figure, imshow(uint8(g)), title('Blurred image (Spatial Domain)');

%% Frequency Domain (Frequency Filtering)
%Tranform Original Image to frequencey domain
F=fftshift(fft2(f));
Gshow = sqrt(real(F).^2+imag(F).^2);
figure, imshow(uint8(10*log(Gshow+1))), title('Original Image Freq (Freq Domain)');

%Add Masking padding to M x N (Spatial Domain)
hmask_pad = padarray(hmask,[round(M/2-3),round(N/2-3)],0,'both');

%Tranform Masking Image to frequencey domain
H=fftshift(fft2(hmask_pad));
Hshow = sqrt(real(H).^2+imag(H).^2);
Hshow = mat2gray(Hshow);
figure, imshow(uint8(200*log(Hshow+1))), title('Masking Image Freq (Freq Domain)');

%Blurring Processing
gBlurred = F.*H;
ggBlurredshow = sqrt(real(gBlurred).^2+imag(gBlurred).^2);
figure, imshow(uint8(10*log(ggBlurredshow+1))), title('Blurred Image Freq (Freq Domain)');

%Back to Spatial Domain
fBlurred=ifftshift(ifft2(ifftshift(gBlurred)));
figure, imshow(uint8(real(fBlurred))), title('Inverse FFT of Blurred Image');

