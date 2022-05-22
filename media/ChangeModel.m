%/////////////////////////////////////////////////////////////////////////////          this function handles changing model and does:       ////////////////////////////////
%1. halts the current model
%2. free the rtdx channel
%3. redefine the rtdx channel
%4. loads the current model
%5. binds the rtdx to the current model
%6. run the CCS and enable the rtdx.
%7.writes the last given index modulation  to the rtdx 
%parameters:
%m - flag that tells if the model is coherential or sqrt
%CCS_Obj - the target
%r_old - the old  rtdx channel 
%last_x - to keep the current Index
%last_y - to keep the current carrier frequency
function r=ChangeModel(m,CCS_Obj,r_old,last_x,last_y)
%halt the current model
CCS_Obj.halt;
%free the curent rtdx channel
cleanupRTDX(CCS_Obj,r_old);
%redefine the rtdx:
chan_struct(1).name = 'InputModulation';
chan_struct(1).mode = 'w';
chan_struct(2).name = 'freq';
chan_struct(2).mode = 'w';
handles.rtdx_chan1=chan_struct(1);
handles.rtdx_chan2=chan_struct(2);
% Identify RTDX host buffer parameters
RTDX_config_struct.Buffsize= 32768;
RTDX_config_struct.Nbuffers = 4;
RTDX_config_struct.Mode = 'continuous';
%reload the new model
switch m
    case 1
    model='AM_Coherent';
    case 2
        model='AM_Sqrt';
end         
CodegenDir = fullfile(pwd, [model '_c6000_rtw']);
OutFile = fullfile(CodegenDir, [model '.out']);
CCS_Obj.load(OutFile,20);
% set up the new rtdx channel and run the target
r = setupRTDX(CCS_Obj, chan_struct, RTDX_config_struct);
CCS_Obj.run;     
r.enable('all');
% keep the last Index and carrier frequency:
if last_x~=1
r.writemsg(chan_struct(2).name,1/last_x);  
end
if last_y~=15000
r.writemsg(chan_struct(2).name,1/last_y);  
end
