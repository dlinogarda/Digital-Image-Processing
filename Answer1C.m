
%% Convolution
% h is the filtering window [3x3] 
h = rot90(h,2); % rotate filtering window 180 degree.

% Add Filtering padding to M x N (Spatial Domain)
h = padarray(h,[round(M/2-3),round(N/2-3)],0,'both'); %Filtering window value is in the center

% Transform image f to frequency domain with the shifting
F = fftshift(fft2(f));

% Create matrix with MxN dimension
G = zeros(M,N);

for i = 1:M
    for j = 1:N
        G(i,j) = F(i,j)*H(i,j);
    end
end

% Transform the G (Filtered image) back to spatial domain
g = ifftshift(ifft2(G));