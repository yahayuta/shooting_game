VERSION 5.00
Begin VB.Form MainForm 
   BorderStyle     =   1  '�Œ�(����)
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
   ScaleMode       =   3  '�߸��
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
      ScaleMode       =   3  '�߸��
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
      ScaleMode       =   3  '�߸��
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
      ScaleMode       =   3  '�߸��
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
      ScaleMode       =   3  '�߸��
      ScaleWidth      =   256
      TabIndex        =   4
      Top             =   0
      Visible         =   0   'False
      Width           =   3900
   End
   Begin VB.Menu Menu000 
      Caption         =   "�ް�"
      Begin VB.Menu Menu001 
         Caption         =   "Wait"
         Checked         =   -1  'True
      End
      Begin VB.Menu Menu002 
         Caption         =   "-"
      End
      Begin VB.Menu Menu003 
         Caption         =   "�ްт̏I��"
      End
   End
   Begin VB.Menu Menu1000 
      Caption         =   "Editor"
      Begin VB.Menu Menu1001 
         Caption         =   "������ި�"
      End
      Begin VB.Menu Menu1002 
         Caption         =   "�G�ړ���ި�"
      End
   End
End
Attribute VB_Name = "MainForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Bgm_Check_Timer()
'�a�f�l�̉��t�`�F�b�N�ƌJ��Ԃ��̏���
    
    Dim MciStatus As String '���b�Z�[�W�󂯎��p�ϐ��̌^��`
     
    '�߂�l�̒���
    StatusLen = 15
    
    'status�i�[�ϐ��ɃX�y�[�X���
    MciStatus = String$(StatusLen + 1, " ")
            
    '�`�F�b�N!
    checking = mciSendString("status MIDI mode", MciStatus, StatusLen, 0)
    
    '��~���̂Ƃ��́A���t���ĊJ����
    If (UCase$(Left$(MciStatus, 7)) = "STOPPED") And (BGM_Flag = True) Then
        Ret = mciSendString("seek MIDI to start", vbNullString, 0, 0)
        Ret = mciSendString("play MIDI from 0", vbNullString, 0, 0)
    End If

End Sub

Private Sub Form_Load()

'���ȉ��̕����Ƀt�H�[���̊O���I�Ȓ����̃R�[�h���L�q���ĉ������B
        
    '���C����ʂƂȂ�PictureBox�̒���
    Crt.AutoRedraw = True
    Crt.ScaleMode = 3
    '���C����ʂ̑傫���̐ݒ�
    Crt.Width = CrtWidth + 4
    Crt.Height = CrtHeight + 4
    
    '����ʗp�s�N�`���{�b�N�X�̐ݒ�
    B_Crt.Width = Crt.Width
    B_Crt.Height = Crt.Height
    
    '���ۂ̃A�v���P�[�V�����̃^�C�g���ɕύX���ĉ�����
    MainForm.Caption = "�Q�[������u�����̇D�@�V���[�e�B���O��"
    '�t�H�[���̑傫�������C���̃s�N�`���{�b�N�X�ɍ��킹��
    MainForm.Width = (Crt.Width + 6) * Screen.TwipsPerPixelX
    MainForm.Height = ((Crt.Height + 24) * Screen.TwipsPerPixelY) + 300
    
'�������܂ŁB
    
    '�����\���ʒu����ʏ�̃Z���^�[�ֈړ�
    If WindowState = 0 Then
        Move (Screen.Width - MainForm.Width) / 2, (Screen.Height - MainForm.Height) / 2
    End If
        
End Sub

Private Sub Form_Unload(Cancel As Integer)
'�A�v���P�[�V�����I������
    
    '�a�f�l�t�@�C�����N���[�Y����
    BGM_CLOSE
    End
    
End Sub

Private Sub Menu001_Click()

    Menu001.Checked = Not Menu001.Checked
    
End Sub

Private Sub Menu003_Click()
'�A�v���P�[�V�����I������
    
    '�a�f�l�t�@�C�����N���[�Y����
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
