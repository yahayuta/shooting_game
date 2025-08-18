VERSION 5.00
Begin VB.Form HappenEditor 
   BorderStyle     =   1  '固定(実線)
   Caption         =   "敵出現テーブルエディタ"
   ClientHeight    =   2805
   ClientLeft      =   7395
   ClientTop       =   1830
   ClientWidth     =   3150
   Icon            =   "Editor1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2805
   ScaleWidth      =   3150
   Begin VB.TextBox Text5 
      Height          =   375
      Left            =   1320
      TabIndex        =   13
      Text            =   "0"
      Top             =   1440
      Width           =   1575
   End
   Begin VB.TextBox Text4 
      Height          =   375
      Left            =   1320
      TabIndex        =   11
      Text            =   "0"
      Top             =   960
      Width           =   1575
   End
   Begin VB.CommandButton Command2 
      Caption         =   "保存"
      Height          =   375
      Left            =   120
      TabIndex        =   10
      Top             =   2400
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "閉じる"
      Height          =   375
      Left            =   1200
      TabIndex        =   9
      Top             =   2400
      Width           =   975
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   255
      Left            =   120
      Max             =   255
      TabIndex        =   8
      Top             =   1920
      Width           =   2895
   End
   Begin VB.TextBox Text3 
      Height          =   375
      Left            =   2280
      TabIndex        =   6
      Text            =   "0"
      Top             =   480
      Width           =   615
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   1320
      TabIndex        =   3
      Text            =   "0"
      Top             =   480
      Width           =   615
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   360
      TabIndex        =   2
      Text            =   "0"
      Top             =   480
      Width           =   615
   End
   Begin VB.Label Label7 
      Caption         =   "Power"
      Height          =   255
      Left            =   600
      TabIndex        =   14
      Top             =   1560
      Width           =   615
   End
   Begin VB.Label Label6 
      Caption         =   "Counter"
      Height          =   255
      Left            =   600
      TabIndex        =   12
      Top             =   1080
      Width           =   735
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000003&
      X1              =   120
      X2              =   3000
      Y1              =   2280
      Y2              =   2280
   End
   Begin VB.Label Label5 
      Caption         =   "No"
      Height          =   255
      Left            =   2040
      TabIndex        =   7
      Top             =   600
      Width           =   375
   End
   Begin VB.Label Label4 
      Caption         =   "Y"
      Height          =   255
      Left            =   1080
      TabIndex        =   5
      Top             =   600
      Width           =   255
   End
   Begin VB.Label Label3 
      Caption         =   "X"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   600
      Width           =   255
   End
   Begin VB.Label Label2 
      Caption         =   "0"
      Height          =   255
      Left            =   480
      TabIndex        =   1
      Top             =   120
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "Ｎｏ"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   375
   End
End
Attribute VB_Name = "HappenEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_Click()
            
    Unload Me
    
End Sub

Private Sub Command2_Click()

    UpLoadData
    'ＦＩＬＥをバイナリ－モードでオープンして変数をそのまま書込む
    Open App.Path & "\Happen.DAT" For Binary Access Write As #1
        Put #1, , EneHappen
    Close #1

End Sub

Private Sub Form_Load()
    
    '初期表示位置を画面上のセンターへ移動
    If WindowState = 0 Then
        Move (Screen.Width - Me.Width) / 2, (Screen.Height - Me.Height) / 2
    End If
    
    'ＦＩＬＥをバイナリ－モードでオープンしてそのまま変数に読み込む
    Open App.Path & "\Happen.DAT" For Binary Access Read As 1
        Get #1, , EneHappen
    Close #1
        
    LoadData

End Sub

Private Sub HScroll1_Change()
    
    UpLoadData
    LoadData
    
End Sub
Sub LoadData()
    
    Label2.Caption = HScroll1.Value
    Text1.Text = EneHappen(HScroll1.Value).X
    Text2.Text = EneHappen(HScroll1.Value).Y
    Text3.Text = EneHappen(HScroll1.Value).No
    Text4.Text = EneHappen(HScroll1.Value).Counter
    Text5.Text = EneHappen(HScroll1.Value).Power

End Sub
Sub UpLoadData()
    
    EneHappen(Label2.Caption).X = Text1.Text
    EneHappen(Label2.Caption).Y = Text2.Text
    EneHappen(Label2.Caption).No = Text3.Text
    EneHappen(Label2.Caption).Counter = Text4.Text
    EneHappen(Label2.Caption).Power = Text5.Text

End Sub

Private Sub text1_GotFocus()

'テキストを選択状態にする。
    Text1.SelStart = 0
    Text1.SelLength = Len(Text1.Text)

End Sub

Private Sub text1_KeyPress(KeyAscii As Integer)

    'テキストＢＯＸを数値のみの入力にする。
    
    Max = 1000          '最大入力数
    Min = -200          '最低入力数

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
    
    Max = 1000          '最大入力数
    Min = -200          '最低入力数

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
Private Sub text3_GotFocus()

'テキストを選択状態にする。
    Text3.SelStart = 0
    Text3.SelLength = Len(Text3.Text)

End Sub

Private Sub text3_KeyPress(KeyAscii As Integer)

    'テキストＢＯＸを数値のみの入力にする。
    
    Max = 300         '最大入力数
    Min = 0           '最低入力数

    Key$ = Chr$(KeyAscii)
    Select Case Key$
        Case "0" To "9", "-", "."     '数字の０～９までを受け付ける。
            NEWVALUE = Val(Left$(Text3.Text, Text3.SelStart) + Key$ + Mid$(Text3.Text, Text3.SelStart + Text3.SelLength + 1))
            If NEWVALUE > Max Or NEWVALUE < Min Then    '入力範囲内のみ受け付ける様にする。
                KeyAscii = 0
            End If
        Case Chr$(8)    'バックスペースを有効にする。
        Case Else       'その他の入力を全て削除する。
            KeyAscii = 0
    End Select
            
End Sub


Private Sub text3_LostFocus()

    'テキストに空を入力されたら０にする。
    If Text3.Text = "" Then
        Text3.Text = 0
    End If

End Sub


Private Sub text4_GotFocus()

'テキストを選択状態にする。
    Text4.SelStart = 0
    Text4.SelLength = Len(Text4.Text)

End Sub

Private Sub text4_KeyPress(KeyAscii As Integer)

    'テキストＢＯＸを数値のみの入力にする。
    
    Max = 1000        '最大入力数
    Min = 0           '最低入力数

    Key$ = Chr$(KeyAscii)
    Select Case Key$
        Case "0" To "9", "-", "."     '数字の０～９までを受け付ける。
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

Private Sub text5_GotFocus()

'テキストを選択状態にする。
    Text5.SelStart = 0
    Text5.SelLength = Len(Text5.Text)

End Sub

Private Sub text5_KeyPress(KeyAscii As Integer)

    'テキストＢＯＸを数値のみの入力にする。
    
    Max = 255        '最大入力数
    Min = 0           '最低入力数

    Key$ = Chr$(KeyAscii)
    Select Case Key$
        Case "0" To "9", "-", "."     '数字の０～９までを受け付ける。
            NEWVALUE = Val(Left$(Text5.Text, Text5.SelStart) + Key$ + Mid$(Text5.Text, Text5.SelStart + Text5.SelLength + 1))
            If NEWVALUE > Max Or NEWVALUE < Min Then    '入力範囲内のみ受け付ける様にする。
                KeyAscii = 0
            End If
        Case Chr$(8)    'バックスペースを有効にする。
        Case Else       'その他の入力を全て削除する。
            KeyAscii = 0
    End Select
            
End Sub


Private Sub text5_LostFocus()

    'テキストに空を入力されたら０にする。
    If Text5.Text = "" Then
        Text5.Text = 0
    End If

End Sub



