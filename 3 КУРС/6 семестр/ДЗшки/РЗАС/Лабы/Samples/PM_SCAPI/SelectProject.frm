VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form SelectProject 
   Caption         =   "PM_SCAPI Test"
   ClientHeight    =   5310
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6645
   LinkTopic       =   "Form1"
   ScaleHeight     =   5310
   ScaleWidth      =   6645
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CreateProject 
      Caption         =   "New Project"
      Height          =   375
      Left            =   5160
      TabIndex        =   10
      Top             =   2280
      Width           =   1215
   End
   Begin VB.CommandButton OutputToFile 
      Caption         =   "&Output to File"
      Height          =   375
      Left            =   2400
      TabIndex        =   9
      Top             =   4440
      Width           =   1455
   End
   Begin VB.CommandButton View 
      Caption         =   "&View"
      Default         =   -1  'True
      Height          =   375
      Left            =   840
      TabIndex        =   8
      Top             =   4440
      Width           =   1215
   End
   Begin MSComDlg.CommonDialog fileDlg 
      Left            =   5760
      Top             =   4560
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton RemoveProject 
      Caption         =   "Remove Selected Project"
      Height          =   855
      Left            =   5160
      TabIndex        =   7
      Top             =   1320
      Width           =   1215
   End
   Begin VB.ListBox ProjectList 
      Height          =   2205
      ItemData        =   "SelectProject.frx":0000
      Left            =   240
      List            =   "SelectProject.frx":0002
      Sorted          =   -1  'True
      TabIndex        =   6
      Top             =   600
      Width           =   4695
   End
   Begin VB.CommandButton BrowseBtn2 
      Caption         =   "..."
      Height          =   375
      Left            =   5640
      TabIndex        =   5
      Top             =   3480
      Width           =   375
   End
   Begin VB.TextBox OutputFile 
      Height          =   375
      Left            =   240
      TabIndex        =   3
      Text            =   "PM_SCAPITest.txt"
      Top             =   3480
      Width           =   5295
   End
   Begin VB.CommandButton CancelBtn 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4200
      TabIndex        =   2
      Top             =   4440
      Width           =   975
   End
   Begin VB.CommandButton BrowseBtn 
      Caption         =   "Add Project"
      Height          =   375
      Left            =   5160
      TabIndex        =   1
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Output file name:"
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   3120
      Width           =   3375
   End
   Begin VB.Label Label1 
      Caption         =   "Select Process Modeler project(s):"
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   3735
   End
End
Attribute VB_Name = "SelectProject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' ------------------------------------------------------------------
' Copyright 2004 Computer Associates International, Inc.
' All rights reserved.
'
' File: SelectProject.frm
'
' Description:  This form is used to select the AllFusion Process
'   Modeler model(s) to display or to output to a file.
' ------------------------------------------------------------------


' Variables for PM_SCAPI

Dim m_scAppPtr As SCAPI.Application
Dim m_scPersistenceUnitCol As SCAPI.PersistenceUnits
Dim m_scSessionCol As SCAPI.Sessions

' Variables for Horizontal scroll
Private Declare Function SendMessageByLong Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Const LB_SETHORIZONTALEXTENT = &H194
Private Const WM_VSCROLL = &H115
Private Const SB_BOTTOM = 7
Private Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
Private Const SM_CXVSCROLL = 2

Dim m_maxWidth As Long

' Browse for a Process Modeler model
Private Sub BrowseBtn_Click()
    Dim w As Long
    Dim projFound As Boolean
    
    fileDlg.DialogTitle = "Open Process Modeler Project"
    fileDlg.Filter = "Project Files (*.bp1)|*.bp1|All Files (*.*)|*.*"
    fileDlg.Flags = &H80000
    fileDlg.ShowOpen
    
    projFound = False
    For i = 0 To ProjectList.ListCount - 1
        If (GetPMFileName(ProjectList.List(i)) = fileDlg.fileName) Then
            projFound = True
            Exit For
        End If
    Next
    
    If (projFound = False And fileDlg.fileName <> "") Then
    Dim displayName As String
        displayName = "[" + fileDlg.fileName + "]"
        
        ProjectList.AddItem (displayName)
    
        w = ProjectList.Parent.TextWidth(fileDlg.fileName)
   
        If (w > m_maxWidth) Then
            m_maxWidth = w
            SendMessageByLong ProjectList.hwnd, LB_SETHORIZONTALEXTENT, _
            w / Screen.TwipsPerPixelX + GetSystemMetrics(SM_CXVSCROLL) + 2, 0
        End If

        SendMessageByLong ProjectList.hwnd, WM_VSCROLL, SB_BOTTOM, 0
    End If
End Sub
' Browse button for text output
Private Sub BrowseBtn2_Click()
    fileDlg.DialogTitle = "PM_SCAPI Output"
    fileDlg.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    fileDlg.ShowOpen
    OutputFile.Text = fileDlg.fileName
End Sub

Private Sub CancelBtn_Click()
    Unload Me
End Sub
' Button to create a new model
Private Sub CreateProject_Click()
    NewProject.Show 1, Me
    If (NewProject.m_cancelNewProject = False) Then
        ProjectList.AddItem (NewProject.m_projectName)
        ProjectList.ItemData(ProjectList.NewIndex) = NewProject.m_modelType
    End If
End Sub

' When the form is loaded, if the client is run from within Process
' Modeler, the models that are currently open in Process Modeler
' are loaded into the selection list.  If the client is a stand-alone
' executable, the selection list is initially empty.

Private Sub Form_Load()
    Dim numUnits As Integer
    Dim persUnit As SCAPI.PersistenceUnit
    
    m_maxWidth = 0
    Set m_scAppPtr = CreateObject("ProcessModeler70.SCAPI")
    Set m_scPersistenceUnitCol = m_scAppPtr.PersistenceUnits
    Set m_scSessionCol = m_scAppPtr.Sessions
    
    ' Load open units
    numUnits = m_scPersistenceUnitCol.Count
    If (numUnits > 0) Then
        For Each persUnit In m_scPersistenceUnitCol
            Dim propBag As SCAPI.PropertyBag
            Dim displayName As String
            If (Len(persUnit.Name) > 0) Then
                Set propBag = persUnit.PropertyBag("Locator")
                displayName = persUnit.Name + " [" + propBag.Value(0) + "]"
                ProjectList.AddItem (displayName)
                ProjectList.ItemData(ProjectList.NewIndex) = -1  ' Existing model
                w = ProjectList.Parent.TextWidth(displayName)
       
                If (w > m_maxWidth) Then
                    m_maxWidth = w
                    SendMessageByLong ProjectList.hwnd, LB_SETHORIZONTALEXTENT, _
                    w / Screen.TwipsPerPixelX + GetSystemMetrics(SM_CXVSCROLL) + 2, 0
                End If
    
                SendMessageByLong ProjectList.hwnd, WM_VSCROLL, SB_BOTTOM, 0
            End If
        Next
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ' make sure all the sessions are closed
    Dim scSession As SCAPI.Session
    
    For Each scSession In m_scSessionCol
        scSession.Close
    Next

    While (m_scSessionCol.Count > 0)
        m_scSessionCol.Remove (0)
    Wend
    
    m_scAppPtr.PersistenceUnits.Clear
End Sub

' Displays the treeview of the projects in the selection list
Private Sub View_Click()
    If (ProjectList.ListCount > 0) Then
        ProjectView.Init m_scAppPtr
        For i = 0 To ProjectList.ListCount - 1
            Dim fileName As String
            fileName = GetPMFileName(ProjectList.List(i))
            If (Len(fileName) > 0) Then
                ' Existing persistence unit
                ProjectView.AddPersistenceUnit fileName, True
            Else
                Dim modelName As String
                modelName = GetPMModelName(ProjectList.List(i))
                If (Len(modelName) > 0) And ProjectList.ItemData(i) = -1 Then
                    ProjectView.AddPersistenceUnit modelName, False
                Else
                    ' New persistence unit
                    ProjectView.CreatePersistenceUnit GetPMModelName(ProjectList.List(i)), ProjectList.ItemData(i)
                    ProjectList.ItemData(i) = -1 ' Item data no longer needs to hold the model type
                End If
            End If
        Next
        ProjectView.Show 1, Me
    Else
        MsgBox ("No project(s) selected.")
    End If
End Sub

' Outputs the models in the selection list to the given file
Private Sub OutputToFile_Click()
Dim scSession As SCAPI.Session
Dim scPersistenceUnit As SCAPI.PersistenceUnit

On Error GoTo ErrExit

    If (ProjectList.ListCount > 0 And OutputFile.Text <> "") Then
        Dim bRetVal As Boolean
        
        Open OutputFile.Text For Output As #1
        TestAppFunctions
            
        For i = 0 To ProjectList.ListCount - 1
            Dim fileName As String
            
            fileName = GetPMFileName(ProjectList.List(i))

            If (Len(fileName) > 0) Then
                ' Existing persistence unit
                Set scPersistenceUnit = OpenPersistenceUnit(fileName, True)
            Else
                Dim modelName As String
                modelName = GetPMModelName(ProjectList.List(i))
                If (Len(modelName) > 0) And ProjectList.ItemData(i) = -1 Then
                    Set scPersistenceUnit = OpenPersistenceUnit(modelName, False)
                Else
                    ' new persistence unit
                    Dim propBag As New SCAPI.PropertyBag
                
                    retVal = propBag.Add("Name", GetPMModelName(ProjectList.List(i)))
                    retVal = propBag.Add("ModelType", ProjectList.ItemData(i))
                    Set scPersistenceUnit = m_scAppPtr.PersistenceUnits.Create(propBag)
                End If
            End If
            
            ' Set the SCAPI Session variables
        
            Set scSession = m_scSessionCol.Add  ' new session
            bRetVal = scSession.Open(scPersistenceUnit, SCD_SL_M0)   ' data level
        
            TestPersistenceUnitCollectionFunctions
            TestSessionFunctions scSession
        
           
        Next
        
        ' scSession.Close
        For Each scSession In m_scSessionCol
            scSession.Close
        Next

        While (m_scSessionCol.Count > 0)
            m_scSessionCol.Remove (0)
        Wend
        
        Close #1
        MsgBox ("Done.")
    Else
        MsgBox ("Filename missing or no projects selected.")
    End If
    Exit Sub
ErrExit:
   MsgBox ("PM_SCAPI Failure.  " + Err.Description)
   Close #1
End Sub

' Parses the string in the selection list to extract the filename
' of the model.
Private Function GetPMFileName(ProjectListString As String) As String
Dim bracketPos As Integer
    bracketPos = InStrRev(ProjectListString, "[")
    If (bracketPos > 0) Then
        GetPMFileName = Mid(ProjectListString, bracketPos + 1, _
             (Len(ProjectListString) - bracketPos - 1))
    Else
        GetPMFileName = ""
    End If
End Function

' Parses the string in the selection list to extract the name
' of the model.
Private Function GetPMModelName(ProjectListString As String) As String
Dim bracketPos As Integer
    bracketPos = InStrRev(ProjectListString, "[")
    If (bracketPos > 2) Then
        GetPMModelName = Left(ProjectListString, bracketPos - 2)
    Else
        GetPMModelName = ProjectListString
    End If
End Function

' Removes the selected model from the selection list.  This does
' NOT delete the model.

Private Sub RemoveProject_Click()
    Dim filePath As String
    Dim modelName As String
    Dim persUnit As SCAPI.PersistenceUnit
    Dim propBag As SCAPI.PropertyBag
    Dim closeUnit As SCAPI.PersistenceUnit
    
    Set closeUnit = Nothing
    If (ProjectList.ListIndex >= 0) Then
        filePath = GetPMFileName(ProjectList.List(ProjectList.ListIndex))
        modelName = GetPMModelName(ProjectList.List(ProjectList.ListIndex))
        
        For Each persUnit In m_scAppPtr.PersistenceUnits
            If (Len(filePath) > 0) Then   ' use filepath for the comparison
                Set propBag = persUnit.PropertyBag("Locator")
                If (StrComp(propBag.Value(0), strFileName, vbTextCompare) = 0) Then
                    Set closeUnit = persUnit
                    Exit For
                End If
            ElseIf (Len(modelName) > 0) Then
            
            End If
        Next
        If Not (closeUnit Is Nothing) Then
            If closeUnit.HasSession() Then
                ' Find the session and close it
                Dim scSession As SCAPI.Session
                For Each scSession In m_scSessionCol
                    If (scSession.PersistenceUnit.ObjectID = closeUnit.ObjectID) Then
                        scSession.Close
                        m_scSessionCol.Remove (scSession)
                        Exit For
                    End If
                Next
            End If
            m_scAppPtr.PersistenceUnits.Remove (closeUnit)
        End If
        ProjectList.RemoveItem ProjectList.ListIndex
    End If
End Sub




Public Function OpenPersistenceUnit(strFileName As String, bIsFile As Boolean) As SCAPI.PersistenceUnit
    Dim scPersistenceUnit As SCAPI.PersistenceUnit

    Dim persUnit As SCAPI.PersistenceUnit
    Dim IsExistingPU As Boolean
    IsExistingPU = False
    For Each persUnit In m_scAppPtr.PersistenceUnits
        Dim propBag As SCAPI.PropertyBag
        If (bIsFile = True) Then
            Set propBag = persUnit.PropertyBag("Locator")
            If (StrComp(propBag.Value(0), strFileName, vbTextCompare) = 0) Then
                ' this is an existing PU
                IsExistingPU = True
                Set scPersistenceUnit = persUnit
                Exit For
            End If
        Else ' compare modelname
            If (strFileName = persUnit.Name) Then
                IsExistingPU = True
                Set scPersistenceUnit = persUnit
                Exit For
            End If
        End If
    Next
    If (IsExistingPU = False) Then
        Set scPersistenceUnit = m_scAppPtr.PersistenceUnits.Add(strFileName, "RDO=Yes")
    End If

    Set OpenPersistenceUnit = scPersistenceUnit
End Function

' Function for outputting data obtained from the API
Public Sub TestAppFunctions()
        Print #1, "Application tool: ", m_scAppPtr.Name
        Print #1, "Version: ", m_scAppPtr.Version
        Print #1, "API Version: ", m_scAppPtr.ApiVersion
End Sub

' Function for outputting data obtained from the API
Public Sub TestPersistenceUnitFunctions(pUnit As SCAPI.PersistenceUnit)
        Print #1, "Persistence unit name:", pUnit.Name
        Dim id As SC_OBJID
        
        id = pUnit.ObjectID
        PrintID id
        Dim propBag As SCAPI.PropertyBag
        Set propBag = pUnit.PropertyBag("Locator;Active Model", True)
        For index = 0 To (propBag.Count - 1)
            Print #1, propBag.Name(index); ": "; propBag.Value(index)
        Next
        Print #1, ""
End Sub

' Function for outputting data obtained from the API
Public Sub TestPersistenceUnitCollectionFunctions()
    Dim pUnit As SCAPI.PersistenceUnit
    Print #1, "------------------------- Persistence Unit Collection Test -------------"
    For Each pUnit In m_scAppPtr.PersistenceUnits
        TestPersistenceUnitFunctions pUnit
    Next
End Sub

' Function for outputting data obtained from the API
Public Sub TestSessionFunctions(scSession As SCAPI.Session)
    Dim scModelObjCol As SCAPI.ModelObjects
    Dim objRoot As SCAPI.ModelObject
    Dim id As SC_OBJID
    
    Print #1, ""
    Print #1, "**************************************************************"
    Print #1, "*                   SESSION TEST                             *"
    Print #1, "**************************************************************"
    Print #1, ""
    ' Model objects
    Set scModelObjCol = scSession.ModelObjects
    
    Print #1, "Root object:"
    Set objRoot = scModelObjCol.root
    TestModelObject objRoot
    
    TestModelObjectCollection scModelObjCol
End Sub

' Function for outputting data obtained from the API
Public Sub TestModelObjectCollection(scModelObjCol As SCAPI.ModelObjects)
    Dim obj As SCAPI.ModelObject
    Dim objs As SCAPI.ModelObjects
    
    ' Test the session level collection
    Print #1, "--------------- Model Object Collection Tests ------------------"
    For Each obj In scModelObjCol
        TestModelObject obj
    Next

End Sub
' Function for outputting data obtained from the API
Public Sub TestModelObject(obj As SCAPI.ModelObject)
    Dim objParent As SCAPI.ModelObject
    
    Print #1, "******* Model Object Test *********"
    'Debug.Print "******* Model Object Test *********"
    Print #1, "Name: "; obj.Name,
    'Debug.Print obj.ClassName + "" + obj.Name
    PrintID obj.ObjectID
    Print #1, "Type: "; obj.ClassName; "   Type ID: "; obj.ClassId
    Set objParent = obj.Context
    If Not (objParent Is Nothing) Then
        Print #1, "Context: "; objParent.ClassName; " - "; objParent.Name
    End If
    Print #1, "Properties:"
    TestPropertyCollection obj
    Print #1,
End Sub

' Function for outputting data obtained from the API
Public Sub PrintID(id As SC_OBJID)
    Print #1, "Id: "; id
End Sub

' Function for outputting data obtained from the API
Public Sub TestPropertyCollection(obj As SCAPI.ModelObject)
    Dim objProperties As SCAPI.ModelProperties
    Dim objSubCollection As SCAPI.ModelProperties
    Dim objProp As SCAPI.ModelProperty
    Dim propertyString As String
    
    ' display flags
    Dim firstFlag As Boolean
    firstFlag = False
    propertyString = "Object Flags: "
    If (obj.Flags = SCD_MOF_DONT_CARE) Then
          propertyString = propertyString + "SCD_MOF_DONT_CARE"
         firstFlag = True
    End If
    If (obj.Flags And SCD_MOF_PERSISTENCE_UNIT) Then
         If (firstFlag) Then
            propertyString = propertyString + ", "
         End If
         propertyString = propertyString + "SCD_MOF_PERSISTENCE_UNIT"
         firstFlag = True
    End If
    If (obj.Flags And SCD_MOF_ROOT) Then
        If (firstFlag) Then
             propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MOF_ROOT"
        firstFlag = True
    End If
    If (obj.Flags And SCD_MOF_USER_DEFINED) Then
        If (firstFlag) Then
               propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MOF_USER_DEFINED"
        firstFlag = True
    End If
    Print #1, propertyString
    
    Set objProperties = obj.Properties
    If (obj.Properties.Count > 0) Then
        For Each objProp In objProperties
            TestProperty objProp
        Next
    End If

End Sub

' Function for outputting data obtained from the API
Public Sub TestProperty(prop As SCAPI.ModelProperty)
Dim propertyString As String
Dim firstFlag As Boolean

    Print #1, "Property name: '"; prop.ClassName; "' Id: "; prop.ClassId; " Value as string: "; prop.FormatAsString
    firstFlag = False
    propertyString = "Property flags: "
    If (prop.Flags And SCD_MPF_DONT_CARE) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_DONT_CARE"
        firstFlag = True
    End If
    If (prop.Flags And SCD_MPF_DERIVED) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_DERIVED"
        firstFlag = True
    End If
    If (prop.Flags And SCD_MPF_NULL) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_NULL"
        firstFlag = True
    End If
    If (prop.Flags And SCD_MPF_OPTIONAL) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_OPTIONAL"
        firstFlag = True
    End If
    If (prop.Flags And SCD_MPF_READ_ONLY) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_READ_ONLY"
        firstFlag = True
    End If
    If (prop.Flags And SCD_MPF_SCALAR) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_SCALAR"
        firstFlag = True
    End If
    If (prop.Flags And SCD_MPF_TOOL) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_TOOL"
        firstFlag = True
    End If
    If (prop.Flags And SCD_MPF_USER_DEFINED) Then
        If (firstFlag) Then
            propertyString = propertyString + ", "
        End If
        propertyString = propertyString + "SCD_MPF_USER_DEFINED"
        firstFlag = True
    End If

    Print #1, "     "; propertyString
    Print #1, "     Count: "; prop.Count
    If (prop.Count > 1 And prop.DataType = SCVT_NULL) Then
        Dim i As Integer
        For i = 0 To (prop.Count - 1)
            Print #1, "     SCAPI Type: "; PrintSC_Type(prop.DataType(i))
            If (IsArray(prop.Value(i))) Then
                Print #1, "    Value: (";
                For j = LBound(prop.Value(i)) To UBound(prop.Value(i))
                    Print #1, prop.Value(i)(j);
                    If (j < UBound(prop.Value(i))) Then
                        Print #1, ", ";
                    End If
                Next
                Print #1, ")"
            Else
                Print #1, "     Value: ", CStr(prop.Value(i))
            End If
        Next
    ElseIf (prop.Count >= 1) Then
        sc_Type = prop.DataType
        Print #1, "     SCAPI Type: "; PrintSC_Type(prop.DataType)
        If (IsArray(prop.Value)) Then
            Print #1, "    Value: (";
            If (NumDim(prop.Value) > 1) Then
                ' Multi-dimensional array
                For j = LBound(prop.Value, 1) To UBound(prop.Value, 1)
                    Print #1, "(";
                    For k = LBound(prop.Value, 2) To UBound(prop.Value, 2)
                        Print #1, prop.Value()(j, k);
                        If (k < UBound(prop.Value, 2)) Then
                            Print #1, ", ";
                        End If
                    Next
                    Print #1, ")";
                    If (j < UBound(prop.Value, 1)) Then
                        Print #1, ", ";
                    End If
                Next
            Else
                For j = LBound(prop.Value) To UBound(prop.Value)
                    Print #1, prop.Value(j);
                    If (j < UBound(prop.Value)) Then
                        Print #1, ", ";
                    End If
                Next
            End If
            Print #1, ")"
        Else
            Print #1, "     Value: ", CStr(prop.Value)
        End If
        
    End If
        
    TestPropertyValues prop.PropertyValues
End Sub


' Function for outputting data obtained from the API
Public Sub TestPropertyValues(propValues As SCAPI.PropertyValues)
    Dim propVal As SCAPI.PropertyValue
    Dim val1 As Variant
    Dim val2 As Variant
    
    Print #1, "     Property value iteration:"
    
    For Each propVal In propValues
        val1 = propVal.Value
        If (propVal.ValueIdType) Then
            val2 = propVal.ValueId(propVal.ValueIdType)
        Else
            val2 = propVal.ValueId
        End If
            
        Print #1, "          ------"
        Print #1, "          ValueIdType: "; PrintSC_Type(propVal.ValueIdType)
        Print #1, "          ValueType: "; PrintSC_Type(propVal.ValueType)
        Print #1, "          PropertyClassId: "; propVal.PropertyClassId
        Print #1, "          PropertyClassName: "; propVal.PropertyClassName
        If (propVal.ValueType <> SCVT_NULL) Then
            If (VarType(val1) = vbBoolean Or VarType(val1) = vbDate Or VarType(val1) = vbLong Or VarType(val1) = vbInteger) Then
                Print #1, "          Value: "; CStr(val1)
            ElseIf (propVal.ValueType = SCVT_BSTR) Then
                Print #1, "         Value: "; val1
            End If
            If (propVal.ValueIdType <> SCVT_BSTR) Then
                Print #1, "          ValueId: "; CStr(val2)
            ElseIf (propVal.ValueIdType = SCVT_BSTR) Then
                Print #1, "          ValueId: "; val2
            End If
        End If
    Next
End Sub


