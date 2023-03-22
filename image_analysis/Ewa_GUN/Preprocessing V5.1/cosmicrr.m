function im = cosmicrr(image, thresh, winsize)
%% This function takes single image (matrix) and removes cosmic rays. 
% Based on the article A Fast Algorithm for Cosmic Rays Removal from Single
% Images by Wojtek Pych
% Since we have small times and small CCDs we set window size to the size of
% image
%% Variables
% image - matrix m x n
% threshold - number - value for detecting cosmic rays
% winsize - for median for for eliminating cosmic rays
% default should be:
% thresh = 3;
% winsize = 15;
sizeIm = size(image);
sigma = std(image(:));
[counts, edges] =  histcounts(round(image(:)),sqrt(numel(image(:))));
centers = edges(1:end-1)+diff(edges)/2;
% [counts,centers] = hist(round(image(:)),sqrt(numel(image(:)))); % Aline: outdated
modeStart = mode(image(:));

emptyCount = strfind(counts, zeros(1,ceil(thresh*sigma/(centers(2)-centers(1)))));

if isempty(emptyCount)
    im = image; % no cosmic rays where found
else
    indMode = knnsearch(centers', modeStart);
   
    if sum(emptyCount<indMode)==numel(emptyCount)
        im = image; % empty pixels on the LHS of mode; no cosmic rays
    else
        indStartCosmic = find(emptyCount>indMode,1);
        indCosmicPixels = find(image>centers(emptyCount(indStartCosmic))); %localize cosmic rays
        [I,J] = ind2sub(sizeIm,indCosmicPixels);
        %replacing cosmic rays with median over patches centered at cosmic ray's pixels
        for i=1:numel(indCosmicPixels)
            windowAroundCosmicRay = image(max(I(i)-winsize,1):min(I(i)+winsize,sizeIm(1)),...
                                      max(J(i)-winsize,1):min(J(i)+winsize,sizeIm(2)));
            image(I(i),J(i)) = median(windowAroundCosmicRay(:));
        end
        im = image; % corrected image
    end
    
end



end