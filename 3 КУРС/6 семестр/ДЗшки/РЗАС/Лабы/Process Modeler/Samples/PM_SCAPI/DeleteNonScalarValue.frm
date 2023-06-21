VERSION 5.00
Begin VB.Form DeleteNonScalarValue 
   Caption         =   "Delete Non-Scalar Value"
   ClientHeight    =   1830
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   1830
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CancelBtn 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   3360
      TabIndex        =   3
      Top             =   1080
      Width           =   855
   End
   Begin VB.CommandButton DeleteEntirePropertyBtn 
      Caption         =   "Delete &entire property"
      Height          =   615
      Left            =   1800
      TabIndex        =   2
      Top             =   960
      Width           =   1455
   End
   Begin VB.CommandButton DeleteSelectedValueBtn 
      Caption         =   "Delete &selected property value"
      Height          =   615
      Left            =   360
      TabIndex        =   1
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "Delete the selected property value or the entire property?"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   4095
   End
End
Attribute VB_Name = "DeleteNonScalarValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' -------------------------------------------------------------
' Copyright 2004 Computer Associates International, Inc.
' All rights reserved.
'
' File: DeleteNonScalarValue.frm
'
' Description:
'   This form is used to delete either a single value from a
'   non-scalar property, or the all the values from a non-scalar
'   property.
' -------------------------------------------------------------

Public m_bDeleteSelectedValue As Boolean
Public m_bDeleteEntireProperty As Boolean

Private Sub CancelBtn_Click()
    Unload Me
End Sub

Private Sub DeleteEntirePropertyBtn_Click()
    m_bDeleteEntireProperty = True
    Unload Me
End Sub

Private Sub DeleteSelectedValueBtn_Click()
    m_bDeleteSelectedValue = True
    Unload Me
End Sub

Private Sub Form_Load()
    m_bDeleteSelectedValue = False
    m_bDeleteEntireProperty = False
End Sub
