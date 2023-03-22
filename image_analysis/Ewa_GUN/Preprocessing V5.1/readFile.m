function [tempData, fileStruct] = readFile(fileName)
% load *.mat files 
        load(fileName);
        try
            if exist('specImage','var')
                tempData = specImage; %old system of files
                fileStruct = 1;
            else
                tempData = HAC_Image.imageStruct.data; % new system of files
                fileStruct = 2;
            end
        catch
            msgTemplate([],[],{'No image found in: '; fileName},'Error')
        end
end