%% Load application on DSP
%CCodegenDir = fullfile(pwd, [bdroot '_c6000_rtw']);
%pwd
%bdroot
%OutFile = fullfile(CodegenDir, [bdroot '.out']);
%CCS_Obj.load(OutFile,20);

%% Configure RTDX channels
% Identify RTDX channel names/modes
chan_struct(1).name = 'inputimage';
chan_struct(1).mode = 'w';
chan_struct(2).name = 'outputimage';
chan_struct(2).mode = 'r';

% Identify RTDX host buffer parameters
RTDX_config_struct.Buffsize = 32768;
RTDX_config_struct.Nbuffers = 4;
RTDX_config_struct.Mode = 'continuous';

% Set up RTDX
r = setupRTDX(CCS_Obj, chan_struct, RTDX_config_struct);


%% Run application
CCS_Obj.run;

%% Enable RTDX
r.enable('all');

%% Import an image from file to send to the DSP
Y = imread('circuit.jpg');
I = rgb2gray(Y);
%I=Y;
figure;
imshow(Y)
title('Original RGB Image')

% figure;
% imshow(I)
% title('Input Grayscale Image')

%% Send test frame to target via RTDX
r.writemsg('inputimage', I);
        
        
%% Read processed test frame from DSP
O = r.readmsg('outputimage', 'uint8', size(I));

figure;
imshow(O)
title('Processed Binary Image')
