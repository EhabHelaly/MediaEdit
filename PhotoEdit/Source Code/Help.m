function varargout = Help(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Help_OpeningFcn, ...
                   'gui_OutputFcn',  @Help_OutputFcn, ...
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


% --- Executes just before Help is made visible.
function Help_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
h=axes('unit','normalized','position',[0 0 1 1]);
bg=imread('Textures/bg.png');imagesc(bg);
set(h,'handlevisibility','off','visible','off')
uistack(h, 'bottom');
global texts
set(handles.text,'string',texts{1});
jFrame=get(hObject,'javaframe');  
jicon=javax.swing.ImageIcon('icon.png');
jFrame.setFigureIcon(jicon);

% Choose default command line output for Help
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Help wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Help_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pEdit.
function pEdit_Callback(hObject, eventdata, handles)
	global texts
	set(handles.panel,'title','Features');
	set(handles.pLicence,'enable','on');
	set(handles.pEdit,'enable','off');
	set(handles.text,'string',texts{1}); 
% --- Executes on button press in pLicence.
function pLicence_Callback(hObject, eventdata, handles)
    global texts
    set(handles.panel,'title','Licence');
	set(handles.pEdit,'enable','on');
	set(handles.pLicence,'enable','off');
    set(handles.text,'string',texts{2})

% --- Executes on button press in pClose.
function pClose_Callback(hObject, eventdata, handles)
close(Help)
