function [mask, myMedian] = getBackground(im, imLoc, mask)

DIC = im(:,:,end);
[filePath,fileName,~] = fileparts(imLoc);

if nargin<3 %% Draw background in getBackground  
    figure();
    % im = imread(imLoc);

    dicMin = min(reshape(imgaussfilt(DIC,4),1024*1024,1));
    dicMax = max(reshape(imgaussfilt(DIC,4),1024*1024,1));
    imshow((DIC-dicMin)./(dicMax-dicMin));
    numROI = 50;
    
    ButtonHandleF = uicontrol('Style', 'PushButton', ...
        'String', 'Finished', 'position',[100 20 80 30],...
        'Callback', 'delete(gcbf)');
    
    % create ROI objects and adjust them
    mask = false(size(DIC,1),size(DIC,2));
    for i =1:numROI
        h = drawfreehand;
        if ~ishandle(ButtonHandleF)
            disp('Loop stopped by user');
            break;
        end
        if exist('h','var')
            mask = mask | createMask(h);
        end
    end
    imwrite(mask,append(filePath,"\",fileName,"_mask_",string(datetime('now','Format','yyyy-MM-dd''_''HH-mm')),".png"));
else
    mask = imread(mask);
    if ~islogical(mask)
        mask = imbinarize(mask,.5);
    end
end

% myMean = zeros(size(im,3)-1,1); 
myMedian = zeros(size(im,3)-1,1);

for i = 1:size(im,3)-1
    imNow = im(:,:,i);
    myPixels = imNow(mask);
%     myMean(i) = mean(myPixels);
    myMedian(i) = median(myPixels);
end

% save(append(filePath,"\",fileName,"_Median.mat"),'myMedian');
% save(append(filePath,"\",fileName,"_Mean_",string(datetime('now','Format','yyyy-MM-dd''_''HH-mm')),".mat"),'myMean');

end

