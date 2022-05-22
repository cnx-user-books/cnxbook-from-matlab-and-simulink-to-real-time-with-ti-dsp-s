function varargout = AM(varargin)
% AM M-file for AM.fig
%      AM, by itself, creates a new AM or raises the existing
%      singleton*.
%
%      H = AM returns the handle to a new AM or the handle to
%      the existing singleton*.
%
%      AM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AM.M with the given input arguments.
%
%      AM('Property','Value',...) creates a new AM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AM_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AM

% Last Modified by GUIDE v2.5 17-Mar-2007 13:44:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AM_OpeningFcn, ...
                   'gui_OutputFcn',  @AM_OutputFcn, ...
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


% --- Executes just before AM is made visible.
function AM_OpeningFcn(hObject, eventdata, handles, varargin)
last_model=1;
handles.last_model=last_model;
modelName = gcs;
%connect to the board
CCS_Obj = connectToCCS(modelName);
% Identify RTDX channel names/modes
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
%building the full path of the file to be loaded
CodegenDir = fullfile(pwd, ['AM_Coherent' '_c6000_rtw']);
OutFile = fullfile(CodegenDir, ['AM_Coherent' '.out']);
%Load is needed for rtdx setup
CCS_Obj.load(OutFile,20);
% Set up RTDX
r = setupRTDX(CCS_Obj, chan_struct, RTDX_config_struct);
handles.pipe=r;
handles.CCS_Obj=CCS_Obj;
%last_x and last_y are the initial values of
%the Index and the carrier respectively 
last_x=1;
last_y=15000;
handles.last_x=last_x;
handles.last_y=last_y;
handles.output = hObject;
% Enable all RTDX channels
r.enable('all');
% Update handles structure
guidata(hObject, handles);
%use the change-model function in order to load the current model.
%this function loads a model to the dsk after initiallization (= the code
%above)
ChangeModel(handles.last_model,handles.CCS_Obj,handles.pipe,handles.last_x,handles.last_y);

% UIWAIT makes AM wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AM (see VARARGIN)

% Choose default command line output for AM
handles.output = hObject;



% UIWAIT makes AM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
handles.last_model=get(hObject,'Value') ;
ChangeModel(handles.last_model,handles.CCS_Obj,handles.pipe,handles.last_x,handles.last_y);
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
last_x=handles.last_x;
r=handles.pipe;
x=single(get(hObject,'Value'));
     if or(x<last_x,x>last_x) %if the Index was changed:
       r.writemsg(handles.rtdx_chan1.name,1/x);       
       %the Index increases when the added amplitude decreases 
       %and thats the reason that we write 1/x to the rtdx
       handles.last_x=x;
     end
guidata(hObject, handles);
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)

% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end






% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
last_y=handles.last_y;
r=handles.pipe;
y=single(get(hObject,'Value'));
     if or(y<last_y,y>last_y)
       r.writemsg(handles.rtdx_chan2.name,y);       
       handles.last_y=y;
     end
guidata(hObject, handles);
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end








% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


