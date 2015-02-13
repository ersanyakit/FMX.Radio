{
  Author : Ersan YAKIT
           ersanyakit@yahoo.com.tr
           www.ersanyakit.com
}

program RadioTest;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form1},
  FMX.Radio       in '..\FMXRadio\FMX.Radio.pas',
  FMX.Radio.Bass  in '..\FMXRadio\FMX.Radio.Bass.pas',
  {$IFDEF ANDROID}   FMX.Radio.Android in '..\FMXRadio\FMX.Radio.Android.pas', {$ENDIF}
  {$IFDEF MSWINDOWS} FMX.Radio.Windows in '..\FMXRadio\FMX.Radio.Windows.pas', {$ENDIF}
  FMX.Radio.Shared in '..\FMXRadio\FMX.Radio.Shared.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
