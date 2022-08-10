unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages,  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.RTTI, System.TypInfo,
  System.Generics.Collections, Vcl.ExtCtrls, Vcl.Samples.Spin, Vcl.CheckLst, System.Types;

type
  TfrmMain = class(TForm)
    btnInitLib: TButton;
    mLog: TMemo;
    cbOutput2Console: TCheckBox;
    panelButtons: TPanel;
    cboxWidgets: TComboBox;
    SpinEdit1: TSpinEdit;
    Button4: TButton;
    btnCreateInstanceInGroup: TButton;
    Button1: TButton;
    btnSetClick: TButton;
    btnDestroy: TButton;
    btnCreateInstance: TButton;
    listboxWidgets: TCheckListBox;
    btnGetState: TButton;
    Label1: TLabel;
    Button2: TButton;
    procedure btnInitLibClick(Sender: TObject);
    procedure btnCreateInstanceClick(Sender: TObject);
    procedure btnDestroyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSetClickClick(Sender: TObject);
    procedure btnGetStateClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    procedure ClassProc(AClass: TPersistentClass);
    procedure GetRegisteredClasses;
    procedure RefreshListBox;
  public
    { Public declarations }
  end;

  TClassOfComponent = class of TComponent;

var
  frmMain: TfrmMain;

implementation

const cWidgetLibraryName = 'OKWidgetsLibrary.bpl';

{$R *.dfm}


var
    GlobalListInstances: TObjectList<TComponent>;


procedure Log(s: ShortString);
begin
  if Not frmMain.cbOutput2Console.Checked then
    frmMain.mLog.Lines.Add(s)
  else
    writeln(s)
end;


procedure InvokeOnClickEvent(widget: TComponent);
var
  context: TRttiContext;
  method: TValue; // System.TMethod
  methodType: TRttiInvokableType;

begin
//  Log('ClassName: ' + widget.ClassName);
  { Get the value of the OnChange property, which is a method pointer }
  method := context.GetType(widget.ClassType).GetProperty('OnClick').GetValue(widget);


  { Get event RTTI }
  methodType := context.GetType(method.TypeInfo) as TRttiInvokableType;
//  Log(methodType.Name);

  { Invoke event }
  { The first parameter must be the procedure/method pointer in a TValue variable }
  if Not method.IsEmpty then
    methodType.Invoke(method, [widget] );
end;



procedure InitializeOKWidgetsLibrary(var m: TMemo);
var
   PackageModule: HModule;
   proc : procedure(var List:TObjectList<TComponent>; var m: TMemo); stdcall;

begin
  PackageModule := LoadPackage( ExtractFilePath( Paramstr(0) ) + cWidgetLibraryName );
  if PackageModule <> 0 then
  begin
    @Proc := Winapi.Windows.GetProcAddress ( PackageModule, 'InitializeWidgetsLibrary' );

    if @Proc <> nil then
      Proc(GlobalListInstances, m);

//     GlobalListInstances := TObjectList<TComponent>.Create();
//     GlobalListInstances.OwnsObjects := True;

  end
  else
    raise Exception.Create('Error Message');
//    writeln('fail to load module')
end;


procedure TfrmMain.ClassProc(AClass: TPersistentClass);
begin
//if AClass is TForm then ComboBox1 .Add(AClass);
  if FindClassHInstance(AClass) = GetModuleHandle(cWidgetLibraryName) then
    cboxWidgets.Items.Add(AClass.ClassName)
end;


procedure TfrmMain.GetRegisteredClasses;
var cf: TClassFinder;
begin
  cf := TClassFinder.Create();
  cf.GetClasses(ClassProc);
  cf.Free;
end;



procedure TfrmMain.btnInitLibClick(Sender: TObject);
var memo: TMemo;
begin
  memo := nil;
  if cbOutput2Console.Checked then
    AllocConsole
  else
    memo := mLog;

  InitializeOKWidgetsLibrary(memo);
  GetRegisteredClasses;
  btnInitLib.Enabled := False;
  cbOutput2Console.Enabled := btnInitLib.Enabled;
  panelButtons.Visible := True;
  cboxWidgets.ItemIndex := 0
end;

function MakeMethod( Data, Code: Pointer ): TMethod;
begin
    Result.Data := Data;
    Result.Code := Code;
end;


procedure DoWidgetClick(P:Pointer; Sender:TObject);
begin
  frmMain.mLog.Lines.Add('Click occurred! Tag = ' + IntToStr((Sender as TComponent).Tag))
end;


procedure TfrmMain.btnSetClickClick(Sender: TObject);
var Widget : TComponent;
begin
  Widget := GlobalListInstances.Items[ listboxWidgets.ItemIndex ];

  if Assigned( Widget ) then
  begin
    SetMethodProp(Widget, 'OnClick', (MakeMethod(frmMain, @DoWidgetClick)));
    listboxWidgets.Checked[listboxWidgets.ItemIndex]:=True
//    listboxWidgets.ItemI
  end;

end;

procedure SetControlParent(obj, parent: TObject);
var
  ctx: TRttiContext;
  typ: TRttiType;
  prop: TRttiProperty;
begin
  typ := ctx.GetType(obj.ClassType);
  prop := typ.GetProperty('Parent');
  prop.SetValue(obj, parent);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var i: UInt32;
    Widget : TComponent;
begin
    i :=  GlobalListInstances.IndexOfItem( TComponent( listboxWidgets.Items.Objects[listboxWidgets.ItemIndex  ]), FromBeginning );
    Widget:=GlobalListInstances[i];
    SetControlParent(Widget, nil);
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var i: UInt32;
    Widget, ParentWidget : TComponent;

begin
    i :=  GlobalListInstances.IndexOfItem( TComponent( listboxWidgets.Items.Objects[listboxWidgets.ItemIndex  ]), FromBeginning );
    Widget:=GlobalListInstances[i];
    ParentWidget:= GlobalListInstances[SpinEdit1.Value];
    SetControlParent(Widget, ParentWidget);
end;


procedure TfrmMain.RefreshListBox;
var w :TComponent;
begin
  listboxWidgets.Clear;
  for w in  GlobalListInstances  do
    listboxWidgets.Items.AddObject( w.ClassName + IntToStr(w.Tag), w  );
  listboxWidgets.ItemIndex:=0;

end;


procedure TfrmMain.btnCreateInstanceClick(Sender: TObject);
var  WidgetClass : TClassOfComponent;
     Widget, parentWidget : TComponent;
begin

  WidgetClass := TClassOfComponent( FindClass(cboxWidgets.Text));

//  if Assigned(WidgetClass) then
  Widget := WidgetClass.Create(Self);

  if (Sender as TButton).Tag = 1 then
  begin
    parentWidget:= TComponent( listboxWidgets.Items.Objects[listboxWidgets.ItemIndex  ] ) ;
    SetControlParent(Widget, parentWidget);
  end;


  GlobalListInstances.Add( Widget  );
  listboxWidgets.Items.AddObject( Widget.ClassName + IntToStr(Widget.Tag), Widget  );
  listboxWidgets.ItemIndex:=0;
//  mLog.Lines.Add( Format('Current number of widgets:%d',  [GlobalListInstances.Count]));

end;

procedure TfrmMain.btnDestroyClick(Sender: TObject);
var  WidgetClass : TClassOfComponent;
    i:UInt32;
    D: TDirection;//  = System.Types.TDirection;
begin
  try
    if GlobalListInstances.Count > 0 then
    begin

      i :=  GlobalListInstances.IndexOfItem( TComponent( listboxWidgets.Items.Objects[listboxWidgets.ItemIndex  ]), FromBeginning );
      GlobalListInstances.Delete(i);
  //      listboxWidgets.Items.Objects[listboxWidgets.ItemIndex  ]

  //    ( listboxWidgets.ItemIndex );

      listboxWidgets.DeleteSelected;

    end;
  finally
      RefreshListBox;
  end;


  mLog.Lines.Add( Format('Current number of widgets:%d',  [GlobalListInstances.Count]));
end;


procedure TfrmMain.btnDoClick(Sender: TObject);
begin
  if Assigned(GlobalListInstances[listboxWidgets.ItemIndex]) then
    InvokeOnClickEvent(GlobalListInstances[listboxWidgets.ItemIndex]);


end;

procedure TfrmMain.btnGetStateClick(Sender: TObject);
var i:word;
    obj: TComponent;

begin
  mLog.Lines.Add('Capacity: '+IntToStr(GlobalListInstances.Count));
  if GlobalListInstances.Count=0 then exit;

  for i := 0 to GlobalListInstances.Count-1 do
  if Assigned(GlobalListInstances[i]) then
  begin
    obj:=GlobalListInstances[i] as TComponent;
      mLog.Lines.Add(obj.ToString + '.' + IntToStr(obj.Tag))
  end

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Left := 0;
  Top := 0;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(GlobalListInstances) then
  begin
    GlobalListInstances.Clear;
    GlobalListInstances.Free
  end;
end;

//finalization
//    UnloadPackage(PackageModule);

end.
