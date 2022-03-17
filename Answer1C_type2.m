
clc
%Input image
% filename='coins_blurred.bmp';
% filename='cameraman.tif';
filename = 'rice.png';
%load image
f=imread(filename);
SX = size(f);
figure, imshow(f), title('original image');
%% Spatial Domain 
%Gaussian Filter Mask 5 x 5
hmask = fspecial('gaussian',[5 5],9);
%Result after convolution
g=imfilter(double(f),hmask,'conv');
%Shows blurred image
figure, imshow(uint8(g)), title('Blurred image (Spatial Domain)');

%% Frequency Domain


%Image Deblurring (Masking out of Gausian); now we already now h
h=imfilter(double(ones(SX(1),SX(2))),hmask,'conv');
hshow=mat2gray(h); %normalize [0,1]
%Image of Masking out
figure, imshow(hshow), title('Image of Masking out (Spatial Domain)');

%Tranform Original Image to frequencey domain
G=fftshift(fft2(f));
Gshow = sqrt(real(G).^2+imag(G).^2);
figure, imshow(uint8(10*log(Gshow+1))), title('Original Image Freq (Freq Domain)');

%Tranform Masking Image to frequencey domain
H=fftshift(fft2(h));
Hshow = sqrt(real(H).^2+imag(H).^2);
figure, imshow(uint8(10*log(Hshow+1))), title('Masking Image Freq (Freq Domain)');

%Blurring Processing
gg = G.*H;
%Back to Spatial Domain
G2=ifft2(ifftshift((gg)));
figure, imshow(uint8(G2)), title('Inverse FFT of Blurred Image');

%% Other case

gfilter=zeros(SX(1),SX(2));
sigma=9; % Sigma Values for Gaussian Filter
for i = 1:SX(1)
    for j = 1:SX(2)
        dist= (i-SX(1)/2)^2 + (j-SX(2)/2)^2;
        gfilter(i,j) = 255*exp(-(dist)/(2*(sigma)^2));
    end
end
gfiltersh=mat2gray(gfilter); 
gfilter = complex(gfilter);
figure, imshow(gfiltersh), title('Image of Masking out (Spatial Domain)');
gSfilter=ifft2(ifftshift((gfilter)));
gSSfilter=mat2gray(real(gSfilter)); 
figure, imshow(uint8(gSSfilter)), title('Inverse FFT of Blurred Image');


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