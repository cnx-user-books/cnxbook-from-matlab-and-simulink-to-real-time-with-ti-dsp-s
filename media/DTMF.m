function varargout = DTMF(varargin)
% DTMF M-file for DTMF.fig
%      DTMF, by itself, creates a new DTMF or raises the existing
%      singleton*.
%
%      H = DTMF returns the handle to a new DTMF or the handle to
%      the existing singleton*.
%
%      DTMF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DTMF.M with the given input arguments.
%
%      DTMF('Property','Value',...) creates a new DTMF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DTMF_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DTMF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DTMF

% Last Modified by GUIDE v2.5 20-Apr-2007 17:09:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DTMF_OpeningFcn, ...
                   'gui_OutputFcn',  @DTMF_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DTMF is made visible.
function DTMF_OpeningFcn(hObject, eventdata, handles, varargin)
modelName = gcs;
CCS_Obj = connectToCCS(modelName);
% Identify RTDX channel names/modes
chan_struct(1).name = 'OutputDigit';
chan_struct(1).mode = 'r';
handles.rtdx_chan1=chan_struct(1);
% Identify RTDX host buffer parameters
RTDX_config_struct.Buffsize= 32768;
RTDX_config_struct.Nbuffers = 4;
RTDX_config_struct.Mode = 'continuous';
CodegenDir = fullfile(pwd, ['DTMF_DSK6713' '_c6000_rtw']);
OutFile = fullfile(CodegenDir, ['DTMF_DSK6713.out']);
%Load is needed for rtdx setup
CCS_Obj.load(OutFile,20);
% Set up RTDX
r = setupRTDX(CCS_Obj, chan_struct, RTDX_config_struct);
handles.pipe=r;
handles.CCS_Obj=CCS_Obj;
handles.output = hObject;
CCS_Obj.run; 
% Enable all RTDX channels
r.enable('all');
%The buffer that stores the user input digits
A=[];
handles.A=A;
% flag that tells if the gui needs to clear the dialed string or 
%the next digit joins the previous string: 
handles.initFlag=0;
handles.maxSize=11;
handles.freqTable=generateTable();
% Update handles structure
guidata(hObject, handles);

function res=generateTable()
t=(1:256*6)/8192;
res(1,:)=sin(2*pi*697*t)+sin(2*pi*1209*t);
res(2,:)=sin(2*pi*697*t)+sin(2*pi*1336*t);
res(3,:)=sin(2*pi*697*t)+sin(2*pi*1477*t);
res(4,:)=sin(2*pi*770*t)+sin(2*pi*1209*t);
res(5,:)=sin(2*pi*770*t)+sin(2*pi*1336*t);
res(6,:)=sin(2*pi*770*t)+sin(2*pi*1477*t);
res(7,:)=sin(2*pi*852*t)+sin(2*pi*1209*t);
res(8,:)=sin(2*pi*852*t)+sin(2*pi*1336*t);
res(9,:)=sin(2*pi*852*t)+sin(2*pi*1477*t);
res(10,:)=sin(2*pi*941*t)+sin(2*pi*1209*t);
res(11,:)=sin(2*pi*941*t)+sin(2*pi*1336*t);
res(12,:)=sin(2*pi*941*t)+sin(2*pi*1477*t);

% --- Outputs from this function are returned to the command line.
function varargout = DTMF_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function handleButton(hObject,handles,k)
%get the digits buffer
A=handles.A;
%if we have to earase so we are doing it here:
if handles.initFlag==1
    handles.initFlag=0;
    A=[];
end
%check if the string is too long with the new digit:
if length(A)==handles.maxSize
    fprintf('Error: too many digits\n');
    return;
end
%concatenate the new digit to the existing buffer
A=[A k];
handles.A=A;
set(handles.text1, 'String', strrep(strrep(strrep(int2str(A),'10','*'),'11','0'),'12','#'));    
guidata(hObject,handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,1);
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,2);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,3);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,4);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,5);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,6);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,7);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,8);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,9);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,10);
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,11);

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
handleButton(hObject,handles,12);


%input: digits and handle to the signals table
%output: buffer that contains the DTMF samples for the digits.
function res=buildXmt(handles,A)
res=[];
for k=1 : length(A)
    freqTable=handles.freqTable;
    %place the next digit and then zeros (space)
    res=[res freqTable(A(k),:) zeros(1,256*6);];
end

%The Send Button Handler:
function pushbutton13_Callback(hObject, eventdata, handles)
r=handles.pipe;
A=handles.A;
padding=0;
if length(A)==0
    return
end
% if dialed less than 11 digits pad to 11 digits
if length(A)<11
     padding=11-length(A);
    A=[A ones(1,11-length(A))];
end
%build the Send Buffer
xmt=0.5*buildXmt(handles,A);
%Transmit DTMF signals buffer
sound(xmt,8192)
%Wait for end of detection
pause(4)
%read the digits from the rtdx:
num_of_msgs = msgcount(r,'OutputDigit');
r.flush('OutputDigit',num_of_msgs-1);
 y=r.readmsg(handles.rtdx_chan1.name, 'double',1);
y=y(1:end-padding);

%Update the upper label with the digits read from dsk estimation
set(handles.text4, 'String', strrep(strrep(strrep(int2str(y),'10','*'),'11','#'),'20','*')); 
handles.initFlag=1;
guidata(hObject, handles);



function text1_CreateFcn(hObject, eventdata, handles)
handles.text1=hObject;
guidata(hObject, handles);


% Delete one digit.
function pushbutton14_Callback(hObject, eventdata, handles)
A=handles.A;
if length(A)==0
    return
end
A=A(1:end-1);
set(handles.text1, 'String', strrep(strrep(strrep(int2str(A),'10','*'),'11','0'),'12','#')); 
handles.A=A;
guidata(hObject, handles);


%Clear all the dialed digits.
function pushbutton15_Callback(hObject, eventdata, handles)
A=handles.A;
A=[];
set(handles.text1, 'String', strrep(strrep(strrep(int2str(A),'10','*'),'11','0'),'12','#')); 
handles.A=A;
guidata(hObject, handles);


