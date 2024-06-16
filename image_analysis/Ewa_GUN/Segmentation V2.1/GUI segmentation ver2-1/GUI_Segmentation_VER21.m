function GUI_Segmentation_VER21
% This GUI helps to do visual inspection of collected *.mat files. 

%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','units','normalized','outerposition',[0 0 1 1],...
    'Tag','fHandle','Name','Segmentation GUI ver. 2.1','Numbertitle','off');

%% Creating menu
f.MenuBar = 'none'; % hide 
menuOpenH = uimenu(f,'Label','Open','Accelerator','o',...
    'Callback',{@menuOpen_callback,f});

menuShowH =  uimenu(f,'Label','Show','Enable','off',...
    'Callback',{@menuShow_callback,f},...
    'Accelerator','s');
setappdata(f,'menuShowH',menuShowH) %saving handle to make it accessible

menuSettingsH =  uimenu(f,'Label','Settings','Enable','on',...
    'Callback',{@msgTemplate,'To be adjusted if need arise.','Settings'});

menuHelpH =  uimenu(f,'Label','Help','Enable','on',...
    'Callback',{@msgTemplate,{'1. Click ''Open'' and select folder with *.mat files.',...
    '2. Select file to investigate',...
    '3. Click ''Show''.'},'Help'});
menuAuthorH =  uimenu(f,'Label','About','Enable','on',...
    'Callback',{@msgTemplate,{'Version: 2.0'},'Help'});

%% Creating listbox
listBoxH = uicontrol(f,'Style','listbox',...
                'Min',1,'Max',1);
listBoxH.Units = 'normalized';
listBoxH.Position = [0.01 0.30 0.14 0.69];
setappdata(f,'listBoxH',listBoxH) %saving handle to make it accessible

%% Creating uitable
textActtionsH = uicontrol('Style','text','String','History of changes','FontSize',12,...
    'Parent',f,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0.01 0.25 0.14 0.02],...
     'FontWeight','bold');
buttonExportH = uicontrol('Style', 'pushbutton', 'String', 'Export',...
                'Parent',f,...
                'Callback',{@buttonExport_callback,f},...
                'Units','normalized',...
                'Position',[0.1 0.25 0.04 0.02],...
                'FontWeight','bold',...
                'FontSize',12);  
            
tableH = uitable(f,'Data',[],...
                'RowName',[],...
                'units','normalized',...
                'ColumnName',{'Method', 'Param1', 'Param2', 'Param3', 'Param4'},... %'ColumnWidth',{50,50,50,50},...
                'ColumnEditable', true);
tableH.Position = [0.01 0.01 0.14 0.24];    
setappdata(f,'tableHistory',tableH);

%% Creating controls
uipanelH = uipanel('Title','Channel','FontSize',12,'FontWeight','bold',...
             'Position',[.72 .94 .27 .06],...
             'Parent',f);
popupChannelH = uicontrol('Style','popup',...
                'Parent',uipanelH,...
                'String',{''}, ...                
                'Callback',{@popupChannel_callback,f});
popupChannelH.Units = 'normalized';
popupChannelH.Position = [0 0 .6 1];
setappdata(f,'popupChannelH',popupChannelH) %saving handle to make it accessible

buttonMeshH = uicontrol('Style', 'pushbutton', 'String', 'Open mesh',...
                'Parent',uipanelH,...
                'Callback',{@buttonMesh_callback,f},...
                'Units','normalized',...
                'Position',[0.65 0 0.35 1],'Enable','off');  
setappdata(f,'buttonMeshH',buttonMeshH) %saving handle to make it accessible

%% Segmentation
uipanelSegH = uipanel('Title','Segmentation','FontSize',12,'FontWeight','bold',...
             'Position',[.72 .08 .27 .86],...
             'Parent',f,...
             'BorderWidth',3);
setappdata(f,'uipanelSegH',uipanelSegH);
%% Smoothing
uipanelSmoothH = uipanel('Title','Smoothing','FontSize',12,...
             'Position',[0 .80 1 .2],...
             'Parent',uipanelSegH,...
             'BorderWidth',3);    
popupSmoothH = uicontrol('Style','popup',...
                'Parent',uipanelSmoothH,...
                'String',{'medfilt2 - median smoothing','filter2 - mean smoothing','wiener2 - Wiener smoothing'},...
                'Callback',{@popupSmooth_callback,f},...
                'Units','normalized',...
                'Position', [0.2 0.5 0.8 0.5]);  
setappdata(f,'popupSmoothH',popupSmoothH);

textWindowSizeH = uicontrol('Style','text','String','Window size:','FontSize',12,...
    'Parent',uipanelSmoothH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.5 0.15 0.5]);
textWindowSizeValueH = uicontrol('Style','text','String','50','FontSize',12,...
    'Parent',uipanelSmoothH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.3 0.5]);
setappdata(f,'textWindowSizeValueH',textWindowSizeValueH); 

sliderSmoothH = drawSlider(10,5,100,[0.2 0 0.8 0.6],uipanelSmoothH, 1,50);
%callback                      
sliderSmoothCallH = handle(sliderSmoothH, 'CallbackProperties');
set(sliderSmoothCallH, 'MouseReleasedCallback', {@popupWindowSize_callback,f},...
    'KeyReleasedCallback', {@popupWindowSize_callback,f});   
setappdata(f,'sliderSmoothH',sliderSmoothH);      

%% Enhancing contrast
uipanelContrastH = uipanel('Title','Enhancing contrast','FontSize',12,...
             'Position',[0 .5 1 .3],...
             'Parent',uipanelSegH,...
             'BorderWidth',3);    
popupContrastH = uicontrol('Style','popup',...
                'Parent',uipanelContrastH,...
                'String',{'imadjust - mapping intensity','imsharpen - sharpening edges',...
                'adapthisteq - contrast-limited adaptive histogram equalization (CLAHE)'},...
                'Callback',{@popupContrast_callback,f},...
                'Units','normalized',...
                'Position', [0 0.8 1 0.2]);  
setappdata(f,'popupContrastH',popupContrastH);
setappdata(f,'uipanelContrastH',uipanelContrastH);

%% imadjust section
uipanelParametersImadjustH = uipanel('Title','Parameters','FontSize',12,...
             'Position',[0 0 1 .84],...
             'Parent',uipanelContrastH); 
setappdata(f,'uipanelParametersImadjustH',uipanelParametersImadjustH);
textImadjust1H = uicontrol('Style','text','String',sprintf('Low_in:\n0'),'FontSize',12,...
    'Parent',uipanelParametersImadjustH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.5 0.3 0.5]);
textImadjust2H = uicontrol('Style','text','String',sprintf('High_in:\n1'),'FontSize',12,...
    'Parent',uipanelParametersImadjustH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0.5 0.5 0.3 0.5]);
textImadjust3H = uicontrol('Style','text','String',sprintf('Low_out:\n0'),'FontSize',12,...
    'Parent',uipanelParametersImadjustH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.0 0.3 0.5]);
textImadjust4H = uicontrol('Style','text','String',sprintf('High_out:\n1'),'FontSize',12,...
    'Parent',uipanelParametersImadjustH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0.5 0 0.3 0.5]);

setappdata(f,'textImadjustH',[textImadjust1H,textImadjust2H,textImadjust3H,textImadjust4H]); 

sliderImadjust1H = drawSlider(25,5,100,[0.2 0.5 0.3 0.5],uipanelParametersImadjustH, 100,0);
sliderImadjustCall1H = handle(sliderImadjust1H, 'CallbackProperties');
set(sliderImadjustCall1H, 'MouseReleasedCallback', {@popupImadjust_callback,f},...
    'KeyReleasedCallback', {@popupImadjust_callback,f}); 
sliderImadjust2H = drawSlider(25,5,100,[0.7 0.5 0.3 0.5],uipanelParametersImadjustH, 100,100);
sliderImadjustCall2H = handle(sliderImadjust2H, 'CallbackProperties');
set(sliderImadjustCall2H, 'MouseReleasedCallback', {@popupImadjust_callback,f},...
    'KeyReleasedCallback', {@popupImadjust_callback,f});   
sliderImadjust3H = drawSlider(25,5,100,[0.2 0 0.3 0.5],uipanelParametersImadjustH, 100,0);
sliderImadjustCall3H = handle(sliderImadjust3H, 'CallbackProperties');
set(sliderImadjustCall3H, 'MouseReleasedCallback', {@popupImadjust_callback,f},...
    'KeyReleasedCallback', {@popupImadjust_callback,f});   
sliderImadjust4H = drawSlider(25,5,100,[0.7 0 0.3 0.5],uipanelParametersImadjustH, 100,100);
sliderImadjustCall4H = handle(sliderImadjust4H, 'CallbackProperties');
set(sliderImadjustCall4H, 'MouseReleasedCallback', {@popupImadjust_callback,f},...
    'KeyReleasedCallback', {@popupImadjust_callback,f});   

setappdata(f,'sliderImadjustH',[sliderImadjust1H,sliderImadjust2H,sliderImadjust3H,sliderImadjust4H])


%% imsharpen section
uipanelParametersImsharpenH = uipanel('Title','Parameters','FontSize',12,...
             'Position',[0 0 1 .84],...
             'Parent',uipanelContrastH,...
             'Visible','off'); 
setappdata(f,'uipanelParametersImsharpenH',uipanelParametersImsharpenH);
textImsharpen1H = uicontrol('Style','text','String',sprintf('Radius:\n0'),'FontSize',12,...
    'Parent',uipanelParametersImsharpenH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.5 0.2 0.5]);
textImsharpen2H = uicontrol('Style','text','String',sprintf('Amount:\n0'),'FontSize',12,...
    'Parent',uipanelParametersImsharpenH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0.5 0.5 0.2 0.5]);
textImsharpen3H = uicontrol('Style','text','String',sprintf('Threshold:\n0'),'FontSize',12,...
    'Parent',uipanelParametersImsharpenH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.2 0.5]);

setappdata(f,'textImsharpenH',[textImsharpen1H,textImsharpen2H,textImsharpen3H]); 

sliderSharpen1H = drawSlider(250,50,1000,[0.2 0.5 0.3 0.5],uipanelParametersImsharpenH, 40,0);
sliderSharpenCall1H = handle(sliderSharpen1H, 'CallbackProperties');
set(sliderSharpenCall1H, 'MouseReleasedCallback', {@popupImsharpen_callback,f},...
    'KeyReleasedCallback', {@popupImsharpen_callback,f}); 
sliderSharpen2H = drawSlider(50,25,200,[0.7 0.5 0.3 0.5],uipanelParametersImsharpenH, 100,0);
sliderSharpenCall2H = handle(sliderSharpen2H, 'CallbackProperties');
set(sliderSharpenCall2H, 'MouseReleasedCallback', {@popupImsharpen_callback,f},...
    'KeyReleasedCallback', {@popupImsharpen_callback,f}); 
sliderSharpen3H = drawSlider(100,50,1000,[0.2 0 0.8 0.5],uipanelParametersImsharpenH, 1000,0);
sliderSharpenCall3H = handle(sliderSharpen3H, 'CallbackProperties');
set(sliderSharpenCall3H, 'MouseReleasedCallback', {@popupImsharpen_callback,f},...
    'KeyReleasedCallback', {@popupImsharpen_callback,f}); 
 
setappdata(f,'sliderImsharpenH',[sliderSharpen1H,sliderSharpen2H,sliderSharpen3H])

%% adapthisteq section
uipanelParametersAdaptH = uipanel('Title','Parameters','FontSize',12,...
             'Position',[0 0 1 .84],...
             'Parent',uipanelContrastH,...
             'Visible','off'); 
setappdata(f,'uipanelParametersAdaptH',uipanelParametersAdaptH);
textAdapt1H = uicontrol('Style','text','String',sprintf('NumTiles:\n2'),'FontSize',12,...
    'Parent',uipanelParametersAdaptH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.5 0.3 0.5]);
textAdapt2H = uicontrol('Style','text','String',sprintf('ClipLimit:\n0'),'FontSize',12,...
    'Parent',uipanelParametersAdaptH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.3 0.5]);
setappdata(f,'textAdaptH',[textAdapt1H,textAdapt2H]); 

sliderAdapt1H = drawSlider(10,5,100,[0.2 0.5 0.8 0.5],uipanelParametersAdaptH, 1,6);
sliderAdaptCall1H = handle(sliderAdapt1H, 'CallbackProperties');
set(sliderAdaptCall1H, 'MouseReleasedCallback', {@popupAdapt_callback,f},...
    'KeyReleasedCallback', {@popupAdapt_callback,f}); 

sliderAdapt2H = drawSlider(10,5,100,[0.2 0 0.8 0.5],uipanelParametersAdaptH, 100,10);
sliderAdaptCall2H = handle(sliderAdapt2H, 'CallbackProperties');
set(sliderAdaptCall2H, 'MouseReleasedCallback', {@popupAdapt_callback,f},...
    'KeyReleasedCallback', {@popupAdapt_callback,f}); 
 
setappdata(f,'sliderAdaptH',[sliderAdapt1H,sliderAdapt2H])
            
%% Thresholding
uipanelThreshH = uipanel('Title','Thresholding','FontSize',12,...
             'Position',[0 .38 1 .12],...
             'Parent',uipanelSegH,...
             'BorderWidth',3);   
textThreshH = uicontrol('Style','text','String','Threshold:','FontSize',12,...
    'Parent',uipanelThreshH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0.5 0.3 0.5]);
textThreshValueH = uicontrol('Style','text','String','50%','FontSize',12,...
    'Parent',uipanelThreshH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.3 0.5]);
setappdata(f,'textThreshValueH',textThreshValueH);

sliderThreshH = drawSlider(1000,100,10000,[0.2 0 0.8 1],uipanelThreshH, 10000,5000);
%callback                      
sliderThreshCallH = handle(sliderThreshH, 'CallbackProperties');
set(sliderThreshCallH, 'StateChangedCallback', {@popupThresh_callback,f});   
setappdata(f,'sliderThreshH',sliderThreshH);

%% Morphological closing
uipanelMorphH = uipanel('Title','Morphological closing, edge smoothing and cleaning','FontSize',12,...
             'Position',[0 .20 1 .18],...
             'Parent',uipanelSegH,...
             'BorderWidth',3); 

popupMorphH = uicontrol('Style','popup',...
                'Parent',uipanelMorphH,...
                'String',{'imclose - morphological closing','imfill - fills holes',...
                'imerode - erodes image ','bwareaopen - removes objects that have fewer than P pixels'},...
                'Callback',{@popupMorph_callback,f},...
                'Units','normalized',...
                'Position', [0 0.75 1 0.25]);  
setappdata(f,'popupMorphH',popupMorphH);
setappdata(f,'uipanelMorphH',uipanelMorphH);         
         
%% imclose section
uipanelParametersImcloseH = uipanel('Title','Parameters','FontSize',12,...
             'Position',[0 0 1 .75],...
             'Parent',uipanelMorphH,...
             'Visible','on'); 
setappdata(f,'uipanelParametersImcloseH',uipanelParametersImcloseH);
textImclose1H = uicontrol('Style','text','String','Shape:','FontSize',12,...
    'Parent',uipanelParametersImcloseH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.25 1]);
textImclose2H = uicontrol('Style','text','String',sprintf('R:\n0'),'FontSize',12,...
    'Parent',uipanelParametersImcloseH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0.41 0 0.2 1]);
setappdata(f,'textImcloseH',textImclose2H);

popupImclose1H = uicontrol('Style','popup',...
                'Parent',uipanelParametersImcloseH,...
                'String',{'disk','diamond'},...
                'Callback',{@popupImclose_callback,f},...
                'Units','normalized',...
                'Position',[0.2 0 0.2 1],...
                'Value',1); 
sliderImcloseH = drawSlider(10,15,100,[0.5 0 0.5 1],uipanelParametersImcloseH, 1,1);
%callback                      
sliderImcloseCallH = handle(sliderImcloseH, 'CallbackProperties');
set(sliderImcloseCallH, 'MouseReleasedCallback', {@popupImclose_callback,f},...
    'KeyReleasedCallback', {@popupImclose_callback,f});   
setappdata(f,'popupsliderImcloseH',[popupImclose1H,sliderImcloseH]);   
                 
%% imerode section
uipanelParametersImerodeH = uipanel('Title','Parameters','FontSize',12,...
             'Position',[0 0 1 .75],...
             'Parent',uipanelMorphH,...
             'Visible','off'); 
setappdata(f,'uipanelParametersImerodeH',uipanelParametersImerodeH);
textImerode1H = uicontrol('Style','text','String','Shape:','FontSize',12,...
    'Parent',uipanelParametersImerodeH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.25 1]);
textImerode2H = uicontrol('Style','text','String',sprintf('R:\n0'),'FontSize',12,...
    'Parent',uipanelParametersImerodeH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0.41 0 0.2 1]);
setappdata(f,'textImerodeH',textImerode2H); 

popupImerode1H = uicontrol('Style','popup',...
                'Parent',uipanelParametersImerodeH,...
                'String',{'disk','diamond'},...
                'Callback',{@popupImerode_callback,f},...
                'Units','normalized',...
                'Position',[0.2 0 0.2 1],...
                'Value',1); 
            
sliderImerodeH = drawSlider(10,5,100,[0.5 0 0.5 1],uipanelParametersImerodeH, 1,1);
%callback                      
sliderImerodeCallH = handle(sliderImerodeH, 'CallbackProperties');
set(sliderImerodeCallH, 'MouseReleasedCallback', {@popupImerode_callback,f},...
    'KeyReleasedCallback', {@popupImerode_callback,f});   
setappdata(f,'popupsliderImerodeH',[popupImerode1H,sliderImerodeH]);  

%% bwareaopen section
uipanelParametersBwareaopenH = uipanel('Title','Parameters','FontSize',12,...
             'Position',[0 0 1 .75],...
             'Parent',uipanelMorphH,...
             'Visible','off'); 
setappdata(f,'uipanelParametersBwareaopenH',uipanelParametersBwareaopenH);
textBwareaopen1H = uicontrol('Style','text','String',sprintf('P:\n0'),'FontSize',12,...
    'Parent',uipanelParametersBwareaopenH,...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'Position',[0 0 0.2 1]);
setappdata(f,'textBwareaopenH',textBwareaopen1H); 

sliderBwareaopenH = drawSlider(20,10,200,[0.1 0 0.9 1],uipanelParametersBwareaopenH, 1,1);
%callback                      
sliderBwareaopenCallH = handle(sliderBwareaopenH, 'CallbackProperties');
set(sliderBwareaopenCallH, 'MouseReleasedCallback', {@popupBwareaopen_callback,f},...
    'KeyReleasedCallback', {@popupBwareaopen_callback,f});   
setappdata(f,'sliderBwareaopenH',sliderBwareaopenH);  

%% Freehand section         
uipanelFreehandH = uipanel('Title','Freehand','FontSize',12,...
             'Position',[0 0.1 1 .1],...
             'Parent',uipanelSegH,...
             'Visible','on',...
             'BorderWidth',3);
buttonImfreehandH = uicontrol('Style', 'pushbutton', 'String', 'imfreehand',...
                'Parent',uipanelFreehandH,...
                'Callback',{@buttonManual_callback,f,1},...
                'Units','normalized',...
                'Position',[0 0.5 0.333 0.5]);           
buttonImellipseH = uicontrol('Style', 'pushbutton', 'String', 'imellipse',...
                'Parent',uipanelFreehandH,...
                'Callback',{@buttonManual_callback,f,2},...
                'Units','normalized',...
                'Position',[0.333 0.5 0.333 0.5]);               
buttonImpolyH = uicontrol('Style', 'pushbutton', 'String', 'impoly',...
                'Parent',uipanelFreehandH,...
                'Callback',{@buttonManual_callback,f,3},...
                'Units','normalized',...
                'Position',[0.666 0.5 0.333 0.5]); 
buttonCreateMaskH = uicontrol('Style', 'pushbutton', 'String', 'Create mask',...
                'Parent',uipanelFreehandH,...
                'Callback',{@buttonCreateMask_callback,f},...
                'Units','normalized',...
                'Position',[0 0 0.333 0.5],...
                'FontWeight','bold');

uibgSelect = uibuttongroup('Visible','on','Position',[0.333 0 0.666 0.5],...
    'Parent',uipanelFreehandH);
buttonCell = uicontrol('Parent',uibgSelect,'Style','radiobutton','FontSize',12,'Units','normalized',...
    'String','Cells (r)','Position',[0.05 0 0.4 1]);
setappdata(f,'buttonCell',buttonCell); 
buttonBack = uicontrol('Parent',uibgSelect,'Style','radiobutton','FontSize',12,'Units','normalized',...
    'String','Background (c)','Position',[0.55 0 0.4 1],'Enable','off','HandleVisibility','on');
setappdata(f,'buttonBack',buttonBack); 


%% Controls
uipanelControlsH = uipanel('Title','Controls','FontSize',12,'FontWeight','bold',...
             'Position',[0 0 1 .1],...
             'Parent',uipanelSegH,...
             'Visible','on',...
             'BorderWidth',3); 
         
buttonSaveH = uicontrol('Style', 'pushbutton', 'String', 'Save',...
                'Parent',uipanelControlsH,...
                'Callback',{@buttonSave_callback,f},...
                'Units','normalized',...
                'Position',[0.666 0.0 0.333 1],...
                'FontWeight','bold',...
                'FontSize',12);  
buttonBackH = uicontrol('Style', 'pushbutton', 'String', 'Back',...
                'Parent',uipanelControlsH,...
                'Callback',{@buttonBack_callback,f},...
                'Units','normalized',...
                'Position',[0 0 0.333 1],...
                'FontWeight','bold',...
                'FontSize',12);  
buttonForwardH = uicontrol('Style', 'pushbutton', 'String', 'Forward',...
                'Parent',uipanelControlsH,...
                'Callback',{@buttonForward_callback,f},...
                'Units','normalized',...
                'Position',[0.333 0.0 0.333 1],...
                'FontWeight','bold',...
                'FontSize',12);  
%% Saving and showing
uipanelFinalH = uipanel('Title','Final','FontSize',12,'FontWeight','bold',...
             'Position',[.72 .0 .27 .08],...
             'Parent',f,...
             'BorderWidth',3);   
setappdata(f,'uipanelFinalH',uipanelFinalH);

buttonSaveAllMaskH = uicontrol('Style', 'pushbutton', 'String', 'Repeat for all',...
                'Parent',uipanelFinalH ,...
                'Callback',{@buttonSaveAllMask_callback,f},...
                'Units','normalized',...
                'Position',[0.75 0.0 0.25 1],...
                'FontSize',12,...
                'FontWeight','bold'); 
buttonSaveMaskH = uicontrol('Style', 'pushbutton', 'String', 'Save mask',...
                'Parent',uipanelFinalH ,...
                'Callback',{@buttonSaveMask_callback,f},...
                'Units','normalized',...
                'Position',[0.5 0.0 0.25 1],...
                'FontSize',12,...
                'FontWeight','bold');          
buttonShowOverlayH = uicontrol('Style', 'pushbutton', 'String', 'Show overlay',...
                'Parent',uipanelFinalH ,...
                'Callback',{@buttonShowOverlay_callback,f},...
                'Units','normalized',...
                'Position',[0.25 0.0 0.25 1],...
                'FontSize',12,...
                'FontWeight','bold');    
buttonImportMaskH = uicontrol('Style', 'pushbutton', 'String', 'Import mask',...
                'Parent',uipanelFinalH ,...
                'Callback',{@buttonImportMask_callback,f},...
                'Units','normalized',...
                'Position',[0 0 0.25 1],...
                'FontSize',12,...
                'FontWeight','bold');    
%% Enabling off all controls when picture not present
set(findall(uipanelSegH,'Type','uicontrol'), 'Enable', 'off')
set(findall(uipanelFinalH,'Type','uicontrol'), 'Enable', 'off')

%% Set visibility of figure on
set(f,'Visible','on');

end

%%================================================%%
%%====================Callback functions==========%%
%%================================================%%
function menuOpen_callback(hObject,callbackdata,figH)
folderName = uigetdir(matlabroot,...
    'Pick folder with *.mat files');
setappdata(figH,'folderName',folderName); % save folder name
 
if  ~strcmp(char(folderName),'0') && exist(char(folderName),'dir')
    % Get a list of all *.mat files in the folder.
    filePattern = fullfile(folderName, '*.mat');
    matFiles = dir(filePattern);

    % remove matfiles with parameters, cal or water
    tempArrayString = {matFiles.name};
    tempArrayString = tempArrayString(cellfun('isempty', strfind(tempArrayString,'param')));
    tempArrayString = tempArrayString(cellfun('isempty', strfind(tempArrayString,'Cal')));
    tempArrayString = tempArrayString(cellfun('isempty', strfind(tempArrayString,'Water')));
    
    % Populate listBox 
    hTemp = getappdata(figH,'listBoxH');
    hTemp.String = tempArrayString;

    % Enable Show
    if length({matFiles.name})>=1
        hTemp = getappdata(figH,'menuShowH');
        hTemp.Enable = 'on';
    end
    
    % No *.mat files found 
    if length(tempArrayString)>=1
        msgTemplate([],[],[num2str(length(tempArrayString)), ' *.mat files found.'],'')
    else
        msgTemplate([],[],'No *.mat files found.','')
    end
else
    msgTemplate([],[],'Choose a folder.','')
end
    
end

function menuShow_callback(hObject,callbackdata,figH)

% cleaning axes if Show was used and scroll
arrayfun(@delete,findall(figH,'type','axes'))
%delete(findall(figH,'Type','uicontrol','Tag','popupmenuChannel'))

%Getting list of files
listTemp = get(getappdata(figH,'listBoxH'),{'string','value'});
%listTemp = listTemp{1}(listTemp{2});
listFilesShow = strcat(getappdata(figH,'folderName'),'\',listTemp{1});
nFiles = length(listTemp{1}(:));

progressbar(0)         % Initialize/reset bar
progressbar(['Loading file']);       % Initialize/reset one bar
% loading particular file
load(listFilesShow{listTemp{2}});
% loading data - name of variable depends on the structure of the file
try
    if exist('specImage','var')
        tempData = specImage; %old system of files
    else
        tempData = HAC_Image.imageStruct.data; % old system of files
    end
catch
     msgTemplate([],[],{'No image found in: ';listFilesShow{listTemp{2}}},'Error')
end

nChannels = size(tempData);
nChannels = nChannels(3);
    
% creating folder if not there
if ~exist(strcat(getappdata(figH,'folderName'),'/mask'),'dir') 
    mkdir(strcat(getappdata(figH,'folderName')),'mask')
end
  
% DIC image or other
axesH = axes('Parent',figH,'Position',[0.14 0.05 0.56 0.9 ]);
myIm = mat2gray(tempData(:,:,end));
plotH = imshow(cat(3,myIm,myIm,myIm),[],'Parent',axesH);
title(axesH, strrep(strrep(strcat(listTemp{1}(listTemp{2}),' Ch: ',num2str(nChannels)),...
    '_','\_'),'.mat',''));
setappdata(figH,'axesH',axesH)
setappdata(figH,'plotH',plotH)%saving handle to make it accessible
setappdata(figH,'imageCurrentH',mat2gray(tempData));
setappdata(figH,'imageWorkH',mat2gray((tempData(:,:,end))));
setappdata(figH,'imageHistoryH',{mat2gray((tempData(:,:,end)))});
setappdata(figH,'currentStepH',1);

% Populate listBox 
hTemp = getappdata(figH,'popupChannelH');
hTemp.String = cellstr(num2str((1:nChannels)'));
pause(0.01)
hTemp.Value = nChannels;

% Enable mesh button
set(getappdata(figH,'buttonMeshH'),'Enable','on');
    
% Enabling uipanels
set(findall(getappdata(figH,'uipanelSegH'),'Type','uicontrol'), 'Enable', 'on')
set(findall(getappdata(figH,'uipanelFinalH'),'Type','uicontrol'), 'Enable', 'on')
set(getappdata(figH,'sliderThreshH'),'Enabled',1);
set(getappdata(figH,'sliderSmoothH'),'Enabled',1);
set(getappdata(figH,'sliderImadjustH'),'Enabled',1);
set(getappdata(figH,'sliderImsharpenH'),'Enabled',1);
set(getappdata(figH,'sliderAdaptH'),'Enabled',1);
tempHandle = getappdata(figH,'popupsliderImcloseH');
set(tempHandle(2),'Enabled',1);
tempHandle = getappdata(figH,'popupsliderImerodeH');
set(tempHandle(2),'Enabled',1);
set(getappdata(figH,'sliderBwareaopenH'),'Enabled',1); 

% Creating handle for imfreehand
sizeData = size(tempData);
imMaskH = zeros(sizeData(1:2));
setappdata(figH,'imMaskH',imMaskH);
imMaskB = zeros(sizeData(1:2));
setappdata(figH,'imMaskB',imMaskB);

% Creating table of actions for batch processing %we store channel in first row
tableActions = table(nChannels, 0,0,0,0,'VariableNames',{'Method' 'Param1' 'Param2' 'Param3' 'Param4'});
setappdata(figH, 'tableActions', tableActions);
setappdata(figH, 'actionCounter', 2);

%list of methods for table of actions
%medfilt-1 filter-2 wiener-3 imadjust-4 imsharpen-5 adapthisteq-6
%thresh-7 imclose-8 imfills-9 imerode-10 bwareaopen-11

% releasing window 
progressbar(1); %release window 
      
end

function popupChannel_callback(hObject,callbackdata,figH)
if ~strcmp(get(hObject,'String'),'')
    tempData = getappdata(figH,'imageCurrentH');
    tempData = tempData(:,:,get(hObject,'Value'));
    setappdata(figH,'imageWorkH',squeeze(tempData)); %image for working
    drawImage(tempData,figH); %drawing image
    listTemp = get(getappdata(figH,'listBoxH'),{'string','value'});
    titleTemp = strrep(strrep(strcat(listTemp{1}(listTemp{2}),' Ch: ',num2str(get(hObject,'Value'))),...
        '_','\_'),'.mat','');
    set(get(getappdata(figH,'axesH'),'Title'),'String',titleTemp);
    
    %if channel changed reset table of actions and actionCounter
    tableActions = table(get(hObject,'Value'), 0,0,0,0,'VariableNames',{'Method' 'Param1' 'Param2' 'Param3' 'Param4'});
    setappdata(figH, 'tableActions', tableActions);
    setappdata(figH, 'actionCounter', 2);
    %reset table with History
    tableH = getappdata(figH,'tableHistory');
    set(tableH,'Data',[]);
end
end

function buttonMesh_callback(hObject,callbackdata,figH)
    tempData = getappdata(figH,'imageCurrentH');
    myChannel = get(getappdata(figH,'popupChannelH'),'Value');
    if size(tempData,3)==myChannel
        msgTemplate([],[],'Mesh not useful on DIC.','Error')
    else
        tempData = tempData(:,:,myChannel);
        figure(); 
        mesh(tempData); xlim([0, size(tempData,1)]); ylim([0, size(tempData,1)]); 
        title("Channel "+myChannel);
        zlabel("Intensity [a.u.]"); xlabel("x [pxl]"); ylabel("y [pxl]");
    end
end

function popupSmooth_callback(hObject,callbackdata,figH)
%tempData = getappdata(figH,'imageCurrentH');

end

function popupWindowSize_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
popupSmoothH = getappdata(figH,'popupSmoothH');
set(getappdata(figH,'textWindowSizeValueH'),'String',num2str(get(hObject,'Value'))); 
tableActions = getappdata(figH, 'tableActions');
actionCounter = getappdata(figH, 'actionCounter');

if get(hObject,'Value')>=2
    switch get(popupSmoothH,'Value')
        case 1
            progressbar(0);        % Initialize/reset bar
            progressbar(['Smoothing...']);  
            tempDataSmooth = medfilt2(tempData, ones(1,2)*get(hObject,'Value')); 
            drawImage(tempDataSmooth,figH); %drawing image
            tableActions{actionCounter,:} = [1,get(hObject,'Value'),0,0,0];
            setappdata(figH, 'tableActions',tableActions);
            progressbar(1);
        case 2
            progressbar(0);         % Initialize/reset bar
            progressbar(['Smoothing...']); 
            tempDataSmooth = filter2(fspecial('average', ones(1,2)*get(hObject,'Value')), tempData);
            drawImage(tempDataSmooth,figH); %drawing image
            tableActions{actionCounter,:} = [2,get(hObject,'Value'),0,0,0];
            setappdata(figH, 'tableActions',tableActions);
            progressbar(1);
        case 3
            progressbar(0);         % Initialize/reset bar
            progressbar(['Smoothing...']);  
            if get(hObject,'Value')>=2
                tempDataSmooth = wiener2(tempData, ones(1,2)*get(hObject,'Value'));
                drawImage(tempDataSmooth,figH); %drawing image
                tableActions{actionCounter,:} = [3,get(hObject,'Value'),0,0,0];
                setappdata(figH, 'tableActions',tableActions);
            else
                drawImage(tempData,figH); %drawing image
            end
            progressbar(1);
    end
else
    msgTemplate([],[],'Window size has to be greater than 1!','');
end
end

function popupContrast_callback(hObject,callbackdata,figH)
%tempData = getappdata(figH,'imageCurrentH');

% visible off all uipanels under contrast panel
set(findall(getappdata(figH,'uipanelContrastH'),'Type','uipanel','Parent',getappdata(figH,'uipanelContrastH')), 'Visible', 'off')
% visible on uipanel needed
switch get(hObject,'Value')
    case 1
        set(getappdata(figH,'uipanelParametersImadjustH'),'Visible', 'on');
    case 2
        set(getappdata(figH,'uipanelParametersImsharpenH'),'Visible', 'on');
    case 3
        set(getappdata(figH,'uipanelParametersAdaptH'),'Visible', 'on');
end
end

function popupImadjust_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
tempParam = cell2mat(get(getappdata(figH,'sliderImadjustH'),'Value'))*0.01;
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

textImadjustH = getappdata(figH,'textImadjustH');
set(textImadjustH(1),'String',sprintf(strcat('Low_in:\n',num2str(tempParam(1)))));
set(textImadjustH(2),'String',sprintf(strcat('High_in:\n',num2str(tempParam(2)))));
set(textImadjustH(3),'String',sprintf(strcat('Low_out:\n',num2str(tempParam(3)))));
set(textImadjustH(4),'String',sprintf(strcat('High_out:\n',num2str(tempParam(4)))));

if (tempParam(1)<tempParam(2)) && (tempParam(3)<tempParam(4))
progressbar(0);        % Initialize/reset bar
progressbar(['Enhancing contrast...']);  
tempDataContrast = imadjust(tempData,tempParam(1:2)',tempParam(3:4)');
%get(hObject,'Value') % not used temporarily 
drawImage(tempDataContrast,figH); %drawing image
tableActions{actionCounter,:} = [4,tempParam(1),tempParam(2),tempParam(3),tempParam(4)];
setappdata(figH, 'tableActions',tableActions);
progressbar(1);
else
    msgTemplate([],[],'LOW_IN must be less than HIGH_IN and LOW_OUT must be less than HIGH_OUT.','')
end

end

function popupImsharpen_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
tempParam = cell2mat(get(getappdata(figH,'sliderImsharpenH'),'Value')).*[0.025;0.01;0.001];
textImsharpenH = getappdata(figH,'textImsharpenH');
set(textImsharpenH(1),'String', sprintf(strcat('Radius:\n',num2str(tempParam(1)))));
set(textImsharpenH(2),'String', sprintf(strcat('Amount:\n',num2str(tempParam(2)))));
set(textImsharpenH(3),'String', sprintf(strcat('Threshold:\n',num2str(tempParam(3)))));
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

if tempParam(1)>0
    progressbar(0);        % Initialize/reset bar
    progressbar(['Enhancing contrast...']);  
    tempDataContrast = imsharpen(tempData,'Radius',tempParam(1),...
        'Amount',tempParam(2),'Threshold',tempParam(3));
    drawImage(tempDataContrast,figH); %drawing image
    tableActions{actionCounter,:} = [5,tempParam(1),tempParam(2),tempParam(3),0];
    setappdata(figH, 'tableActions',tableActions);
    progressbar(1);
else
    msgTemplate([],[],'Radius has to be positive!','')
end
end

function popupAdapt_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
tempParam = cell2mat(get(getappdata(figH,'sliderAdaptH'),'Value')).*[1;0.01];
textAdaptH = getappdata(figH,'textAdaptH');
set(textAdaptH(1),'String', sprintf(strcat('NumTiles:\n',num2str(tempParam(1)))));
set(textAdaptH(2),'String', sprintf(strcat('ClipLimit:\n',num2str(tempParam(2)))));
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

if tempParam(1)>=2
    progressbar(0);        % Initialize/reset bar
    progressbar(['Enhancing contrast...']);  
    tempDataContrast = adapthisteq(tempData,'NumTiles',ones(1,2).*tempParam(1),...
        'ClipLimit',tempParam(2),'Range','original');
    drawImage(tempDataContrast,figH); %drawing image
    tableActions{actionCounter,:} = [6,tempParam(1),tempParam(2),0,0];
    setappdata(figH, 'tableActions',tableActions);
    progressbar(1);
else
    msgTemplate([],[],'NumTiles has to be at least 2!','')
end
end

function popupThresh_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
tempDataThresh = im2bw(tempData,get(hObject,'Value')*0.0001);
drawImage(tempDataThresh,figH); %drawing image
set(getappdata(figH,'textThreshValueH'),'String',strcat(num2str(get(hObject,'Value')/100),' %'));
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');
tableActions{actionCounter,:} = [7,get(hObject,'Value')*0.0001,0,0,0];
setappdata(figH, 'tableActions',tableActions);
end

function popupMorph_callback(hObject,callbackdata,figH)
%tempData = getappdata(figH,'imageCurrentH');

% visible off all uipanels under contrast panel
set(findall(getappdata(figH,'uipanelMorphH'),'Type','uipanel','Parent',getappdata(figH,'uipanelMorphH')), 'Visible', 'off')
% visible on uipanel needed
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

switch get(hObject,'Value')
    case 1
        set(getappdata(figH,'uipanelParametersImcloseH'),'Visible', 'on');
    case 2
        tempData = getappdata(figH,'imageWorkH');
       
        progressbar(0);        % Initialize/reset bar
        progressbar(['Morphological closing...']);  
        tempDataMorph = imfill(tempData,'holes');
        drawImage(tempDataMorph,figH); %drawing image
        tableActions{actionCounter,:} = [9,0,0,0,0];
        setappdata(figH, 'tableActions',tableActions);
        progressbar(1);
    case 3
        set(getappdata(figH,'uipanelParametersImerodeH'),'Visible', 'on');
    case 4
        set(getappdata(figH,'uipanelParametersBwareaopenH'),'Visible', 'on');
end
end

function popupImclose_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
tempParam = cell2mat(get(getappdata(figH,'popupsliderImcloseH'),'Value'));
tempShape = {'disk','diamond'};
set(getappdata(figH,'textImcloseH'),'String',sprintf(strcat('R:\n',num2str(tempParam(2)))));
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

progressbar(0);        % Initialize/reset bar
progressbar(['Morphological closing...']);  
tempDataImclose = imclose(tempData,strel(tempShape{tempParam(1)},tempParam(2)));
drawImage(tempDataImclose,figH); %drawing image
tableActions{actionCounter,:} = [8,tempParam(1),tempParam(2),0,0];
setappdata(figH, 'tableActions',tableActions);
progressbar(1);
end

function popupImerode_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
tempParam = cell2mat(get(getappdata(figH,'popupsliderImerodeH'),'Value'));
tempShape = {'disk','diamond'};
set(getappdata(figH,'textImerodeH'),'String',sprintf(strcat('R:\n',num2str(tempParam(2)))));
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

progressbar(0);        % Initialize/reset bar
progressbar(['Morphological closing...']);  
tempDataImerode = imerode(tempData,strel(tempShape{tempParam(1)},tempParam(2)));
drawImage(tempDataImerode,figH); %drawing image
tableActions{actionCounter,:} = [10,tempParam(1),tempParam(2),0,0];
setappdata(figH, 'tableActions',tableActions);
progressbar(1);
end

function popupBwareaopen_callback(hObject,callbackdata,figH)
tempData = getappdata(figH,'imageWorkH');
set(getappdata(figH,'textBwareaopenH'),'String',strcat('P: ',num2str(get(hObject,'Value')))); 
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

progressbar(0);        % Initialize/reset bar
progressbar(['Morphological closing...']);  
tempDataBwareaopen = bwareaopen(tempData,get(hObject,'Value'));
drawImage(tempDataBwareaopen,figH); %drawing image
tableActions{actionCounter,:} = [11,get(hObject,'Value'),0,0,0];
setappdata(figH, 'tableActions',tableActions);
progressbar(1);
end

function doubleClick_callback(hObject,callbackdata,figH,pathFull,nameFile,iChannel)
switch get(figH,'SelectionType')
    case 'normal' %single click
        % for future use    
    case 'open' %double click
      
end
end

function drawImage(im, figH)
im = mat2gray(im); % scalling of values
mySize = size(im);
if length(mySize)<3
    im = cat(3,im,im,im);
end
plotH = getappdata(figH,'plotH');
set(plotH,'CData',im); % replacing image in axes
axesH = getappdata(figH,'axesH');

set(axesH, 'Clim', [0 1]);
end

function hSlider = drawSlider(MajorTickSpacing,MinorTickSpacing,Maximum,Position,uipanel, Scale,Val)
hSlider = uicomponent('style','slider',...
                      'MajorTickSpacing',MajorTickSpacing,'MinorTickSpacing',MinorTickSpacing,... 
                      'Paintlabels',1,'PaintTicks',1,'Maximum',Maximum);  % vertical slider
                      set(hSlider,'Units','norm')          
                      set(hSlider,'Position',Position)
                      set(hSlider,'Parent',uipanel)
                      set(hSlider,'Enabled',0)
                      % Create the label table for slider
                      labelTable = java.util.Hashtable();
                      for iLabel=0:MajorTickSpacing:Maximum
                        labelTable.put(int32(iLabel), javax.swing.JLabel(num2str(iLabel/Scale)));
                      end
                      set(hSlider, 'LabelTable',labelTable);
                      set(hSlider, 'Value',Val)
end

function buttonManual_callback(hObject,callbackdata,figH,typeROI)
buttonSave_callback([],[],figH); %saving current state of plot

cellContour = get(getappdata(figH,'buttonCell'),'Value');

plotH = getappdata(figH,'plotH');
setappdata(figH,'imageWorkH',get(plotH,'CData'));
axesH = getappdata(figH,'axesH');

if cellContour
    myMask = getappdata(figH,'imMaskH'); myColor = 'red';
else
    myMask = getappdata(figH,'imMaskB'); myColor = 'cyan';
end

sizeImMask = size(myMask);

if length(sizeImMask)==2
    maskN = 1; 
else
    maskN = sizeImMask(3); 
end

if cellContour
    myDelete = {@imMaskDelete_Callback,figH,maskN+1};
else
    myDelete = {@imMaskBDelete_Callback,figH,maskN+1};
end

switch typeROI
    case 1
        imfreehandH = imfreehand(axesH); 
        set(imfreehandH,'DeleteFcn',myDelete,'Tag','maskManual')
        fcnConst = makeConstrainToRectFcn('imfreehand',get(axesH,'XLim'), get(axesH,'YLim'));
        setPositionConstraintFcn(imfreehandH,fcnConst);
        setColor(imfreehandH,myColor);
        myMask(:,:,maskN+1) = createMask(imfreehandH);
    case 2
        imellipseH = imellipse(axesH); 
        set(imellipseH,'DeleteFcn',myDelete,'Tag','maskManual')
        fcnConst = makeConstrainToRectFcn('imellipse',get(axesH,'XLim'), get(axesH,'YLim'));
        setPositionConstraintFcn(imellipseH,fcnConst);
        setColor(imellipseH,myColor);
        myMask(:,:,maskN+1) = createMask(imellipseH);
    case 3
        impolyH = impoly(axesH); 
        set(impolyH,'DeleteFcn',myDelete,'Tag','maskManual')
        fcnConst = makeConstrainToRectFcn('impoly',get(axesH,'XLim'), get(axesH,'YLim'));
        setPositionConstraintFcn(impolyH,fcnConst);
        setColor(impolyH,myColor);
        myMask(:,:,maskN+1) = createMask(impolyH);
end

if cellContour
    setappdata(figH,'imMaskH',myMask);
else
    setappdata(figH,'imMaskB',myMask);
end

end

function imMaskDelete_Callback(hObject,callbackdata,figH,ind)
imMaskH = getappdata(figH,'imMaskH'); 
%removing deleted mask
%ind

imMaskH(:,:,ind) = 0;
setappdata(figH,'imMaskH',imMaskH);   
end

function imMaskBDelete_Callback(hObject,callbackdata,figH,ind)
imMaskB = getappdata(figH,'imMaskB'); 
%removing deleted mask
%ind

imMaskB(:,:,ind) = 0;  
setappdata(figH,'imMaskB',imMaskB);
end

% function imMaskChange_Callback(hObject,figH,ind) %ALINE
% % on top:
% addNewPositionCallback(impolyH,@(p) imMaskChange_Callback(p,figH,maskN+1));
% 
% imMaskH = getappdata(figH,'imMaskH'); 
% imMaskH(:,:,ind)=0;
% 
% axesH = getappdata(figH,'axesH');
% fcnConst = makeConstrainToRectFcn('imfreehand',get(axesH,'XLim'), get(axesH,'YLim'));
% setPositionConstraintFcn(hObject,fcnConst);
% setColor(hObject,myColor);
% imMaskH(:,:,ind) = createMask(hObject);
% 
% 
% setappdata(figH,'imMaskH',imMaskH); 
% 
% 
% 
% end

function buttonCreateMask_callback(hObject,callbackdata,figH)
plotH = getappdata(figH,'plotH');
axesH = getappdata(figH,'axesH');
imMaskH = getappdata(figH,'imMaskH');
imMaskHFinal = max(imMaskH,[],3);
imMaskB = getappdata(figH,'imMaskB');
imMaskBFinal = max(imMaskB,[],3);
myIm = zeros(size(imMaskHFinal,1),size(imMaskHFinal,2),3);
myIm(:,:,1)=imMaskHFinal;
myIm(:,:,2)=imMaskBFinal;
myIm(:,:,3)=imMaskBFinal;
set(plotH,'CData',myIm);
% arrayfun(@delete,findall(axesH,'Tag','maskManual'));

end

function buttonSave_callback(hObject,callbackdata,figH)
plotH = getappdata(figH,'plotH');
setappdata(figH,'imageWorkH',get(plotH,'CData'));
imageHistoryH = getappdata(figH,'imageHistoryH'); %reading history of changes
imageHistoryH{end+1} = get(plotH,'CData');
setappdata(figH,'imageHistoryH',imageHistoryH); %updating history of changes
setappdata(figH,'currentStepH',getappdata(figH,'currentStepH')+1); %increasing the counter

%increasing the counter of actions
%increase counter only if there is action has been performed
tempTableActions = getappdata(figH, 'tableActions');

if tempTableActions{end,1}~=0
    setappdata(figH, 'actionCounter', getappdata(figH, 'actionCounter')+1);
    %refresh table with history of actions
    tableRefresh(figH);
end

end

function buttonBack_callback(hObject,callbackdata,figH)
% show previous saved
imageHistoryH = getappdata(figH,'imageHistoryH'); %reading history of changes
plotH = getappdata(figH,'plotH');
stepInd = getappdata(figH,'currentStepH');
if stepInd>=2
    set(plotH,'CData',imageHistoryH{stepInd});
    setappdata(figH,'currentStepH',getappdata(figH,'currentStepH')-1); %decreasing the counter
else
    set(plotH,'CData',imageHistoryH{1});
    msgTemplate([],[],'First saved image. ','')
end
end

function buttonForward_callback(hObject,callbackdata,figH)
imageHistoryH = getappdata(figH,'imageHistoryH'); %reading history of changes
plotH = getappdata(figH,'plotH');
stepInd = getappdata(figH,'currentStepH');
if stepInd<length(imageHistoryH)
    set(plotH,'CData',imageHistoryH{stepInd});
    setappdata(figH,'currentStepH',getappdata(figH,'currentStepH')+1); %decreasing the counter
else
    set(plotH,'CData',imageHistoryH{end});
    msgTemplate([],[],'Last saved image. ','')
end
end

function buttonSaveMask_callback(hObject,callbackdata,figH)
plotH = getappdata(figH,'plotH');

imMaskH = getappdata(figH,'imMaskH');
imMaskHFinal = max(imMaskH,[],3);
imMaskB = getappdata(figH,'imMaskB');
imMaskBFinal = max(imMaskB,[],3);

imSize = size(imMaskHFinal);


if sum(((imMaskHFinal(:)==1)+(imMaskHFinal(:)==0)))==(imSize(1)*imSize(2)) %file is binary
    progressbar(0);        % Initialize/reset bar
    progressbar(['Saving file...']);  
    
    %Getting file name
    listTemp = get(getappdata(figH,'listBoxH'),{'string','value'});
    fileName = strrep(listTemp{1}(listTemp{2}),'.mat','.png');
    fileNameB = strrep(listTemp{1}(listTemp{2}),'.mat','_back.png');

    % creating folder if not there
    if ~exist(strcat(getappdata(figH,'folderName'),'/mask'),'dir') 
        mkdir(strcat(getappdata(figH,'folderName')),'mask')
    end
    if ~exist(strcat(getappdata(figH,'folderName'),'/maskB'),'dir') 
        mkdir(strcat(getappdata(figH,'folderName')),'maskB')
    end

    imwrite(imMaskHFinal, char(strcat(getappdata(figH,'folderName'),'/mask/',fileName)),'BitDepth',1);
    imwrite(imMaskBFinal, char(strcat(getappdata(figH,'folderName'),'/maskB/',fileNameB)),'BitDepth',1);
    progressbar(1);
else
    msgTemplate([],[],'File is not binary (black and white)! Saving unsuccesful! Use thresholding for instance.','')
end
end

function buttonShowOverlay_callback(hObject,callbackdata,figH)
plotH = getappdata(figH,'plotH');
im = get(plotH,'CData'); % getting image
imSize = size(im);

if length(imSize)>2 && ~islogical(im)
    im = rgb2gray(im);
    im = imbinarize(im);
    imSize = size(im);
elseif length(imSize)>2 && islogical(im)
    im = im(:,:,1);
end

if sum(((im(:)==1)+(im(:)==0)))==(imSize(1)*imSize(2)) %file is binary
    %Getting file name
    listTemp = get(getappdata(figH,'listBoxH'),{'string','value'});
    fileName = strrep(listTemp{1}(listTemp{2}),'.mat','');
    
    %Getting DIC and current channel
    tempData = getappdata(figH,'imageCurrentH');
    popupChannel = get(getappdata(figH,'popupChannelH'),'Value');
    sizeData = size(tempData);
    channelLast = sizeData(3);
    
    % Perimeter
    imPerim = bwperim(im);
    figure('Visible','on','units','normalized','outerposition',[0 0 1 1]);
    subtightplot(1,2,1)
    overlayImage1 = imoverlay(squeeze(tempData(:,:,end)), imPerim, [.3 1 .3]);
    imshow(overlayImage1)
    title(strrep(strcat(fileName,' Channel: ', num2str(channelLast)),'_','\_'))
    subtightplot(1,2,2)
    overlayImage2 = imoverlay(mat2gray(squeeze(tempData(:,:,popupChannel))), imPerim, [.3 1 .3]);
    imshow(overlayImage2)
    title(strrep(strcat(fileName,' Channel: ', num2str(popupChannel)),'_','\_'))
    
else
    msgTemplate([],[],'File is not binary (black and white)! Overlay is possible only for binary images! Use thresholding for instance.','')
end

end

function buttonImportMask_callback(hObject,callbackdata,figH)
[fileName, pathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files'}, 'Select a mask',...
          'C:\Users\Jakub\Desktop\MQ\Segmentation\hela 2 in new structures\mask');
 
plotH = getappdata(figH,'plotH');
im = get(plotH,'CData'); % getting image
sizeIm = size(im);

if  ~strcmp(char(fileName),'0') && exist(fullfile(pathName, fileName),'file')
    progressbar(0);        % Initialize/reset bar
    progressbar(['Reading mask...']);  
    
    imMask = imread(fullfile(pathName, fileName));
    imSize = size(imMask);

    if length(imSize)>2 && ~islogical(im)
        imMask = rgb2gray(imMask);
        imMask = imbinarize(imMask);
        imMask = size(imMask);
    elseif length(imSize)>2 && islogical(im)
        im = im(:,:,1);
    end

    imMaskBW = imMask;

%     if sum(size(imMaskBW)==sizeIm)<2 % ALINE continue here
    if isequal(size(imMaskBW),sizeIm) % ALINE continue here
        
        imMaskBW = imresize(imMask,sizeIm);
        msgTemplate([],[],['Image was resized to: ',num2str(sizeIm(1)),' x ',num2str(sizeIm(2))],'')
    end
    
    imMaskBW = cat(3,imMaskBW,imMaskBW,imMaskBW);
    
    set(plotH,'CData',imMaskBW); % setting image
    pause(0.03)
    buttonSave_callback([],[],figH) %saving new Mask
    progressbar(1)
    
else
    msgTemplate([],[],'Choose a file.','')
end
    
end
                 
function buttonSaveAllMask_callback(hObject,callbackdata,figH)
%Getting actionTable and actionCounter
tableActions = getappdata(figH, 'tableActions'); %getting Action table and counter
actionCounter = getappdata(figH, 'actionCounter');

%Getting list of files for processing
listTemp = get(getappdata(figH,'listBoxH'),'string');

%listTemp = listTemp{1}(listTemp{2});
listFilesShow = strcat(getappdata(figH,'folderName'),'\',listTemp);
nFiles = length(listTemp(:));

progressbar(0)         % Initialize/reset bar
progressbar('Loading file');       % Initialize/reset one bar

% loading particular file
for i=1:nFiles
    if ~strcmp(listTemp{i}(1:5),'param')
        load(listFilesShow{i}); % loading data
        % loading data - name of variable depends on the structure of the file
        try
            if exist('specImage','var')
                tempData = specImage; %old system of files
            else
                tempData = HAC_Image.imageStruct.data; % old system of files
            end
            
            %accessing the right channel
            tempData = mat2gray(tempData(:,:,tableActions{1,1}));
        catch
             msgTemplate([],[],{'No image found in: ';listFilesShow{i}},'Error')
        end
        
        for j=2:length(tableActions{:,1})
        %performing actions on each file acording to actionTable
            switch tableActions{j,1}
                case 1
                    tempData = mat2gray(medfilt2(tempData, ones(1,2)*tableActions{j,2}));
                case 2
                    tempData = mat2gray(filter2(fspecial('average', ones(1,2)*tableActions{j,2}), tempData));
                case 3
                     tempData = mat2gray(wiener2(tempData, ones(1,2)*tableActions{j,2}));
                case 4
                    %*1 so we transform logical to double
                    tempData = mat2gray(imadjust(tempData*1,tableActions{j,2:3}',tableActions{j,4:5}'));
                case 5
                     tempData = mat2gray(imsharpen(tempData,'Radius',tableActions{j,2},...
                         'Amount',tableActions{j,3},'Threshold',tableActions{j,4}));
                case 6
                    tempData = mat2gray(adapthisteq(tempData,'NumTiles',ones(1,2).*tableActions{j,2},...
                          'ClipLimit',tableActions{j,3},'Range','original'));                    
                case 7
                     tempData = im2bw(tempData,tableActions{j,2});
                case 8
                    tempShape = {'disk','diamond'};
                    tempData = mat2gray(imclose(tempData,strel(tempShape{tableActions{j,2}},tableActions{j,3})));
                case 9
                    tempData = mat2gray(imfill(tempData,'holes'));
                case 10
                    tempShape = {'disk','diamond'};
                    tempData = mat2gray(imerode(tempData,strel(tempShape{tableActions{j,2}},tableActions{j,3})));
                case 11
                    tempData = mat2gray(bwareaopen(tempData,tableActions{j,2}));
            end      
        end
        
        tempDataSize = size(tempData);
        %saving according to channel number
        if sum(((tempData(:)==1)+(tempData(:)==0)))==(tempDataSize(1)*tempDataSize(2)) %file is binary
          
            %Getting file name
            fileName = strrep(listTemp{i},'.mat',strcat('_channel_',num2str(tableActions{1,1}),'.png'));

            % creating folder if not there
            if ~exist(strcat(getappdata(figH,'folderName'),'/mask'),'dir') 
                mkdir(strcat(getappdata(figH,'folderName')),'mask')
            end
            imwrite(tempData, char(strcat(getappdata(figH,'folderName'),'/mask/',fileName)),'BitDepth',1);
 
        else
            msgTemplate([],[],'File is not binary (black and white)! Saving unsuccesful! Use thresholding for instance.','')
        end
    end
    %updating progressbar
    progressbar(strcat(num2str(100*i/nFiles),' %'));
    progressbar(i/nFiles);
end
%removing 0's from tableActions
%tableActions{all(tableActions{:,:}==zeros(1,5))}=[];

%saving table of actions
writetable(tableActions,char(strcat(getappdata(figH,'folderName'),'/mask/',...
    'tableOfActions_channel_',num2str(tableActions{1,1}),'.txt')));
progressbar(1);

%medfilt-1 %filter-2 %wiener-3 %imadjust-4 % imsharpen -5 %adapthisteq - 6
%thresh-7 imclose-8 imfills -9 imerode -10 bwareaopen -11

end

function buttonExport_callback(hObject,callbackdata,figH)
tableH = getappdata(figH,'tableHistory'); %get handle to table

[filename, pathname] = uiputfile('*.txt','Save as');
if isequal(filename,0) || isequal(pathname,0)
    msgTemplate([],[],'No file name or selected folder!','Error')
else
    tempData = get(tableH,'Data');
    tempNewData=mat2cell(tempData,ones(size(tempData,1),1),ones(size(tempData,2),1));
    
    tableData = cell2table(tempNewData,...
    'VariableNames',{'Method' 'Param1' 'Param2' 'Param3' 'Param4'});
    %writing data
    writetable(tableData, fullfile(pathname,filename),'Delimiter',',')
end

end

function tableRefresh(figH)
tableActions = getappdata(figH, 'tableActions'); %getting Action table 
tableH = getappdata(figH,'tableHistory');
set(tableH,'Data',[]);
% go  through action table and translate 
for i=2:length(tableActions{:,1})
switch tableActions{i,1}
    case 1
        oldData = get(tableH,'Data');
        newRow={'medfilt2',num2str(tableActions{i,2}),'','',''};
        set(tableH,'Data',[oldData; newRow])
    case 2
        oldData = get(tableH,'Data');
        newRow={'filter2',num2str(tableActions{i,2}),'','',''};
        set(tableH,'Data',[oldData; newRow])        
    case 3
        oldData = get(tableH,'Data');
        newRow={'wiener2',num2str(tableActions{i,2}),'','',''};
        set(tableH,'Data',[oldData; newRow])
    case 4
        oldData = get(tableH,'Data');
        newRow={'imadjust',strcat('Low_in:',num2str(tableActions{i,2})),...
            strcat('High_in:',num2str(tableActions{i,3})),...
            strcat('Low_out:',num2str(tableActions{i,4})),...
            strcat('High_out:',num2str(tableActions{i,5}))};
        set(tableH,'Data',[oldData; newRow])
    case 5
        oldData = get(tableH,'Data');
        newRow={'imsharpen',strcat('Radius:',num2str(tableActions{i,2})),...
            strcat('Amount',num2str(tableActions{i,3})),strcat('Threshold:',num2str(tableActions{i,4})),''};
        set(tableH,'Data',[oldData; newRow])
    case 6
        oldData = get(tableH,'Data');
        newRow={'adapthisteq',strcat('NumTiles:',num2str(tableActions{i,2})),...
            strcat('ClipLimit',tableActions{i,3}),'',''};
        set(tableH,'Data',[oldData; newRow])
    case 7
        oldData = get(tableH,'Data');
        newRow={'threshold',num2str(tableActions{i,2}),'','',''};
        set(tableH,'Data',[oldData; newRow])
    case 8
        tempShape = {'disk','diamond'};
        oldData = get(tableH,'Data');
        newRow={'imclose',strcat('Shape:',tempShape{tableActions{i,2}}),num2str(tableActions{i,3}),'',''};
        set(tableH,'Data',[oldData; newRow])
    case 9
        oldData = get(tableH,'Data');
        newRow={'imfill','','','',''};
        set(tableH,'Data',[oldData; newRow])
    case 10
        tempShape = {'disk','diamond'};
        oldData = get(tableH,'Data');
        newRow={'imerode',strcat('Shape:',tempShape{tableActions{i,2}}),num2str(tableActions{i,3}),'',''};
        set(tableH,'Data',[oldData; newRow])
    case 11
        oldData = get(tableH,'Data');
        newRow={'bwareaopen',strcat('P:',num2str(tableActions{i,2})),'','',''};
        set(tableH,'Data',[oldData; newRow]) 
end     
end
end

function msgTemplate(hObject,callbackdata,textData,titleData)

fontSize = 14;
msgHandle = msgbox( textData, titleData);
set( msgHandle, 'Visible', 'off' );

% get handles to the UIControls ([OK] PushButton) and Text
delete(findobj( msgHandle, 'Type', 'UIControl'));
textH = findobj( msgHandle, 'Type', 'Text' ); %gettind rid of butrton

% change the font and fontsize
extent0 = get( textH, 'Extent' ); % text extent in old font
set(textH, 'FontSize', fontSize );
extent1 = get( textH, 'Extent' ); % text extent in new font

% need to resize the msgbox object to accommodate new FontName
% and FontSize
delta = extent1 - extent0; % change in extent
pos = get( msgHandle, 'Position' ); % msgbox current position
pos = pos + delta; % change size of msgbox
set( msgHandle, 'Position', pos ); % set new position

set( msgHandle, 'Visible', 'on' );
end
