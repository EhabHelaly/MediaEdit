function varargout = Preferences(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Preferences_OpeningFcn, ...
                   'gui_OutputFcn',  @Preferences_OutputFcn, ...
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


% --- Executes just before Preferences is made visible.
function Preferences_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% varargin   command line arguments to Preferences (see VARARGIN)
h=axes('unit','normalized','position',[0 0 1 1]);
bg=imread('Textures/bg.png');imagesc(bg);
set(h,'handlevisibility','off','visible','off')
uistack(h, 'bottom');
global options 
set(handles.checkbox1,'value',options{1});
set(handles.checkbox2,'value',options{2});
set(handles.radiobutton1,'value',options{3});
set(handles.radiobutton2,'value',~options{3});
set(handles.checkbox8,'value',options{4}{1});
if ~options{4}{1}
	set(handles.edit1,'enable','on');
	set(handles.browse,'enable','on');
	set(handles.edit1,'string',options{4}{2});
else
	options{4}{2}=pwd;	
	set(handles.edit1,'string',options{4}{2});
end
jFrame=get(hObject,'javaframe');  
jicon=javax.swing.ImageIcon('icon.png');
jFrame.setFigureIcon(jicon);

% Choose default command line output for Preferences
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Preferences wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Preferences_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)

% --- Executes on button press in pOk.
function pOk_Callback(hObject, eventdata, handles)
global options reg scuts pops texts the_path
options={get(handles.checkbox1,'value')...
         get(handles.checkbox2,'value')...
         get(handles.radiobutton1,'value')...
         {get(handles.checkbox8,'value')...
         get(handles.edit1,'string')}...
         };
if ~exist(the_path, 'dir')
    mkdir(the_path)
end
save ([the_path 'reg.mat'] ,'reg' ,'options' ,'pops' ,'scuts' ,'texts')
close(Preferences)
% --- Executes on button press in pCancel.
function pCancel_Callback(hObject, eventdata, handles)
close(Preferences)
% --- Executes on button press in pScuts.
function pScuts_Callback(hObject, eventdata, handles)
ishandle(Shortcuts);
% --- Executes on button press in pHelp.
function pHelp_Callback(hObject, eventdata, handles)
ishandle(Help);
% --- Executes on button press in pCredits.
function pCredits_Callback(hObject, eventdata, handles)
    msgbox('This Software is developed by M.E.Helaly','Credits');
% --- Executes on button press in pCode.
function pCode_Callback(hObject, eventdata, handles)
	web('https://github.com/EhabHelaly','-browser')


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
global options
fpath=uigetdir(options{4}{2},'Select Main Folder');
if fpath
	set(handles.edit1,'string',fpath);
end
% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
if get(handles.checkbox8,'value')
	set(handles.edit1,'enable','off');
	set(handles.browse,'enable','off');
	set(handles.edit1,'string',pwd);
else
	set(handles.edit1,'enable','on');
	set(handles.browse,'enable','on');
end	
	
function edit1_Callback(hObject, eventdata, handles)
if ~exist(get(handles.edit1,'string'),'dir')
	msgbox('Directory not found','Error');
	set(handles.edit1,'string',pwd);
end
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
