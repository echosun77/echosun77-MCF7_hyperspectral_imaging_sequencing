function denoisedImage = denoise(im, parameter)
%DENOISE This function does smoothing
%   
% im - image of the size 2^n x 2^n
% parameter - double - smoothing parameter - 0 - no smoothing 
%% Adding toolboxes
% getd = @(p)path(p,path);
% getd('toolbox_signal/');
% getd('toolbox_general/');
%% Some other parameters
Jmin = 2;
options.ti = 1; % translation invariant wavelets
%% Since scale at every wavelength might be different we translate parameter to percentage of range
parameter = max(im(:))*parameter/10^3;
%% Smoothing
im = squeeze(im); % in case
coef = perform_wavelet_transf(im,Jmin,+1,options);
coefThresh = perform_thresholding(coef, parameter, 'hard');
denoisedImage = perform_wavelet_transf(coefThresh,Jmin,-1,options);

end

