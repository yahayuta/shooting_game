VERSION 5.00
Begin VB.Form MoveEditor 
   Caption         =   "EnemyMoveEditor"
   ClientHeight    =   2250
   ClientLeft      =   4590
   ClientTop       =   3735
   ClientWidth     =   6435
   Icon            =   "Editor2.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   2250
   ScaleWidth      =   6435
   Begin VB.CommandButton Command7 
      Caption         =   "Past && Inc"
      Height          =   255
      Left            =   5280
      TabIndex        =   22
      Top             =   1080
      Width           =   1095
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Past"
      Height          =   255
      Left            =   5280
      TabIndex        =   17
      Top             =   720
      Width           =   1095
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Copy"
      Height          =   255
      Left            =   5280
      TabIndex        =   16
      Top             =   480
      Width           =   1095
   End
   Begin VB.CommandButton Command4 
      Caption         =   "閉じる"
      Height          =   375
      Left            =   2160
      TabIndex        =   12
      Top             =   1800
      Width           =   1095
   End
   Begin VB.CommandButton Command3 
      Caption         =   "保存"
      Height          =   375
      Left            =   960
      TabIndex        =   11
      Top             =   1800
      Width           =   1095
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   255
      Left            =   1320
      Max             =   255
      TabIndex        =   10
      Top             =   1440
      Width           =   5055
   End
   Begin VB.TextBox Text4 
      Height          =   375
      Left            =   3960
      TabIndex        =   9
      Text            =   "0"
      Top             =   960
      Width           =   855
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   2160
      TabIndex        =   8
      Text            =   "0"
      Top             =   960
      Width           =   855
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   2160
      TabIndex        =   7
      Text            =   "0"
      Top             =   480
      Width           =   855
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Past"
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   840
      Width           =   855
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Copy"
      Height          =   375
      Left            =   0
      TabIndex        =   3
      Top             =   480
      Width           =   855
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   1455
      Left            =   960
      Max             =   20
      TabIndex        =   0
      Top             =   0
      Width           =   255
   End
   Begin VB.Label Label12 
      Caption         =   "000"
      Height          =   255
      Left            =   5640
      TabIndex        =   21
      Top             =   120
      Width           =   375
   End
   Begin VB.Label Label11 
      Caption         =   "000"
      Height          =   255
      Left            =   3960
      TabIndex        =   20
      Top             =   120
      Width           =   375
   End
   Begin VB.Label Label10 
      Caption         =   "相対位置Ｙ："
      Height          =   255
      Left            =   4560
      TabIndex        =   19
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label9 
      Caption         =   "相対位置Ｘ："
      Height          =   255
      Left            =   2880
      TabIndex        =   18
      Top             =   120
      Width           =   975
   End
   Begin VB.Label Label8 
      Caption         =   "ﾌﾗｸﾞ"
      Height          =   255
      Left            =   3240
      TabIndex        =   15
      Top             =   1080
      Width           =   735
   End
   Begin VB.Label Label6 
      Caption         =   "Y増加量"
      Height          =   255
      Left            =   1440
      TabIndex        =   14
      Top             =   1080
      Width           =   735
   End
   Begin VB.Label Label5 
      Caption         =   "X増加量"
      Height          =   255
      Left            =   1440
      TabIndex        =   13
      Top             =   600
      Width           =   735
   End
   Begin VB.Label Label4 
      Caption         =   "0"
      Height          =   255
      Left            =   1680
      TabIndex        =   6
      Top             =   120
      Width           =   735
   End
   Begin VB.Label Label3 
      Caption         =   "No"
      Height          =   255
      Left            =   1320
      TabIndex        =   5
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label2 
      Caption         =   "0"
      Height          =   255
      Left            =   360
      TabIndex        =   2
      Top             =   120
      Width           =   375
   End
   Begin VB.Label Label1 
      Caption         =   "No"
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   120
      Width           =   375
   End
End
Attribute VB_Name = "MoveEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private TmpEneMove As EneMoveType
Private TmpEneMoveB(0 To 255) As EneMoveType


Private Sub Command1_Click()

    For i = 0 To 255
        TmpEneMoveB(i).X = EneMove(VScroll1.Value, i).X
        TmpEneMoveB(i).Y = EneMove(VScroll1.Value, i).Y
        TmpEneMoveB(i).Flag = EneMove(VScroll1.Value, i).Flag
    Next i

End Sub

Private Sub Command2_Click()

    For i = 0 To 255
        EneMove(VScroll1.Value, i).X = TmpEneMoveB(i).X
        EneMove(VScroll1.Value, i).Y = TmpEneMoveB(i).Y
        EneMove(VScroll1.Value, i).Flag = TmpEneMoveB(i).Flag
    Next i
    Load

End Sub

Private Sub Command3_Click()

    'ＦＩＬＥをバイナリ－モードでオープンして変数をそのまま書込む
    Open App.Path & "\EneMove.DAT" For Binary Access Write As #1
        Put #1, , EneMove
    Close #1

End Sub


Private Sub Command4_Click()
    
    Unload Me
    
End Sub

Private Sub Command5_Click()

    TmpEneMove.X = Text1.Text
    TmpEneMove.Y = Text2.Text
    TmpEneMove.Flag = Text4.Text
    Label2.Caption = VScroll1.Value
    Label4.Caption = HScroll1.Value

End Sub

Private Sub Command6_Click()
    
    Text1.Text = TmpEneMove.X
    Text2.Text = TmpEneMove.Y
    Text4.Text = TmpEneMove.Flag
    UpLoad
    Label2.Caption = VScroll1.Value
    Label4.Caption = HScroll1.Value

End Sub

Private Sub Command7_Click()

    Text1.Text = TmpEneMove.X
    Text2.Text = TmpEneMove.Y
    Text4.Text = TmpEneMove.Flag
    UpLoad
    HScroll1.Value = HScroll1.Value + 1
    Label2.Caption = VScroll1.Value
    Label4.Caption = HScroll1.Value

End Sub


Private Sub Form_Load()
    
    '初期表示位置を画面上のセンターへ移動
    If WindowState = 0 Then
        Move (Screen.Width - Me.Width) / 2, (Screen.Height - Me.Height) / 2
    End If
    
    'ＦＩＬＥをバイナリ－モードでオープンしてそのまま変数に読み込む
    Open App.Path & "\EneMove.DAT" For Binary Access Read As 1
        Get #1, , EneMove
    Close #1
    
    Load
    
End Sub
Sub Load()

    Text1.Text = EneMove(VScroll1.Value, HScroll1.Value).X
    Text2.Text = EneMove(VScroll1.Value, HScroll1.Value).Y
    Text4.Text = EneMove(VScroll1.Value, HScroll1.Value).Flag
    Label2.Caption = VScroll1.Value
    Label4.Caption = HScroll1.Value
    
    '相対位置Ｘの割り出し
    Label11.Caption = 0
    For i = 0 To HScroll1.Value
        Label11.Caption = Label11.Caption + EneMove(VScroll1.Value, i).X
    Next i
    
    '相対位置Ｙの割り出し
    Label12.Caption = 0
    For i = 0 To HScroll1.Value
        Label12.Caption = Label12.Caption + EneMove(VScroll1.Value, i).Y
    Next i
    

End Sub

Sub UpLoad()

    EneMove(Label2.Caption, Label4.Caption).X = Text1.Text
    EneMove(Label2.Caption, Label4.Caption).Y = Text2.Text
    EneMove(Label2.Caption, Label4.Caption).Flag = Text4.Text
    Label2.Caption = VScroll1.Value
    Label4.Caption = HScroll1.Value

End Sub

Private Sub HScroll1_Change()

    UpLoad
    Load

End Sub

Private Sub VScroll1_Change()
    
    UpLoad
    Load
    
End Sub
Private Sub text1_GotFocus()

'テキストを選択状態にする。
    Text1.SelStart = 0
    Text1.SelLength = Len(Text1.Text)

End Sub

Private Sub text1_KeyPress(KeyAscii As Integer)

    'テキストＢＯＸを数値のみの入力にする。
    
    Max = 1000             '最大入力数
    Min = -1000            '最低入力数

    Key$ = Chr$(KeyAscii)
    Select Case Key$
        Case "0" To "9", "-", "."     '数字の０～９までを受け付ける。
            NEWVALUE = Val(Left$(Text1.Text, Text1.SelStart) + Key$ + Mid$(Text1.Text, Text1.SelStart + Text1.SelLength + 1))
            If NEWVALUE > Max Or NEWVALUE < Min Then    '入力範囲内のみ受け付ける様にする。
                KeyAscii = 0
            End If
        Case Chr$(8)    'バックスペースを有効にする。
        Case Else       'その他の入力を全て削除する。
            KeyAscii = 0
    End Select
            
End Sub


Private Sub text1_LostFocus()

    'テキストに空を入力されたら０にする。
    If Text1.Text = "" Then
        Text1.Text = 0
    End If

End Sub

Private Sub text2_GotFocus()

'テキストを選択状態にする。
    Text2.SelStart = 0
    Text2.SelLength = Len(Text2.Text)

End Sub

Private Sub text2_KeyPress(KeyAscii As Integer)

    'テキストＢＯＸを数値のみの入力にする。
    
    Max = 1000            '最大入力数
    Min = -1000           '最低入力数

    Key$ = Chr$(KeyAscii)
    Select Case Key$
        Case "0" To "9", "-", "."     '数字の０～９までを受け付ける。
            NEWVALUE = Val(Left$(Text2.Text, Text2.SelStart) + Key$ + Mid$(Text2.Text, Text2.SelStart + Text2.SelLength + 1))
            If NEWVALUE > Max Or NEWVALUE < Min Then    '入力範囲内のみ受け付ける様にする。
                KeyAscii = 0
            End If
        Case Chr$(8)    'バックスペースを有効にする。
        Case Else       'その他の入力を全て削除する。
            KeyAscii = 0
    End Select
            
End Sub


Private Sub text2_LostFocus()

    'テキストに空を入力されたら０にする。
    If Text2.Text = "" Then
        Text2.Text = 0
    End If

End Sub

Private Sub text4_GotFocus()

'テキストを選択状態にする。
    Text4.SelStart = 0
    Text4.SelLength = Len(Text4.Text)

End Sub

Private Sub text4_KeyPress(KeyAscii As Integer)

    'テキストＢＯＸを数値のみの入力にする。
    
    Max = 255       '最大入力数
    Min = 0           '最低入力数

    Key$ = Chr$(KeyAscii)
    Select Case Key$
        Case "0" To "9", "-", "."   '数字の０～９までを受け付ける。
            NEWVALUE = Val(Left$(Text4.Text, Text4.SelStart) + Key$ + Mid$(Text4.Text, Text4.SelStart + Text4.SelLength + 1))
            If NEWVALUE > Max Or NEWVALUE < Min Then    '入力範囲内のみ受け付ける様にする。
                KeyAscii = 0
            End If
        Case Chr$(8)    'バックスペースを有効にする。
        Case Else       'その他の入力を全て削除する。
            KeyAscii = 0
    End Select
            
End Sub


Private Sub text4_LostFocus()

    'テキストに空を入力されたら０にする。
    If Text4.Text = "" Then
        Text4.Text = 0
    End If

End Sub







