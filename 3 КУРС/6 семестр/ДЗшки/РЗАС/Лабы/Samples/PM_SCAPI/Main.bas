Attribute VB_Name = "StartModule"
' ------------------------------------------------------------------
' Copyright 2004 Computer Associates International, Inc.
' All rights reserved.
'
' File: Main.bas
'
' Description:  This module is the starting point for the sample API
'   stand-alone client.
' ------------------------------------------------------------------


Sub Main()

    msg = "This is an example program and allows dangerous editing of models that can result in damaged models and/or crashing. If you have unsaved work, you should save it before continuing. Do you want to continue?"   ' Define message.
    Title = "AllFusion Process Modeler PM_SCAPI Example Application"   ' Define title.
    ' Display message.
    response = MsgBox(msg, 4, Title)
    If response = 7 Then   ' User chose No.
       Exit Sub ' Perform some action.
    End If
    
    SelectProject.Show 1
    End
End Sub
