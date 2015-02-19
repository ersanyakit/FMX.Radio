{
  Author : Ersan YAKIT
           ersanyakit@yahoo.com.tr
           www.ersanyakit.com
}

unit FMX.Radio;

{$WARNINGS OFF}
{$HINTS OFF}

interface
uses FMX.Radio.Shared,
     FMX.Radio.Bass,
     FMX.Types,
     FMX.Forms;

type
  TFMXCustomRadio = class(TObject)
    procedure InitRadio(iHandle:TWindowHandle);virtual;abstract;
    procedure UnloadRadio;virtual;abstract;
    procedure SetVolume(const AValue:Single);  virtual; abstract;
    function  GetVolume: Single; virtual;abstract;
    function  Play:Boolean;virtual;abstract;
    procedure Pause;virtual;abstract;
    procedure SetStreamURL(AUrl : string);virtual;abstract;

    procedure SetStatusProc(AProc:TStatusProc);virtual;abstract;
    procedure SetBroadcastInfoProc(AProc:TBroadcastInfoProc);virtual;abstract;
    procedure SetBroadcastMetaProc(AProc:TBroadcastMetaProc);virtual;abstract;

    procedure PauseRadioOnIncomingCalls(APauseOnIncomingCalls:Boolean);virtual;abstract;
  end;


  TFMXRadio = class(TFMXCustomRadio)
  private
    FPlatformRadio: TFMXCustomRadio;
    FOwner : TFMXObject;

    procedure InitRadio(iHandle:TWindowHandle);override;
    procedure UnloadRadio;override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetOwner(AOwner : TFmxObject);
    procedure SetVolume(const AValue:Single); override;
    function  GetVolume: Single;override;

    function  Play:Boolean;override;
    procedure Pause;override;
    procedure SetStreamURL(AUrl : string);override;

    procedure SetStatusProc(AProc:TStatusProc);override;
    procedure SetBroadcastInfoProc(AProc:TBroadcastInfoProc);override;
    procedure SetBroadcastMetaProc(AProc:TBroadcastMetaProc);override;
    procedure PauseRadioOnIncomingCalls(APauseOnIncomingCalls:Boolean);override;
  end;

implementation

uses
{$IFDEF ANDROID}
  FMX.Radio.Android;
{$ENDIF}
{$IFDEF MSWINDOWS}
  FMX.Radio.Windows;
{$ENDIF}

{ TFMXRadio }

constructor TFMXRadio.Create;
begin
  inherited;
  if BASS_Available=false
    then begin
            Exit;
         end;

  FPlatformRadio := TFMXPlatformRadio.Create;
end;

procedure TFMXRadio.SetOwner(AOwner : TFmxObject);
begin
  FOwner := AOwner;
   if BASS_Available = true
    then begin
            InitRadio(TForm(FOwner).Handle);
         end;

end;

destructor TFMXRadio.Destroy;
begin
  UnloadRadio;
  FPlatformRadio.Free;
  inherited;
end;

procedure TFMXRadio.SetVolume(const AValue:Single);
begin
  if Assigned(FPlatformRadio)
     then begin
             FPlatformRadio.SetVolume(AValue);
          end;
end;

function  TFMXRadio.GetVolume: Single;
begin
   Result := FPlatformRadio.GetVolume;
end;

function TFMXRadio.Play:Boolean;
begin
  if Not Assigned(FPlatformRadio)
    then begin
            Result := false;
            Exit;
         end;
   Result := FPlatformRadio.Play;
end;

procedure TFMXRadio.Pause;
begin
  if  Assigned(FPlatformRadio)
    then begin
            FPlatformRadio.Pause;
          end;
end;

procedure TFMXRadio.SetStreamURL(AUrl : string);
begin
  if  Assigned(FPlatformRadio)
    then begin
           FPlatformRadio.SetStreamURL(AUrl);
         end;
end;

procedure TFMXRadio.SetStatusProc(AProc:TStatusProc);
begin
  if (Assigned(AProc) and
      Assigned(FPlatformRadio))
    then begin
            FPlatformRadio.SetStatusProc(AProc);
         end;
end;

procedure TFMXRadio.SetBroadcastInfoProc(AProc:TBroadcastInfoProc);
begin
  if (Assigned(AProc) and
      Assigned(FPlatformRadio))
    then begin
            FPlatformRadio.SetBroadcastInfoProc(AProc);
         end;
end;

procedure TFMXRadio.SetBroadcastMetaProc(AProc:TBroadcastMetaProc);
begin
  if (Assigned(AProc) and
      Assigned(FPlatformRadio))
    then begin
            FPlatformRadio.SetBroadcastMetaProc(AProc);
         end;
end;

procedure TFMXRadio.PauseRadioOnIncomingCalls(APauseOnIncomingCalls:Boolean);
begin
  if Assigned(FPlatformRadio)
    then begin
           FPlatformRadio.PauseRadioOnIncomingCalls(APauseOnIncomingCalls);
         end;
end;

procedure TFMXRadio.InitRadio(iHandle:TWindowHandle);
begin
  if Assigned(FPlatformRadio)
    then begin
            FPlatformRadio.InitRadio(iHandle);
         end;
end;

procedure TFMXRadio.UnloadRadio;
begin
  if Assigned(FPlatformRadio)
    then begin
            FPlatformRadio.UnloadRadio;
         end;
end;

end.


