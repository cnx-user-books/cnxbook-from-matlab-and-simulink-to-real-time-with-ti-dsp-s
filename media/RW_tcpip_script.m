function my_tcpip_surveil_script(hostModelName)
%TCPIP_SURVEIL_SCRIPT controls host-side TCP/IP processing for 
%  Video Surveillance demo:
%
%  1) Builds & runs the target application

% $Revision: 1.1.6.3 $ $Date: 2007/05/29 21:39:09 $
% Copyright 2002-2007 The MathWorks, Inc.


%********** Initialization ********************
% Get model name
modelName = gcs;

% Connect to CCS
CCS_Obj = connectToCCS(modelName);
saved_visibility = CCS_Obj.isvisible;
CCS_Obj.visible(1);

% Load application
loadApp(modelName, CCS_Obj);

% Run application
fprintf('Running application: %s\n', modelName);
CCS_Obj.run;     

% Allow some time for DHCP address acquisition
pause(3);

% Retrive target's host name 
boardType = get_param([modelName '/IP Config'], 'boardType');
userPrompt = sprintf('Enter the IP address or the host name of the %s board: ', boardType);
hostName = inputdlg(userPrompt, 'Target IP address');
if isempty(hostName)
    errordlg('You have to provide a valid IP address or host name to run the demo.', ...
        'TCP/IP Surveillance Recording', 'modal');
    return;
end
hostName = strtrim(hostName{1});


% Launch host side UDP receive / Video display model
fprintf('Launching host side application: %s\n', hostModelName);
open_system(hostModelName);

% Update host side TCP/IP blocks with target's IP address
set_param([hostModelName '/TCP//IP Send'], 'Host', hostName);
set_param([hostModelName '/TCP//IP Receive'], 'Host', hostName);
fprintf('Click on play button to start running the host side application!\n\n')
 

%[EOF] tcpip_surveil_script.m
