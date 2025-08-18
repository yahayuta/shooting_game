Attribute VB_Name = "メインモジュール"
    
'グローバル変数の定義

    '全般での変数
    Public CrtWidth As Integer     '表示画面用ピクチャボックスの幅設定
    Public CrtHeight As Integer    '表示画面用ピクチャボックスの高さ設定
        
    'ウェイト関係の変数
    Public StartTime As Long
    Public EndTime As Long
    Public ElapseTime As Long
    
    Public SCORE As Long        '点数
    Public HISCORE As Long      '最高点数

    
    'ゲーム終了関係の変数
    Public EndFlag As Boolean  'ゲーム終了フラグ
    
    '効果音メモリ再生用の変数
    Public Sound1() As Byte
    
    '自機の変数定義
    Type MyType
        X As Single
        Y As Single
        X_Max As Integer
        Y_Max As Integer
        Move As Single
        Bom As Boolean
    End Type
    Public My As MyType
    
    '自機の弾用変数定義
    Type MyShotType
        X As Single
        Y As Single
        Move As Single
        Flag As Byte
    End Type
    Public MyShot(0 To 30) As MyShotType

    '敵の変数定義
    Type EnemyType
        No As Byte
        X As Single
        Y As Single
        Power As Integer
        Flag As Byte
        MoveFlag(0 To 2) As Byte
        BomCounter As Byte
    End Type
    Public Enemy(0 To 20) As EnemyType
    Public EnemyMax As Byte
    
    '敵の弾用変数の定義
    Type EneShotType
        X As Single
        Y As Single
        MoveX As Single
        MoveY As Single
        Flag As Byte
    End Type
    Public EneShot(0 To 40) As EneShotType
    Public EneShotMax As Byte
    
    '敵移動データ用変数の定義
    Type EneMoveType
        X As Single
        Y As Single
        Flag As Byte
    End Type
    Public EneMove(0 To 20, 0 To 255) As EneMoveType
    
    '敵登場用デーブルデータ
    Type EnemyHappenType
        X As Single
        Y As Single
        No As Integer
        Counter As Integer
        Power As Byte
    End Type
    Public EneHappen(0 To 255) As EnemyHappenType

    
    '背景用の星屑用変数の定義
    Type StarDustType
        X As Integer
        Y As Integer
        Speed As Integer
    End Type
    Public Stardust(0 To 20) As StarDustType
    Public MaxDust As Byte
    
Sub Main()
'
'このサブルーチンが実際に一番最初に走るプログラムです。
'

    'メインフォームを表示する
    CrtWidth = 32 * 8: CrtHeight = 32 * 10
    Load MainForm
    MainForm.Show
    
    'Exit Sub
    '▼ここから実際のゲームプログラムを記述して下さい。
    
    'メインルーチンを実行
    
    GetAsyncKeyState (vbKeyEscape)
    GetAsyncKeyState (vbKeySpace)

    '乱数の初期化
    Randomize
    
    '星屑の初期処理
    MaxDust = 20
    For i = 0 To MaxDust
    
        Stardust(i).X = Int((320 - 0 + 1) * Rnd + 0)
        Stardust(i).Y = Int((480 - 0 + 1) * Rnd + 0)
        Stardust(i).Speed = Int((6 - 2 + 1) * Rnd + 2)
    
    Next i

    'タイトル画面処理
    Do
    
        StarDustShow
        BitBlt MainForm.Crt.hdc, 10, 120, 246, 50, MainForm.MessagePic.hdc, 0, 0, SrcPaint
        MainForm.Crt.Refresh
        DoEvents
        
        If GetAsyncKeyState(vbKeySpace) Then
            
            MainForm.Crt.Cls
            DoEvents
            Wait 500
            BGM_OPEN "Bgm.MID"
            BGM_Play
            
            MainRoutine
            
            BGM_Stop
            BGM_CLOSE
            MainForm.Crt.Cls
            DoEvents
            Wait 500
            GetAsyncKeyState (vbKeyEscape)
            GetAsyncKeyState (vbKeySpace)
        
        End If
        Wait 25
        
    Loop
    
    '▲ここまで。
      
    End     '全ての処理が終了したらアプリケーションの終了
    
End Sub
Sub EarlyProcess()
'ゲーム開始前に必要な初期処理を全て記述する。
    
    '効果音の読み込み
    Open App.Path & "\Sound1.wav" For Binary As #1
        ReDim Sound1(LOF(1))
        Get #1, , Sound1()
    Close #1
    
    SCORE = 0
    
    '自機のスタート座標を設定
    My.X = Int((MainForm.Crt.Width - 32) / 2)
    My.Y = Int(MainForm.Crt.Height - 32)
    My.X_Max = CrtWidth - 32
    My.Y_Max = CrtHeight - 32
    My.Move = 8
        
    '敵キャラクタの設定
    EHCounter = 0
    NextCounter = 0
    
    EnemyMax = 20
    EneShotMax = 40
    
    For i = 0 To EnemyMax
        Enemy(i).Flag = 0
    Next i
    
    For i = 0 To EneShotMax
        EneShot(i).Flag = 0
    Next i
    
    '敵発生テーブルの読み込み
    Open App.Path & "\Happen.DAT" For Binary Access Read As 1
        Get #1, , EneHappen
    Close #1
    
    '敵移動テーブルの読み込み
    Open App.Path & "\EneMove.DAT" For Binary Access Read As 1
        Get #1, , EneMove
    Close #1

End Sub

Sub MainRoutine()
'メインルーチン

    '初期処理
    Const CycleTime = 25    '１サイクルの実行時間を設定
    EndFlag = 0

    '▼以下の部分に必要な初期処理を全て記述する。
    
    EarlyProcess
    
    '▲ここまで。
    
    Do  '実際のループ
        
        'ループ開始時のタイムを記憶
        StartTime = timeGetTime()
        
        '▼以下の部分にメインループでの仕事を記述する。
        StarDustShow
        MyRoutine
        MyShotRoutine
        EnemyHappen
        EnemyMove
        EnemyShotMove
        BomCheck
        MyBom
    
        ScoreShow
        '▲ここまで。
        
        MainForm.Crt.Refresh
        DoEvents    '他の処理を実行
        
        'ゲーム終了処理
        If GetAsyncKeyState(vbKeyEscape) Or EndFlag Then
            'ループを抜ける
            Exit Do
        End If
        
        'ループ時間に関する処理
        EndTime = timeGetTime()
        ElapseTime = EndTime - StartTime  '終了したタイムからかかったタイムを出す
        'ループした時間が短ければＷａｉｔ関数を呼び出し待つ
        If ElapseTime < CycleTime And MainForm.Menu001.Checked Then
            Wait (CycleTime - ElapseTime)
        End If
        
        EndTime = timeGetTime()
        ElapseTime = EndTime - StartTime   'スコア表示用にウェイトを含む実際の時間を出しなおす

    Loop
    
    
End Sub

Sub StarDustShow()
'背景の星屑を描画

    BitBlt MainForm.Crt.hdc, 0, 0, CrtWidth, CrtHeight, MainForm.Bg_Pic.hdc, 0, 0, SrcCopy
    For i = 0 To MaxDust
    
        SetPixelV MainForm.Crt.hdc, Stardust(i).X, Stardust(i).Y, QBColor(15)

        Stardust(i).Y = Stardust(i).Y + Stardust(i).Speed
        If Stardust(i).Y > CrtHeight Then
            Stardust(i).Y = 0
            Stardust(i).X = Int((CrtWidth - 0 + 1) * Rnd + 0)
        End If

    Next i

End Sub

Sub MyRoutine()

    If My.Bom = False Then
        
        '自機移動処理
        Select Case Stick   'Ｓｔｉｃｋ関数によりカーソルキーの状態が帰って来ます（Ｍｓｘと同じ）

            Case 1  '上キー
                
                My.Y = My.Y - My.Move
                If My.Y <= 0 Then My.Y = 0
            
            Case 2  '右上キー
            
                My.X = My.X + My.Move: My.Y = My.Y - My.Move
                If My.X >= My.X_Max Then My.X = My.X_Max
                If My.Y <= 0 Then My.Y = 0
                            
            Case 3  '右キー
                
                My.X = My.X + My.Move
                If My.X >= My.X_Max Then My.X = My.X_Max
            Case 4  '右下キー
                
                My.X = My.X + My.Move: My.Y = My.Y + My.Move
                If My.X >= My.X_Max Then My.X = My.X_Max
                If My.Y >= My.Y_Max Then My.Y = My.Y_Max
                        
            Case 5  '下キー
                
                My.Y = My.Y + My.Move
                If My.Y >= My.Y_Max Then My.Y = My.Y_Max
            
            Case 6  '左下キー
                
                My.X = My.X - My.Move: My.Y = My.Y + My.Move
                If My.X <= 0 Then My.X = 0
                If My.Y >= My.Y_Max Then My.Y = My.Y_Max
            
            Case 7  '左キー
            
                My.X = My.X - My.Move
                If My.X <= 0 Then My.X = 0
                
            Case 8  '左上キー
                
                My.X = My.X - My.Move: My.Y = My.Y - My.Move
                If My.X <= 0 Then My.X = 0
                If My.Y <= 0 Then My.Y = 0
        
        End Select
    
        '自機の表示
        BitBlt MainForm.Crt.hdc, My.X, My.Y, 32, 32, MainForm.Chr.hdc, 0, 96, SrcAnd
        BitBlt MainForm.Crt.hdc, My.X, My.Y, 32, 32, MainForm.Chr.hdc, 0, 64, SrcPaint
    
    End If
    
End Sub

Sub MyShotRoutine()
    
    '弾の発射処理
    Static Counter As Byte
    If Counter = 3 Then
        If My.Bom = False And GetAsyncKeyState(vbKeyX) Then
            For i = 0 To 29 Step 2
                
                If MyShot(i).Flag = 0 Then
                
                    MyShot(i).Flag = 1
                    MyShot(i).X = My.X - 2
                    MyShot(i).Y = My.Y - 32
                    MyShot(i).Move = 12
                    
                    MyShot(i + 1).Flag = 1
                    MyShot(i + 1).X = My.X + 18
                    MyShot(i + 1).Y = My.Y - 32
                    MyShot(i + 1).Move = 12
    
                    Exit For
                    
                End If
                
            Next i
        End If
        Counter = 0
    Else
        Counter = Counter + 1
    End If
    
    '存在をチェックして表示等を行う
    For i = 0 To 30
        
        If MyShot(i).Flag = 1 Then
        
            BitBlt MainForm.Crt.hdc, MyShot(i).X, MyShot(i).Y, 16, 32, MainForm.Chr.hdc, 32, 96, SrcAnd
            BitBlt MainForm.Crt.hdc, MyShot(i).X, MyShot(i).Y, 16, 32, MainForm.Chr.hdc, 32, 64, SrcPaint
        
            MyShot(i).Y = MyShot(i).Y - MyShot(i).Move
            If MyShot(i).Y <= -32 Or MyShotHitJudge(MyShot(i).X, MyShot(i).Y) = 1 Then
                MyShot(i).Flag = 0
            End If
        
        End If
    
    Next i
    
End Sub
Sub EnemyHappen()
'出現テーブルに従って敵を発生させて行く

'出現テーブルでの機能一覧
'
'   ２５５　最初に戻る
'   ２５６　繰り返し地点    Ｘ　戻り先  Ｙ　繰り返し回数（減算）　Power カウント初期値
'   ２５７　ランダム出現    Ｘ　最小番号    Ｙ　最大番号
'
'座標 通常のNOでの出現に限る
'
'   ７００　乱数にて制御    Ｘ　０～３２０  Ｙ　０～４８０
'
    Static NextCounter As Byte     '出現タイミングカウント用変数
    Static EHCounter As Byte        '出現テーブルの読み込み位置用変数

    '発生カウンターをインクル
    NextCounter = NextCounter + 1
    
    'テーブル読み込みループ
    Do
        '特殊番号の処理
        Select Case EneHappen(EHCounter).No
                
            Case 256    '繰り返し
                
                If EneHappen(EHCounter).Y <= 0 Then
                    EneHappen(EHCounter).Y = EneHappen(EHCounter).Power
                    EHCounter = EHCounter + 1
                    Exit Do
                Else
                    EneHappen(EHCounter).Y = EneHappen(EHCounter).Y - 1
                    EHCounter = EneHappen(EHCounter).X
                End If
            
            Case 255    '頭へ戻る
            
                EHCounter = 0
            
        End Select
        
        If NextCounter >= EneHappen(EHCounter).Counter Then
        
            '発生カウントに達していたら発生処理
            F = 0
            For i = 0 To EnemyMax

                If Enemy(i).Flag = 0 Then
                  
                    Enemy(i).No = EneHappen(EHCounter).No
                    Enemy(i).Flag = 1
                    Enemy(i).MoveFlag(0) = 0
                    Enemy(i).MoveFlag(1) = 0
                    Enemy(i).MoveFlag(2) = 0
                    
                    Enemy(i).Y = EneHappen(EHCounter).Y
                    
                    '座標の乱数発生
                    If EneHappen(EHCounter).X = 700 Then
                    
                        Enemy(i).X = Int(((CrtWidth - 32) - 1 + 1) * Rnd)
                    
                    Else
                        
                        Enemy(i).X = EneHappen(EHCounter).X
                    
                    End If
                    
                    Enemy(i).Power = EneHappen(EHCounter).Power
                    Exit For
                
                End If
            
            Next i
            
            NextCounter = 0
            EHCounter = EHCounter + 1

        Else
        
            'カウントに達していければループを終了する
            Exit Do
        
        End If
                
    Loop
        

End Sub
Sub EnemyMove()
    
    Dim i As Integer
    Dim ShowX As Integer, ShowY As Integer

    For i = 0 To EnemyMax
        
        If Enemy(i).Flag = 1 Then
            
            Select Case EneMove(Enemy(i).No, Enemy(i).MoveFlag(0)).Flag
                
                Case 1 To 10
                
                    EnemyShotRoutine i
                
                Case 253    '無条件ジャンプ　Ｘ＝ジャンプ先
                
                    Enemy(i).Flag = EneMove(Enemy(i).No, Enemy(i).MoveFlag(0)).X

                
                Case 254    '繰り返し　Ｘ＝ジャンプ先、Ｙ＝繰り返し回数
                
                    If Enemy(i).MoveFlag(1) = 0 Then
                    
                        Enemy(i).MoveFlag(2) = EneMove(Enemy(i).No, Enemy(i).MoveFlag(0)).Y
                        Enemy(i).MoveFlag(1) = 1
                        
                    End If
                    
                    If Enemy(i).MoveFlag(2) <= 0 Then
                                            
                        Enemy(i).MoveFlag(1) = 0
                    
                    Else
                        
                        Enemy(i).MoveFlag(0) = EneMove(Enemy(i).No, Enemy(i).MoveFlag(0)).X
                        Enemy(i).MoveFlag(2) = Enemy(i).MoveFlag(2) - 1
                        
                    End If
                    
                    
                    
                Case 255
                    
                    Enemy(i).Flag = 0
                                        
            End Select
            
            Enemy(i).X = Enemy(i).X + EneMove(Enemy(i).No, Enemy(i).MoveFlag(0)).X
            Enemy(i).Y = Enemy(i).Y + EneMove(Enemy(i).No, Enemy(i).MoveFlag(0)).Y
            Enemy(i).MoveFlag(0) = Enemy(i).MoveFlag(0) + 1

            '敵の表示
            ShowX = Int(Enemy(i).X): ShowY = Int(Enemy(i).Y)
            BitBlt MainForm.Crt.hdc, ShowX, ShowY, 32, 32, MainForm.Chr.hdc, Enemy(i).No * 32, 32, SrcAnd
            BitBlt MainForm.Crt.hdc, ShowX, ShowY, 32, 32, MainForm.Chr.hdc, Enemy(i).No * 32, 0, SrcPaint
                
        End If
                            
    Next i

End Sub
Function MyShotHitJudge(AX, AY As Single)
    
    '指定座標と敵との辺り判定
    For i = 0 To EnemyMax
        If Enemy(i).Flag = 1 Then
            'Ｘ座標のチェック
            F1 = Enemy(i).X - 16 < AX And Enemy(i).X + 32 > AX
            'Ｙ座標のチェック
            F2 = Enemy(i).Y - 24 < AY And Enemy(i).Y + 32 > AY
            '実際に当たっているかどうかのチェック
            If F1 And F2 Then
            
                Enemy(i).Power = Enemy(i).Power - 1
                
                If Enemy(i).Power <= 0 Then
                    
                    Enemy(i).Flag = 2     '敵の存在フラグをセットする
                    
                    SCORE = SCORE + 100
                    If SCORE > HISCORE Then HISCORE = SCORE
                    
                    '効果音を出す
                    sndPlaySound Sound1(0), Snd_Async Or Snd_Memory
                    
                End If
                
                MyShotHitJudge = 1            '返り値に１をセットする
            
            End If
            
        End If
    Next i

End Function
Function EnemyShotRoutine(EneNo As Integer)
    
    For i = 0 To EneShotMax
                    
        If EneShot(i).Flag = 0 Then
            
            EneShot(i).Flag = 1
            EneShot(i).X = Enemy(EneNo).X + (32 / 2)
            EneShot(i).Y = Enemy(EneNo).Y + 32
            
            RS = Int((6 - 4 + 1) * Rnd + 4)
            mmovx = My.X + 32 + Int((90 - 1 + 1) * Rnd + 1 - 30) - EneShot(i).X
            mmovy = My.Y + 32 + Int((90 - 1 + 1) * Rnd + 1 - 30) - EneShot(i).Y
            mmov = Sqr(mmovx * mmovx + mmovy * mmovy)
            EneShot(i).MoveX = RS * mmovx / mmov
            EneShot(i).MoveY = RS * mmovy / mmov

            Exit For
                    
        End If
                
    Next i
    
End Function
Sub EnemyShotMove()

    Dim ShowX As Integer, ShowY As Integer
    For i = 0 To EneShotMax
        
        If EneShot(i).Flag = 1 Then

            EneShot(i).X = EneShot(i).X + EneShot(i).MoveX
            EneShot(i).Y = EneShot(i).Y + EneShot(i).MoveY
            F1 = (EneShot(i).X < 0) Or (EneShot(i).X > CrtWidth)
            F2 = (EneShot(i).Y < 0) Or (EneShot(i).Y > CrtHeight)
            
            If MainForm.Menu003.Checked = False Then F = EneShotHitJudge(EneShot(i).X, EneShot(i).Y)
            
            If F1 Or F2 Or (F = 1) Then
                
                EneShot(i).Flag = 0
            
            Else
    
                ShowX = Int(EneShot(i).X): ShowY = Int(EneShot(i).Y)
                BitBlt MainForm.Crt.hdc, ShowX, ShowY, 16, 16, MainForm.Chr.hdc, 48, 80, SrcAnd
                BitBlt MainForm.Crt.hdc, ShowX, ShowY, 16, 16, MainForm.Chr.hdc, 48, 64, SrcPaint
                
            End If
        
        End If
        
    Next i
    
End Sub

Function EneShotHitJudge(AX, AY As Single)

    If My.Bom = False And My.X < AX And My.X + 22 > AX And My.Y + 8 < AY And My.Y + 26 > AY Then
        
        EneShotHitJudge = 1
        sndPlaySound Sound1(0), Snd_Async Or Snd_Memory
        My.Bom = True
    
    End If
    
End Function
Sub BomCheck()
    
    Static Bom_Counter As Byte
    Dim ShowX, ShowY As Integer
            
    '敵の爆発処理
    For i = 0 To EnemyMax
        
        If Enemy(i).Flag = 2 Then
        
            ShowX = Int(Enemy(i).X): ShowY = Int(Enemy(i).Y)
            BitBlt MainForm.Crt.hdc, ShowX, ShowY, 32, 32, MainForm.Chr.hdc, 32 * Enemy(i).BomCounter, 128, SrcPaint
            Enemy(i).Y = Enemy(i).Y + 4
            
            '一定時間置きに爆発中のキャラクタを調べてインクルする
            'コレにより確実に安定して爆発のアニメーションを可能とする。
            If Bom_Counter = 2 Then
                Bom_Counter = 0
                Enemy(i).BomCounter = Enemy(i).BomCounter + 1
                If Enemy(i).BomCounter = 7 Then
                    Enemy(i).Flag = 0
                    Enemy(i).BomCounter = 0
                End If
            Else
                Bom_Counter = Bom_Counter + 1
            End If
                
        End If
    
    Next i
        

End Sub

Sub MyBom()
    
    Static Bom_Counter As Byte
    Static MyBom As Byte
    
    If My.Bom Then
            
        ShowX = Int(My.X): ShowY = Int(My.Y)
        BitBlt MainForm.Crt.hdc, ShowX, ShowY, 32, 32, MainForm.Chr.hdc, 32 * MyBom, 128, SrcPaint
        'my(i).Y = Enemy(i).Y + 4
        
        '一定時間置きに爆発中のキャラクタを調べてインクルする
        'コレにより確実に安定して爆発のアニメーションを可能とする。
        If Bom_Counter >= 2 Then
        
            Bom_Counter = 0
            MyBom = MyBom + 1
            If MyBom = 7 Then
                EndFlag = True
                My.Bom = False
                MyBom = 0
            End If
        Else
            Bom_Counter = Bom_Counter + 1
        End If
        
    End If
    
End Sub

Sub ScoreShow()

    '画面左上にスコアを表示する。
    '※Printメソッドを利用すると勝手に描画処理を行う為その後
    '　Rifreshは行わなくて良い、逆に言うと必ず最後に実行しなければいけない
    Static ShowTimer0 As Long
    Static ShowTimer1 As Long
    Static ShowTimer As Long
    
    If ShowTimer0 < ShowTimer1 And ElapseTime > 0 Then
        ShowTimer0 = timeGetTime() + 250
        ShowTimer = Int(1000 / ElapseTime)
    Else
        ShowTimer1 = timeGetTime()
    End If
    
    MainForm.Crt.CurrentX = 5: MainForm.Crt.CurrentY = 2
    MainForm.Crt.Print "HISCORE" & " " & Format(HISCORE, "000000") & "  SCORE" & " " & Format(SCORE, "000000") & Space(1) & "FPS " & Format(ShowTimer, "00000")
    
End Sub

