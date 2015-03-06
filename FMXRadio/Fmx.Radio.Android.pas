{
  Author : Ersan YAKIT
           ersanyakit@yahoo.com.tr
           www.ersanyakit.com
}

unit FMX.Radio.Android;

interface
{$WARNINGS OFF}
{$HINTS OFF}
{$IFDEF ANDROID}
uses
  FMX.Radio.Bass,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Radio,
  FMX.Types,
  FMX.Radio.Shared,
  FMX.Forms,
  FMX.Platform.Android,
  Androidapi.JNI.Os,
  Androidapi.JNI.Net,
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Media,
  Androidapi.JNI.Provider,
  Androidapi.Helpers,
  Androidapi.JNI.App,
  FMX.Platform,
  FMX.PhoneDialer;

type
  TFMXPlatformRadio = class(TFMXCustomRadio)
  private
    FStreamURL            : string;
    FActiveChannel        : HSTREAM;
    FStatusProc           : TStatusProc;
    FBroadcastInfoProc    : TBroadcastInfoProc;
    FBroadcastMetaProc    : TBroadcastMetaProc;
    FPauseOnIncomingCalls : Boolean;
    FPhoneDialerService   : IFMXPhoneDialerService;

    procedure DoMeta();
    procedure DetectIsCallStateChanged(const ACallID: String; const ACallState: TCallState);
  public
    procedure SetVolume(const AValue:Single); override;
    function  GetVolume: Single;override;
    function  Play:Boolean;override;
    procedure Pause;override;
    procedure SetStreamURL(AUrl : string); override;
    procedure InitRadio(iHandle:TWindowHandle);override;
    procedure UnloadRadio;override;

    procedure SetStatusProc(AProc:TStatusProc);override;
    procedure SetBroadcastInfoProc(AProc:TBroadcastInfoProc);override;
    procedure SetBroadcastMetaProc(AProc:TBroadcastMetaProc);override;
    procedure PauseRadioOnIncomingCalls(APauseOnIncomingCalls:Boolean);override;
  end;

{$ENDIF}

implementation
{ TFMXPlatformRadio }
{$IFDEF ANDROID}
var
  ARadio : TFMXPlatformRadio;


procedure TFMXPlatformRadio.DetectIsCallStateChanged(const ACallID: String; const ACallState: TCallState);
Begin
	case ACallState of
		//TCallState.csNone:
		//TCallState.csConnected:
		TCallState.csIncoming: begin
                              if FPauseOnIncomingCalls=true
                               then begin
                                      Pause;
                                    end;
                           end;
		//TCallState.csDialing:
		//TCallState.csDisconnected:
	end;
End;

procedure MetaSync(handle: HSYNC; channel, data: DWORD; user: Pointer);cdecl;
begin
  if Assigned(ARadio)
    then begin
            ARadio.DoMeta();
         end;
end;

function TFMXPlatformRadio.GetVolume: Single;
var
  AudioManager: JAudioManager;
begin
  AudioManager := TJAudioManager.Wrap(MainActivity.getSystemService(TJContext.JavaClass.AUDIO_SERVICE));
  Result := AudioManager.getStreamVolume(TJAudioManager.JavaClass.STREAM_MUSIC);
  Result := Result / AudioManager.getStreamMaxVolume(TJAudioManager.JavaClass.STREAM_MUSIC);
end;

procedure TFMXPlatformRadio.SetVolume(const AValue:Single);
var
  AudioManager: JAudioManager;
begin
  AudioManager := TJAudioManager.Wrap(MainActivity.getSystemService(TJContext.JavaClass.AUDIO_SERVICE));
  AudioManager.setStreamVolume(TJAudioManager.JavaClass.STREAM_MUSIC,
                               Round(AudioManager.getStreamMaxVolume(TJAudioManager.JavaClass.STREAM_MUSIC) * AValue), 0);
end;

procedure TFMXPlatformRadio.DoMeta();
var
  meta: MarshaledAString;
  line: string;
  p: Integer;
begin
  meta := BASS_ChannelGetTags(FActiveChannel, BASS_TAG_META);
  if (meta <> nil) then
  begin
    line:=UTF8Decode(meta);
    p := Pos('StreamTitle=', line);
    if (p = 0) then
      Exit;
    p := p + 13;

    if Assigned(FBroadcastMetaProc)
      then begin
               FBroadcastMetaProc(Copy(meta, p, Pos(';', line) - p - 1));
           end;
  end;
end;

function TFMXPlatformRadio.Play:Boolean;
var
  szBroadcastName    : string;
  szBroadcastBitRate :string;
  icy                : MarshaledAString;
  ResultCode         : Integer;
  len, Progress      : DWORD;
begin
  Result := false;
  ResultCode := 0;
  BASS_StreamFree(FActiveChannel);
  Progress := 0;

  FActiveChannel := BASS_StreamCreateURL(PChar(FStreamURL),
                                         0,
                                         BASS_STREAM_BLOCK or
                                         BASS_STREAM_STATUS or
                                         BASS_STREAM_AUTOFREE or
                                         BASS_UNICODE,
                                         nil,
                                         nil);
  if FActiveChannel = 0 then
  begin
    ResultCode := Bass_ErrorGetCode;
    Result := false;
    Exit;
  end;
  begin
    // Progress
    repeat
      len := BASS_StreamGetFilePosition(FActiveChannel, BASS_FILEPOS_END);
      if (len = DW_Error)
        then begin
                break;
             end;
      application.ProcessMessages;
      Progress := BASS_StreamGetFilePosition(FActiveChannel, BASS_FILEPOS_BUFFER) * 100 div len;

      if Assigned(FStatusProc)
        then begin
                FStatusProc(strLoading,Progress);
             end;
    until (Progress > 75) or (BASS_StreamGetFilePosition(FActiveChannel, BASS_FILEPOS_CONNECTED) = 0);


    icy := BASS_ChannelGetTags(FActiveChannel, BASS_TAG_ICY);
    if (icy = nil) then
      icy := BASS_ChannelGetTags(FActiveChannel, BASS_TAG_HTTP);

    szBroadcastName := strUnknown;
    szBroadcastBitRate := strUnknown;

    if (icy <> nil)
    then begin
            while (icy^ <> #0) do
            begin
              if (Copy(icy, 1, 9) = 'icy-name:')
                then begin
                        szBroadcastName := Copy(icy, 10, MaxInt);
                     end
              else if (Copy(icy, 1, 7) = 'icy-br:')
                then begin
                        szBroadcastBitRate := 'bitrate: ' + Copy(icy, 8, MaxInt);
                     end;
              icy := icy + Length(icy) + 1;
            end;

           if Assigned(FBroadcastInfoProc)
            then begin
                     FBroadcastInfoProc(szBroadcastName,szBroadcastBitRate);
                 end;
         end;

    DoMeta();
    BASS_ChannelSetSync(FActiveChannel, BASS_SYNC_META, 0, @MetaSync, nil);
    BASS_ChannelPlay(FActiveChannel, FALSE);
    FStatusProc(strCompleted,100);
    Result := True;
  end;
end;

procedure TFMXPlatformRadio.Pause;
begin
  if FActiveChannel<>0
    then begin
          BASS_ChannelStop(FActiveChannel);
         end;
end;

procedure TFMXPlatformRadio.SetStreamURL(AUrl : string);
begin
    FStreamURL := AUrl;
end;

procedure TFMXPlatformRadio.SetStatusProc(AProc:TStatusProc);
begin
    FStatusProc := AProc;
end;

procedure TFMXPlatformRadio.SetBroadcastInfoProc(AProc:TBroadcastInfoProc);
begin
  FBroadcastInfoProc := AProc;
end;

procedure TFMXPlatformRadio.SetBroadcastMetaProc(AProc:TBroadcastMetaProc);
begin
  FBroadcastMetaProc := AProc;
end;

procedure TFMXPlatformRadio.PauseRadioOnIncomingCalls(APauseOnIncomingCalls:Boolean);
begin
  FPauseOnIncomingCalls := APauseOnIncomingCalls;
end;

procedure TFMXPlatformRadio.InitRadio(iHandle:TWindowHandle);
begin
    FActiveChannel := 0;
    FStatusProc:=Nil;
    ARadio := Self;

  if BASS_Init(-1,
               44100,
               0,
               iHandle,
               nil)
  then begin
          BASS_PluginLoad(PChar(BASS_FOLDER + 'libbass_aac.so'), 0 or BASS_UNICODE);
          BASS_SetConfig(BASS_CONFIG_NET_PLAYLIST, 1);
          BASS_SetConfig(BASS_CONFIG_NET_PREBUF, 0);
       end;

  TPlatformServices.Current.SupportsPlatformService(IFMXPhoneDialerService, IInterface(FPhoneDialerService));
  if Assigned(FPhoneDialerService)
    then begin
            FPhoneDialerService.OnCallStateChanged := DetectIsCallStateChanged;
         end;
end;

procedure TFMXPlatformRadio.UnloadRadio;
begin
  if FActiveChannel<>0
    then begin
           BASS_StreamFree(FActiveChannel);
         end;
end;



{$ENDIF}
end.

