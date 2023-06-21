VERSION 5.00
Begin VB.Form NewProject 
   Caption         =   "New Project"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame ModelType 
      Caption         =   "Model Type"
      Height          =   1335
      Left            =   360
      TabIndex        =   4
      Top             =   1320
      Width           =   3855
      Begin VB.OptionButton IDEF3Type 
         Caption         =   "IDEF3"
         Height          =   255
         Left            =   240
         TabIndex        =   7
         Top             =   960
         Width           =   3255
      End
      Begin VB.OptionButton DFDType 
         Caption         =   "DFD"
         Height          =   255
         Left            =   240
         TabIndex        =   6
         Top             =   600
         Width           =   3495
      End
      Begin VB.OptionButton IDEF0Type 
         Caption         =   "IDEF0"
         Height          =   255
         Left            =   240
         TabIndex        =   5
         Top             =   240
         Width           =   3375
      End
   End
   Begin VB.CommandButton CancelBtn 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   2400
      TabIndex        =   3
      Top             =   2760
      Width           =   1215
   End
   Begin VB.CommandButton OKBtn 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1080
      TabIndex        =   2
      Top             =   2760
      Width           =   1095
   End
   Begin VB.TextBox ProjectName 
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   720
      Width           =   3855
   End
   Begin VB.Label Label1 
      Caption         =   "Enter name for new project:"
      Height          =   375
      Left            =   360
      TabIndex        =   1
      Top             =   240
      Width           =   3855
   End
End
Attribute VB_Name = "NewProject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' ---------------------------------------------------------------
' Copyright 2004 Computer Associates International, Inc.
' All rights reserved.
'
' File: NewProject.frm
'
' Description:
'   This form is used to create a new model in Process Modeler.
' ---------------------------------------------------------------



Public m_projectName As String
Public m_cancelNewProject As Boolean
Public m_modelType As Integer

Private Sub CancelBtn_Click()
    m_cancelNewProject = True
    Unload Me
End Sub

Private Sub Form_Load()
    IDEF0Type.Value = True
End Sub

Private Sub OKBtn_Click()
    m_cancelNewProject = False
    m_projectName = ProjectName.Text
    If (IDEF0Type.Value = True) Then
        m_modelType = 0
    ElseIf (DFDType.Value = True) Then
        m_modelType = 1
    ElseIf (IDEF3Type.Value = True) Then
        m_modelType = 2
    End If
    Unload Me
End Sub
