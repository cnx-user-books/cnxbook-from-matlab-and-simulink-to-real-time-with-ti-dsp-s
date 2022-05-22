function varargout = Spectrum(varargin)
% SPECTRUM M-file for Spectrum.fig
%      SPECTRUM, by itself, creates a new SPECTRUM or raises the existing
%      singleton*.
%
%      H = SPECTRUM returns the handle to a new SPECTRUM or the handle to
%      the existing singleton*.
%
%      SPECTRUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTRUM.M with the given input arguments.
%
%      SPECTRUM('Property','Value',...) creates a new SPECTRUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Spectrum_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Spectrum_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Spectrum

% Last Modified by GUIDE v2.5 09-Feb-2007 18:26:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Spectrum_OpeningFcn, ...
                   'gui_OutputFcn',  @Spectrum_OutputFcn, ...
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


% --- Executes just before Spectrum is made visible.
function Spectrum_OpeningFcn(hObject, eventdata, handles, varargin)
modelName = gcs;
%connect to target:
CCS_Obj = connectToCCS(modelName);
% Identify RTDX channel names/modes
CodegenDir = fullfile(pwd, ['Periodogram' '_c6000_rtw']);
OutFile = fullfile(CodegenDir, ['Periodogram' '.out']);
%load the model to the DSK:
CCS_Obj.load(OutFile,20);
handles.CCS_Obj=CCS_Obj;
handles.output = hObject;
%remember the current model: 
handles.last_model=1;
CCS_Obj.run;     
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Spectrum wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Spectrum_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
handles.last_model=get(hObject,'Value') ;
SelectModel(handles.last_model,handles.CCS_Obj);
guidata(hObject, handles);
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


