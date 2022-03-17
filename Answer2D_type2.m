clc
clear all
close all
%Input image
% filename='coins_blurred.bmp';
% filename='cameraman.tif';
% filename = 'rice.png';
filename = 'moon.tif';
%load image
f_ori=imread(filename);
SX = size(f_ori);
%Making odd pixels image resolution
f = f_ori(1:SX(1),1:SX(2)-1);
SX = size(f);
figure, imshow(f), title('original image');
%Tranform Original Image to frequencey domain
F=fftshift(fft2(f));
Fshow = sqrt(real(F).^2+imag(F).^2);
figure, imshow(uint8(10*log(Fshow+1))), title('Original Image Freq (Freq Domain)');
%% How to generate Highboost Filter related to Highpass Filter in Frequency Domain
%Highpass Masking Filter
Hhp=zeros(SX(1),SX(2));
radius=100; 
for i = 1:SX(1)
    for j = 1:SX(2)
        dist= (i-SX(1)/2)^2 + (j-SX(2)/2)^2;
        Hhp(i,j) = 1*(1-exp(-(dist)/(2*(radius)^2)));
    end
end
figure, imshow(mat2gray(Hhp)), title('Gaussian Highpass Masking (Frequency Domain)');

%% Highpass Filter "Testing Image"
%Highpass Filter Image
Fhp = Hhp.*F;
Fhpshow = sqrt(real(Fhp).^2+imag(Fhp).^2);
Fhpshow = mat2gray((Fhpshow));
figure, imshow((10*log(Fhpshow+1))),  title('Highpass Filter Image(Freq Domain)');
%Back to Spatial Domain (Highpass Filter)
fHP=(ifft2(ifftshift(Fhp)));
figure, imshow(mat2gray(real(fHP))), title('Inverse FFT of Highpass Filter');
%%
%Highpass Filter (Ghp)
k = 27;
Ghp = (1+(k*Hhp)).*F;
Ghpshow = sqrt(real(Ghp).^2+imag(Ghp).^2);
Ghpshow = mat2gray((Ghpshow));
figure, imshow((100*log(Ghpshow+1))), title('Highpass Filter Image(Freq Domain)');

%Back to Spatial Domain (Highpass Filter)
gHP=real(ifft2(ifftshift(Ghp)));
figure, imshow(mat2gray(real(gHP))), title('Inverse FFT of Highpass Filter');

%Highboost Filter (Ghb) (in Spatial Domain)
gHB = double(f)+double(real(gHP));
figure, imshow(mat2gray(real(gHB))), title('Highboost Filter in Spatial Domain');