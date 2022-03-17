
clc
clear all

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
%% Spatial Domain 
%Gaussian Filter Mask 5 x 5
% hmask = fspecial('gaussian',[5 5],9);
hmask = fspecial('sobel');
% hmask = rot90(hmask,2);
%Result after convolution
g=imfilter(double(f),hmask,'conv');
%Shows blurred image
figure, imshow(uint8(g)), title('Blurred image (Spatial Domain)');

%% Frequency Domain
%Tranform Original Image to frequencey domain
G=fftshift(fft2(f));
Gshow = sqrt(real(G).^2+imag(G).^2);
figure, imshow(uint8(10*log(Gshow+1))), title('Original Image Freq (Freq Domain)');

%Add Masking padding to M x N (Spatial Domain)
hmask_pad = padarray(hmask,[round(SX(1)/2-3),round(SX(2)/2-3)],0,'both');

%Tranform Masking Image to frequencey domain
H=fftshift(fft2(hmask_pad));
Hshow = sqrt(real(H).^2+imag(H).^2);
Hshow = mat2gray(Hshow);
figure, imshow(uint8(200*log(Hshow+1))), title('Masking Image Freq (Freq Domain)');

%Blurring Processing
gBlurred = G.*H;
ggBlurredshow = sqrt(real(gBlurred).^2+imag(gBlurred).^2);
figure, imshow(uint8(10*log(ggBlurredshow+1))), title('Blurred Image Freq (Freq Domain)');

%Back to Spatial Domain
fBlurred=ifftshift(ifft2(ifftshift(gBlurred)));
figure, imshow(uint8(real(fBlurred))), title('Inverse FFT of Blurred Image');

%% Other case
% Filtering in Frequency Domain
GLPF = SFDomain.GaussianLowFilter(G,30);
figure, imshow(uint8(10*log(GLPF{2}+1))), title('Gaussian Lowpass Filter (Freq Domain)');
GLPF_Spatial = (ifft2(ifftshift(GLPF{1})));
figure, imshow(uint8(real(GLPF_Spatial))), title('Blurred Image of GLF (Freq Domain)');

%Filtering in Frequency Domain
gfilter=zeros(SX(1),SX(2));
radius=30; % Sigma Values for Gaussian Filter
for i = 1:SX(1)
    for j = 1:SX(2)
        dist= (i-SX(1)/2)^2 + (j-SX(2)/2)^2;
        gfilter(i,j) = 255*exp(-(dist)/(2*(radius)^2));
    end
end
figure, imshow(gfilter), title('Gaussian Lowpass Filter (Frequency Domain)');