# Epuck2-MATLAB-kernel
The original and official code please refer to https://github.com/gctronic/e-puck-library.
This kernel is updated by Jiacheng Chen, Sheffield Hallam University, UK.
Thanks to Stefano Morgani for his help.

Also available in MATLAB Add-ons
[![View Epuck2-MATLAB-kernel on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/129024-epuck2-matlab-kernel)

Update:
1. Use 'serialport' instead 'serial', previously close MATLAB by mistake or detele kernel by mistake will
cause an error which epuck needs to wait for a long time to re-connect. The new kernel solves this problem.

2. The max speed of motor used to be 1000 steps/s for epuck1, the max speed for epuck2 upgraded to 1200.

3. Add onboard RGB LEDs control.

4. Add Range and Bearing Board control.
