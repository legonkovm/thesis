function varargout = kursgui(varargin)
% KURSGUI MATLAB code for kursgui.fig
%      KURSGUI, by itself, creates a new KURSGUI or raises the existing
%      singleton*.
%
%      H = KURSGUI returns the handle to a new KURSGUI or the handle to
%      the existing singleton*.
%
%      KURSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KURSGUI.M with the given input arguments.
%
%      KURSGUI('Property','Value',...) creates a new KURSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kursgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kursgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kursgui

% Last Modified by GUIDE v2.5 04-May-2019 14:12:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @kursgui_OpeningFcn, ...
    'gui_OutputFcn',  @kursgui_OutputFcn, ...
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


% --- Executes just before kursgui is made visible.
function kursgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kursgui (see VARARGIN)

% Choose default command line output for kursgui
handles.output = hObject;
handles.m_ExpGUI = varargin{1}; %добавляем ссылку на себя

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kursgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kursgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%дописать загрузку параметров из m_InputData
% set(handles.editPfa,'String',sprintf('%d',handles.m_ExpGUI.m_InputData.Pfa));
set(handles.editPfa,'String',handles.m_ExpGUI.m_InputData.Pfa);
set(handles.editNumRot,'String',handles.m_ExpGUI.m_InputData.NumRot);
set(handles.editDistance,'String',handles.m_ExpGUI.m_InputData.Distance);
set(handles.editNumRLS,'String',handles.m_ExpGUI.m_InputData.NumRLS);
set(handles.editAzimut,'String',handles.m_ExpGUI.m_InputData.Azimut);
set(handles.editDistPd,'String',handles.m_ExpGUI.m_InputData.DistPd);
try
    set(handles.popupmenuAlgSelect,'Value',handles.m_ExpGUI.m_InputData.algNumber)
catch
    set(handles.popupmenuAlgSelect,'Value',1);
    handles.m_ExpGUI.m_InputData.algNumber = 1; 
    contents = cellstr(get(hObject,'String'));
    handles.m_ExpGUI.m_InputData.algName = contents{1};  
    set(handles.popupmenuNoiseSelect,'Value',1);
    handles.m_ExpGUI.m_InputData.noiseNumber = 1; 
    contents = cellstr(get(hObject,'String'));
    handles.m_ExpGUI.m_InputData.noiseName = contents{1};
    set(handles.popupmenuSignalSelect,'Value',1);
    handles.m_ExpGUI.m_InputData.signalNumber = 1; 
    contents = cellstr(get(hObject,'String'));
    handles.m_ExpGUI.m_InputData.signalName = contents{1}; 
end
cla(handles.axes);

% --- Executes on button press in pushbuttonCalcPfa.
function pushbuttonCalcPfa_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCalcPfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.m_ExpGUI.m_StatExperiment.calculate_Pfa;


function editPfa_Callback(hObject, eventdata, handles)
% hObject    handle to editPfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pfa = str2double(get(hObject, 'String'));
handles.m_ExpGUI.m_InputData.Pfa = Pfa;
% Hints: get(hObject,'String') returns contents of editPfa as text
%        str2double(get(hObject,'String')) returns contents of editPfa as a double

% --- Executes during object creation, after setting all properties.
function editPfa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonCalcPd.
function pushbuttonCalcPd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCalcPd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.m_ExpGUI.m_StatExperiment.calculate_Pd;


% --- Executes on selection change in popupmenuAlgSelect.
function popupmenuAlgSelect_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuAlgSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuAlgSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuAlgSelect
contents = cellstr(get(hObject,'String'));
handles.m_ExpGUI.m_InputData.algName = contents{get(hObject,'Value')};
handles.m_ExpGUI.m_InputData.algNumber = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function popupmenuAlgSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuAlgSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles.m_ExpGUI.m_InputData.update;
delete(hObject);


% --- Executes on button press in pushbuttonsave.
function pushbuttonsave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uiputfile('plot.jpg');
saveas(handles.axes, file, 'jpg');


function editNumRot_Callback(hObject, eventdata, handles)
% hObject    handle to editNumRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NumRot = str2double(get(hObject, 'String'));
handles.m_ExpGUI.m_InputData.NumRot = NumRot;
% Hints: get(hObject,'String') returns contents of editNumRot as text
%        str2double(get(hObject,'String')) returns contents of editNumRot as a double


% --- Executes during object creation, after setting all properties.
function editNumRot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxmedian.
function checkboxmedian_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxmedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.m_ExpGUI.m_InputData.MedOn = get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of checkboxmedian


% --- Executes on button press in pushbuttonPicture.
function pushbuttonPicture_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.m_ExpGUI.m_StatExperiment.show_picture;



function editNumRLS_Callback(hObject, eventdata, handles)
% hObject    handle to editNumRLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NumRLS = str2double(get(hObject, 'String'));
handles.m_ExpGUI.m_InputData.NumRLS = NumRLS;
% Hints: get(hObject,'String') returns contents of editNumRLS as text
%        str2double(get(hObject,'String')) returns contents of editNumRLS as a double


% --- Executes during object creation, after setting all properties.
function editNumRLS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumRLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDistance_Callback(hObject, eventdata, handles)
% hObject    handle to editDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Distance = str2double(get(hObject, 'String'));
handles.m_ExpGUI.m_InputData.Distance = Distance;
% Hints: get(hObject,'String') returns contents of editDistance as text
%        str2double(get(hObject,'String')) returns contents of editDistance as a double


% --- Executes during object creation, after setting all properties.
function editDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAzimut_Callback(hObject, eventdata, handles)
% hObject    handle to editAzimut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Azimut = str2double(get(hObject, 'String'));
handles.m_ExpGUI.m_InputData.Azimut = Azimut;
% Hints: get(hObject,'String') returns contents of editAzimut as text
%        str2double(get(hObject,'String')) returns contents of editAzimut as a double


% --- Executes during object creation, after setting all properties.
function editAzimut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAzimut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDistPd_Callback(hObject, eventdata, handles)
% hObject    handle to editDistPd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DistPd = str2double(get(hObject, 'String'));
handles.m_ExpGUI.m_InputData.DistPd = DistPd;
% Hints: get(hObject,'String') returns contents of editDistPd as text
%        str2double(get(hObject,'String')) returns contents of editDistPd as a double


% --- Executes during object creation, after setting all properties.
function editDistPd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDistPd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
