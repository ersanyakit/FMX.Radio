{
  Author : Ersan YAKIT
           ersanyakit@yahoo.com.tr
           www.ersanyakit.com
}

unit FMX.Radio.Shared;

interface

const
  strLoading:String='Loading...';
  strUnknown:String='Unknown!';
  strCompleted:String='Completed!';

  DLL_BASS_ACC : string = 'bass_aac.dll';

type
    TStatusProc        = procedure(pszData : string;Progress:Integer);
    TBroadcastInfoProc = procedure(pszBroadcastName,pszBitRate:string);
    TBroadcastMetaProc = procedure(pszData : string);

implementation

end.
