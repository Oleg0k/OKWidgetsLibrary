unit uOKWidgetsLibrary;

interface

uses System.Classes, VCL.StdCtrls, System.Generics.Collections, System.SysUtils;

type

  TOKWidgetContainer = class;

  TOKBaseClass = class(TComponent)
  private
    class var fCounter: UInt32;
    class var Instances: TObjectList<TComponent>;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;


  TOKWidget = class(TOKBaseClass)
  private
    FParent : TOKWidgetContainer;
    fCaption: ShortString;
    function GetCaption: ShortString;
    procedure SetCaption(const Val: ShortString);
  protected

    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;

    procedure SetParent(AParent: TOKWidgetContainer); virtual;

    procedure Click; virtual;
    procedure DblClick; virtual;
    procedure DoEnter; virtual;
    procedure DoExit; virtual;
  public
    property Caption: ShortString read GetCaption write SetCaption;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;

    property Parent: TOKWidgetContainer read FParent write SetParent;

//    constructor Create(AOwner: TComponent); override;
//    destructor Destroy; override;

  end;

  TOKWidgetContainer = class(TOKWidget)
  private
    fWidgets :TObjectList<TOKWidget>;
//    fWidgets: TList;
  protected
    procedure RemoveWidget(aWidget: TOKWidget);
    procedure InsertWidget(aWidget: TOKWidget);
    function GetWidget(Index: Integer): TOKWidget;

    property Widgets[Index: Integer]: TOKWidget read GetWidget;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TOKWidgetGroupBox = class(TOKWidgetContainer)
  public
    property Widgets;
  published
    property Parent;
  end;

  TOKWidgetPanel = class(TOKWidgetContainer)
  public
    property Widgets;
  published
    property Parent;
  end;

  TOKWidgetFrame = class(TOKWidgetContainer)
  public
    property Widgets;
  published
    property Parent;
  end;


  TOKWidgetButton = class(TOKWidget)

  published
    property Parent;
    property Caption;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
  end;

  TOKWidgetLabel = class(TOKWidget)

  published
    property Parent;
    property Caption;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
  end;

  TOKWidgetImage = class(TOKWidget)

  published
    property Parent;
    property Caption;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;

  end;

  TOKWidgetEdit = class(TOKWidget)

  published
    property Parent;
    property Caption;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
  end;

// Button, Label, Image, Edit


{  TOKFactoryWidgets = class
  private
      ListInstances: TObjectList<TComponent>;
  public
    Add
    Remove
    FindByHash
  end;} // Prototype



procedure InitializeWidgetsLibrary(Var aList :TObjectList<TComponent> ; var memo: TMemo); stdcall;

exports
   InitializeWidgetsLibrary;

var GlobalMemoAsConsole: TMemo = nil;

implementation

procedure Log(s: ShortString);
begin
  if Assigned(GlobalMemoAsConsole) then
    GlobalMemoAsConsole.Lines.Add(s)
  else
    writeln(s)
end;

procedure InitializeWidgetsLibrary(Var aList :TObjectList<TComponent> ; var memo: TMemo);
begin
  GlobalMemoAsConsole := memo;
  TOKBaseClass.Instances := TObjectList<TComponent>.Create(True);
  aList := TOKBaseClass.Instances;
  Log('Initialized')
end;


procedure ListAdd(var List: TList; Item: Pointer);
begin
  if List = nil then
    List := TList.Create;
  List.Add(Item);
end;


procedure ListRemove(var List: TList; Item: Pointer);
var
  Count: Integer;
begin
  Count := List.Count;
  if Count > 0 then
  begin
    if List[Count - 1] = Item then
      List.Delete(Count - 1)
    else
      List.Remove(Item);
  end;
  if List.Count = 0 then
  begin
    List.Free;
    List := nil;
  end;
end;



constructor TOKWidgetContainer.Create(AOwner: TComponent);
begin
  inherited;
  fWidgets := TObjectList<TOKWidget>.Create(True)

end;


destructor TOKWidgetContainer.Destroy;
var i: word;
begin
  Log('TOKWidgetContainer.Destroy');
  if Assigned(fWidgets) then
  begin
    if fWidgets.Count > 0 then
    begin
      for i := 0 to fWidgets.Count-1 do
          TOKBaseClass.Instances.Remove( fWidgets[i] );

    end;
    FreeAndNil(fWidgets);
  end;
  inherited
end;


function TOKWidgetContainer.GetWidget(Index: Integer): TOKWidget;
var
  N: Integer;
begin
  if fWidgets <> nil then
    N := fWidgets.Count
  else
    N := 0;
  if Index < N then
    Result := TOKWidget(fWidgets[Index]) else
  Result := nil

end;


constructor TOKBaseClass.Create;
begin
  inherited Create(nil);
  Inc(fCounter);
  (Self as TComponent).Tag := fCounter;
  Log('Create: '+Self.ClassName + '.' + IntToStr(Self.Tag))
end;

destructor TOKBaseClass.Destroy;
begin
  Log('Destroy: '+Self.ClassName+ '.' + IntToStr(Self.Tag));
  Dec(fCounter);
  inherited;
end;


procedure TOKWidgetContainer.RemoveWidget(aWidget: TOKWidget);
begin
//  ListRemove(fWidgets, aWidget);
  fWidgets.Remove(aWidget);
end;

procedure TOKWidgetContainer.InsertWidget(aWidget: TOKWidget);
begin
//  ListAdd(fWidgets, aWidget);
  fWidgets.Add(aWidget);
end;

procedure TOKWidget.SetParent(AParent: TOKWidgetContainer);
begin
  if FParent <> AParent then
  begin
//    if AParent = Self then
//      raise EInvalidOperation;

    if FParent <> nil then
      FParent.RemoveWidget(Self);
    if AParent <> nil then
      AParent.InsertWidget(Self);

    FParent := AParent
  end;
end;

function TOKWidget.GetCaption: ShortString;
begin
  Result := fCaption;
end;

procedure TOKWidget.SetCaption(const Val: ShortString);
begin
  fCaption := Val;
end;


procedure TOKWidget.DoEnter;
begin
  if Assigned(FOnEnter) then FOnEnter(Self);
end;

procedure TOKWidget.DoExit;
begin
  if Assigned(FOnExit) then FOnExit(Self);
end;


procedure TOKWidget.Click;
begin
  if Assigned(FOnClick) then FOnClick(Self);
end;

procedure TOKWidget.DblClick;
begin
  if Assigned(FOnDblClick) then FOnDblClick(Self);
end;


initialization
//   InitializeWidgetsLibrary;
  RegisterClasses([TOKWidget, TOKWidgetButton, TOKWidgetLabel, TOKWidgetImage, TOKWidgetEdit, TOKWidgetGroupBox, TOKWidgetPanel, TOKWidgetFrame]);
  TOKBaseClass.fCounter := 0;

finalization
  UnregisterClasses([TOKWidget, TOKWidgetButton, TOKWidgetLabel, TOKWidgetImage, TOKWidgetEdit, TOKWidgetGroupBox, TOKWidgetPanel, TOKWidgetFrame]);
  FreeAndNil( TOKBaseClass.Instances)
end.


