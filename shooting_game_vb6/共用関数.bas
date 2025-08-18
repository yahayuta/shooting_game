Attribute VB_Name = "共用関数"
'ＢＧＭが演奏中かどうかのフラグ
Public BGM_Flag As Boolean

Sub BGM_OPEN(Filename As String)

    '指定されたファイルをオープンする
    Ret = mciSendString("close MIDI notify", vbNullString, 0, 0)
    Ret = mciSendString("open " & App.Path + "\" + Filename & " alias MIDI", vbNullString, 0, 0)
    
End Sub
Sub BGM_CLOSE()
    
    'オープンしているファイルを閉じる
    Ret = mciSendString("close MIDI notify", vbNullString, 0, 0)

End Sub
Sub BGM_Play()
    
    '開いてあるファイルを再生する
    BGM_Flag = True
    Ret = mciSendString("play MIDI notify", vbNullString, 0, 0)

End Sub
Sub BGM_Stop()
    
    '演奏中のファイルを停止する
    BGM_Flag = False
    Ret = mciSendString("stop MIDI notify", vbNullString, 0, 0)
    
End Sub
Sub Wave_Play(Filename As String)
    
    '効果音の再生
    Ret = mciSendString("close WAVE notify", vbNullString, 0, 0)
    Ret = mciSendString("open " & App.Path + "\" + Filename & " alias WAVE", vbNullString, 0, 0)
    Ret = mciSendString("play WAVE notify", vbNullString, 0, 0)

End Sub
Sub Sound_Play(Filename As String)
    
    'サウンド効果音の再生　Ｗａｖｅ＿Ｐｌａｙと違い連続再生が可能である
    sndPlaySound AppPath & "\" & Filename, Snd_Async Or Snd_Nodefault

End Sub

Sub Wait(Wait_Time As Long)
'ＡＰＩ版ウェイト関数
    
    '使用する変数の定義
    Dim Start_Time As Long
    
    'Ｗａｉｔ開始時の時間を取得
    Start_Time = timeGetTime()
    Do
        DoEvents    '他の処理を実行
        
        '設定時間到達のチェック
        If timeGetTime() - Start_Time > Wait_Time Then
            '到達したらループを抜ける
            Exit Do
        End If
    Loop

End Sub

Function Stick()

'Ｓｔｉｃｋ関数
'
'   戻り値の内容
'
'   ０＝押されていない
'   １＝上　：　２＝右上：　３＝右　：　４＝右下
'   ５＝下　：　６＝左下：　７＝左　：　８＝左上
'

    '使用する変数の定義
    Dim Key_Tmp As String
    Key_Tmp = 0
    
    '通常の４方向のチェック
    If GetAsyncKeyState(vbKeyUp) Then Key_Tmp = 1
    If GetAsyncKeyState(vbKeyRight) Then Key_Tmp = 3
    If GetAsyncKeyState(vbKeyDown) Then Key_Tmp = 5
    If GetAsyncKeyState(vbKeyLeft) Then Key_Tmp = 7
    
    '斜め方向のチェック
    If GetAsyncKeyState(vbKeyUp) And GetAsyncKeyState(vbKeyRight) Then Key_Tmp = 2
    If GetAsyncKeyState(vbKeyUp) And GetAsyncKeyState(vbKeyLeft) Then Key_Tmp = 8
    If GetAsyncKeyState(vbKeyDown) And GetAsyncKeyState(vbKeyRight) Then Key_Tmp = 4
    If GetAsyncKeyState(vbKeyDown) And GetAsyncKeyState(vbKeyLeft) Then Key_Tmp = 6
    
    '入力されている方向を戻り値として返す
    Stick = Key_Tmp
    
    '次の入力の為キーのクリア
    GetAsyncKeyState (vbKeyUp)
    GetAsyncKeyState (vbKeyRight)
    GetAsyncKeyState (vbKeyDown)
    GetAsyncKeyState (vbKeyLeft)

End Function
