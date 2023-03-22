function msgTemplate(hObject,eventData,textData,titleData)

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
