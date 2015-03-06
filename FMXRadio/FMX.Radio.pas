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
  FPlatformRadio := TFMXPlatformRadio.Create;
end;

procedure TFMXRadio.SetOwner(AOwner : TFmxObject);
begin
  FOwner := AOwner;
  InitRadio(TForm(FOwner).Handle);
end;

destructor TFMXRadio.Destroy;
begin
  UnloadRadio;
  FPlatformRadio.Free;
  inherited;
end;

procedure TFMXRadio.SetVolume(const AValue:Single);
begin
   FPlatformRadio.SetVolume(AValue);
end;

function  TFMXRadio.GetVolume: Single;
begin
   Result := FPlatformRadio.GetVolume;
end;

function TFMXRadio.Play:Boolean;
begin
   Result := FPlatformRadio.Play;
end;

procedure TFMXRadio.Pause;
begin
   FPlatformRadio.Pause;
end;

procedure TFMXRadio.SetStreamURL(AUrl : string);
begin
   FPlatformRadio.SetStreamURL(AUrl);
end;

procedure TFMXRadio.SetStatusProc(AProc:TStatusProc);
begin
  if Assigned(AProc)
    then begin
            FPlatformRadio.SetStatusProc(AProc);
         end;
end;

procedure TFMXRadio.SetBroadcastInfoProc(AProc:TBroadcastInfoProc);
begin
  if Assigned(AProc)
    then begin
            FPlatformRadio.SetBroadcastInfoProc(AProc);
         end;
end;

procedure TFMXRadio.SetBroadcastMetaProc(AProc:TBroadcastMetaProc);
begin
  if Assigned(AProc)
    then begin
            FPlatformRadio.SetBroadcastMetaProc(AProc);
         end;
end;

procedure TFMXRadio.PauseRadioOnIncomingCalls(APauseOnIncomingCalls:Boolean);
begin
   FPlatformRadio.PauseRadioOnIncomingCalls(APauseOnIncomingCalls);
end;

procedure TFMXRadio.InitRadio(iHandle:TWindowHandle);
begin
  FPlatformRadio.InitRadio(iHandle);
end;

procedure TFMXRadio.UnloadRadio;
begin
  FPlatformRadio.UnloadRadio;
end;

end.


