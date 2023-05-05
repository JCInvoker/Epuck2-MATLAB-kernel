function ePic = set(ePic,varargin)
% SET Set asset properties and return the updated object. The information
% will be send to ePuck during the next update cycle.
%
% ePic = set(ePic,propName,value)
%
% Results :
%   ePic            :   updated ePicKernel object
%
% Parameters :
%   ePic            :   ePicKernel object
%   value           :   value to set
%   propName        :
%       'speed'           :   set motor speed values
%       'ledON'           :   switch the led number (value) on
%       'ledOFF'          :   switch the led number (value) off
%       'odom'            :   set odometry values for current position and
%                             set the initialization flag to restart
%                             odometry
%       'camMode'         :   set camera mode (0:grayscale, 1:color)
%       'camSize'         :   set camera image size [width, height]
%       'camZoom'         :   set camera zoom factor (1,4,8)
%       'external'        :   select the external sensor to update. For the
%                             list of sensor, please refer to the
%                             ePicKernel.update file
%       'ledIR'           :   select the IR led for the external 5 led
%                             range sensor
%       'custom'          :   defines a custom command to send to the
%                             e-puck. It takes as argument a vector
%                             containing [command, size of the data]

propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
        case 'speed'
            ePic.set.speed = val;
            % Verify max speed
            if ePic.set.speed(1) < -1200
                ePic.set.speed(1) = -1200;
            elseif ePic.set.speed(1) > 1200
                ePic.set.speed(1) = 1200;
            end
            if ePic.set.speed(2) < -1200
                ePic.set.speed(2) = -1200;
            elseif ePic.set.speed(2) > 1200
                ePic.set.speed(2) = 1200;
            end

        case 'ledON'
            if (val > 9 || val < 0)
                for i=1:10
                    ePic.set.led(1,i) = 1;
                end
            else
                ePic.set.led(1,val+1) = 1;
            end
        case 'ledOFF'
            if (val > 9|| val < 0)
                for i=1:10
                    ePic.clear.led(1,i) = 1;
                end
            else
                ePic.clear.led(1,val+1) = 1;
            end
        case 'odom'
            ePic.value.odom = val;
            ePic.param.odomIni = 0;
        case 'camMode'
            ePic.param.imgMode = val;
            ePic.param.imgMod = 1;
        case 'camSize'
            ePic.param.imgSize = val;
            ePic.param.imgMod = 1;
        case 'camZoom'
            ePic.param.imgZoom = val;
            ePic.param.imgMod = 1;
        case 'ledIR'
            ePic.param.ledIR = val;
        case 'external'
            ePic.param.extSel = val;
        case 'custom'
            ePic.param.customCommand = val(1:size(val,2)-1);
            ePic.param.customSize = val(size(val,2));
        case 'rgbled2'
            ePic.set.rgbled2 = val;
            for i = 1:3
                if ePic.set.rgbled2(1,i) > 100
                    ePic.set.rgbled2(1,i) = 100;
                elseif ePic.set.rgbled2(1,i) < 0
                    ePic.set.rgbled2(1,i) = 0;
                end
            end
        case 'rgbled4'
            ePic.set.rgbled4 = val;
            for i = 1:3
                if ePic.set.rgbled4(1,i) > 100
                    ePic.set.rgbled4(1,i) = 100;
                elseif ePic.set.rgbled4(1,i) < 0
                    ePic.set.rgbled4(1,i) = 0;
                end
            end
        case 'rgbled6'
            ePic.set.rgbled6 = val;
            for i = 1:3
                if ePic.set.rgbled6(1,i) > 100
                    ePic.set.rgbled6(1,i) = 100;
                elseif ePic.set.rgbled6(1,i) < 0
                    ePic.set.rgbled6(1,i) = 0;
                end
            end
        case 'rgbled8'
            ePic.set.rgbled8 = val;
            for i = 1:3
                if ePic.set.rgbled8(1,i) > 100
                    ePic.set.rgbled8(1,i) = 100;
                elseif ePic.set.rgbled8(1,i) < 0
                    ePic.set.rgbled8(1,i) = 0;
                end
            end
        case 'rgboff'
            ePic.set.rgbled2 = zeros(1,3);
            ePic.set.rgbled4 = zeros(1,3);
            ePic.set.rgbled6 = zeros(1,3);
            ePic.set.rgbled8 = zeros(1,3);
        case 'extension0'
            ePic.set.extension0 = val;
            for i = 1:3
                if ePic.set.extension0(1,i) > 128
                    ePic.set.extension0(1,i) = 128;
                elseif ePic.set.extension0(1,i) < 0
                    ePic.set.extension0(1,i) = 0;
                end
            end
        case 'extension1'
                        ePic.set.extension1 = val;
            for i = 1:3
                if ePic.set.extension1(1,i) > 128
                    ePic.set.extension1(1,i) = 128;
                elseif ePic.set.extension1(1,i) < 0
                    ePic.set.extension1(1,i) = 0;
                end
            end
        case 'extension2'
                        ePic.set.extension2 = val;
            for i = 1:3
                if ePic.set.extension2(1,i) > 128
                    ePic.set.extension2(1,i) = 128;
                elseif ePic.set.extension2(1,i) < 0
                    ePic.set.extension2(1,i) = 0;
                end
            end
        case 'extension3'
                        ePic.set.extension3 = val;
            for i = 1:3
                if ePic.set.extension3(1,i) > 128
                    ePic.set.extension3(1,i) = 128;
                elseif ePic.set.extension3(1,i) < 0
                    ePic.set.extension3(1,i) = 0;
                end
            end
        case 'extension4'
                        ePic.set.extension4 = val;
            for i = 1:3
                if ePic.set.extension4(1,i) > 128
                    ePic.set.extension4(1,i) = 128;
                elseif ePic.set.extension4(1,i) < 0
                    ePic.set.extension4(1,i) = 0;
                end
            end
        case 'extension5'
                        ePic.set.extension5 = val;
            for i = 1:3
                if ePic.set.extension5(1,i) > 128
                    ePic.set.extension5(1,i) = 128;
                elseif ePic.set.extension5(1,i) < 0
                    ePic.set.extension5(1,i) = 0;
                end
            end
        case 'extension6'
                        ePic.set.extension6 = val;
            for i = 1:3
                if ePic.set.extension6(1,i) > 128
                    ePic.set.extension6(1,i) = 128;
                elseif ePic.set.extension6(1,i) < 0
                    ePic.set.extension6(1,i) = 0;
                end
            end
        case 'extension7'
                        ePic.set.extension7 = val;
            for i = 1:3
                if ePic.set.extension7(1,i) > 128
                    ePic.set.extension7(1,i) = 128;
                elseif ePic.set.extension7(1,i) < 0
                    ePic.set.extension7(1,i) = 0;
                end
            end
        case 'extension8'
                        ePic.set.extension8 = val;
            for i = 1:3
                if ePic.set.extension8(1,i) > 128
                    ePic.set.extension8(1,i) = 128;
                elseif ePic.set.extension8(1,i) < 0
                    ePic.set.extension8(1,i) = 0;
                end
            end
        otherwise
            error('Asset properties: Descriptor, Date, CurrentValue')
    end
end