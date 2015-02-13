{
  Author : Ersan YAKIT
           ersanyakit@yahoo.com.tr
           www.ersanyakit.com
}

unit uMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Memo,
  FMX.Radio;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    TrackBar1: TTrackBar;
    CheckBox1: TCheckBox;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Tracking(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Change(Sender: TObject);
  private
    { Private declarations }
      FRadyo : TFMXRadio;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure AddLog(pszData : string);
begin
  Form1.Memo1.Lines.Add(pszData);
end;

procedure StatusProc(pszData : string;Progress:Integer);
begin
  //AddLog(Format('FUNC:%s:%s:%d',['StatusProc',pszData,Progress]));
  Form1.Label1.Text := Format('%s: %s',['Status:', pszData]);
  Form1.ProgressBar1.Value := Round(Progress);
end;

procedure BroadcastInfoProc(pszBroadcastName,pszBitRate:string);
begin
  AddLog(Format('FUNC:%s:BROADCAST=%s:BITRATE=%s',['BroadcastInfoProc',pszBroadcastName,pszBitRate]));
end;

procedure BroadcastMetaProc(pszData : string);
begin
  AddLog(Format('FUNC:%s:%s',['BroadcastMetaProc',pszData]));
end;

procedure TForm1.Button1Click(Sender: TObject);
Begin
  FRadyo.SetStatusProc(StatusProc);
  FRadyo.SetBroadcastInfoProc(BroadcastInfoProc);
  FRadyo.SetBroadcastMetaProc(BroadcastMetaProc);
  FRadyo.SetStreamURL('http://46.20.3.201:80/listen.pls');

  if FRadyo.Play=True
    then begin
            AddLog('Radio Has Been Started Successfuly');
         end
    else
         begin
            AddLog('Radio Cannot Be Started!');
         end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Assigned(FRadyo)
    then begin
            FRadyo.Pause;
         end;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if Assigned(FRadyo)
    then begin
            FRadyo.PauseRadioOnIncomingCalls(TCheckBox(Sender).IsChecked);
         end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FRadyo)
    then begin
           FRadyo.Destroy;
         end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FRadyo := TFMXRadio.Create;
  FRadyo.SetOwner(Self);
  {$IFDEF ANDROID}
      TrackBar1.Min := 0;
      TrackBar1.Max := 1;
      TrackBar1.Value := 0.5;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
      TrackBar1.Min := 0;
      TrackBar1.Max := 100;
      TrackBar1.Value := 50;
  {$ENDIF}

end;

procedure TForm1.TrackBar1Tracking(Sender: TObject);
begin
    if Assigned(FRadyo)
      then begin
              FRadyo.SetVolume(TTrackBar(Sender).Value);
           end;
end;

end.
