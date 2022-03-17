clc
clear all
close all
%Input image
% filename='coins_blurred.bmp';
% filename='cameraman.tif';
filename = 'rice.png';
%load image
f_ori=imread(filename);
SX = size(f_ori);
%Making odd pixels resolution
f = f_ori(1:SX(1)-1,1:SX(2)-1);
SX = size(f);
figure, imshow(f), title('original image');
%% Proof of Laplacian to be Highboost Filter
%Laplacian Filter Mask 3 x 3
k = 1;
hmask = fspecial('laplacian',0)*-k;
%Add center by 6
hmask(2,2) = (hmask(2,2)+6)*(1/6);
hmask = hmask*(1/6);
%Result after convolution
g=imfilter(double(f),hmask,'conv');
%Shows Highpass image
gshow = mat2gray(g);
figure, imshow(gshow), title('Highpass Filter (Laplacian(Whb))');
%Highboost Filter
fHB = double(f)+double(g);
%Shows Highboost image
fHBshow = mat2gray(fHB);
figure, imshow(fHBshow), title('Highboost Filter (Laplacian(Whb)) => f+highpass');

%% Proof of the Gaussian to be Highboost Filter
k = 1;
hgausmask = fspecial('laplacian',0)*k*(1/6);
hgausmask(2,2) = hgausmask(2,2)*-1/2;
%Result after convolution
g=imfilter(double(f),hgausmask,'conv');
%Shows blurred image
gshow = mat2gray(g);
figure, imshow(gshow), title('Gaussian Filter (Gaussian (Wa))');
%Highpass Filter
fhighpass = double(f)-double(g);
%Shows Highpass Filter
fhighpassshow = mat2gray(fhighpass);
figure, imshow(fhighpassshow), title('Highpass Filter (Gaussian (Wa))=> f-lowpass');
%Highboost Filter
fhighboost = double(f) + fhighpass;
%Shows Highboost Filter
fhighboostshow = mat2gray(fhighboost);
figure, imshow(fhighboostshow), title('Highboost Filter (Gaussian (Wa))=> f+highpass');