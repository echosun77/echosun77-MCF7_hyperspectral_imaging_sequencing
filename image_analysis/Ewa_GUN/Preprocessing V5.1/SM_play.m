%emission from the protocol
nChannel=39;
channel = struct('emission', {HAC_Image.imageStruct.protocol.channel(1:nChannel).emission});
c = struct2cell(channel);
AA = [c{:}];
% AA=(struct2array(channel));
%%
%QE for the camera
BB=HAC_Image.projectStruct.hardware.camera.QuantumEffResponse;
DD=interp1(BB(:,1),BB(:,2),[BB(1,1):1:BB(end,1)]);
QE_all(:,2)=DD.';
QE_all(:,1)=([BB(1,1):1:BB(end,1)]).';
%%

for jj=1:nChannel
    r1=find(QE_all(:,1)==str2double(AA{1,jj}));
    QE_SM(jj,1)=QE_all(r1,2);
end
SENS=str2double(HAC_Image.projectStruct.hardware.camera.epercount);
BIAS=str2double(HAC_Image.projectStruct.hardware.camera.darkoffset);
