Attribute VB_Name = "API定義用"
'画像転送用ＡＰＩの定義
    
    Public Declare Function BitBlt Lib "gdi32" ( _
    ByVal hdc As Long, _
    ByVal X As Long, ByVal Y As Long, _
    ByVal nWidth As Long, _
    ByVal nHeight As Long, _
    ByVal hSrcDC As Long, _
    ByVal XSrc As Long, ByVal YSrc As Long, _
    ByVal dwRop As Long _
    ) As Long

    'ラスタオペレーションの定義
    Public Const SrcCopy = &HCC0020
    Public Const SrcAnd = &H8800C6
    Public Const SrcPaint = &HEE0086

'ＰＳＥＴのＡＰＩ版

    Public Declare Function SetPixelV Lib "gdi32" ( _
    ByVal hdc As Long, ByVal X As Long, _
    ByVal Y As Long, ByVal crColor As Long _
    ) As Long


'キーボード検知のＡＰＩの定義

    Public Declare Function GetKeyState Lib "user32" ( _
    ByVal nVirtKey As Long _
    ) As Integer

    Public Declare Function GetAsyncKeyState Lib "user32" ( _
    ByVal vKey As Long _
    ) As Integer

'ＭＩＤＩ及びＷＡＶＥファイルの再生用ＡＰＩの定義

    Public Declare Function mciSendString Lib "winmm.dll" Alias "mciSendStringA" ( _
    ByVal CMD$, ByVal Ret$, ByVal RLen&, ByVal hWnd&) As Long

'ウェイトの為のタイマーＡＰＩの定義

    Public Declare Function timeGetTime Lib "winmm.dll" () As Long

'効果音サウンド用ＡＰＩの定義
    
    Public Declare Function sndPlaySound Lib "winmm" Alias "sndPlaySoundA" _
    (ByRef lpszSoundName As Byte, ByVal uFlags As Long) As Long

    Public Const Snd_Sync = &H0
    Public Const Snd_Async = &H1
    Public Const Snd_Nodefault = &H2
    Public Const Snd_Memory = &H4
    Public Const Snd_Loop = &H8
    Public Const Snd_Nostop = &H10


