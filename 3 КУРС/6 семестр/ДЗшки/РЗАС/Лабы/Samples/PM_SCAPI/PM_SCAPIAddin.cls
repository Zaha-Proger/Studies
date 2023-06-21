VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "PM_SCAPIAddin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' ---------------------------------------------------------------
' Copyright 2004 Computer Associates International, Inc.
' All rights reserved.
'
' File: PM_SCAPIAddin.cls
'
' Description:  This module is the entry point for the client.
'   The Run function is called from within Process Modeler.
' ----------------------------------------------------------------


Public Function Run()
On Error GoTo ErrExit

Dim msg As String
Dim title As String

msg = "This is an example program and allows dangerous editing of models that can result in damaged models and/or crashing. If you have unsaved work, you should save it before continuing. Do you want to continue?"   ' Define message.
title = "AllFusion Process Modeler PM_SCAPI Example Application"   ' Define title.
' Display message.
response = MsgBox(msg, 4, title)
If response = 7 Then   ' User chose No.
   Exit Function ' Perform some action.
End If

    SelectProject.Show 1
    Exit Function
ErrExit:
    MsgBox (Err.Description)
End Function


' To run in C++:
' _PM_SCAPIAddinPtr addinPtr;
' HRESULT hr = addinPtr.CreateInstance("PM_SCAPI70_AddinDLL.PM_SCAPIAddin");
' if (SUCCEEDED(hr))
'      addinPtr->Run();
