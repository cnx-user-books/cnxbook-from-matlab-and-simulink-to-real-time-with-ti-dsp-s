% Load video data (vG3 is loaded here)
 %load vid_hist;
[vR3 vG3 vB3]=avi2rgb('vipmem_Y.avi');
vG3=uint8(256*vG3);
% Identify RTDX channel names/modes
chan_struct(1).name = 'InputVideo';
chan_struct(1).mode = 'w';
chan_struct(2).name = 'OutputVideo';
chan_struct(2).mode = 'r';

% Identify RTDX host buffer parameters
RTDX_config_struct.Buffsize = 32768;
RTDX_config_struct.Nbuffers = 4;
RTDX_config_struct.Mode = 'continuous';

r = setupRTDX(CCS_Obj, chan_struct, RTDX_config_struct);

VidLoop = 0;
videosize=size(vG3);
VidLoopFrames = videosize(3);

% Enable all RTDX channels
r.enable('all');

% run target
CCS_Obj.run;
%********** End of Initialization *************

while isrunning(CCS_Obj)
    try
         % Prepare next test video frame
        VidLoop = 1+rem(VidLoop,VidLoopFrames);
        % Send test frame to target via RTDX
        r.writemsg('InputVideo', vG3(:,:,VidLoop));
        pause(3);
        % Read video frames and update display
        outVideo  = r.readmsg('OutputVideo', 'uint8',[120 160]);
    catch
        % Halt processor and report error
        CCS_Obj.halt;
        fprintf('Error occurred during run-time loop.\n');
        fprintf([lasterr '\n']);
     end
    figure(1)
    imshow(vG3(:,:,VidLoop))
    figure(2)
    imshow(outVideo)
end
