object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 784
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnInitLib: TButton
    Left = 2
    Top = 0
    Width = 100
    Height = 33
    Hint = 'Press me first'
    Caption = 'Init widgets lib'
    TabOrder = 0
    OnClick = btnInitLibClick
  end
  object mLog: TMemo
    Left = 0
    Top = 228
    Width = 796
    Height = 556
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    ExplicitWidth = 838
  end
  object cbOutput2Console: TCheckBox
    Left = 2
    Top = 32
    Width = 100
    Height = 17
    Caption = 'OutputToConsole'
    TabOrder = 2
  end
  object panelButtons: TPanel
    Left = 116
    Top = 0
    Width = 680
    Height = 228
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    Visible = False
    ExplicitWidth = 722
    object Label1: TLabel
      Left = 0
      Top = 1
      Width = 99
      Height = 13
      Caption = 'What will we create?'
    end
    object cboxWidgets: TComboBox
      Left = 0
      Top = 18
      Width = 114
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object SpinEdit1: TSpinEdit
      Left = 276
      Top = 80
      Width = 45
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object Button4: TButton
      Left = 120
      Top = 76
      Width = 150
      Height = 32
      Hint = 'The element is supposed to be of type "TOKWidgetContainer"'
      Caption = 'Attach selected to group '#8470
      TabOrder = 2
      OnClick = Button4Click
    end
    object btnCreateInstanceInGroup: TButton
      Tag = 1
      Left = 120
      Top = 47
      Width = 150
      Height = 32
      Caption = 'Create in group selected'
      TabOrder = 3
      OnClick = btnCreateInstanceClick
    end
    object Button1: TButton
      Left = 360
      Top = 18
      Width = 44
      Height = 32
      Caption = 'Click!'
      TabOrder = 4
      OnClick = btnDoClick
    end
    object btnSetClick: TButton
      Left = 276
      Top = 18
      Width = 81
      Height = 32
      Caption = 'Set Click Event'
      TabOrder = 5
      OnClick = btnSetClickClick
    end
    object btnDestroy: TButton
      Left = 406
      Top = 18
      Width = 69
      Height = 32
      Caption = 'Destroy'
      TabOrder = 6
      OnClick = btnDestroyClick
    end
    object btnCreateInstance: TButton
      Left = 120
      Top = 18
      Width = 150
      Height = 32
      Hint = 'Press me first now'
      Caption = 'Create standalone widget'
      TabOrder = 7
      OnClick = btnCreateInstanceClick
    end
    object listboxWidgets: TCheckListBox
      Left = 482
      Top = 1
      Width = 197
      Height = 226
      Hint = 'Checked means "Click" event is assigned'
      Align = alRight
      ItemHeight = 13
      TabOrder = 8
      ExplicitLeft = 524
    end
    object btnGetState: TButton
      Left = 0
      Top = 194
      Width = 129
      Height = 33
      Caption = 'Get State'
      TabOrder = 9
      OnClick = btnGetStateClick
    end
    object Button2: TButton
      Left = 120
      Top = 108
      Width = 150
      Height = 25
      Caption = 'Detach selected from group'
      TabOrder = 10
      OnClick = Button2Click
    end
  end
end
