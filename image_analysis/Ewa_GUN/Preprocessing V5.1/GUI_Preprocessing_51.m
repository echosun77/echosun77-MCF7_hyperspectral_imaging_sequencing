function GUI_Preprocessing_51


%%  Create and then hide the UI as it is being constructed.
f = figure('Visible','on','units','normalized','outerposition',[0 0 1 1],...
    'Tag','fHandle','Name','GUI Preprocessing V5.1','Numbertitle','off');

%% Adding toolboxes
% getd = @(p)path(p,path);
% getd('toolbox_signal/');
% getd('toolbox_general/');

%% Creating menu
f.MenuBar = 'none'; % hide 
menuOpenH = uimenu(f,'Label','Open','Accelerator','o');

menuCellsH =  uimenu(menuOpenH,'Label','Cells','Enable','on',...
    'Callback',{@menuCells_callback,f},...
    'Accelerator','c');
setappdata(f,'menuCellsH',menuCellsH) %saving handle to make it accessible

menuWaterH =  uimenu(menuOpenH,'Label','Water','Enable','on',...
    'Callback',{@menuWater_callback,f},...
    'Accelerator','w');
setappdata(f,'menuWaterH',menuWaterH) %saving handle to make it accessible

menuCalibrationH =  uimenu(menuOpenH,'Label','Calibration','Enable','on',...
    'Callback',{@menuCalibration_callback,f},...
    'Accelerator','b');
setappdata(f,'menuCalibrationH',menuCalibrationH) %saving handle to make it accessible

menuFluorologH =  uimenu(menuOpenH,'Label','Fluorolog','Enable','on',...
    'Callback',{@menuFluorolog_callback,f},...
    'Accelerator','f');
setappdata(f,'menuFluorologH',menuFluorologH) %saving handle to make it accessible

menuMasksH =  uimenu(menuOpenH,'Label','Cell masks','Enable','on',...
    'Callback',{@menuMasks_callback,f},...
    'Accelerator','m');
setappdata(f,'menuMasksH',menuMasksH) %saving handle to make it accessible

menuMasksBH =  uimenu(menuOpenH,'Label','Background masks','Enable','on',... 
    'Callback',{@menuMasksB_callback,f},...
    'Accelerator','h');
setappdata(f,'menuMasksBH',menuMasksBH) %saving handle to make it accessible


% menuHelpH =  uimenu(f,'Label','Help','Enable','on',...
%     'Callback',{@msgTemplate,{'1. Click ''Open'' and select folder with *.mat files.',...
%     '2. Select files to investigate from the list using CTRL.',...
%     '3. Click ''Show''.',...
%     '4. Double-click on image for details.'}, 'Help'});

%% FILES AND PARAMETERS  
uipanelParH = uipanel('Title','Files and parameters','FontSize',12,'FontWeight','bold',...
             'Position',[.01 .0 .66 1],...
             'Parent',f,...
             'BorderWidth',3);
setappdata(f,'uipanelParH',uipanelParH);

uipanelCellsH = uipanel('Title','Cells','FontSize',12,...
             'Position',[.0 .0 .33 1],...
             'Parent',uipanelParH,...
             'BorderWidth',3);
setappdata(f,'uipanelCellsH',uipanelCellsH);

%Creating listbox
listCellsH = uicontrol(uipanelCellsH,'Style','listbox',...
            'Units','normalized',...
            'Position',[0.0 0.0 1 1]);
setappdata(f,'listCellsH',listCellsH) %saving handle to make it accessible

%Creating listbox
uipanelWaterH = uipanel('Title','Water','FontSize',12,...
             'Position',[.3333 .75 .3333 0.25],...
             'Parent',uipanelParH,...
             'BorderWidth',3);
setappdata(f,'uipanelWaterH',uipanelWaterH);

%Creating listbox
listWaterH = uicontrol(uipanelWaterH,'Style','listbox',...
            'Units','normalized',...
            'Position',[0.0 0.0 1 1]);
setappdata(f,'listWaterH',listWaterH) %saving handle to make it accessible

uipanelCalibrationH = uipanel('Title','Calibration fluid','FontSize',12,...
             'Position',[.3333 .5 .3333 0.25],...
             'Parent',uipanelParH,...
             'BorderWidth',3);
setappdata(f,'uipanelCalibrationH',uipanelCalibrationH);

%Creating listbox
listCalibrationH = uicontrol(uipanelCalibrationH,'Style','listbox',...
            'Units','normalized',...
            'Position',[0.0 0.0 1 1]);
setappdata(f,'listCalibrationH',listCalibrationH) %saving handle to make it accessible

uipanelQEFH = uipanel('Title','Fluorolog','FontSize',12,...
             'Position',[.3333 .0 .3333 0.5],...
             'Parent',uipanelParH,...
             'BorderWidth',3);
setappdata(f,'uipanelQEFH',uipanelQEFH);

% Column names and column format
columnname = {'Channel','Fluorolog'};
columnformat = {'numeric','numeric'};

% Create the uitable
uitableFH = uitable('Data', [0, 0],... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', [false true ],...
            'RowName',[],...
            'Parent',uipanelQEFH,...
            'Units','normalized',...
            'Position',[0 0 1 1]);
setappdata(f,'uitableFH',uitableFH);

% Create uipanel for masks
uipanelMasksH = uipanel('Title','Cell masks','FontSize',12,...
             'Position',[.6666 .5 .3333 .5],...
             'Parent',uipanelParH,...
             'BorderWidth',3);
setappdata(f,'uipanelMasksH',uipanelMasksH);
%Creating listbox
listMasksH = uicontrol(uipanelMasksH,'Style','listbox',...
            'Units','normalized',...
            'Position',[0.0 0.0 1 1]);
setappdata(f,'listMasksH',listMasksH) %saving handle to make it accessible

% Create uipanel for background masks
uipanelMasksBH = uipanel('Title','Background masks','FontSize',12,...
             'Position',[.6666 0 .3333 .5],...
             'Parent',uipanelParH,...
             'BorderWidth',3);
setappdata(f,'uipanelMasksBH',uipanelMasksBH);
%Creating listbox
listMasksBH = uicontrol(uipanelMasksBH,'Style','listbox',...
            'Units','normalized',...
            'Position',[0.0 0.0 1 1]);
setappdata(f,'listMasksBH',listMasksBH) %saving handle to make it accessible


%% ACTIONS
uipanelActionsH = uipanel('Title','Actions','FontSize',12,'FontWeight','bold',...
             'Position',[.6766 .0 .3233 1],...
             'Parent',f,...
             'BorderWidth',3);
setappdata(f,'uipanelActionsH',uipanelActionsH); 

%%%%%%% Cosmic Rays Removal
uipanelCosmicH = uipanel('Title','Cosmic Rays Removal','FontSize',12,...
             'Position',[0 .75 1 0.25],...
             'Parent',uipanelActionsH);
setappdata(f,'uipanelCosmicH',uipanelCosmicH);

popupCosmicH = uicontrol('Style','popup',...
                'Parent',uipanelCosmicH,...
                'String',{'Fast Cosmic Rays Removal','no cosmic rays removal'},...
                'Units','normalized',...
                'Position', [0.4 0.8 0.6 0.2]);  
setappdata(f,'popupCosmicH',popupCosmicH);

textWindowSizeCosmicH = uicontrol('Style','text','String','Window size: 5','FontSize',12,...
    'Parent',uipanelCosmicH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.8 0.35 0.2]);
setappdata(f,'textWindowSizeCosmicH',textWindowSizeCosmicH); 

sliderSmoothWCH = drawSlider(10,5,100,[0.05 0.5 0.9 0.25],uipanelCosmicH, 1,5);
setappdata(f,'sliderSmoothWCH',sliderSmoothWCH); 
%callback                      
sliderSmoothCallWCH = handle(sliderSmoothWCH, 'CallbackProperties');
set(sliderSmoothCallWCH, 'MouseReleasedCallback', {@sliderCosmicWindowSize_callback,f},...
    'KeyReleasedCallback', {@sliderCosmicWindowSize_callback,f}); 

textThreshH = uicontrol('Style','text','String','Threshold:','FontSize',12,...
    'Parent',uipanelCosmicH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.2 0.35 0.1]);

editTextH = uicontrol('Style','edit',...
                'Parent',uipanelCosmicH,...
                'String','3',...
                'Units','normalized',...
                'Position', [0.4 0.2 0.6 0.1]);  
setappdata(f,'editTextH',editTextH);

popupTestCosmicH = uicontrol('Style','popup',...S
                'Parent',uipanelCosmicH,...
                'String',{'cell','water','calibration fluid'},...
                'Units','normalized',...
                'Callback',{@testCosmic_callback,f},...
                'Position', [0.4 0 0.6 0.2]);  
setappdata(f,'popupTestCosmicH',popupTestCosmicH);

textTestCosmicH = uicontrol('Style','text','String','Test on selected file: ','FontSize',12,...
    'Parent',uipanelCosmicH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.35 0.2]);

%%%%%%% Smoothing Water and Calibration Fluid
uipanelSmoothWCH = uipanel('Title','Smoothing Water and Calibration Fluid','FontSize',12,...
             'Position',[0 .5 1 0.25],...
             'Parent',uipanelActionsH);
setappdata(f,'uipanelSmoothWCH',uipanelSmoothWCH); 

% wavelets part
textWaveletWCH = uicontrol('Style','text','String','Wavelet:','FontSize',12,...
    'Parent',uipanelSmoothWCH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.8 0.3 0.2]);
popupWaveletWCH = uicontrol('Style','popup',... % drop-down list
                'Parent',uipanelSmoothWCH,...
                'String',{'wavelet'},...
                'Units','normalized',...
                'Position',[0.4 0.8 0.6 0.2]);
setappdata(f,'popupWaveletWCH', popupWaveletWCH)

uipanelSParWCH = uipanel('Title','Smoothing parameters','FontSize',12,...
    'Position',[0 .25 1 0.6],...
    'Parent',uipanelSmoothWCH);

uibgWCH = uibuttongroup('Visible','on','Position',[0 .55 .50 0.35],...
    'Parent',uipanelSParWCH);
button1WCH = uicontrol('Parent',uibgWCH,'Style','radiobutton','FontSize',12,'Units','normalized',...
    'String','All channels','Callback',{@allWCH_callback,f},'Position',[0 0.25 .5 .4]);
setappdata(f,'button1WCH',button1WCH); 
button2WCH = uicontrol('Parent',uibgWCH,'Style','radiobutton','FontSize',12,'Units','normalized',...
    'String','Individual','Position',[0.5 0.25 .5 .4],'Callback',{@differentWCH_callback,f},'Enable','off','HandleVisibility','on');
setappdata(f,'button2WCH',button2WCH); 

popupChWCH = uicontrol('Style','popup','Enable','off',...
                'Parent',uipanelSParWCH,...
                'String',get(getappdata(f,'uitableFH'),'Data'),...
                'Units','normalized',...
                'Callback',{@channelPWCH_callback,f},...
                'Position', [0.54 0.6 .14 .2],'Enable','off');  
setappdata(f,'popupChWCH',popupChWCH);

nowSliderWCH = 300;
editWCH = uicontrol('Parent',uipanelSParWCH,'Style','edit','FontSize',12,'Units','normalized', ...
    'Position',[0.71 0.6 .14 .2],'String',nowSliderWCH(1),'Callback',{@editWCH_callback,f}); 
setappdata(f,'editWCH',editWCH);
setappdata(f,'nowSliderWCH',nowSliderWCH);

buttonPWCH = uicontrol('Parent',uipanelSParWCH,'Style','pushbutton',...
    'String','...',...
    'Units','normalized',...
    'Position',[0.88 0.6 .07 .2],...
    'Units','normalized', ...
    'Callback',{@buttonPWCH_callback,f},...
    'FontSize',12,'Enable','off');
setappdata(f,'buttonPWCH',buttonPWCH);

sliderDenoiseWCH = drawSlider(100,50,1000,[0.05 0.05 0.9 0.4],uipanelSParWCH, 1,nowSliderWCH(1));
setappdata(f,'sliderDenoiseWCH',sliderDenoiseWCH); 
%callback                      
sliderDenoiseCallWCH = handle(sliderDenoiseWCH, 'CallbackProperties');
set(sliderDenoiseCallWCH, 'MouseReleasedCallback', {@sliderDenoiseWCH_callback,f},...
    'KeyReleasedCallback', {@sliderDenoiseWCH_callback,f}); 

popupTestWH = uicontrol('Style','popup',...
                'Parent',uipanelSmoothWCH,...
                'String',{'water','calibration fluid'},...
                'Callback',{@testWave_callback,f,1},...
                'Units','normalized',...
                'Position', [0.4 0 0.6 0.2]);  
setappdata(f,'popupTestWH',popupTestWH);

textTestCosmicH = uicontrol('Style','text','String','Test on selected file: ','FontSize',12,...
    'Parent',uipanelSmoothWCH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.35 0.2]);

%%%%%%% Smoothing Cells
uipanelSmoothCH = uipanel('Title','Smoothing Cells','FontSize',12,...
             'Position',[0 .25 1 0.25],...
             'Parent',uipanelActionsH);
setappdata(f,'uipanelSmoothCH',uipanelSmoothCH); 
 
% wavelets part
textWaveletCH = uicontrol('Style','text','String','Wavelet:','FontSize',12,...
    'Parent',uipanelSmoothCH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.8 0.3 0.2]);
popupWaveletCH = uicontrol('Style','popup',...
                'Parent',uipanelSmoothCH,...
                'String',{'wavelet','no wavelet'},...
                'Units','normalized', ...
                'Callback',{@waveletCH_callback,f},...
                'Position',[0.4 0.8 0.6 0.2]);
setappdata(f,'popupWaveletCH', popupWaveletCH)

uipanelSParCH = uipanel('Title','Smoothing parameters','FontSize',12,...
    'Position',[0 .25 1 0.6],...
    'Parent',uipanelSmoothCH);

uibgCH = uibuttongroup('Visible','on','Position',[0 .55 .50 0.35],...
    'Parent',uipanelSParCH);
button1CH = uicontrol('Parent',uibgCH,'Style','radiobutton','FontSize',12,'Units','normalized',...
    'String','All channels','Callback',{@allCH_callback,f},'Position',[0 0.25 .5 .4]);
setappdata(f,'button1CH',button1CH); 
button2CH = uicontrol('Parent',uibgCH,'Style','radiobutton','FontSize',12,'Units','normalized',...
    'String','Individual','Position',[0.5 0.25 .5 .4],'HandleVisibility','on','Callback',{@differentCH_callback,f},'Enable','off');
setappdata(f,'button2CH',button2CH); 

popupChCH = uicontrol('Style','popup','Enable','off',...
                'Parent',uipanelSParCH,...
                'String',get(getappdata(f,'uitableFH'),'Data'),...  
                'Units','normalized',...
                'Callback',{@channelPCH_callback,f},...
                'Position', [0.54 0.6 .14 .2]);  
setappdata(f,'popupChCH',popupChCH);

nowSliderCH = 250;

editCH = uicontrol('Parent',uipanelSParCH,'Style','edit','FontSize',12,'Units','normalized', ...
    'Position',[0.71 0.6 .14 .2],'String',nowSliderCH(1),'Callback',{@editCH_callback,f}); 
setappdata(f,'editCH',editCH);
setappdata(f,'nowSliderCH',nowSliderCH);

buttonPCH = uicontrol('Parent',uipanelSParCH,'Style','pushbutton',...
    'String','...',...
    'Units','normalized',...
    'Position',[0.88 0.6 .07 .2],...
    'Units','normalized', ...
    'Callback',{@buttonPCH_callback,f},...
    'FontSize',12,'Enable','off');
setappdata(f,'buttonPCH',buttonPCH);

sliderDenoiseCH = drawSlider(100,50,1000,[0.05 0.05 0.9 0.4],uipanelSParCH, 1,nowSliderCH(1));
setappdata(f,'sliderDenoiseCH',sliderDenoiseCH); 
%callback                      
sliderDenoiseCallCH = handle(sliderDenoiseCH, 'CallbackProperties');
set(sliderDenoiseCallCH, 'MouseReleasedCallback', {@sliderDenoiseCH_callback,f},...
    'KeyReleasedCallback', {@sliderDenoiseCH_callback,f}); 

popupTestCH = uicontrol('Style','popup',...
                'Parent',uipanelSmoothCH,...
                'String',{'cell'},...
                'Callback',{@testWave_callback,f,2},...
                'Units','normalized',...
                'Position', [0.4 0 0.35 0.2]);  
setappdata(f,'popupTestCH',popupTestCH);

shiftCH = uicontrol('Parent',uipanelSmoothCH,'Style','checkbox',...
    'String','Shifting',...
    'Units','normalized',...
    'Position',[0.83 0 .22 .3],...
    'Units','normalized',...
    'FontSize',12,'Value',1);
setappdata(f,'shiftCH',shiftCH);

textTestCH = uicontrol('Style','text','String','Test on selected file: ','FontSize',12,...
    'Parent',uipanelSmoothCH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.35 0.2]);


%%%%%%%%%%% Preparing for unmixing
uipanelPrepareH = uipanel('Title','Flattening for unmixing','FontSize',12,...
             'Position',[0 0.2 1 0.05],...
             'Parent',uipanelActionsH);
setappdata(f,'uipanelPrepareH',uipanelPrepareH);

buttonPrepareH = uicontrol(uipanelPrepareH,'Style','pushbutton',...
             'String','Flatten',...
             'Units','normalized',...
             'Position',[0 0 1 1],...
             'Callback',{@buttonPrepare_callback,f},...
             'Units','normalized',...
             'FontWeight','bold',...
             'FontSize',14);
     
%%%%%%%%%%% Statistics for separate cells
uipanelStatH = uipanel('Title','Statistics for cells','FontSize',12,...
             'Position',[0 0.15 1 0.05],...
             'Parent',uipanelActionsH);
setappdata(f,'uipanelStatH',uipanelStatH);

buttonStatH = uicontrol(uipanelStatH,'Style','pushbutton',...
             'String','Generate statistics',...
             'Units','normalized',...
             'Position',[0 0 1 1],...
             'Callback',{@buttonStat_callback,f},...
             'Units','normalized',...
             'FontWeight','bold',...
             'FontSize',14);         
         
%%%%%%%%%%% Statistics for separate cells
uipanelUnmixTabH = uipanel('Title','Table for unmixing','FontSize',12,...
             'Position',[0 0.1 1 0.05],...
             'Parent',uipanelActionsH);
setappdata(f,'uipanelUnmixTabH',uipanelUnmixTabH);

buttonUnmixTabH = uicontrol(uipanelUnmixTabH,'Style','pushbutton',...
             'String','Generate table for unmixing',...
             'Units','normalized',...
             'Position',[0 0 1 1],...
             'Callback',{@buttonUnmixTab_callback,f},...
             'Units','normalized',...
             'FontWeight','bold',...
             'FontSize',14);

% %% GLOBAL CONSTANTS
% QE_OLD = [0.500000000000000;0.500000000000000;0.500000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.600000000000000;0.600000000000000;0.600000000000000];
% 
% %%
% BB=HAC_Image.projectStruct.hardware.camera.QuantumEffResponse;
% DD=interp1(BB(:,1),BB(:,2),[BB(1,1):1:BB(end,1)]);
% QE_all(:,2)=DD.';
% QE_all(:,1)=([BB(1,1):1:BB(end,1)]).';
% for jj=1:nChannel
%     r1=find(QE_all(:,1)==str2double(AA{1,jj}));
%     QE_SM(jj,1)=QE_all(r1,2);
% end
% QE_NEW = QE_SM %[59.50892319;59.50892319;59.50892319;59.50892319;59.50892319;59.50892319;59.50892319;59.50892319;59.50892319;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;72.40146452;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436;55.11851436]; %38 channels
% clear  BB DD QE_all r1 QE_SM
% %%
% SENS=str2double(HAC_Image.projectStruct.hardware.camera.epercount);
% BIAS = 0; %%str2double(HAC_Image.projectStruct.hardware.camera.darkoffset); I am using it because this will taken care by the water
% structConst.QEOLD = QE_OLD;
% structConst.QENEW = QE_NEW;
% structConst.SENS = SENS;
% structConst.BIAS = BIAS;
%saving for future use
% setappdata(f,'structConst',structConst);
         
end

%%================================================%%
%%====================Callback functions==========%%
%%================================================%%
function menuCells_callback(hObject,callbackdata,figH)
[filenameCell, pathnameCell] = uigetfile( ...
       {'*.mat','MAT-files (*.mat)'}, ...
        'Pick files', ...
        'MultiSelect', 'on');
    
if  ~isequal(filenameCell,0)
    setappdata(figH,'pathnameCell',pathnameCell); % save folder name
    % updating listCell
    listCellsH = getappdata(figH,'listCellsH');
    set(listCellsH,'string',filenameCell);
    % updating title uipanel
    uipanelCellsH = getappdata(figH,'uipanelCellsH');
    if ischar(filenameCell) %handling error when there is only 1 file
        filenameCell = {filenameCell}; 
    end
    set(uipanelCellsH,'Title',['Cells | ',num2str(numel(filenameCell(:))), ' file(s)'])
end

end

function menuWater_callback(hObject,callbackdata,figH)
[filenameWater, pathnameWater] = uigetfile( ...
       {'*.mat','MAT-files (*.mat)'}, ...
        'Pick files', ...
        'MultiSelect', 'off');
    
if  ~isequal(filenameWater,0)
    setappdata(figH,'pathnameWater',pathnameWater); % save folder name
    % updating listWater
    listWaterH = getappdata(figH,'listWaterH');
    set(listWaterH,'string',filenameWater);
     % updating title uipanel
    uipanelWaterH = getappdata(figH,'uipanelWaterH');
    set(uipanelWaterH,'Title',['Water | 1 file'])
end
end

function menuCalibration_callback(hObject,callbackdata,figH)
[filenameCalibration, pathnameCalibration] = uigetfile( ...
       {'*.mat','MAT-files (*.mat)'}, ...
        'Pick files', ...
        'MultiSelect', 'off');
    
if  ~isequal(filenameCalibration,0)
    setappdata(figH,'pathnameCalibration',pathnameCalibration); % save folder name
    % updating listWater
    listCalibrationH = getappdata(figH,'listCalibrationH');
    set(listCalibrationH,'string',filenameCalibration);
     % updating title uipanel
    uipanelCalibrationH = getappdata(figH,'uipanelCalibrationH');
    set(uipanelCalibrationH,'Title',['Calibration fluid | 1 file'])
end
end

function menuFluorolog_callback(hObject,callbackdata,figH)
[filenameFluorolog, pathnameFluorolog] = uigetfile( ...
       {'*.xls;*.xlsx','Excel-files (*.xls, *.xlsx)'}, ...
        'Pick files', ...
        'MultiSelect', 'off');
    
if  ~isequal(filenameFluorolog,0)
    % setting 
    tableFluorolog = readtable(strcat(pathnameFluorolog, filenameFluorolog));
    % updating tableFluorolog
    set(getappdata(figH,'uitableFH'),'Data',tableFluorolog{:,:});
    set(getappdata(figH,'button2CH'),'Enable','on'); 
    set(getappdata(figH,'button2WCH'),'Enable','on');
    set(getappdata(figH,'button2CH'),'Value',0);
    set(getappdata(figH,'button2WCH'),'Value',0);
    set(getappdata(figH,'button1CH'),'Value',1);
    set(getappdata(figH,'button1WCH'),'Value',1);
    set(getappdata(figH,'popupChWCH'),'String',table2cell(tableFluorolog(:,1)));
    set(getappdata(figH,'popupChCH'),'String',table2cell(tableFluorolog(:,1))); 
    cValue = str2double(get(getappdata(figH,'editWCH'),'String'));
    setappdata(figH,'nowSliderWCH',repmat(cValue(1),size(tableFluorolog,1),1));
    cValue = str2double(get(getappdata(figH,'editCH'),'String'));
    setappdata(figH,'nowSliderCH',repmat(cValue(1),size(tableFluorolog,1),1));
    set(getappdata(figH,'popupChWCH'),'Enable','off');
    set(getappdata(figH,'popupChCH'),'Enable','off');
    set(getappdata(figH,'buttonPWCH'),'Enable','off');
    set(getappdata(figH,'buttonPCH'),'Enable','off');
end
end

function menuMasks_callback(hObject,callbackdata,figH)
[filenameMask, pathnameMask] = uigetfile( ...
       {'*.png','PNG-files (*.png)';...
        '*.tif','TIF-files (*.tif)'},... 
        'Pick files', ...
        'MultiSelect', 'on');
    
if ~isequal(filenameMask,0)
    setappdata(figH,'pathnameMask',pathnameMask); % save folder name
    % updating listMask
    listMasksH = getappdata(figH,'listMasksH');
    set(listMasksH,'string',filenameMask);
    % updating title uipanel
    uipanelMasksH = getappdata(figH,'uipanelMasksH');
    if ischar(filenameMask) %handling error when there is only 1 file
        filenameMask = {filenameMask}; 
    end
    set(uipanelMasksH,'Title',['Cell masks | ',num2str(length(filenameMask)), ' files'])
end
end

function menuMasksB_callback(hObject,callbackdata,figH)
[filenameMask, pathnameMask] = uigetfile( ...
       {'*.png','PNG-files (*.png)';...
        '*.tif','TIF-files (*.tif)'},... 
        'Pick files', ...
        'MultiSelect', 'on');
    
if ~isequal(filenameMask,0)
    setappdata(figH,'pathnameBMask',pathnameMask); % save folder name
    % updating listMask
    listMasksBH = getappdata(figH,'listMasksBH');
    set(listMasksBH,'string',filenameMask);
    % updating title uipanel
    uipanelMasksBH = getappdata(figH,'uipanelMasksBH');
    if ischar(filenameMask) %handling error when there is only 1 file
        filenameMask = {filenameMask}; 
    end
    set(uipanelMasksBH,'Title',['Background masks | ',num2str(length(filenameMask)), ' files'])
end
end

function buttonPrepare_callback(hObject,callbackdata,figH)
progressbar(0); progressbar('Loading data...');
%%  getting data
listCellsH = getappdata(figH,'listCellsH');
listWaterH = getappdata(figH,'listWaterH');
listCalibrationH = getappdata(figH,'listCalibrationH');
pathnameCell = getappdata(figH,'pathnameCell');
pathnameWater = getappdata(figH,'pathnameWater');
pathnameCalibration = getappdata(figH,'pathnameCalibration');
%
listCellName = get(listCellsH,'string');
listWater = get(listWaterH,'string');
listCalibration = get(listCalibrationH,'string');

%%% GLOBAL CONSTANTS
QE_OLD = [0.46;0.46;0.500000000000000;0.500000000000000;0.500000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.640000000000000;0.600000000000000;0.600000000000000;0.600000000000000];

% DATA FROM QE AND FLUOROLOG, BIAS OFFSET AND SENSITIVITY
structConst = getappdata(figH,'structConst');
tableF = get(getappdata(figH,'uitableFH'),'Data');
% bias = structConst.BIAS; 
% sens = structConst.SENS;
structConst.FLUOROLOG = tableF(:,2);
nChannel = length(tableF(:,2));

% USER REQUESTED TO REMOVE RAYS 1 or 0
remRays = (get(getappdata(figH,'popupCosmicH'),'Value')==1);
rayWinSize = get(getappdata(figH,'sliderSmoothWCH'),'Value');
rayThresh = str2double(get(getappdata(figH,'editTextH'),'String'));

% USER REQUEST TO SHIFT
shiftC = (get(getappdata(figH,'shiftCH'),'Value')==1);

% USER REQUESTED TO SMOOTH WATER AND CALIBRATION FLUID 1 or 0
smoothParamWC = getappdata(figH,'nowSliderWCH'); 

% USER REQUESTED TO SMOOTH CELLS 1 or 0
smoothC = (get(getappdata(figH,'popupWaveletCH'),'Value')==1);
smoothParamC = getappdata(figH,'nowSliderCH'); 

smoothP = table(smoothParamWC, smoothParamC);
if remRays
    nameRemRays = "_CRR_w" + num2str(rayWinSize) +  "_t" + strrep(num2str(rayThresh),".",",");
else
    nameRemRays = "_noCRR";
end
save(strrep(strcat(pathnameWater, listWater),'.mat',...
    append("_SmoothingP_",string(datetime('now','Format','yyyy-MM-dd''_''HH-mm')),nameRemRays,".mat")),'smoothP');

% checking if we have water and calibration fluid

if isempty(listWater) 
     msgTemplate([],[],'Choose water file!','Error')
          return
end
if isempty(listCalibration) 
     msgTemplate([],[],'Choose calibration file!','Error')
          return
end


%% WATER 
% getting full paths
listWaterFull = strcat(pathnameWater, listWater);
listCalibrationFull = strcat(pathnameCalibration, listCalibration);

progressbar(0)         % Initialize/reset bar
progressbar('Water');

if contains(listWater,'_prepared_smoothed') % avoiding operations if water prepared
    [tempWater, ~] = readFile(listWaterFull);
else
    load(listWaterFull)  %loading water
    BB=HAC_Image.projectStruct.hardware.camera.QuantumEffResponse;
    if size(BB,2) >1 
        channel = struct('emission', {HAC_Image.imageStruct.protocol.channel(1:nChannel).emission});
        c = struct2cell(channel);
        AA = [c{:}];
%         AA=(struct2array(channel));
        DD=interp1(BB(:,1),BB(:,2),[BB(1,1):1:BB(end,1)]);
        QE_all(:,2)=DD.';
        QE_all(:,1)=([BB(1,1):1:BB(end,1)]).';
        for jj=1:nChannel
            r1=find(QE_all(:,1)==str2double(AA{1,jj}));
            QE_SM(jj,1)=QE_all(r1,2);
        end
        QE_NEW = QE_SM; 
        SENS=str2double(HAC_Image.projectStruct.hardware.camera.epercount);
        BIAS = 0; %%str2double(HAC_Image.projectStruct.hardware.camera.darkoffset); I am using it because this will taken care by the water
        structConst.QEOLD = QE_OLD;
        structConst.QENEW = QE_NEW;
        structConst.SENS = SENS;
        structConst.BIAS = BIAS;
        bias = structConst.BIAS; 
        sens = structConst.SENS;
    end
    
    try
        if exist('specImage','var')==1 % old structure
            fileStruct = 1 % old structure
            % load parameters
            try
                load(strcat(pathnameWater,'paramDesc_',listWater))
            catch
                msgTemplate([],[],{'No parameters found for: ';listWaterFull},'Error')
            end
    
            tempTimeGainQE = ones(size(specImage));
    
            for i=1:nChannel
                tempTimeGainQE(:,:,i) = tempTimeGainQE(:,:,i)...
                    *para.imageSettings(i).emGain...
                    *para.imageSettings(i).emInt...
                    *structConst.QEOLD(i)...
                    ./structConst.FLUOROLOG(i);
                progressbar(i/(nChannel+0.01)) 
                % removing rays if user requested
                if remRays
                    specImage(:,:,i) = cosmicrr(specImage(:,:,i), rayThresh, rayWinSize);
                end
            end
    
            tempWater = (specImage - bias)*sens./tempTimeGainQE;
        else  %new structure
            fileStruct = 2 %new structure
    
            for i=1:nChannel
                    sens = 1;
                
                progressbar(i/(nChannel+0.01)) 
                % removing rays if user requested
                if remRays
                    HAC_Image.imageStruct.data(:,:,i) = cosmicrr(HAC_Image.imageStruct.data(:,:,i), rayThresh, rayWinSize);
                end
            end
    
            tempWater = HAC_Image.imageStruct.data;
            clear tempTimeGainQE HAC_Image %releasing memory
        end
    catch
        msgTemplate([],[],{'No image found in: ';listWaterFull},'Error')
    end  
    
    progressbar('Smoothing...')
    %Smoothing water ALWAYS
    for iChannel = 1:nChannel
        if fileStruct==1
            sizeTW = size(squeeze(tempWater(:,:,iChannel)));
            tempWater(:,:,iChannel) = imresize(denoise(imresize(squeeze(tempWater(:,:,iChannel)),...
                [1024, 1024]),smoothParamWC(iChannel)),sizeTW);
            progressbar(iChannel/(nChannel+0.01))
            if remRays
                tempWater(:,:,i) = cosmicrr(tempWater(:,:,i), rayThresh, rayWinSize);
            end
            disp(['Channel: ',num2str(iChannel),' smoothed.'])
        else
            tempWater(:,:,iChannel) = denoise(tempWater(:,:,iChannel),smoothParamWC(iChannel));
              progressbar(iChannel/(nChannel+0.01)) 
             disp(['Channel: ',num2str(iChannel),' smoothed.'])
        end
    end
    
    progressbar('Saving...')
    % Saving and clearing memory
    if fileStruct==1
        specImage = round(tempWater,5,'significant');
        save(strrep(strcat(pathnameWater, listWater),'.mat','_prepared_smoothed.mat'),'specImage');
    
        clear tempTimeGainQE specImage para %releasing memory
    else
        HAC_Image.imageStruct.data = round(tempWater,5,'significant');
        save(strrep(strcat(pathnameWater, listWater),'.mat','_prepared_smoothed.mat'),'HAC_Image');
    
        clear tempTimeGainQE HAC_Image %releasing memory
    end
end
   

%% CALIBRATION FLUID
progressbar('Calibration'); 

if contains(listCalibration,'_prepared_smoothed') % avoiding operations if water prepared
    [tempCalibration, ~] = readFile(listCalibrationFull);
else
    % loading calibration files
    load(listCalibrationFull)
    if size(BB,2) >1 
        BB=HAC_Image.projectStruct.hardware.camera.QuantumEffResponse;
        channel = struct('emission', {HAC_Image.imageStruct.protocol.channel(1:nChannel).emission});
        c = struct2cell(channel);
        AA = [c{:}];
%         AA=(struct2array(channel));
        DD=interp1(BB(:,1),BB(:,2),[BB(1,1):1:BB(end,1)]);
        QE_all(:,2)=DD.';
        QE_all(:,1)=([BB(1,1):1:BB(end,1)]).';
        for jj=1:nChannel
            r1=find(QE_all(:,1)==str2double(AA{1,jj}));
            QE_SM(jj,1)=QE_all(r1,2);
        end
        QE_NEW = QE_SM;
        SENS=str2double(HAC_Image.projectStruct.hardware.camera.epercount);
        BIAS = 0; %%str2double(HAC_Image.projectStruct.hardware.camera.darkoffset); I am using it because this will taken care by the water
        structConst.QEOLD = QE_OLD;
        structConst.QENEW = QE_NEW;
        structConst.SENS = SENS;
        structConst.BIAS = BIAS;
        bias = structConst.BIAS;
        sens = structConst.SENS;
    end
    try
        
        if exist('specImage','var')==1 % old structure
            fileStruct=1; % old structure
            %load parameters
            try
                load(strcat(pathnameCalibration,'paramDesc_',listCalibration))
            catch
                 msgTemplate([],[],{'No parameters found for: ';listCalibrationFull},'Error')
            end
            tempTimeGainQE = ones(size(specImage));

            for i=1:nChannel
                tempTimeGainQE(:,:,i) = tempTimeGainQE(:,:,i)...
                    *para.imageSettings(i).emGain...
                    *para.imageSettings(i).emInt...
                    *structConst.QEOLD(i);
                progressbar(i/(nChannel+0.01)) 
                % removing rays if user requested
                if remRays
                    specImage(:,:,i) = cosmicrr(specImage(:,:,i), rayThresh, rayWinSize);
                end
            end

            tempCalibration = (specImage - bias)*sens./tempTimeGainQE;
        else  %new structure
            fileStruct = 2; %new structure

            for i=1:nChannel
                progressbar(i/(nChannel+0.01)) 
                % removing rays if user requested
                if remRays
                    HAC_Image.imageStruct.data(:,:,i) = cosmicrr(HAC_Image.imageStruct.data(:,:,i), rayThresh, rayWinSize);
                end
            end

            tempCalibration = HAC_Image.imageStruct.data;
        end
    catch
        msgTemplate([],[],{'No image found in: ';listCalibrationFull},'Error')
    end  

    progressbar('Smoothing...')
    %smoothing calibration ALWAYS
    for iChannel = 1:nChannel
        if fileStruct==1
            sizeTW = size(squeeze(tempCalibration(:,:,iChannel)));
            tempCalibration(:,:,iChannel) = imresize(denoise(imresize(squeeze(tempCalibration(:,:,iChannel)),...
                [1024, 1024]),smoothParamWC(iChannel)),sizeTW);
            progressbar(iChannel/(nChannel+0.01)) 
            if remRays
                tempCalibration(:,:,i) = cosmicrr(tempCalibration(:,:,i), rayThresh, rayWinSize);
            end
            disp(['Channel: ',num2str(iChannel),' smoothed.'])
        else
            tempCalibration(:,:,iChannel) = denoise(tempCalibration(:,:,iChannel),smoothParamWC(iChannel));
            progressbar(iChannel/(nChannel+0.01)) 
            disp(['Channel: ',num2str(iChannel),' smoothed.'])
        end
    end
    progressbar('Saving...')
    % Saving and clearing memory
    if fileStruct==1
        specImage = round(tempCalibration,5,'significant');
        save(strrep(strcat(pathnameCalibration, listCalibration),'.mat','_prepared_smoothed.mat'),'specImage');

        clear tempTimeGainQE specImage para %releasing memory
    else
        HAC_Image.imageStruct.data = round(tempCalibration,5,'significant');
        save(strrep(strcat(pathnameWater, listCalibration),'.mat','_prepared_smoothed.mat'),'HAC_Image');

        clear tempTimeGainQE HAC_Image %releasing memory
    end

end

%% CELLS START HERE
listCellFull = strcat(pathnameCell, listCellName);
progressbar('Cells');
if ischar(listCellFull)
    listCellFull = {listCellFull};
    listCellName = {listCellName};
end

for iFile=1:length(listCellFull)
    load(listCellFull{iFile});
    progressbar(iFile/(length(listCellFull)+1)); 
    
    tempCell = 0;
    try
        if exist('specImage','var')==1 % old structure
            fileStruct = 1; %oldstructure
            %load parameters
            try
                load(strcat(pathnameCell,'paramDesc_',listCellName{iFile}))
            catch
                 msgTemplate([],[],{'No parameters found for: ';listCellFull{iFile}},'Error')
            end
            tempTimeGainQE = ones(size(specImage));
            
            for i=1:nChannel
                tempTimeGainQE(:,:,i) = tempTimeGainQE(:,:,i)...
                    *para.imageSettings(i).emGain...
                    *para.imageSettings(i).emInt...
                    *structConst.QEOLD(i);
                progressbar(i/(nChannel+0.01)) 
                % removing rays if user requested
                if remRays
                    specImage(:,:,i) = cosmicrr(specImage(:,:,i), rayThresh, rayWinSize);
                end
            end
            
            tempCell = (specImage - bias)*sens./tempTimeGainQE;
         else  %new structure
            fileStruct = 2; % new structure
            BB=HAC_Image.projectStruct.hardware.camera.QuantumEffResponse;
            if size(BB,2) >1 
                channel = struct('emission', {HAC_Image.imageStruct.protocol.channel(1:nChannel).emission});
                c = struct2cell(channel);
                AA = [c{:}];
%                 AA=(struct2array(channel));
                DD=interp1(BB(:,1),BB(:,2),[BB(1,1):1:BB(end,1)]);
                QE_all(:,2)=DD.';
                QE_all(:,1)=([BB(1,1):1:BB(end,1)]).';
                for jj=1:nChannel
                    r1=find(QE_all(:,1)==str2double(AA{1,jj}));
                    QE_SM(jj,1)=QE_all(r1,2);
                end
                QE_NEW = QE_SM; 
                clear  BB DD QE_all r1 QE_SM
                SENS=str2double(HAC_Image.projectStruct.hardware.camera.epercount);
                BIAS = 0; %%str2double(HAC_Image.projectStruct.hardware.camera.darkoffset); I am using it because this will taken care by the water
                structConst.QEOLD = QE_OLD;
                structConst.QENEW = QE_NEW;
                structConst.SENS = SENS;
                structConst.BIAS = BIAS;
                bias = structConst.BIAS;
                sens = structConst.SENS;
            end
            
            for i=1:nChannel
                progressbar(i/(nChannel+0.01)) 
                % removing rays if user requested
                if remRays
                    HAC_Image.imageStruct.data(:,:,i) = cosmicrr(HAC_Image.imageStruct.data(:,:,i), rayThresh, rayWinSize);
                end
            end
            
            tempCell = HAC_Image.imageStruct.data;
        end
    catch
        msgTemplate([],[],{'No image found in: ';listCellFull{iFile}},'Error')
    end
    
    % final operations/flattening and shifting
    tempCell(:,:,1:nChannel) = tempCell(:,:,1:nChannel)-tempWater(:,:,1:nChannel);
    myCalibration(:,:,1:nChannel) = tempCalibration(:,:,1:nChannel)-tempWater(:,:,1:nChannel);

    for iChannel = 1:nChannel
        myImage = myCalibration(:,:,iChannel);

        [I,J] = find(~myImage);
        winsize = 10;
        sizeOld = 0;
        while ~ isempty(I)
            if size(I,1) == sizeOld
                winsize = winsize + 1;
            end
            sizeIm = size(myImage);
            for i=1:numel(I)
                myWindow = myImage(max(I(i)-winsize,1):min(I(i)+winsize,sizeIm(1)),...
                                          max(J(i)-winsize,1):min(J(i)+winsize,sizeIm(2)));
                myImage(I(i),J(i)) = median(nonzeros(myWindow(:)));
            end
            sizeOld = size(I,1);
            [I,J] = find(~myImage);
        end

        myCalibration(:,:,iChannel) = myImage;
    end
    

    
    % apply calibration formula and shifting
    for iChannel = 1:nChannel 
%         tempCell(:,:,iChannel) = tempCell(:,:,iChannel)-repmat(myMedian(iChannel),size(tempCell,1),size(tempCell,2));
%         tempCell(:,:,iChannel) = tempCell(:,:,iChannel)./(myCalibration(:,:,iChannel)-repmat(myMedian(iChannel),size(tempCell,1),size(tempCell,2)));
%         % also shifts calibration
        tempCell(:,:,iChannel) = tempCell(:,:,iChannel)./(myCalibration(:,:,iChannel));
        tempCell(:,:,iChannel) = tempCell(:,:,iChannel).*structConst.FLUOROLOG(iChannel);
    end

    if shiftC
        if hasMasks(figH) % load background masks
            listMasksBH = getappdata(figH,'listMasksBH');
            listMaskBName = get(listMasksBH,'string');
            pathnameMaskB = getappdata(figH,'pathnameBMask');
            listMasksBFull = strcat(pathnameMaskB, listMaskBName);
            if ischar(listMasksBFull)
                listMasksBFull = {listMasksBFull};
            end

            [~, myMedian] = getBackground(tempCell, listCellFull{iFile},listMasksBFull{iFile});
        else
            msgTemplate([],[],{'No image found in: ';listCellFull{iFile}},'Error')
            return
        end
    else
        myMedian = zeros(nChannel,1);
    end

    for iChannel = 1:nChannel 
        tempCell(:,:,iChannel) = tempCell(:,:,iChannel)-repmat(myMedian(iChannel),size(tempCell,1),size(tempCell,2));
    end


    progressbar('Smoothing...')
    % Smoothing if requested by user 
    
    if smoothC 
        for iChannel = 1:nChannel
            if fileStruct==1pre
                sizeTW = size(squeeze(tempCell(:,:,iChannel)));
                tempCell(:,:,iChannel) = imresize(denoise(imresize(squeeze(tempCell(:,:,iChannel)),...
                    [1024, 1024]),smoothParamC(iChannel)),sizeTW);
                progressbar(iChannel/(nChannel+0.01))
                disp(['Channel: ',num2str(iChannel),' smoothed.'])

            else
                tempCell(:,:,iChannel) = denoise(tempCell(:,:,iChannel),smoothParamC(iChannel));
                progressbar(iChannel/(nChannel+0.01)) 
                disp(['Channel: ',num2str(iChannel),' smoothed.'])
            end
        end
    end

    % Saving and clearing memory
    progressbar('Saving...');
    if fileStruct==1
        specImage = round(tempCell,5,'significant');
        if ~smoothC
            save(strrep(strcat(pathnameCell, listCellName{iFile}),'.mat','_prepared.mat'),'specImage');
        else
            save(strrep(strcat(pathnameCell, listCellName{iFile}),'.mat','_prepared_smoothed.mat'),'specImage');
        end
        clear tempTimeGainQE specImage para %releasing memory
    else
        HAC_Image.imageStruct.data = round(tempCell,5,'significant');
    
        if ~smoothC
            save(strrep(strcat(pathnameCell, listCellName{iFile}),'.mat','_prepared.mat'),'HAC_Image');
        else
            save(strrep(strcat(pathnameCell, listCellName{iFile}),'.mat','_prepared_smoothed.mat'),'HAC_Image');
        end
        clear tempTimeGainQE HAC_Image %releasing memory
    end
end  
%closing progressbar   
progressbar(1);
end

function [hasMask] = hasMasks(figH)
% Checks whether correct background masks have been selected
hasMask = false;
listCells = getappdata(figH,'listCellsH');
listCellName = get(listCells,'string');
listMasksBH = getappdata(figH,'listMasksBH');
listMaskBName = get(listMasksBH,'string');

if ischar(listCellName) %handling error when there is only 1 file
    listCellName = {listCellName}; 
end
if ischar(listMaskBName) %handling error when there is only 1 file
    listMaskBName = {listMaskBName};
end

% checking if number of files correct
if length(listCellName)~=length(listMaskBName)
    msgTemplate([],[],'Number of masks and *.mat files is different!','Error')
    return
end

% checking if for every file has mask 
for iFile=1:length(listCellName)
    % looking for related mask
    matchesMasks = strfind(listMaskBName,strrep(listCellName{iFile},'.mat','_back.png'));
    emptyCells = cellfun(@isempty,matchesMasks);
    if length(listMaskBName(~emptyCells))~=1
          msgTemplate([],[],['No masks found for: ', listCellName{iFile},'!'],'Error')
          return
    end 
end
hasMask = true;
end

%% Statistics
function buttonStat_callback(hObject,callbackdata,figH)
% getting masks
listCellsH = getappdata(figH,'listCellsH');
listCellName = get(listCellsH,'string');
listMasksH = getappdata(figH,'listMasksH');
listMaskName = get(listMasksH,'string');
pathnameMask = getappdata(figH,'pathnameMask');
pathnameCell = getappdata(figH,'pathnameCell');
%getting number of channels
nChannel =  size(get(getappdata(figH,'uitableFH'),'Data'),1);

if ischar(listCellName) %handling error when there is only 1 file
    listCellName = {listCellName}; 
end
if ischar(listMaskName) %handling error when there is only 1 file
    listMaskName = {listMaskName};
end

% checking if number of files correct
if length(listCellName)~=length(listMaskName)
    msgTemplate([],[],'Number of masks and *.mat files is different!','Error')
    return
end

% checking if for every file has mask 
for iFile=1:length(listCellName)
    % looking for related mask
    matchesMasks = strfind(listMaskName,strrep(listCellName{iFile},'.mat','.png'));
    emptyCells = cellfun(@isempty,matchesMasks);
    if length(listMaskName(~emptyCells))~=1
          msgTemplate([],[],['No masks found for: ', listCellName{iFile},'!'],'Error')
          return
    end 
end

% Creating table for the output
channelListNumbers = strtrim(cellstr(num2str((1:nChannel)'))')';
channelList = strcat({'Channel_'},channelListNumbers);
rowNames = [{'File'; 'Cell'};channelList; {'Area'}];
tableCells = cell2table(cell(1,3+nChannel));
tableCells.Properties.VariableNames = rowNames;
warning off;

% extracting white regions from masks and calcuating statistics
progressbar(0); progressbar('Calculating statistics...')
ind = 0;
for iFile=1:length(listCellName)
    progressbar(iFile/(length(listCellName)+0.01))
    
    % looking for related mask
    matchesMasks = strfind(listMaskName,strrep(listCellName{iFile},'.mat',''));
    selectedCell = ~cellfun(@isempty,matchesMasks);
    % loading file and mask
    [tempData, ~] = readFile(strrep(strcat(pathnameCell,listCellName{iFile}),'.mat','_prepared_smoothed.mat')); 
    tempMask = imread(strcat(pathnameMask,listMaskName{selectedCell}));
    if ~islogical(tempMask)
        tempMask = imbinarize(tempMask);
    end
    cellRegions = regionprops(tempMask, 'area', 'PixelIdxList','Centroid');
    
    %calculating stats for each region
    for iRegion=1:size(cellRegions,1)
        ind = ind+1;
        tableCells{ind,1:2} = {listCellName{iFile}, strcat('Cell_',num2str(iRegion))};
        for iChannel=1:nChannel
            tempImage = tempData(:,:,iChannel);
            tempImage = tempImage(:);
            tableCells{ind,iChannel+2} = {round(mean(tempImage(cellRegions(iRegion).PixelIdxList)),5,'significant')};
        end
        tableCells{ind,end} = {cellRegions(iRegion).Area};
        
        % numbering each region with associated number from stats.xls
        tempMask = insertText(tempMask*1,round(cellRegions(iRegion).Centroid),...
            strcat('',num2str(iRegion)),'FontSize',18,'BoxColor','red',...
            'BoxOpacity',0.4,'TextColor','white');
        tempMask = insertShape(tempMask, 'FilledCircle', ...
            [round(cellRegions(iRegion).Centroid) 5], 'Color', 'red'); %adding circle
    end
    
    % saving numbered image
    imwrite(tempMask,strcat(pathnameMask,strrep(listMaskName{selectedCell},'.','_numbered.')));
    
    % clearing memory
    clear tempImage tempData tempMask cellRegions
end
% saving
progressbar('Saving...')
filename=[pathnameCell,'stats.xls'];

try
    writetable(tableCells,filename,'Sheet',1)
catch
    opts = struct('WindowStyle','modal','Interpreter','tex');
    errordlg('Close all stats.xls/stats.xlsx file','xls write Error!', opts);
end
progressbar(1)

end

%% UNMIXING
function buttonUnmixTab_callback(hObject,callbackdata,figH)
% GETTING NECESSARY DATA FROM GUI
listCellsH = getappdata(figH,'listCellsH');
listCellName = get(listCellsH,'string');
listMasksH = getappdata(figH,'listMasksH');
listMaskName = get(listMasksH,'string');
pathnameMask = getappdata(figH,'pathnameMask');
pathnameCell = getappdata(figH,'pathnameCell');
% getting number of channels
tableFQ = array2table(get(getappdata(figH,'uitableFH'),'Data'));
tableFQ.Properties.VariableNames = get(getappdata(figH,'uitableFH'),'ColumnName');

nChannel =  size(tableFQ,1);

if ischar(listCellName) % handling error when there is only 1 file
    listCellName = {listCellName}; 
end
if ischar(listMaskName) % handling error when there is only 1 file
    listMaskName = {listMaskName};
end

% checking if number of files correct
if length(listCellName)~=length(listMaskName)
    msgTemplate([],[],'Number of masks and *.mat files is different!','Error')
    return
end
 
% TABLES FOR STORING DATA
% saving to table (n channels, file_no, pixel number) + file_desc(file no, file name, file type)
headerPixel = strrep(strcat({'Channel_'}, num2str((1:nChannel)'))',' ','');
headerPixel = [headerPixel,{'FileNo' 'PixelIndex'}];
cellPixel = cell(0,size(headerPixel,2));
tablePixel = cell2table(cellPixel);
tablePixel.Properties.VariableNames = headerPixel; %tablePixel stores necessary data

tableFile = cell2table(cell(0,3));
tableFile.Properties.VariableNames = {'FileNo' 'FileName' 'FileType'};

progressbar(0); progressbar('Applying mask to cells...')

for iFile=1:length(listMaskName)
    % loading cell file
    [tempCell, ~] = readFile(strrep(strcat(pathnameCell,listCellName{iFile}),'.mat','_prepared_smoothed.mat'));
    % looking for related mask
    matchesMasks = strfind(listMaskName,strrep(strrep(strrep(listCellName{iFile},'.mat',''),'_prepared',''),'_smoothed',''));
    emptyCells = cellfun(@isempty,matchesMasks);
    listMaskName(~emptyCells); % related mask
    
    % loading mask
    tempMask = imbinarize(imread(strcat(pathnameMask,listMaskName{iFile}))); % instead of im2bw
    cellRegions = regionprops(tempMask, 'area', 'PixelIdxList','Centroid');
    % calculating stats for each region Date 29 Mar 22
    tempMask1 = cell(size(cellRegions,1),1);
    for iRegion=1:size(cellRegions,1)
        tempMask1{iRegion,1}=cellRegions(iRegion).PixelIdxList;
    end
    tempMask=cell2mat(tempMask1);
 
    % extracting selected pixels
    tempCell = tempCell(:,:,1:nChannel);
    
    % reshaping for selecting right pixels
    tempCell = reshape(tempCell,[size(tempCell,1)*size(tempCell,2) size(tempCell,3)]);
    tempCell = tempCell(tempMask(:),:);
    
    % saving data to table (n channels, file_no, pixel number) + file_desc(file no, file name, file type)
    
    tablePixel = [tablePixel;...
        array2table([tempCell, iFile*ones(size(tempCell,1),1), find(tempMask(:)>0)],...
        'VariableNames',headerPixel)];
    tableFile = [tableFile;...
        cell2table({num2str(iFile), listCellName{iFile}, 'Cell'},...
        'VariableNames',{'FileNo' 'FileName' 'FileType'})]; 
    
    % cleaning memory
    clear tempCell tempMask
    progressbar(iFile/(length(listMaskName)+0.01))
end
% SAVING NECESSARY DATA
progressbar('Saving...'); 
filename1=[pathnameCell,'pixel.mat'];
save(filename1,'tablePixel','tableFile','tableFQ')
progressbar(1);
    
end

%% Test functions
function testCosmic_callback(hObject,callbackdata,figH)
if get(getappdata(figH,'popupCosmicH'),'Value')==1
% getting number of channel
channel = str2double(inputdlg('Enter Channel:',...
             'Select Channel', [1 50]));
    if isempty(channel)
        msgTemplate([],[],'No channel provided. ','Error')
    else
        % getting fileType (water, calibration fluid, cells)
        fileType = {'listCellsH', 'listWaterH', 'listCalibrationH'};
        fileFolder = {'pathnameCell', 'pathnameWater', 'pathnameCalibration'};
        listSel = get(getappdata(figH,fileType{get(hObject,'Value')}),{'string','value'});
        if iscell(listSel{1})
            listSel =  listSel{1}(listSel{2});
        else
            listSel =  listSel(1);
        end
         
        listSelFull = strcat(getappdata(figH,fileFolder{get(hObject,'Value')}),listSel);

        % reading selected file from listbox
        try
            [tempData, ~] = readFile(listSelFull{1});
             % working with selected channel only
             tempData = squeeze(tempData(:,:,channel));
                try
                    % obtaining results
                    im = cosmicrr(tempData,...% image
                        str2double(get(getappdata(figH,'editTextH'),'String')),...% threshhold
                        get(getappdata(figH,'sliderSmoothWCH'),'Value')); % window size
                    % showing result
                    figCosmic = figure;
                    subplot(121); mesh(tempData); title(strcat('Original image | Channel: ',...
                        num2str(channel), ' | ',strrep(listSel,'_','\_')));
                    subplot(122); mesh(im); title(strcat('Image after Fast Cosmic Rays Removal | Channel: ',...
                        num2str(channel)),' | ',strrep(listSel,'_','\_'));
                catch
                end
                catch
            msgTemplate([],[],'File not read','Error')
        end
    end

else
    msgTemplate([],[],'Choose Fast Cosmic Ray Removal for testing.','Warning')
end

end

function testWave_callback(hObject,callbackdata,figH,filePanel)
if (get(getappdata(figH,'popupWaveletWCH'),'Value')==1 && filePanel==1) || (get(getappdata(figH,'popupWaveletCH'),'Value')==1 && filePanel==2 )
% getting number of channel
channel = str2double(inputdlg('Enter Channel:',...
             'Select Channel', [1 50]));
    if isempty(channel)
        msgTemplate([],[],'No channel provided. ','Error')
    else
        % getting fileType (water, calibration fluid, cells)
        switch filePanel
            case 1
                 fileType = {'listWaterH', 'listCalibrationH'};
                 fileFolder = {'pathnameWater', 'pathnameCalibration'};
                 cValue = getappdata(figH,'nowSliderWCH');
            case 2
                 fileType = {'listCellsH'};
                 fileFolder = {'pathnameCell'};
                 cValue = getappdata(figH,'nowSliderCH');
        end
        myParameter = cValue(channel);
        listSel = get(getappdata(figH,fileType{get(hObject,'Value')}),{'string','value'});
        if iscell(listSel{1})
            listSel =  listSel{1}(listSel{2});
        else
            listSel =  listSel(1);
        end
        
        listSelFull = strcat(getappdata(figH,fileFolder{get(hObject,'Value')}),listSel);
        
        % USER REQUESTED TO REMOVE RAYS 1 or 0
        remRays = (get(getappdata(figH,'popupCosmicH'),'Value')==1);
        rayWinSize = get(getappdata(figH,'sliderSmoothWCH'),'Value');
        rayThresh = str2double(get(getappdata(figH,'editTextH'),'String'));

        % reading selected file from listbox
        try
            [tempData, fileStruct] = readFile(listSelFull{1});
             % working with selected channel only
             tempData = squeeze(tempData(:,:,channel));
             sizeTempData = size(tempData);
             if fileStruct==1 %resizing of image for denoising if size is not 2^n x 2^n
                 tempData = imresize(tempData,[1024, 1024]);
             end
            try
                % obtaining results
                if remRays
                    tempData = cosmicrr(tempData, rayThresh, rayWinSize);
                end
                im = denoise(tempData,myParameter);
                if remRays && filePanel==1
                    im = cosmicrr(im, rayThresh, rayWinSize);
                end
                % downsizing in case of old structure
                if fileStruct==1 %downsizing of image after denoising
                    tempData = imresize(tempData,  sizeTempData);
                end
                % showing result
                figWave = figure;
                ax3 = subplot(2,2,3); imshow(tempData,[],'Parent',ax3); 
                ax4 = subplot(2,2,4); imshow(im,[],'Parent',ax4);
                title(ax4,['Parameter: ',num2str(myParameter)])
                ax1 = subplot(2,2,1); mesh(tempData); title(strcat('Original image | Channel: ',...
                    num2str(channel), ' | ',strrep(listSel,'_','\_')));
                colormap(ax1,'default')
                ax2 = subplot(2,2,2); mesh(im); title(strcat('Image after Denoising | Channel: ',...
                    num2str(channel),' | ',strrep(listSel,'_','\_')));
                colormap(ax2, 'default');
            catch
            end
        catch
            msgTemplate([],[],'File not read.','Error')
        end
    end

else
    msgTemplate([],[],'Choose wavelet for testing.','Warning')
end

end

%% GUI functionality
function hSlider = drawSlider(MajorTickSpacing,MinorTickSpacing,Maximum,Position,uipanel, Scale,Val)
hSlider = uicomponent('style','slider',...
                      'MajorTickSpacing',MajorTickSpacing,'MinorTickSpacing',MinorTickSpacing,... 
                      'Paintlabels',1,'PaintTicks',1,'Maximum',Maximum);  % vertical slider
                      set(hSlider,'Units','norm')          
                      set(hSlider,'Position',Position)
                      set(hSlider,'Parent',uipanel)
                      set(hSlider,'Enabled',1)
                      % Create the label table for slider
                      labelTable = java.util.Hashtable();
                      for iLabel=0:MajorTickSpacing:Maximum
                        labelTable.put(int32(iLabel), javax.swing.JLabel(num2str(iLabel/Scale)));
                      end
                      set(hSlider, 'LabelTable',labelTable);
                      set(hSlider, 'Value',Val)
end

function sliderCosmicWindowSize_callback(hObject,callbackdata,figH)
% Callback for changing Text in Window Size                      
set(getappdata(figH,'textWindowSizeCosmicH'),'String',...
    ['Window size: ',num2str(get(getappdata(figH,'sliderSmoothWCH'),'Value'))]);
end

function sliderDenoiseWCH_callback(hObject,callbackdata,figH)
% Callback for changing Text in Window Size   
sliderValue = get(getappdata(figH,'sliderDenoiseWCH'),'Value');
set(getappdata(figH,'editWCH'),'String',sliderValue);
cValue = getappdata(figH,'nowSliderWCH');
if get(getappdata(figH,'button2WCH'),'Value')
    myIndex = get(getappdata(figH,'popupChWCH'),'Value');
    cValue(myIndex) = sliderValue;
    setappdata(figH,'nowSliderWCH',cValue);
else
    setappdata(figH,'nowSliderWCH',repmat(sliderValue,size(cValue,1),1));
end
end

function sliderDenoiseCH_callback(hObject,callbackdata,figH)
% Callback for changing Text in Window Size 
sliderValue = get(getappdata(figH,'sliderDenoiseCH'),'Value');
set(getappdata(figH,'editCH'),'String',sliderValue);
cValue = getappdata(figH,'nowSliderCH');
if get(getappdata(figH,'button2CH'),'Value')
    myIndex = get(getappdata(figH,'popupChCH'),'Value');
    cValue(myIndex) = sliderValue;
    setappdata(figH,'nowSliderCH',cValue);
else
    setappdata(figH,'nowSliderCH',repmat(sliderValue,size(cValue,1),1));
end
end

function channelPWCH_callback(hObject, callbackdata,figH)
% Panel channel selection (water, cal)
nowSliderWCH = getappdata(figH,'nowSliderWCH');
myIndex = get(getappdata(figH,'popupChWCH'),'Value');
set(getappdata(figH,'sliderDenoiseWCH'),'Value',nowSliderWCH(myIndex));
set(getappdata(figH,'editWCH'),'String',nowSliderWCH(myIndex));
end

function channelPCH_callback(hObject, callbackdata,figH)
% Panel channel selection (cell)
nowSliderCH = getappdata(figH,'nowSliderCH');
myIndex = get(getappdata(figH,'popupChCH'),'Value');
set(getappdata(figH,'sliderDenoiseCH'),'Value',nowSliderCH(myIndex));
set(getappdata(figH,'editCH'),'String',nowSliderCH(myIndex));
end

function editWCH_callback(hObject, callbackdata,figH)
% Panel field edit parameter (water, cal)
sliderValue = str2double(get(getappdata(figH,'editWCH'),'String'));
if isnan(sliderValue)
    warndlg('Input must be numerical');
    sliderValue = -1;
end

if sliderValue < 0
    sliderValue = 0;
    set(getappdata(figH,'editWCH'),'String',sliderValue);
elseif sliderValue > 1000
    sliderValue = 1000;
    set(getappdata(figH,'editWCH'),'String',sliderValue);
end

set(getappdata(figH,'sliderDenoiseWCH'),'Value',sliderValue);
cValue = getappdata(figH,'nowSliderWCH');
if get(getappdata(figH,'button2WCH'),'Value')
    myIndex = get(getappdata(figH,'popupChWCH'),'Value');
    cValue(myIndex) = sliderValue;
    setappdata(figH,'nowSliderWCH',cValue);
else
    setappdata(figH,'nowSliderWCH',repmat(sliderValue,size(cValue,1),1));
end
end

function editCH_callback(hObject, callbackdata,figH)
% Panel field edit parameter (cell)
sliderValue = str2double(get(getappdata(figH,'editCH'),'String'));
if isnan(sliderValue)
    warndlg('Input must be numerical');
    sliderValue = -1;
end
if sliderValue < 0
    sliderValue = 0;
    set(getappdata(figH,'editCH'),'String',sliderValue);
elseif sliderValue > 1000
    sliderValue = 1000;
    set(getappdata(figH,'editCH'),'String',sliderValue);
end

set(getappdata(figH,'sliderDenoiseCH'),'Value',sliderValue);
cValue = getappdata(figH,'nowSliderCH');
if get(getappdata(figH,'button2CH'),'Value')
    myIndex = get(getappdata(figH,'popupChCH'),'Value');
    cValue(myIndex) = sliderValue;
    setappdata(figH,'nowSliderCH',cValue);
else
    setappdata(figH,'nowSliderCH',repmat(sliderValue,size(cValue,1),1));
end

end

function allWCH_callback(hObject,callbackdata,figH)
% Callback for radio button all (water, cal)                     
nowSliderWCH = getappdata(figH,'nowSliderWCH');
setappdata(figH,'nowSliderWCH',repmat(get(getappdata(figH,'sliderDenoiseWCH'),'Value'),size(nowSliderWCH,1),1));
set(getappdata(figH,'popupChWCH'),'Enable','off');
set(getappdata(figH,'buttonPWCH'),'Enable','off');
end

function allCH_callback(hObject,callbackdata,figH)
% Callback for radio button all (cells)                      
nowSliderCH = getappdata(figH,'nowSliderCH');
setappdata(figH,'nowSliderCH',repmat(get(getappdata(figH,'sliderDenoiseCH'),'Value'),size(nowSliderCH,1),1));
set(getappdata(figH,'popupChCH'),'Enable','off');
set(getappdata(figH,'buttonPCH'),'Enable','off');
end

function differentWCH_callback(hObject,callbackdata,figH)
% Callback for radio button different (water, cal) 
set(getappdata(figH,'editWCH'),'String',...
    [num2str(get(getappdata(figH,'sliderDenoiseWCH'),'Value'))]);
set(getappdata(figH,'button2WCH'),'Enable','on');
set(getappdata(figH,'popupChWCH'),'Enable','on');
set(getappdata(figH,'buttonPWCH'),'Enable','on');
end

function differentCH_callback(hObject,callbackdata,figH)
% Callback for radio button different (cell)
set(getappdata(figH,'editCH'),'String',...
    [num2str(get(getappdata(figH,'sliderDenoiseCH'),'Value'))]);
set(getappdata(figH,'button2CH'),'Enable','on');
set(getappdata(figH,'popupChCH'),'Enable','on');
set(getappdata(figH,'buttonPCH'),'Enable','on');
end

function buttonPWCH_callback(hObject,callbackdata,figH)
% Callback for button load parameters (water, cal)
[filenamePWCH, pathnamePWCH] = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
        'Pick file', 'MultiSelect', 'off');
if  ~isequal(filenamePWCH,0) 
    cValue = load(strcat(pathnamePWCH, filenamePWCH),'smoothP');
    cValue = table2array(cValue.smoothP);
    myFluorolog = get(getappdata(figH,'uitableFH'),'Data');
    if size(cValue,2)==2 && size(cValue,1)==size(myFluorolog,1)
        cValue = cValue(:,1);
        setappdata(figH,'nowSliderWCH',cValue);
        myIndex = get(getappdata(figH,'popupChWCH'),'Value');
        set(getappdata(figH,'sliderDenoiseWCH'),'Value',cValue(myIndex));
        set(getappdata(figH,'editWCH'),'String',...
            [num2str(cValue(myIndex))]);
    else
        msgTemplate([],[],'Parameter file has wrong size','Error')
    end
end
end

function buttonPCH_callback(hObject,callbackdata,figH)
% Callback for button load parameters (cell)
[filenamePCH, pathnamePCH] = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
        'Pick file', 'MultiSelect', 'off');
if  ~isequal(filenamePCH,0) 
    cValue = load(strcat(pathnamePCH, filenamePCH),'smoothP');
    cValue = table2array(cValue.smoothP);
    myFluorolog = get(getappdata(figH,'uitableFH'),'Data');
    if size(cValue,2)==2 && size(cValue,1)==size(myFluorolog,1)
        cValue = cValue(:,2);
        setappdata(figH,'nowSliderCH',cValue);
        myIndex = get(getappdata(figH,'popupChCH'),'Value');
        set(getappdata(figH,'sliderDenoiseCH'),'Value',cValue(myIndex));
        set(getappdata(figH,'editCH'),'String',...
            [num2str(cValue(myIndex))]);
    else
        msgTemplate([],[],'Parameter file has wrong size','Error')
    end
end
end

function waveletCH_callback(hObject,callbackdata,figH)
% Callback for drop-down menu wavelet (cell)
if get(getappdata(figH,'popupWaveletCH'),'Value')==1
    set(getappdata(figH,'editCH'),'Visible','on');
    set(getappdata(figH,'button2CH'),'Visible','on');
    set(getappdata(figH,'button1CH'),'Visible','on');
    set(getappdata(figH,'popupChCH'),'Visible','on');
    set(getappdata(figH,'buttonPCH'),'Visible','on');
    set(getappdata(figH,'sliderDenoiseCH'),'Visible','on');
else
    set(getappdata(figH,'editCH'),'Visible','off');
    set(getappdata(figH,'button2CH'),'Visible','off');
    set(getappdata(figH,'button1CH'),'Visible','off');
    set(getappdata(figH,'popupChCH'),'Visible','off');
    set(getappdata(figH,'buttonPCH'),'Visible','off');
    set(getappdata(figH,'sliderDenoiseCH'),'Visible','off');
end
end
