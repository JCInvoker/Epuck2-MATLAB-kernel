function ePic = update(ePic)
% update ePic parameter. 
% ask for selected sensors information and set motor, led and other
% parameters values on the ePuck.
%
% use the methode '[ePic] = updateDef(ePic, propName, value)' to define
% which sensor will be updated
%   
% ePic = update(ePic)
%
% Results :
%   ePic            :   updated ePicKernel object
%
% Parameters :
%   ePic            :   ePicKernel object


if (ePic.param.connected == 0)
    return;
end

% reset updated values
ePic.updated.accel = 0;
ePic.updated.proxi = 0;
ePic.updated.light = 0;
ePic.updated.micro = 0;
ePic.updated.speed = 0;
ePic.updated.pos = 0;
ePic.updated.floor = 0;
ePic.updated.exter = 0;
ePic.updated.RGB = 0;
ePic.updated.extension = 0;
ePic.updated.randb = 0;

% Construction of the command string
command=[];
sdata=0;

% choices for values asking
if (ePic.update.proxi > 0)   % Proximity
    command=[command -'N'];
    sdata=sdata+16;
end

if (ePic.update.light > 0)   % Light sensors
    command=[command -'O'];
    sdata=sdata+16;
end

if (ePic.update.accel > 0)   % Accelerometer
    command=[command -'a'];
    sdata=sdata+6;
end

if (ePic.update.pos > 0)     % Motor position
    command=[command -'Q'];
    sdata=sdata+4;
end

if (ePic.update.micro > 0)   % Microphones
    command=[command -'u'];
    sdata=sdata+6;
end

if (ePic.update.floor > 0)   % floor sensors
    command=[command -'M'];
    sdata=sdata+6;
end

% set motor speed
if (isempty(ePic.set.speed)~=1)          % Set motor speed
    command=[command -'D' typecast(int16(ePic.set.speed(1)),'int8') typecast(int16(ePic.set.speed(2)),'int8')];
    clear ePic.set.speed;
end

% More logical to put it after updating the values.
if (ePic.update.speed > 0)   % Motor speed
    command=[command -'E'];
    sdata=sdata+4;
end

% set led values
for i=1:10
    if (ePic.set.led(i)==1)
        command=[command -'L' i-1 1];
    elseif(ePic.clear.led(i)==1)
        command=[command -'L' i-1 0];
    end
end
ePic.set.led = zeros(1,10); 
ePic.clear.led = zeros(1,10); 

if (ePic.update.RGB > 0) % onboard RGB LEDs setting
    command = [command -10 ePic.set.rgbled2 ePic.set.rgbled4 ePic.set.rgbled6 ePic.set.rgbled8];
    ePic.set.rgbleds = [ePic.set.rgbled2;ePic.set.rgbled4;ePic.set.rgbled6;ePic.set.rgbled8];
end

if (ePic.update.extension > 0) % RGB display panel setting
    command = [command -119 ePic.set.extension0(1,1) ePic.set.extension1(1,1) ePic.set.extension2(1,1) ePic.set.extension3(1,1)...
        ePic.set.extension4(1,1) ePic.set.extension5(1,1) ePic.set.extension6(1,1) ePic.set.extension7(1,1)...
        ePic.set.extension0(1,3) ePic.set.extension1(1,3) ePic.set.extension2(1,3) ePic.set.extension3(1,3)...
        ePic.set.extension4(1,3) ePic.set.extension5(1,3) ePic.set.extension6(1,3) ePic.set.extension7(1,3)...
        ePic.set.extension0(1,2) ePic.set.extension1(1,2) ePic.set.extension2(1,2) ePic.set.extension3(1,2)...
        ePic.set.extension4(1,2) ePic.set.extension5(1,2) ePic.set.extension6(1,2) ePic.set.extension7(1,2)...
        ePic.set.extension8(1,1) ePic.set.extension8(1,3) ePic.set.extension8(1,2)...
        ePic.set.IRstate];
end

command=[command 0];

% Asking for the data
flush(ePic);
writeBin(ePic, command);
raw_data = readBinSized(ePic, sdata);

% Converting the data
index=1;

if (size(raw_data,2)>0)
    
    % Proximity sensors
    if (ePic.update.proxi > 0)
        prox = zeros(1,8);
        for i=1:8
            prox(i)=two_complement(raw_data(i*2-1:i*2));
        end
        ePic.value.proxi = filter_Prox(prox);
        ePic.updated.proxi = ePic.updated.proxi + 1;
        index=index+16;
    end
    
    % Light sensors
    if (ePic.update.light > 0)
        lights = zeros(1,8);
        for i=1:8
            lights(i)=two_complement(raw_data(index+i*2-2:index+i*2-1));
        end
        ePic.value.light = filter_Light(lights);
        ePic.updated.light = ePic.updated.light + 1;
        index=index+16;
    end

    % Accelerometers
    if (ePic.update.accel > 0)
        accel = zeros(1,3);
        for i=1:3
            accel(i)=two_complement(raw_data(index+i*2-2:index+i*2-1));
        end
        ePic.value.accel = filter_Accel(accel);
        ePic.updated.accel = ePic.updated.accel + 1;
        index=index+6;
    end

    % Motor position
    if (ePic.update.pos > 0)
        for i=1:2
            ePic.value.pos(i)=two_complement(raw_data(index+i*2-2:index+i*2-1));
        end
        ePic.updated.pos =  ePic.updated.pos + 1;
        index=index+4;
    end

    % Microphone
    if (ePic.update.micro > 0)
        micro = zeros(1,3);
        for i=1:3
            micro(i)=two_complement(raw_data(index+i*2-2:index+i*2-1));
        end
        ePic.value.micro = filter_Micro(micro);
        ePic.updated.micro = ePic.updated.micro + 1;
        index=index+6;
    end

    % Floor sensors
    if (ePic.update.floor > 0)
        floor = zeros(1,3);
        for i=1:3
            floor(i)=two_complement(raw_data(index+i*2-2:index+i*2-1));
        end
        ePic.value.floor = filter_Floor(floor);
        ePic.updated.floor = ePic.updated.floor + 1;
        index=index+6;
    end
      
    % Motor speed
    if (ePic.update.speed > 0)
        for i=1:2
            ePic.value.speed(i)=two_complement(raw_data(index+i*2-2:index+i*2-1));
        end
        ePic.updated.speed = ePic.updated.speed + 1;
        index=index+4;
    end    
    
end


if (ePic.update.randb > 0)
    % set proximtiy slow update sampling and turn off time of flight to get
    % less interference in the RandB communication
    command=[-16 2 -17 0 0];
    flush(ePic);
    writeBin(ePic, command);
    pause(0.05);

    % set range of RandB
    command=[-87 64 12 50 0];
    flush(ePic);
    writeBin(ePic, command);
    pause(0.05);

    % set onboard calculation for RandB
    command=[-87 64 17 0 0]; % 87 = W
    flush(ePic);
    writeBin(ePic, command);
    pause(0.05);

    %    % Send data
    command=[-87 64 13 120 0]; % Send MSB
    flush(ePic);
    writeBin(ePic, command);
    pause(0.05);
    command=[-87 64 14 50 0]; % Send LSB
    flush(ePic);
    writeBin(ePic, command);
    pause(0.05);

    % Check if data received
    command=[-89 64 0 0];
    flush(ePic);
    writeBin(ePic, command);
    pause(0.05);
    value = readBinSized(ePic, 1);

    if value == 1 % Read the data
        command=[-89 64 1 -89 64 2 -89 64 3 ...
            -89 64 4 -89 64 5 -89 64 6 ...
            -89 64 7 -89 64 8 -89 64 9 0]; % 89 = Y
        flush(ePic);
        writeBin(ePic, command);
        pause(0.05);
        fulldata = readBinSized(ePic, 9);
        ePic.value.msb = fulldata(1);
        ePic.value.lsb = fulldata(2);
        ePic.value.bearingm = fulldata(3);
        ePic.value.bearingl = fulldata(4);
        ePic.value.rangem = fulldata(5);
        ePic.value.rangel = fulldata(6);
        ePic.value.maxm = fulldata(7);
        ePic.value.maxl = fulldata(8);
        ePic.value.sensord = fulldata(9);
    end

end
% Reset update once parameters
if ePic.update.accel == 2
    ePic.update.accel = 0; end
if ePic.update.proxi == 2
    ePic.update.proxi = 0; end
if ePic.update.light == 2
    ePic.update.light = 0; end
if ePic.update.micro == 2
    ePic.update.micro = 0; end
if ePic.update.speed == 2
    ePic.update.speed = 0; end
if ePic.update.pos == 2
    ePic.update.pos = 0; end
if ePic.update.floor == 2
    ePic.update.floor = 0; end
if ePic.update.exter == 2
    ePic.update.exter = 0; end
if ePic.update.custom == 2
    ePic.update.custom = 0; end
if ePic.update.RGB == 2
    ePic.update.RGB = 0; end
if ePic.update.extension == 2
    ePic.update.extension = 0; end
if ePic.update.randb == 2
    ePic.update.randb = 0; end