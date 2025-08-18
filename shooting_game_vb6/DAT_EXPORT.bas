Attribute VB_Name = "DAT_EXPORT"

' DAT Export Utility for Unity Migration
' This module exports the binary .DAT files to JSON format

Option Explicit

' Enemy movement data structure
Type EneMoveType
    X As Single
    Y As Single
    Flag As Byte
End Type

' Enemy spawn data structure
Type EnemyHappenType
    X As Single
    Y As Single
    No As Integer
    Counter As Integer
    Power As Byte
End Type

' Global arrays
Public EneMove(0 To 20, 0 To 255) As EneMoveType
Public EneHappen(0 To 255) As EnemyHappenType

Sub ExportDATFiles()
    ' Export both .DAT files to JSON format
    
    ' Load the data files
    LoadEneMoveData
    LoadHappenData
    
    ' Export to JSON
    ExportEneMoveToJSON
    ExportHappenToJSON
    
    MsgBox "DAT files exported to JSON successfully!", vbInformation
End Sub

Sub LoadEneMoveData()
    ' Load EneMove.DAT file
    Open App.Path & "\EneMove.DAT" For Binary Access Read As #1
        Get #1, , EneMove
    Close #1
End Sub

Sub LoadHappenData()
    ' Load Happen.DAT file
    Open App.Path & "\Happen.DAT" For Binary Access Read As #1
        Get #1, , EneHappen
    Close #1
End Sub

Sub ExportEneMoveToJSON()
    ' Export enemy movement data to JSON
    Dim jsonFile As Integer
    Dim enemyType As Integer
    Dim stepIndex As Integer
    Dim flagDesc As String
    
    jsonFile = FreeFile
    Open App.Path & "\EnemyMovement.json" For Output As #jsonFile
    
    Print #jsonFile, "{"
    Print #jsonFile, "  ""enemyTypes"": ["
    
    For enemyType = 0 To 20
        Print #jsonFile, "    {"
        Print #jsonFile, "      ""enemyId"": " & enemyType & ","
        Print #jsonFile, "      ""movementPattern"": ["
        
        For stepIndex = 0 To 255
            ' Get flag description
            flagDesc = GetFlagDescription(EneMove(enemyType, stepIndex).Flag)
            
            Print #jsonFile, "        {"
            Print #jsonFile, "          ""x"": " & EneMove(enemyType, stepIndex).X & ","
            Print #jsonFile, "          ""y"": " & EneMove(enemyType, stepIndex).Y & ","
            Print #jsonFile, "          ""flag"": " & EneMove(enemyType, stepIndex).Flag & ","
            Print #jsonFile, "          ""description"": """ & flagDesc & """"
            
            If stepIndex < 255 Then
                Print #jsonFile, "        },"
            Else
                Print #jsonFile, "        }"
            End If
        Next stepIndex
        
        Print #jsonFile, "      ]"
        
        If enemyType < 20 Then
            Print #jsonFile, "    },"
        Else
            Print #jsonFile, "    }"
        End If
    Next enemyType
    
    Print #jsonFile, "  ]"
    Print #jsonFile, "}"
    
    Close #jsonFile
End Sub

Sub ExportHappenToJSON()
    ' Export enemy spawn data to JSON
    Dim jsonFile As Integer
    Dim i As Integer
    Dim desc As String
    
    jsonFile = FreeFile
    Open App.Path & "\EnemySpawn.json" For Output As #jsonFile
    
    Print #jsonFile, "{"
    Print #jsonFile, "  ""spawnPatterns"": ["
    
    For i = 0 To 255
        ' Get description based on special values
        desc = GetSpawnDescription(EneHappen(i))
        
        Print #jsonFile, "    {"
        Print #jsonFile, "      ""x"": " & EneHappen(i).X & ","
        Print #jsonFile, "      ""y"": " & EneHappen(i).Y & ","
        Print #jsonFile, "      ""enemyType"": " & EneHappen(i).No & ","
        Print #jsonFile, "      ""counter"": " & EneHappen(i).Counter & ","
        Print #jsonFile, "      ""power"": " & EneHappen(i).Power & ","
        Print #jsonFile, "      ""description"": """ & desc & """"
        
        If i < 255 Then
            Print #jsonFile, "    },"
        Else
            Print #jsonFile, "    }"
        End If
    Next i
    
    Print #jsonFile, "  ]"
    Print #jsonFile, "}"
    
    Close #jsonFile
End Sub

Function GetFlagDescription(flag As Byte) As String
    ' Convert flag value to description
    Select Case flag
        Case 1 To 10
            GetFlagDescription = "Shoot pattern " & flag
        Case 253
            GetFlagDescription = "Jump to position"
        Case 254
            GetFlagDescription = "Wait/loop"
        Case 255
            GetFlagDescription = "End enemy"
        Case Else
            GetFlagDescription = "Move"
    End Select
End Function

Function GetSpawnDescription(spawn As EnemyHappenType) As String
    ' Get description for spawn data
    Select Case spawn.No
        Case 256
            GetSpawnDescription = "Wait " & spawn.Y & " frames"
        Case 255
            GetSpawnDescription = "Return to start"
        Case Else
            If spawn.X = 700 Then
                GetSpawnDescription = "Spawn enemy type " & spawn.No & " at random X"
            Else
                GetSpawnDescription = "Spawn enemy type " & spawn.No & " at position"
            End If
    End Select
End Function 