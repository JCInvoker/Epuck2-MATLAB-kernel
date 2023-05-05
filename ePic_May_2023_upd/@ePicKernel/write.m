function  write(ePic, data )
% write allow you to send ASCII datas to the epuck
%
% write(ePic, data )
%
% Parameters :
%   ePic            :   ePicKernel object
%   data            :   ASCII data to send 

flush(ePic);
try
    writeline(ePic.param.comPort,data);
catch
    disp 'Erreur while data writing'
end