VERSION 5.00
Begin VB.Form ReallocateArrayForm 
   Caption         =   "Reallocate Array"
   ClientHeight    =   2820
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4065
   LinkTopic       =   "Form1"
   ScaleHeight     =   2820
   ScaleWidth      =   4065
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CancelBtn 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   2040
      TabIndex        =   4
      Top             =   2160
      Width           =   855
   End
   Begin VB.CommandButton OKBtn 
      Caption         =   "&OK"
      Height          =   375
      Left            =   840
      TabIndex        =   3
      Top             =   2160
      Width           =   975
   End
   Begin VB.TextBox NumElements 
      BeginProperty DataFormat 
         Type            =   1
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1033
         SubFormatType   =   1
      EndProperty
      Height          =   375
      Left            =   360
      TabIndex        =   2
      Top             =   720
      Width           =   735
   End
   Begin VB.Label Label2 
      Caption         =   "Clicking on OK will delete the existing array and replace it with an array of the new size with no data."
      Height          =   735
      Left            =   360
      TabIndex        =   1
      Top             =   1320
      Width           =   3495
   End
   Begin VB.Label Label1 
      Caption         =   "Enter the number of elements for the new array:"
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   3855
   End
End
Attribute VB_Name = "ReallocateArrayForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' -----------------------------------------------------------------
' Copyright 2004 Computer Associates International, Inc.
' All rights reserved.
'
' File: ReallocateArrayFrom.frm
'
' Description:
'   This form is used when a data is added to a non-scalar property
'   value.
' -----------------------------------------------------------------


Public m_numElements As Integer ' number of elements in the array
Public m_bCancel As Boolean  ' whether or not the user canceled the dialog


Private Sub CancelBtn_Click()
    m_bCancel = True
    Unload Me
End Sub

Private Sub Form_Load()
    m_numElements = 0
End Sub

Private Sub OKBtn_Click()
    m_numElements = val(NumElements.Text)
    m_bCancel = False
    Unload Me
End Sub
