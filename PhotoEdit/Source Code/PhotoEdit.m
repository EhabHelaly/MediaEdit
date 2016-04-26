function varargout = PhotoEdit(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PhotoEdit_OpeningFcn, ...
                   'gui_OutputFcn',  @PhotoEdit_OutputFcn, ...
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

% --- Executes just before PhotoEdit is made visible.
function PhotoEdit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
global pic data pics r s reg options pops scuts texts ah the_path
the_path=[getenv('USERPROFILE') '\Documents\MediaEdit\PhotoEdit\'];
if ~exist(the_path,'dir')
    mkdir(the_path)
    load('WorkSpace.mat')
    save ([the_path 'WorkSpace.mat'] ,'pic' ,'data', 'pics' ,'r' ,'s')
    load('reg.mat')
    save ([the_path 'reg.mat'] ,'reg' ,'options' ,'pops' ,'scuts' ,'texts')
else
    if exist([the_path 'WorkSpace.mat'],'file')
        load ([the_path 'WorkSpace.mat'])
    else
        load('WorkSpace.mat')
        save ([the_path 'WorkSpace.mat'] ,'pic' ,'data', 'pics' ,'r' ,'s')
    end
    if exist([the_path 'reg.mat'],'file')
        load ([the_path 'reg.mat'])
    else
        load('reg.mat')
        save ([the_path 'reg.mat'] ,'reg' ,'options' ,'pops' ,'scuts' ,'texts')
    end
end

ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
m =ones(400,1000,3);imagesc(m);
set(ah,'handlevisibility','off','visible','off')
uistack(ah, 'top');

h=axes('unit','normalized','position',[0 0 1 1]);
bg=imread('Textures/media_bg.png');imagesc(bg);
set(h,'handlevisibility','off','visible','off')
uistack(h, 'bottom');
if r~=0
    showpic(pic,handles)
end

%%%%%%%%%%%%%%%%
bs=imread('Textures/buttons.png');
bs1=mat2cell(bs(1:40,:,:),40,ones(1,12)*40,3);
bs2=mat2cell(bs(41:70,1:390,:),30,ones(1,13)*30,3);
set(handles.b1,'cdata',bs1{1,1});
set(handles.b2,'cdata',bs1{1,2});
set(handles.b3,'cdata',bs1{1,3});
set(handles.b4,'cdata',bs1{1,4});
set(handles.b5,'cdata',bs1{1,5});
set(handles.b6,'cdata',bs1{1,6});
set(handles.b7,'cdata',bs1{1,7});
set(handles.b8,'cdata',bs1{1,8});
set(handles.b9,'cdata',bs1{1,9});
set(handles.b10,'cdata',bs1{1,10});
set(handles.b11,'cdata',bs1{1,11});
set(handles.b12,'cdata',bs1{1,12});
set(handles.p1,'cdata',bs2{1,1});
set(handles.p2,'cdata',bs2{1,2});
set(handles.p3,'cdata',bs2{1,3});
set(handles.p4,'cdata',bs2{1,4});
set(handles.p5,'cdata',bs2{1,5});
set(handles.p6,'cdata',bs2{1,6});
set(handles.p7,'cdata',bs2{1,7});
set(handles.p8,'cdata',bs2{1,8});
set(handles.p9,'cdata',bs2{1,9});
set(handles.p10,'cdata',bs2{1,10});
set(handles.p11,'cdata',bs2{1,11});
set(handles.p12,'cdata',bs2{1,12});
set(handles.massedit,'cdata',bs2{1,13});

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jFrame=get(hObject,'javaframe');  
jicon=javax.swing.ImageIcon([pwd '/icon.png']);
jFrame.setFigureIcon(jicon);
% Choose default command line output for PhotoEdit
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = PhotoEdit_OutputFcn(hObject, eventdata, handles) 
global ah
ah2 = axes('unit', 'normalized', 'position', [0 0 1 1]); 
m= imread('Textures/media.png'); h=imagesc(m);
set(ah2,'handlevisibility','off','visible','off')
uistack(ah2, 'top');
tic
x=toc;
while toc<=1
	set(h,'AlphaData',toc)
    pause(toc-x)
    x=toc;
end
pause(2)
delete(ah)
delete(ah2)
showstuff(handles);
% Get default command line output from handles structure
varargout{1} = handles.output;

%open
function b1_Callback(hObject, eventdata, handles)
global pic pics data r s options
[FileName,PathName,FilterIndex] = uigetfile({'*.jpg;*.png' 'Image(*.png,*.jpg)'},'Select File(s)','MultiSelect','on',options{4}{2});
r=size(pics,2);
if iscell(FileName)
    for i=1:size(FileName,2)
        r=r+1;
        pics{r}{1}=imread([PathName,FileName{i}]);
        data{r}={PathName FileName{i} 1 0};
    end
elseif ischar(FileName)
    r=r+1;
    pics{r}{1}=imread([PathName,FileName]);
    data{r}={PathName FileName 1 0};    
else
    return
end
s=1;
pic=pics{r}{1};
showpic(pic,handles);
%close
function b2_Callback(hObject, eventdata, handles)
global pic pics data r s 
if size(pics,2)<=1
    b3_Callback(hObject, eventdata, handles)
else
    if data{r}{4}
        check=questdlg(['Save changes to ' data{r}{2} ' ?'],'Close prompt','Yes','No','Cancel','Cancel');
        switch check
            case 'Yes'
                imwrite(pics{r}{s},[data{r}{1},data{r}{2}])
                data{r}{4}=0;
            case 'Cancel'
                return
            case ''
                return
        end
    end
	pics{r}=[];
    data{r}=[];
	emptyCells = cellfun(@isempty,data);
    pics(emptyCells) = [];
	data(emptyCells) = [];
    if r==size(pics,2)+1
        r=r-1;
    end
    s=data{r}{3};
	pic=pics{r}{s};
    showpic(pic,handles);        
end
%close all
function b3_Callback(hObject, eventdata, handles)
global pic pics data r s 
for i=1:length(pics)
    if data{i}{4}
        check=questdlg(['Save changes to ' data{i}{2} ' ?'],'Close prompt','Yes','No','Cancel','Cancel');
        switch check
            case 'Yes'
                imwrite(pics{i}{s},[data{i}{1},data{i}{2}])
                data{i}{4}=0;
            case 'Cancel'
                return
            case ''
                return
        end
    end
end
pics={};data={};r=0;s=0;pic=[];
showpic(pic,handles);
%save
function b4_Callback(hObject, eventdata, handles)
global pics data r s
if r~=0 
imwrite(pics{r}{s},[data{r}{1},data{r}{2}])
data{r}{4}=0;
set(handles.text1,'string',data{r}{2});
end
%save as
function b5_Callback(hObject, eventdata, handles)
global pics data r s options
if r ~=0 
[FileName,PathName,FilterIndex] = uiputfile({'*.jpg','image(*.jpg)';'*.png','image(*.png)';},'Save as',options{4}{2});
if ischar(FileName)
imwrite(pics{r}{s},[PathName,FileName])
data{r}{4}=0;
set(handles.text1,'string',data{r}{2});
end
end
%save all
function b6_Callback(hObject, eventdata, handles)
global pics data r
if r==0
    return
end
for i=1:size(pics,2)
    s=data{i}{3};
    imwrite(pics{i}{s},[data{i}{1},data{i}{2}])
    data{i}{4}=0;
end
set(handles.text1,'string',data{r}{2});
%undo
function b7_Callback(hObject, eventdata, handles)
global pic pics data r s 
if s>1
	s=s-1;data{r}{3}=s;
    pic=pics{r}{s}; 
    data{r}{4}=1;       
end
if get(handles.massedit,'Value')==1
    for i=1:size(pics,2)
        if data{i}{3}~=1 && i~=r
            data{i}{3}=data{i}{3}-1;
            data{i}{4}=1;
        end
    end
end
showpic(pic,handles);
%redo
function b8_Callback(hObject, eventdata, handles)
global pic pics data r s 
if r==0 
    return
end
if s~=size(pics{r},2)
	s=s+1;data{r}{3}=s;
    pic=pics{r}{s}; 
    data{r}{4}=1;       
end
if get(handles.massedit,'Value')==1
    for i=1:size(pics,2)
        if data{i}{3}~=size(pics{i},2) && i~=r
            data{i}{3}=data{i}{3}+1;
            data{i}{4}=1;
        end
    end
end
showpic(pic,handles);
%previous
function b9_Callback(hObject, eventdata, handles)
global pic pics data r s
if r<=1
    return
end
r=r-1;s=data{r}{3};
pic=pics{r}{s};
showpic(pic,handles);
%next
function b10_Callback(hObject, eventdata, handles)
global pic pics data r s
if r==size(pics,2) || r==0
    return
end
r=r+1;s=data{r}{3};
pic=pics{r}{s};
showpic(pic,handles);
%Settings
function b11_Callback(hObject, eventdata, handles)
ishandle(Preferences);
%Help
function b12_Callback(hObject, eventdata, handles) 
ishandle(Help);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%flip H
function p1_Callback(hObject, eventdata, handles)
global pic pics data r s 
if r==0 
    return
end
if get(handles.massedit,'Value')==0
    out=pic(:,end:-1:1,:);
    editpic(out,handles);
else
for i=1:size(pics,2)
    j=data{i}{3};
    in=pics{i}{j};
    out=in(:,end:-1:1,:);
    masseditpic(out,i,j);
end
s=s+1;
pic=pics{r}{s};
showpic(pic,handles);
end
hideall(handles);
%flip V
function p2_Callback(hObject, eventdata, handles)
global pic pics data r s
if r==0 
    return
end
if get(handles.massedit,'Value')==0
out=pic(end:-1:1,:,:);
editpic(out,handles);
else
for i=1:size(pics,2)
    j=data{i}{3};
    in=pics{i}{j};
    out=in(end:-1:1,:,:);
    masseditpic(out,i,j);
end
s=s+1;
pic=pics{r}{s};
showpic(pic,handles);
end
hideall(handles);
%resize
function p3_Callback(hObject, eventdata, handles)
        global pic r
        if r==0 
            return
        end
        showpic(pic,handles);
        hideall(handles);
        set(handles.text4,'visible','on','string','Width')
        set(handles.text5,'visible','on','string','Height')
        set(handles.edit1,'visible','on','string','')
        set(handles.edit2,'visible','on','string','')
        set(handles.checkbox1,'visible','on')
        set(handles.panel1,'visible','on')
        set(handles.apply,'visible','on')
        uicontrol(handles.edit1);
%crop
function p4_Callback(hObject, eventdata, handles)
    global pic r rect 
    if r==0 
        return
    end
    rect=[0 0 0 0 0 0];
    showpic(pic,handles);
    hideall(handles);
	set(handles.text4,'visible','on','string','Top')
    set(handles.text5,'visible','on','string','Bottom')
	set(handles.text6,'visible','on','string','Left')
    set(handles.text7,'visible','on','string','Right')
    set(handles.text8,'visible','on','string',get(handles.text2,'string'))
	set(handles.edit1,'visible','on','string','0')
    set(handles.edit2,'visible','on','string','0')
	set(handles.edit3,'visible','on','string','0')
    set(handles.edit4,'visible','on','string','0')        
	set(handles.apply,'visible','on')

    uicontrol(handles.edit1);
%rotate 90 cw
function p5_Callback(hObject, eventdata, handles)
    global r
    if r==0 
        return
    end
    rot(handles,affine2d([0 -1 0; 1 0 0; 0 0 1]))
    hideall(handles)
%rotate 90 acw
function p6_Callback(hObject, eventdata, handles)
    global r
    if r==0 
        return
    end
    rot(handles,affine2d([0 1 0; -1 0 0; 0 0 1]))
    hideall(handles)
%rotate 180
function p7_Callback(hObject, eventdata, handles)
    global r
    if r==0 
        return
    end
    rot(handles,affine2d([-1 0 0; 0 -1 0; 0 0 1]))
    hideall(handles)
%rotate 
function p8_Callback(hObject, eventdata, handles)
        global pic r
        if r==0 
            return
        end
        showpic(pic,handles);
        hideall(handles);
        set(handles.text4,'visible','on','string','Rotation angle')
        set(handles.edit1,'visible','on','string','')
        set(handles.apply,'visible','on')
        uicontrol(handles.edit1);
%shear H
function p9_Callback(hObject, eventdata, handles)
        global pic r
        if r==0 
            return
        end
        showpic(pic,handles);
        hideall(handles);
        set(handles.text4,'visible','on','string','Shear angle')
        set(handles.edit1,'visible','on','string','')
        set(handles.apply,'visible','on') 
        uicontrol(handles.edit1);
%shear V
function p10_Callback(hObject, eventdata, handles)
        global pic r
        if r==0 
            return
        end
        showpic(pic,handles);
        hideall(handles);
        set(handles.text4,'visible','on','string',' Shear angle ')
        set(handles.edit1,'visible','on','string','')
        set(handles.apply,'visible','on') 
        uicontrol(handles.edit1);
%brightness and contrast
function p11_Callback(hObject, eventdata, handles)
        global pic r
        if r==0 
            return
        end
        showpic(pic,handles);
        hideall(handles);
        set(handles.text4,'visible','on','string','Brightness')
        set(handles.text6,'visible','on','string','Contrast')
        set(handles.edit1,'visible','on','string','0')
        set(handles.edit3,'visible','on','string','0')
        set(handles.slider1,'visible','on','value',0.5)
        set(handles.slider2,'visible','on','value',0.5)        
        set(handles.apply,'visible','on') 
        uicontrol(handles.edit1);
%invert
function p12_Callback(hObject, eventdata, handles)
global pic pics data r s
if r==0 
	return
end
if get(handles.massedit,'Value')==0
out=256-pic;
editpic(out,handles);
else
for i=1:size(pics,2)
    j=data{i}{3};
    in=pics{i}{j};
    out=256-in;
    masseditpic(out,i,j);
end
s=s+1;
pic=pics{r}{s};
showpic(pic,handles);
end
hideall(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% --- Executes on button press in massedit.
function massedit_Callback(hObject, eventdata, handles)
    if get(handles.massedit,'value')
        set(handles.menu2_10_1,'enable','off')
        set(handles.menu2_10_2,'enable','on')
    else 
        set(handles.menu2_10_1,'enable','on')
        set(handles.menu2_10_2,'enable','off')        
    end        

function apply_Callback(hObject, eventdata, handles)
global pic pics data r s view rect options
if r==0 
	return
end
switch get(handles.text4,'string')
    case 'Width'
        w=str2double(get(handles.edit1,'string')); 
        h=str2double(get(handles.edit2,'string'));
        if ~isempty(w) && ~isempty(h)
            if get(handles.massedit,'value')==0
                pic=res(handles,pic,w,h);
                editpic(pic,handles);
            else
                for i=1:size(pics,2)
                    j=data{i}{3};
                    in=pics{i}{j};
                    out=res(handles,in,w,h);
                    masseditpic(out,i,j);
                end
                s=s+1;
                pic=pics{r}{s};
                showpic(pic,handles);                
            end
        end
        if get(handles.radiobutton2,'value')==1
            set(handles.edit1,'string','100'); 
            set(handles.edit2,'string','100'); 
        else 
            set(handles.edit1,'string',size(pic,2)); 
            set(handles.edit2,'string',size(pic,1)); 
        end
    case 'Top'
        if get(handles.massedit,'value')==0;
            if rect(5)>=size(pic,1) || rect(6)>=size(pic,2)
                return
            end
            out=pic(rect(1)+1:size(pic,1)-rect(2),rect(3)+1:size(pic,2)-rect(4),:);
            editpic(out,handles);
        else
            fit=['Cropping dimensions didn''t fit for some images' char(10)];
            for i=1:size(pics,2)
                j=data{i}{3};
                in=pics{i}{j};
                if rect(5)<size(in,1) && rect(6)<size(in,2)
                    out=in(rect(1)+1:size(in,1)-rect(2),rect(3)+1:size(in,2)-rect(4),:);
                    masseditpic(out,i,j);
                else
                    fit=[fit char(10) '     ' data{i}{2}];
                end
            end
            s=data{r}{3};
            pic=pics{r}{s};
            showpic(pic,handles)
            if ~strcmp(fit,['Cropping dimensions didn''t fit for some images' char(10)]);
                msgbox(fit,'Error')
            end
        end
        rect=[0 0 0 0];
        set(handles.edit1,'string','0')
        set(handles.edit2,'string','0')
        set(handles.edit3,'string','0')
        set(handles.edit4,'string','0') 
        set(handles.text8,'string',get(handles.text2,'string'))
    case 'Rotation angle'
        R=str2double(get(handles.edit1,'string'));
        if  ~isempty(R) 
            th=deg2rad(-R);
            angle=affine2d([cos(th) -sin(th) 0;sin(th) cos(th) 0; 0 0 1]);
            rot(handles,angle)
        end       
        set(handles.edit1,'string',''); 
    case 'Shear angle'
        S=str2double(get(handles.edit1,'string'));
        if  ~isempty(S) && S>-90 && S<90   
            if get(handles.massedit,'Value')==0
                editpic(view,handles)
            else 
                T = affine2d([1 0 0;-tan(deg2rad(S)) 1 0; 0 0 1]);
                for i=1:size(pics,2)
                    j=data{i}{3};
                    in=pics{i}{j};
                    out= imwarp(in,T,'FillValues',[255 255 255]*options{3});
                    masseditpic(out,i,j);
                end
                s=s+1;
                pic=pics{r}{s};
                showpic(pic,handles);
            end
        end
        set(handles.edit1,'string',''); 
    case ' Shear angle '
        S=str2double(get(handles.edit1,'string'));
        if  ~isempty(S) && S>-90 && S<90   
            if get(handles.massedit,'Value')==0
                editpic(view,handles)
            else 
                T = affine2d([1 -tan(deg2rad(S)) 0; 0 1 0; 0 0 1] );
                for i=1:size(pics,2)
                    j=data{i}{3};
                    in=pics{i}{j};
                    out= imwarp(in,T,'FillValues',[255 255 255]*options{3});
                    masseditpic(out,i,j);
                end
                s=s+1;
                pic=pics{r}{s};
                showpic(pic,handles);
            end
        end
        set(handles.edit1,'string','');         
    case 'Brightness'
        editpic(view,handles)
        set(handles.edit1,'string','0')
        set(handles.edit3,'string','0')
        set(handles.slider1,'value',0.5)
        set(handles.slider2,'value',0.5)  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit1_Callback(hObject, eventdata, handles)
global pic view rect options
switch get(handles.text4,'string')
    case 'Width';
        w=str2double(get(handles.edit1,'string'));
        if get(handles.checkbox1,'value')==1 && ~isempty(w) && w>0
           set(handles.edit2,'string',num2str(floor(w*size(pic,1)/size(pic,2)))) 
        end
            

    case 'Top';
        if str2double(get(handles.edit1,'string'))<0
            set(handles.edit1,'string','0');
        end
        rect(1)=str2double(get(handles.edit1,'string'));
        showrect(handles)       
    case 'Rotation angle';
        R=str2double(get(handles.edit1,'string'));
        if  ~isempty(R) 
            th=deg2rad(-R);
            angle=affine2d([cos(th) -sin(th) 0;sin(th) cos(th) 0; 0 0 1]);
           view=imwarp(pic,angle,'FillValues',[255 255 255]*options{3});
           showpic(view,handles)
        end   
    case 'Shear angle';
        S=str2double(get(handles.edit1,'string'));
        if  ~isempty(S) && S>-90 && S<90
            T = affine2d([1 0 0;-tan(deg2rad(S)) 1 0; 0 0 1] );
            view = imwarp(pic,T,'FillValues',[255 255 255]*options{3});
            showpic(view,handles)
        end
    case ' Shear angle ';
        S=str2double(get(handles.edit1,'string'));
        if  ~isempty(S) && S>-90 && S<90
            T = affine2d([1 -tan(deg2rad(S)) 0;0 1 0; 0 0 1] );
            view = imwarp(pic,T,'FillValues',[255 255 255]*options{3});
            showpic(view,handles)
        end
	case 'Brightness';
        b=str2double(get(handles.edit1,'string'));
        if  ~isempty(b) 
            if b<-50
                b=-50;
            elseif b>50
                b=50;
            end
            set(handles.slider1,'value',(b+50)/100);
            BaC(handles);
        end           
end
function edit2_Callback(hObject, eventdata, handles)
global pic rect
switch get(handles.text4,'string')
    case 'Width';
        h=str2double(get(handles.edit2,'string'));
        if get(handles.checkbox1,'value')==1 && ~isempty(h) && h>0
           set(handles.edit1,'string',num2str(floor(h*size(pic,2)/size(pic,1))))
        end
    case 'Top';
        if str2double(get(handles.edit2,'string'))<0
            set(handles.edit2,'string','0');
        end
        rect(2)=str2double(get(handles.edit2,'string'));       
        showrect(handles)
end
function edit3_Callback(hObject, eventdata, handles)
global rect
switch get(handles.text4,'string')
    case 'Top'
        if str2double(get(handles.edit3,'string'))<0
            set(handles.edit3,'string','0');
        end
        rect(3)=str2double(get(handles.edit3,'string'));       
        showrect(handles)
    case 'Brightness'
        b=str2double(get(handles.edit3,'string'));
        if  ~isempty(b) 
            if b<-50
                b=-50;
            elseif b>50
                b=50;
            end
            set(handles.slider2,'value',(b+50)/100);
            BaC(handles);
        end 
end
function edit4_Callback(hObject, eventdata, handles)
        global rect
        if str2double(get(handles.edit4,'string'))<0
            set(handles.edit4,'string','0');
        end
        rect(4)=str2double(get(handles.edit4,'string'));       
        showrect(handles)

% --- Executes on button press in radiobutton2.
function radiobutton1_Callback(hObject, eventdata, handles)
    global pic
    x=1
    if size(pic)
        set(handles.edit1,'visible','on','string',size(pic,1))
        set(handles.edit2,'visible','on','string',size(pic,2))
    end
function radiobutton2_Callback(hObject, eventdata, handles)
    x=2
    set(handles.edit1,'string','100')
    set(handles.edit2,'string','100')
function checkbox1_Callback(hObject, eventdata, handles)
    global pic
    w=str2double(get(handles.edit1,'string'));
    h=str2double(get(handles.edit1,'string'));
    if ~isempty(w) && w>0
       set(handles.edit2,'string',num2str(floor(w*size(pic,1)/size(pic,2)))) 
    elseif ~isempty(h) && h>0
       set(handles.edit1,'string',num2str(floor(h*size(pic,2)/size(pic,1)))) 
    end
function slider1_Callback(hObject, eventdata, handles)
        b=get(handles.slider1,'value');
        set(handles.edit1,'string',num2str((b-0.5)*100));
        BaC(handles);
function slider2_Callback(hObject, eventdata, handles)
        b=get(handles.slider2,'value');
        set(handles.edit3,'string',b*100-50);
        BaC(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showpic(out,handles)
global pics data r 
if size(out)
    imshow(out,'parent',handles.ax);  
    set(handles.ax,'handlevisibility','off','visible','off')
    if data{r}{4}
        set(handles.text1,'string',['*' data{r}{2}]);
    else
        set(handles.text1,'string',data{r}{2});
    end
    set(handles.text2,'string',[num2str(size(out,1)),'x',num2str(size(out,2))]);
    set(handles.text3,'string',[num2str(r),'/',num2str(size(pics,2))]);
else
    set(handles.text1,'string','');
    set(handles.text2,'string','');
    set(handles.text3,'string','-/-');
    cla(handles.ax);
end

function editpic(out,handles)
global pic pics data r s options
pic=out;
s=s+1;pics{r}{s}=pic;data{r}{3}=s;
if options{2}==1
    imwrite(pic,[data{r}{1} data{r}{2}]);
    data{r}{4}=0;
else
    data{r}{4}=1;
end
showpic(pic,handles)

function showstuff(handles)
set(handles.menu1,'visible','on');
set(handles.menu2,'visible','on');
set(handles.menu3,'visible','on');
set(handles.menu4,'visible','on');    
set(handles.massedit,'visible','on')
set(handles.b1,'visible','on')
set(handles.b2,'visible','on')
set(handles.b3,'visible','on')
set(handles.b4,'visible','on')
set(handles.b5,'visible','on')
set(handles.b6,'visible','on')
set(handles.b7,'visible','on')
set(handles.b8,'visible','on')
set(handles.b9,'visible','on')
set(handles.b10,'visible','on')
set(handles.b11,'visible','on')
set(handles.b12,'visible','on')
set(handles.p1,'visible','on')
set(handles.p2,'visible','on')
set(handles.p3,'visible','on')
set(handles.p4,'visible','on')
set(handles.p5,'visible','on')
set(handles.p6,'visible','on')
set(handles.p7,'visible','on')
set(handles.p8,'visible','on')
set(handles.p9,'visible','on')
set(handles.p10,'visible','on')
set(handles.p11,'visible','on')
set(handles.p12,'visible','on')
set(handles.text1,'visible','on')
set(handles.text2,'visible','on')
set(handles.text3,'visible','on')

function hideall(handles)
        set(handles.text4,'visible','off')
        set(handles.text5,'visible','off')
        set(handles.text6,'visible','off')
        set(handles.text7,'visible','off')        
        set(handles.text8,'visible','off')        
        set(handles.edit1,'visible','off')
        set(handles.edit2,'visible','off')
        set(handles.edit3,'visible','off')
        set(handles.edit4,'visible','off')        
        set(handles.slider1,'visible','off')
        set(handles.slider2,'visible','off')
        set(handles.checkbox1,'visible','off')
        set(handles.panel1,'visible','off')
        set(handles.edit2,'visible','off')        
        set(handles.apply,'visible','off')
        pause(0.001)

function showrect(handles)
    %rect=[top bottom left right height width];
    global pic view rect
    rect(5)=rect(1)+rect(2);
    rect(6)=rect(3)+rect(4);
    r1=size(pic,1)-rect(5);
    c1=size(pic,2)-rect(6);
    if r1>0 && c1>0
            x1=rect(1)+1:size(pic,1)-rect(2);
            x2=rect(3)+1:size(pic,2)-rect(4);
            view=pic-100;
            view(x1,x2,:)=pic(x1,x2,:);
            set(handles.text8,'string',[num2str(r1) 'x' num2str(c1)])
    else
        view=pic;
        set(handles.text8,'string',get(handles.text2,'string'))
    end
    showpic(view,handles)

function BaC(handles)
     global pic view
     b=get(handles.slider1,'value')-0.5;
     c=get(handles.slider2,'value')-0.5;
     view=pic+b/0.5*64;     
      if c>0
        mn2=0;
        mx2=1;
        mn=c*0.2;
        mx=1-mn;
      elseif c<0
        mn=0;
        mx=1;
        mn2=abs(c)*0.2;
        mx2=1-mn;
      end 
      if c~=0    
        view=imadjust(view,[mn ; mx],[mn2; mx2]);
      end
     showpic(view,handles)        

function masseditpic(out,r,s)
global pics data options
s=s+1;pics{r}{s}=out;data{r}{3}=s;
if options{2}==1
    imwrite(pic,[data{r}{1} data{r}{2}]);
    data{r}{4}=0;
else
    data{r}{4}=1;
end

function rot(handles,angle)
global pic pics data r s options
if get(handles.massedit,'Value')==0
    out=imwarp(pic,angle,'FillValues',[255 255 255]*options{3});
    editpic(out,handles);
else
for i=1:size(pics,2)
    j=data{i}{3};
    in=pics{i}{j};
    out=imwarp(in,angle,'FillValues',[255 255 255]*options{3});
    masseditpic(out,i,j);
end
s=s+1;
pic=pics{r}{s};
showpic(pic,handles);
end

function [x]=res(handles,in,w,h)
        if get(handles.radiobutton2,'value')==1
            h=floor(h/100*size(in,1));
            w=floor(w/100*size(in,2));
        end
        if h>9999 || w>9999 || w<0 || h<0
            x=in;
        else
            x=imresize(in,[h w]);
        end    

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)

global reg
mods=eventdata.Modifier;
key=eventdata.Key;
if size(mods,2)==0
        switch key
            case 'leftarrow';
                b9_Callback(hObject, eventdata, handles)
            case 'rightarrow';
                b10_Callback(hObject, eventdata, handles)
        end 
        return   
end
moods=strcat(mods{:});
if     strcmp(moods,reg{1,1}) && strcmp(key,reg{1,2})
        b1_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{2,1}) && strcmp(key,reg{2,2})
        b2_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{3,1}) && strcmp(key,reg{3,2})
        b3_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{4,1}) && strcmp(key,reg{4,2})
        b4_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{5,1}) && strcmp(key,reg{5,2})
        b5_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{6,1}) && strcmp(key,reg{6,2})
        b6_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{7,1}) && strcmp(key,reg{7,2})
        b7_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{8,1}) && strcmp(key,reg{8,2})
        b8_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{9,1}) && strcmp(key,reg{9,2})
        b11_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{10,1}) && strcmp(key,reg{10,2})
        b12_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{11,1}) && strcmp(key,reg{11,2})
        exit
elseif strcmp(moods,reg{12,1}) && strcmp(key,reg{12,2})
        set(handles.massedit,'value',~get(handles.massedit,'value'))
        massedit_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{13,1}) && strcmp(key,reg{1,2})
        p1_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{14,1}) && strcmp(key,reg{14,2})
        p2_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{15,1}) && strcmp(key,reg{15,2})
        p3_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{16,1}) && strcmp(key,reg{16,2})
        p4_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{17,1}) && strcmp(key,reg{17,2})
        p5_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{18,1}) && strcmp(key,reg{18,2})
        p6_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{19,1}) && strcmp(key,reg{19,2})
        p7_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{20,1}) && strcmp(key,reg{20,2})
        p8_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{21,1}) && strcmp(key,reg{21,2})
        p9_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{22,1}) && strcmp(key,reg{22,2})
        p10_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{23,1}) && strcmp(key,reg{23,2})
        p11_Callback(hObject, eventdata, handles)
elseif strcmp(moods,reg{24,1}) && strcmp(key,reg{24,2})
        p12_Callback(hObject, eventdata, handles)
end
% --------------------------------------------------------------------
function menu1_Callback(hObject, eventdata, handles)
function menu2_Callback(hObject, eventdata, handles)
function menu3_Callback(hObject, eventdata, handles)
function menu4_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function menu1_1_Callback(hObject, eventdata, handles)
        b1_Callback(hObject, eventdata, handles)
function menu1_2_Callback(hObject, eventdata, handles)
        b2_Callback(hObject, eventdata, handles)
function menu1_3_Callback(hObject, eventdata, handles)
        b3_Callback(hObject, eventdata, handles)
function menu1_4_Callback(hObject, eventdata, handles)
        b4_Callback(hObject, eventdata, handles)
function menu1_5_Callback(hObject, eventdata, handles)
        b5_Callback(hObject, eventdata, handles)
function menu1_6_Callback(hObject, eventdata, handles)
        b6_Callback(hObject, eventdata, handles)
function menu1_7_Callback(hObject, eventdata, handles)
exit
% --------------------------------------------------------------------
function menu2_1_Callback(hObject, eventdata, handles)
        b7_Callback(hObject, eventdata, handles)
function menu2_2_Callback(hObject, eventdata, handles)
        b8_Callback(hObject, eventdata, handles)
function menu2_3_Callback(hObject, eventdata, handles)
function menu2_4_Callback(hObject, eventdata, handles)
function menu2_5_Callback(hObject, eventdata, handles)
        p3_Callback(hObject, eventdata, handles)
function menu2_6_Callback(hObject, eventdata, handles)
        p4_Callback(hObject, eventdata, handles)
function menu2_7_Callback(hObject, eventdata, handles)
function menu2_8_Callback(hObject, eventdata, handles)
        p11_Callback(hObject, eventdata, handles)
function menu2_9_Callback(hObject, eventdata, handles)
        p12_Callback(hObject, eventdata, handles)
function menu2_10_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function menu2_3_1_Callback(hObject, eventdata, handles)
        p1_Callback(hObject, eventdata, handles)
function menu2_3_2_Callback(hObject, eventdata, handles)
        p2_Callback(hObject, eventdata, handles)
function menu2_4_1_Callback(hObject, eventdata, handles)
        p5_Callback(hObject, eventdata, handles)
function menu2_4_2_Callback(hObject, eventdata, handles)
        p6_Callback(hObject, eventdata, handles)
function menu2_4_3_Callback(hObject, eventdata, handles)
        p7_Callback(hObject, eventdata, handles)
function menu2_4_4_Callback(hObject, eventdata, handles)
        p8_Callback(hObject, eventdata, handles)
function menu2_7_1_Callback(hObject, eventdata, handles)
        p9_Callback(hObject, eventdata, handles)
function menu2_7_2_Callback(hObject, eventdata, handles)
        p10_Callback(hObject, eventdata, handles)
function menu2_10_1_Callback(hObject, eventdata, handles)
        set(handles.massedit,'value',1)
        set(handles.menu2_10_1,'enable','off')
        set(handles.menu2_10_2,'enable','on')
function menu2_10_2_Callback(hObject, eventdata, handles)
        set(handles.massedit,'value',0)
        set(handles.menu2_10_1,'enable','on')
        set(handles.menu2_10_2,'enable','off')
% --------------------------------------------------------------------
function menu3_1_Callback(hObject, eventdata, handles)
    ishandle(Preferences);
function menu3_2_Callback(hObject, eventdata, handles)
    ishandle(Shortcuts);
% --------------------------------------------------------------------
function menu4_1_Callback(hObject, eventdata, handles)
    ishandle(Help);
function menu4_2_Callback(hObject, eventdata, handles)
    msgbox('This Software is developed by M.E.Helaly','Credits');
function menu4_3_Callback(hObject, eventdata, handles)
    web('https://github.com/EhabHelaly','-browser')
% --------------------------------------------------------------------


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
global pic pics data r s options the_path
for i=1:length(pics)
    if data{i}{4}
        check=questdlg(['Save changes to ' data{i}{2} ' ?'],'Exit Dialog','Yes','No','Cancel','Cancel');
        switch check
            case 'Yes'
                imwrite(pics{i}{s},[data{i}{1},data{i}{2}])
                data{i}{4}=0;
            case 'Cancel'
                return
            case ''
                return
        end
    end
end
if options{1}==0
    pics={};data={};r=0;s=0;pic=[];
end
if ~exist(the_path, 'dir')
    mkdir(the_path)
end
save ([the_path 'WorkSpace.mat'] ,'pic' ,'data', 'pics' ,'r' ,'s')
%delete(hObject);
exit
