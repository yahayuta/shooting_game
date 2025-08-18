Attribute VB_Name = "���p�֐�"
'�a�f�l�����t�����ǂ����̃t���O
Public BGM_Flag As Boolean

Sub BGM_OPEN(Filename As String)

    '�w�肳�ꂽ�t�@�C�����I�[�v������
    Ret = mciSendString("close MIDI notify", vbNullString, 0, 0)
    Ret = mciSendString("open " & App.Path + "\" + Filename & " alias MIDI", vbNullString, 0, 0)
    
End Sub
Sub BGM_CLOSE()
    
    '�I�[�v�����Ă���t�@�C�������
    Ret = mciSendString("close MIDI notify", vbNullString, 0, 0)

End Sub
Sub BGM_Play()
    
    '�J���Ă���t�@�C�����Đ�����
    BGM_Flag = True
    Ret = mciSendString("play MIDI notify", vbNullString, 0, 0)

End Sub
Sub BGM_Stop()
    
    '���t���̃t�@�C�����~����
    BGM_Flag = False
    Ret = mciSendString("stop MIDI notify", vbNullString, 0, 0)
    
End Sub
Sub Wave_Play(Filename As String)
    
    '���ʉ��̍Đ�
    Ret = mciSendString("close WAVE notify", vbNullString, 0, 0)
    Ret = mciSendString("open " & App.Path + "\" + Filename & " alias WAVE", vbNullString, 0, 0)
    Ret = mciSendString("play WAVE notify", vbNullString, 0, 0)

End Sub
Sub Sound_Play(Filename As String)
    
    '�T�E���h���ʉ��̍Đ��@�v�������Q�o�������ƈႢ�A���Đ����\�ł���
    sndPlaySound AppPath & "\" & Filename, Snd_Async Or Snd_Nodefault

End Sub

Sub Wait(Wait_Time As Long)
'�`�o�h�ŃE�F�C�g�֐�
    
    '�g�p����ϐ��̒�`
    Dim Start_Time As Long
    
    '�v�������J�n���̎��Ԃ��擾
    Start_Time = timeGetTime()
    Do
        DoEvents    '���̏��������s
        
        '�ݒ莞�ԓ��B�̃`�F�b�N
        If timeGetTime() - Start_Time > Wait_Time Then
            '���B�����烋�[�v�𔲂���
            Exit Do
        End If
    Loop

End Sub

Function Stick()

'�r���������֐�
'
'   �߂�l�̓��e
'
'   �O��������Ă��Ȃ�
'   �P����@�F�@�Q���E��F�@�R���E�@�F�@�S���E��
'   �T�����@�F�@�U�������F�@�V�����@�F�@�W������
'

    '�g�p����ϐ��̒�`
    Dim Key_Tmp As String
    Key_Tmp = 0
    
    '�ʏ�̂S�����̃`�F�b�N
    If GetAsyncKeyState(vbKeyUp) Then Key_Tmp = 1
    If GetAsyncKeyState(vbKeyRight) Then Key_Tmp = 3
    If GetAsyncKeyState(vbKeyDown) Then Key_Tmp = 5
    If GetAsyncKeyState(vbKeyLeft) Then Key_Tmp = 7
    
    '�΂ߕ����̃`�F�b�N
    If GetAsyncKeyState(vbKeyUp) And GetAsyncKeyState(vbKeyRight) Then Key_Tmp = 2
    If GetAsyncKeyState(vbKeyUp) And GetAsyncKeyState(vbKeyLeft) Then Key_Tmp = 8
    If GetAsyncKeyState(vbKeyDown) And GetAsyncKeyState(vbKeyRight) Then Key_Tmp = 4
    If GetAsyncKeyState(vbKeyDown) And GetAsyncKeyState(vbKeyLeft) Then Key_Tmp = 6
    
    '���͂���Ă��������߂�l�Ƃ��ĕԂ�
    Stick = Key_Tmp
    
    '���̓��͂̈׃L�[�̃N���A
    GetAsyncKeyState (vbKeyUp)
    GetAsyncKeyState (vbKeyRight)
    GetAsyncKeyState (vbKeyDown)
    GetAsyncKeyState (vbKeyLeft)

End Function
