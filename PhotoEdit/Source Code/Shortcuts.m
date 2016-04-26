function varargout = Shortcuts(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Shortcuts_OpeningFcn, ...
                   'gui_OutputFcn',  @Shortcuts_OutputFcn, ...
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

% --- Executes just before Shortcuts is made visible.
function Shortcuts_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Shortcuts (see VARARGIN)
global scuts reg reg2 scuts2
set(handles.listbox1,'string',scuts(:,1));
reg2=reg;
scuts2=scuts;
h=axes('unit','normalized','position',[0 0 1 1]);
bg=imread('Textures/bg.png');imagesc(bg);
set(h,'handlevisibility','off','visible','off')
uistack(h, 'bottom');
jFrame=get(hObject,'javaframe');  
jicon=javax.swing.ImageIcon('icon.png');
jFrame.setFigureIcon(jicon);

% Choose default command line output for Shortcuts
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Shortcuts wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Shortcuts_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
if get(handles.pop,'value')==1
  msgbox('Select a modifier(s) from the popupmenu first','Error')
  return 
end
set(handles.pushbutton1,'string','Waiting..','enable','off');

function pushbutton2_Callback(hObject, eventdata, handles)
global reg scuts pops options texts reg2 scuts2 the_path
reg=reg2;
scuts=scuts2;
if ~exist(the_path, 'dir')
    mkdir(the_path)
end
save ([the_path 'reg.mat'] ,'reg' ,'options' ,'pops' ,'scuts' ,'texts')
close(Shortcuts);
function pushbutton3_Callback(hObject, eventdata, handles)
close(Shortcuts);
function pushbutton4_Callback(hObject, eventdata, handles)
global scuts2 reg2
v=get(handles.listbox1,'value');
reg2{v,1}='None';
reg2{v,2}='None';
scuts2{v,1}=strrep(scuts2{v,1},scuts2{v,2},'None');
scuts2{v,2}='None';
set(handles.listbox1,'string',scuts2(:,1));
function listbox1_Callback(hObject, eventdata, handles)
if get(hObject,'value')<=12
  set(handles.pushbutton1,'enable','off','string','Edit');
  set(handles.pushbutton4,'enable','off');
else
  set(handles.pushbutton1,'enable','on','string','Edit');
  set(handles.pushbutton4,'enable','on');
end
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pop_Callback(hObject, eventdata, handles)
function pop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
global reg2 scuts2 pops
c=get(handles.pop,'value');
v=get(handles.listbox1,'value');
if strcmp(get(handles.pushbutton1,'string'),'Waiting..');
  moods=pops{c,1};
  key=eventdata.Key;
  mods=eventdata.Modifier;
  if strcmp(mods,key)
    msgbox('Inappropriate Key','Error');
    set(handles.pushbutton1,'string','Edit','enable','on');
    return 
  end
  for i=1:24
    if strcmp(moods,reg2{i,1}) && strcmp(key,reg2{i,2})
      msgbox('Shortcut is already taken','Error');      
      set(handles.pushbutton1,'string','Edit','enable','on');
      return
    end
  end
    scuts2{v,1}=strrep(scuts2{v,1},scuts2{v,2},[pops{c,2} ' ' key]); 
    scuts2{v,2}=[pops{c,2} ' ' key];
    reg2{v,1}=moods;
    reg2{v,2}=key;
    set(handles.pushbutton1,'string','Edit','enable','on');
    set(handles.listbox1,'string',scuts2(:,1));
end

