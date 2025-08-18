VERSION 5.00
Begin VB.Form MainForm 
   BorderStyle     =   1  '固定(実線)
   Caption         =   "MainForm"
   ClientHeight    =   4980
   ClientLeft      =   5655
   ClientTop       =   2985
   ClientWidth     =   3960
   Icon            =   "MainForm.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   332
   ScaleMode       =   3  'ﾋﾟｸｾﾙ
   ScaleWidth      =   264
   Begin VB.PictureBox MessagePic 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      Height          =   1560
      Left            =   0
      Picture         =   "MainForm.frx":030A
      ScaleHeight     =   1500
      ScaleWidth      =   3645
      TabIndex        =   3
      Top             =   3360
      Visible         =   0   'False
      Width           =   3705
   End
   Begin VB.Timer Bgm_Check 
      Interval        =   1000
      Left            =   3480
      Top             =   2760
   End
   Begin VB.PictureBox B_Crt 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      Height          =   375
      Left            =   360
      ScaleHeight     =   21
      ScaleMode       =   3  'ﾋﾟｸｾﾙ
      ScaleWidth      =   21
      TabIndex        =   2
      Top             =   0
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.PictureBox Chr 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      Height          =   2940
      Left            =   0
      Picture         =   "MainForm.frx":1826
      ScaleHeight     =   192
      ScaleMode       =   3  'ﾋﾟｸｾﾙ
      ScaleWidth      =   224
      TabIndex        =   1
      Top             =   360
      Visible         =   0   'False
      Width           =   3420
   End
   Begin VB.PictureBox Crt 
      BackColor       =   &H00000000&
      ForeColor       =   &H00FF0000&
      Height          =   375
      Left            =   0
      ScaleHeight     =   21
      ScaleMode       =   3  'ﾋﾟｸｾﾙ
      ScaleWidth      =   21
      TabIndex        =   0
      Top             =   0
      Width           =   375
   End
   Begin VB.PictureBox Bg_Pic 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   4860
      Left            =   0
      Picture         =   "MainForm.frx":336F
      ScaleHeight     =   320
      ScaleMode       =   3  'ﾋﾟｸｾﾙ
      ScaleWidth      =   256
      TabIndex        =   4
      Top             =   0
      Visible         =   0   'False
      Width           =   3900
   End
   Begin VB.Menu Menu000 
      Caption         =   "ｹﾞｰﾑ"
      Begin VB.Menu Menu001 
         Caption         =   "Wait"
         Checked         =   -1  'True
      End
      Begin VB.Menu Menu002 
         Caption         =   "-"
      End
      Begin VB.Menu Menu003 
         Caption         =   "ｹﾞｰﾑの終了"
      End
   End
   Begin VB.Menu Menu1000 
      Caption         =   "Editor"
      Begin VB.Menu Menu1001 
         Caption         =   "発生ｴﾃﾞｨﾀ"
      End
      Begin VB.Menu Menu1002 
         Caption         =   "敵移動ｴﾃﾞｨﾀ"
      End
   End
End
Attribute VB_Name = "MainForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Bgm_Check_Timer()
'ＢＧＭの演奏チェックと繰り返しの処理
    
    Dim MciStatus As String 'メッセージ受け取り用変数の型定義
     
    '戻り値の長さ
    StatusLen = 15
    
    'status格納変数にスペース代入
    MciStatus = String$(StatusLen + 1, " ")
            
    'チェック!
    checking = mciSendString("status MIDI mode", MciStatus, StatusLen, 0)
    
    '停止中のときは、演奏を再開する
    If (UCase$(Left$(MciStatus, 7)) = "STOPPED") And (BGM_Flag = True) Then
        Ret = mciSendString("seek MIDI to start", vbNullString, 0, 0)
        Ret = mciSendString("play MIDI from 0", vbNullString, 0, 0)
    End If

End Sub

Private Sub Form_Load()

'▼以下の部分にフォームの外見的な調整のコードを記述して下さい。
        
    'メイン画面となるPictureBoxの調整
    Crt.AutoRedraw = True
    Crt.ScaleMode = 3
    'メイン画面の大きさの設定
    Crt.Width = CrtWidth + 4
    Crt.Height = CrtHeight + 4
    
    '裏画面用ピクチャボックスの設定
    B_Crt.Width = Crt.Width
    B_Crt.Height = Crt.Height
    
    '実際のアプリケーションのタイトルに変更して下さい
    MainForm.Caption = "ゲーム製作講座その⑤　シューティング♪"
    'フォームの大きさをメインのピクチャボックスに合わせる
    MainForm.Width = (Crt.Width + 6) * Screen.TwipsPerPixelX
    MainForm.Height = ((Crt.Height + 24) * Screen.TwipsPerPixelY) + 300
    
'▲ここまで。
    
    '初期表示位置を画面上のセンターへ移動
    If WindowState = 0 Then
        Move (Screen.Width - MainForm.Width) / 2, (Screen.Height - MainForm.Height) / 2
    End If
        
End Sub

Private Sub Form_Unload(Cancel As Integer)
'アプリケーション終了処理
    
    'ＢＧＭファイルをクローズする
    BGM_CLOSE
    End
    
End Sub

Private Sub Menu001_Click()

    Menu001.Checked = Not Menu001.Checked
    
End Sub

Private Sub Menu003_Click()
'アプリケーション終了処理
    
    'ＢＧＭファイルをクローズする
    BGM_CLOSE
    End

End Sub

Private Sub Menu1001_Click()
    
    Load HappenEditor
    HappenEditor.Show vbModal
    
End Sub

Private Sub Menu1002_Click()
    
    Load MoveEditor
    MoveEditor.Show vbModal
    
End Sub
