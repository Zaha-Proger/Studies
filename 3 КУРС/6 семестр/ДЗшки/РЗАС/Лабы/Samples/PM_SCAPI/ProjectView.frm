VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Begin VB.Form ProjectView 
   Caption         =   "Project View"
   ClientHeight    =   8955
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   13065
   LinkTopic       =   "Form1"
   ScaleHeight     =   8955
   ScaleWidth      =   13065
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame PropertyOptions 
      Caption         =   "Property View Options"
      Height          =   1215
      Left            =   7680
      TabIndex        =   6
      Top             =   7560
      Width           =   4935
      Begin VB.OptionButton ViewOnlyNonScalarProperties 
         Caption         =   "View only non-scalar properties"
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   840
         Width           =   4575
      End
      Begin VB.OptionButton ViewOnlyScalarProperties 
         Caption         =   "View only scalar properties"
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   540
         Width           =   4575
      End
      Begin VB.OptionButton ViewAllProperties 
         Caption         =   "View all properties"
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   240
         Width           =   4455
      End
   End
   Begin VB.Frame ObjectOptions 
      Caption         =   "Object View Options"
      Height          =   1215
      Left            =   720
      TabIndex        =   5
      Top             =   7560
      Width           =   5655
      Begin VB.OptionButton HideUserDefined 
         Caption         =   "Hide user-defined objects"
         Height          =   315
         Left            =   240
         TabIndex        =   9
         Top             =   840
         Width           =   5055
      End
      Begin VB.OptionButton ViewOnlyUserDefined 
         Caption         =   "View only user-defined objects"
         Height          =   255
         Left            =   240
         TabIndex        =   8
         Top             =   600
         Width           =   4215
      End
      Begin VB.OptionButton ViewAllObj 
         Caption         =   "View all objects"
         Height          =   375
         Left            =   240
         TabIndex        =   7
         Top             =   240
         Width           =   4815
      End
   End
   Begin VB.ListBox InfoView 
      Height          =   6885
      Left            =   7200
      TabIndex        =   4
      Top             =   360
      Width           =   5415
   End
   Begin VB.CommandButton Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   6480
      TabIndex        =   1
      Top             =   8400
      Width           =   1095
   End
   Begin ComctlLib.TreeView ProjectTree 
      Height          =   6975
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   6495
      _ExtentX        =   11456
      _ExtentY        =   12303
      _Version        =   327682
      LineStyle       =   1
      Sorted          =   -1  'True
      Style           =   7
      Appearance      =   1
   End
   Begin VB.Label Label2 
      Caption         =   "Properties:"
      Height          =   375
      Left            =   7200
      TabIndex        =   3
      Top             =   120
      Width           =   3135
   End
   Begin VB.Label Label1 
      Caption         =   "Objects"
      Height          =   375
      Left            =   480
      TabIndex        =   2
      Top             =   120
      Width           =   975
   End
   Begin ComctlLib.ImageList TreeIcons 
      Left            =   0
      Top             =   8400
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   18
      ImageHeight     =   18
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "ProjectView.frx":0000
            Key             =   "Folder"
            Object.Tag             =   "Collection"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "ProjectView.frx":016A
            Key             =   "Project"
            Object.Tag             =   "Project"
         EndProperty
      EndProperty
   End
   Begin VB.Menu MetaClassMenu 
      Caption         =   "MetaClass Menu"
      Visible         =   0   'False
      Begin VB.Menu CreateNewObj 
         Caption         =   "Create New Object"
      End
   End
   Begin VB.Menu NodeMenu 
      Caption         =   "Node Menu"
      Visible         =   0   'False
      Begin VB.Menu CreateNewChild 
         Caption         =   "Create new child"
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_0"
            Index           =   0
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_1"
            Index           =   1
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_2"
            Index           =   2
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_3"
            Index           =   3
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_4"
            Index           =   4
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_5"
            Index           =   5
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_6"
            Index           =   6
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_7"
            Index           =   7
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_8"
            Index           =   8
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_9"
            Index           =   9
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_10"
            Index           =   10
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_11"
            Index           =   11
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_12"
            Index           =   12
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_13"
            Index           =   13
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_14"
            Index           =   14
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_15"
            Index           =   15
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_16"
            Index           =   16
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_17"
            Index           =   17
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_18"
            Index           =   18
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_19"
            Index           =   19
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_20"
            Index           =   20
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_21"
            Index           =   21
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_22"
            Index           =   22
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_23"
            Index           =   23
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_24"
            Index           =   24
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_25"
            Index           =   25
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_26"
            Index           =   26
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_27"
            Index           =   27
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_28"
            Index           =   28
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_29"
            Index           =   29
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_30"
            Index           =   30
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_31"
            Index           =   31
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_32"
            Index           =   32
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_33"
            Index           =   33
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_34"
            Index           =   34
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_35"
            Index           =   35
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_36"
            Index           =   36
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_37"
            Index           =   37
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_38"
            Index           =   38
            Visible         =   0   'False
         End
         Begin VB.Menu CreateChildMenu 
            Caption         =   "Child_type_39"
            Index           =   39
            Visible         =   0   'False
         End
      End
      Begin VB.Menu ModifyObject 
         Caption         =   "Modify Object"
      End
      Begin VB.Menu DeleteObject 
         Caption         =   "Delete Object"
      End
      Begin VB.Menu SaveModel 
         Caption         =   "Save Model"
      End
   End
End
Attribute VB_Name = "ProjectView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private m_scAppPtr As SCAPI.Application
Private m_scPersistenceUnitCol As SCAPI.PersistenceUnits
Private m_scSessionCol As SCAPI.Sessions
Private m_scMetaModelSession As SCAPI.Session

' Horizontal scroll variables
Private Declare Function SendMessageByLong Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Const LB_SETHORIZONTALEXTENT = &H194
Private Const WM_VSCROLL = &H115
Private Const SB_BOTTOM = 7
Private Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
Private Const SM_CXVSCROLL = 2




Sub Init(scAppPtr As SCAPI.Application)
    Dim scTempPU As SCAPI.PersistenceUnit
    Set m_scAppPtr = scAppPtr
    Set m_scPersistenceUnitCol = m_scAppPtr.PersistenceUnits
    Set m_scSessionCol = m_scAppPtr.Sessions
    ' Create a meta-model session for meta-model access
    Set m_scMetaModelSession = m_scSessionCol.Add  ' new session
    bRetVal = m_scMetaModelSession.Open(scTempPU, SCD_SL_M1)   ' meta-model
End Sub


Sub AddPersistenceUnit(PUName As String, bIsLocator As Boolean)
Dim scPersistenceUnit As SCAPI.PersistenceUnit
Dim persUint As SCAPI.PersistenceUnit
Dim bRetVal As Boolean
Dim IsExistingPU As Boolean

    IsExistingPU = False
    For Each persUnit In m_scPersistenceUnitCol
        If bIsLocator = True Then
            Dim propBag As SCAPI.PropertyBag
            Set propBag = persUnit.PropertyBag("Locator")
            If (StrComp(propBag.Value(0), PUName, vbTextCompare) = 0) Then
                ' this is an existing PU
                IsExistingPU = True
                Set scPersistenceUnit = persUnit
                Exit For
            End If
        Else
            If (persUnit.Name = PUName) Then ' going by the name of a model that hasn't been saved yet
                IsExistingPU = True
                Set scPersistenceUnit = persUnit
                Exit For
            End If
        End If
    Next
    If (IsExistingPU = False) Then
        Set scPersistenceUnit = m_scPersistenceUnitCol.Add(PUName, "RDO=Yes")
    End If

    Set scSession = m_scSessionCol.Add  ' new session
    bRetVal = scSession.Open(scPersistenceUnit, SCD_SL_M0)   ' data level
End Sub

Sub CreatePersistenceUnit(modelName As String, ModelType As Integer)
    Dim propBag As New SCAPI.PropertyBag
    Dim scPersistenceUnit As SCAPI.PersistenceUnit
    
    bRetVal = propBag.Add("Name", modelName)
    bRetVal = propBag.Add("ModelType", ModelType)
    Set scPersistenceUnit = m_scPersistenceUnitCol.Create(propBag)
    If (scPersistenceUnit Is Nothing) Then
        Exit Sub
    End If
    Set scSession = m_scSessionCol.Add  ' new session
    bRetVal = scSession.Open(scPersistenceUnit, SCD_SL_M0)   ' data level
End Sub

Private Sub LoadPersistenceUnitCollection()
    Dim pUnit As SCAPI.PersistenceUnit
    Dim n As Node
    Dim root As Node
    Dim scSession As SCAPI.Session
    Dim scModelObjects As SCAPI.ModelObjects
    Dim index As Integer
    
    Screen.MousePointer = vbHourglass
    
    ' Clear the tree first in case of re-load
    While (ProjectTree.Nodes.Count > 0)
        ProjectTree.Nodes.Remove (1)
    Wend
    Set root = ProjectTree.Nodes.Add(, , , "Model", "Folder")
    index = 0

    For Each scSession In m_scSessionCol
         index = index + 1
         If (scSession.Level = SCD_SL_M0) Then
             Set n = ProjectTree.Nodes.Add(root, tvwChild, scSession.PersistenceUnit.ObjectID, scSession.PersistenceUnit.Name, "Project")
             n.Sorted = True

             Set scModelObjects = scSession.ModelObjects
             LoadObjects n, scModelObjects.root, scModelObjects
             n.Tag = str(index)

         End If
    Next

    Screen.MousePointer = vbArrow
End Sub
Private Sub LoadObjects(parentNode As Node, rootObj As SCAPI.ModelObject, objCollection As SCAPI.ModelObjects)
    Dim scAllModelObjectTypes As SCAPI.ModelObjects
    Dim scModelObjectTypes As SCAPI.ModelObjects
    Dim scModelObjects As SCAPI.ModelObjects
    Dim scObjectType As SCAPI.ModelObject
    Dim scObj As SCAPI.ModelObject
    Dim objTypeNode As Node
    Dim objNode As Node
    Dim objName As String
    
    Set scAllModelObjectTypes = m_scMetaModelSession.ModelObjects
    Set scModelObjectTypes = scAllModelObjectTypes.Collect(scAllModelObjectTypes.root, "Model Object")
    For Each scObjectType In scModelObjectTypes
        If (ViewAllObj.Value = True) Then
            Set scModelObjects = objCollection.Collect(rootObj, scObjectType.ObjectID, 1)
        ElseIf (ViewOnlyUserDefined.Value = True) Then
            Set scModelObjects = objCollection.Collect(rootObj, scObjectType.ObjectID, 1, SCD_MOF_USER_DEFINED)
        ElseIf (HideUserDefined.Value = True) Then
            Set scModelObjects = objCollection.Collect(rootObj, scObjectType.ObjectID, 1, , SCD_MOF_USER_DEFINED)
        End If
        If (scModelObjects.Count > 0) Then
            Set objTypeNode = ProjectTree.Nodes.Add(parentNode, tvwChild, , scObjectType.Name, "Folder")
            For Each scObj In scModelObjects
                objName = scObj.Name
                If (objName = "") Then
                    objName = "[Unnamed " + scObjectType.Name + "]"
                Else
                    RemoveCarriageReturn objName
                End If
                Set objNode = ProjectTree.Nodes.Add(objTypeNode, tvwChild, , objName)
                objNode.Tag = scObj.ObjectID
                objNode.Sorted = True
                ' Get the children of object
                LoadObjects objNode, scObj, objCollection
            Next
        End If
    Next
    Exit Sub
End Sub


Private Sub Close_Click()
    Unload Me
End Sub

Private Sub CreateChildMenu_Click(index As Integer)
    CreateNewObject CreateChildMenu(index).Caption
End Sub

Private Sub CreateNewObj_Click()
    CreateNewObject ProjectTree.SelectedItem.Text
End Sub

Private Sub CreateNewObject(newObjType As String)
Dim scModelObjectTypes As SCAPI.ModelObjects
Dim scModelObjectType As SCAPI.ModelObject
Dim scSession As SCAPI.Session
Dim scObjCol As SCAPI.ModelObjects
Dim objID As String
Dim PUNode As Node
Dim parentIsModel As Boolean

    parentIsModel = False
    If (ProjectTree.SelectedItem <> ProjectTree.SelectedItem.root) Then
        ' retrieve the object
        objID = ""
        Set PUNode = ProjectTree.SelectedItem
        Do While (PUNode <> PUNode.root)
            If (PUNode.Parent.Text = "Model") Then
                If (objID = "") Then
                    parentIsModel = True
                End If
                Exit Do
            Else
                If (objID = "" And PUNode.Tag <> "") Then
                    objID = PUNode.Tag
                End If
                Set PUNode = PUNode.Parent
            End If
        Loop
    End If
    
    Set scSession = m_scSessionCol.Item(val(PUNode.Tag))
    If (parentIsModel) Then
        Set scObj = scSession.ModelObjects.root
    Else
        Set scObj = scSession.ModelObjects.Item(objID)
    End If
    Set ModifyObjectForm.m_scSession = scSession
    Set ModifyObjectForm.m_scChildObjs = scSession.ModelObjects.Collect(scObj, , 1)
    Set ModifyObjectForm.m_selectedNode = ProjectTree.SelectedItem
    ModifyObjectForm.m_bIsNewObject = True
    ModifyObjectForm.m_newObjType = newObjType
    ModifyObjectForm.m_scTransactionId = scSession.BeginTransaction
    ModifyObjectForm.Show 1, Me
    If (ModifyObjectForm.m_bCancel = False) Then
        ' refresh property view
        ProjectTree_NodeClick ProjectTree.SelectedItem
    End If
End Sub

Private Sub DeleteObject_Click()
    DeleteNode ProjectTree.SelectedItem
End Sub

Private Sub Form_Load()
    Set ProjectTree.ImageList = TreeIcons
    ViewAllObj.Value = True
    ViewAllProperties.Value = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
Dim scSession As SCAPI.Session

    For Each scSession In m_scSessionCol
            scSession.Close
    Next
    While (m_scSessionCol.Count > 0)
        m_scSessionCol.Remove (0)
    Wend

End Sub

Private Sub ModifyObject_Click()
Dim scSession As SCAPI.Session
Dim scObjCol As SCAPI.ModelObjects
Dim objID As String
Dim PUNode As Node
    
    If (ProjectTree.SelectedItem <> ProjectTree.SelectedItem.root) Then
        ' retrieve the object
        objID = ProjectTree.SelectedItem.Tag
        Set PUNode = ProjectTree.SelectedItem
        Do While (PUNode <> PUNode.root)
            If (PUNode.Parent.Text = "Model") Then
                Exit Do
            Else
                Set PUNode = PUNode.Parent
            End If
        Loop
    End If
    
    Set scSession = m_scSessionCol.Item(val(PUNode.Tag))
    Set scObjCol = scSession.ModelObjects
    ModifyObjectForm.m_bIsNewObject = False
    If (ProjectTree.SelectedItem = PUNode) Then
        Set ModifyObjectForm.m_scObj = scObjCol.root
    Else
        Set ModifyObjectForm.m_scObj = scObjCol.Item(objID)
    End If
    Set ModifyObjectForm.m_scSession = scSession
    Set ModifyObjectForm.m_selectedNode = ProjectTree.SelectedItem
    ModifyObjectForm.ClassType.Text = ProjectTree.SelectedItem.Parent.Text
    ModifyObjectForm.ObjectID.Text = ProjectTree.SelectedItem.Tag
    ModifyObjectForm.Show 1, Me
    If (ModifyObjectForm.m_bCancel = False) Then
        ' refresh property view
        ProjectTree_NodeClick ProjectTree.SelectedItem
    End If
End Sub

Private Sub ProjectTree_AfterLabelEdit(Cancel As Integer, NewString As String)
Dim scSession As SCAPI.Session
Dim scObjCol As SCAPI.ModelObjects
Dim scObj As SCAPI.ModelObject
Dim objID As String
Dim PUNode As Node
Dim parentIsModel As Boolean

    ' Handle editing
    parentIsModel = False
    If (ProjectTree.SelectedItem <> ProjectTree.SelectedItem.root) Then
        ' retrieve the object
        objID = ""
        Set PUNode = ProjectTree.SelectedItem
        Do While (PUNode <> PUNode.root)
            If (PUNode.Parent.Text = "Model") Then
                If (objID = "") Then
                    parentIsModel = True
                End If
                Exit Do
            Else
                If (objID = "" And PUNode.Tag <> "") Then
                    objID = PUNode.Tag
                End If
                Set PUNode = PUNode.Parent
            End If
        Loop
    End If
    
    Set scSession = m_scSessionCol.Item(val(PUNode.Tag))
    If (parentIsModel) Then
        Set scObj = scSession.ModelObjects.root
    Else
        Set scObj = scSession.ModelObjects.Item(objID)
    End If
    
    Dim transactionID As Variant
    
    transactionID = scSession.BeginTransaction
    If (scObj.Properties.HasProperty("Name")) Then
        Set nameProperty = scObj.Properties.Item("Name")
        If (Not (nameProperty Is Nothing)) Then
            nameProperty.Value = NewString
            ' refresh property view
            ProjectTree_NodeClick ProjectTree.SelectedItem
            scSession.CommitTransaction transactionID
        Else
            Cancel = True
            ' scSession.RollbackTransaction transactionID
        End If
    Else
        Cancel = True
        ' scSession.RollbackTransaction transactionID
    End If
    
End Sub


Private Sub ProjectTree_KeyDown(KeyCode As Integer, Shift As Integer)
    If (ProjectTree.SelectedItem <> ProjectTree.SelectedItem.root) Then
        If (ProjectTree.SelectedItem.Tag <> "") And (ProjectTree.SelectedItem.Parent <> ProjectTree.SelectedItem.root) Then
            If (KeyCode = vbKeyDelete) Then
                DeleteNode ProjectTree.SelectedItem
            End If
        End If
    End If
End Sub




Private Sub ProjectTree_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim objTypes As SCAPI.ModelObjects
Dim startObj As SCAPI.ModelObject
Dim objType As SCAPI.ModelObject
Static index As Integer

    If (Button = vbRightButton) And (ProjectTree.SelectedItem <> ProjectTree.SelectedItem.root) Then
        If (ProjectTree.SelectedItem.Tag = "") Then
            PopupMenu MetaClassMenu
        End If
        If (ProjectTree.SelectedItem.Tag <> "") Then
            If (ProjectTree.SelectedItem.Parent <> ProjectTree.SelectedItem.root) Then
                ' not a model
                ClassType = "Model Object"
                Set startObj = m_scMetaModelSession.ModelObjects.Item(ProjectTree.SelectedItem.Parent.Text, "Model Object")
            Else
                ' selected item is a model
                Set startObj = m_scMetaModelSession.ModelObjects.root
            End If
            Set objTypes = m_scMetaModelSession.ModelObjects.Collect(startObj, "Model Object", 1)
            If (objTypes.Count = 0) Then
                CreateNewChild.Enabled = False
                PopupMenu NodeMenu
                Exit Sub
            End If
            CreateNewChild.Enabled = True
            While (index > objTypes.Count - 1 And index >= 0)
                CreateChildMenu(index).Visible = False
                index = index - 1
            Wend
            index = 0
            For Each objType In objTypes
                CreateChildMenu(index).Caption = objType.Name
                CreateChildMenu(index).Visible = True
                index = index + 1
            Next
            PopupMenu NodeMenu
        End If
    End If
End Sub

Private Sub ProjectTree_NodeClick(ByVal Node As ComctlLib.Node)
    Dim propertyString As String
    Dim objID As String
    Dim PUNode As Node
    Dim scSession As SCAPI.Session
    Dim scObjCol As SCAPI.ModelObjects
    Dim scObj As SCAPI.ModelObject
    Dim scObjProperties As SCAPI.ModelProperties
    Dim scObjProp As SCAPI.ModelProperty
    Dim scPropValue As SCAPI.PropertyValue
    Dim maxString As String
    Dim bIsModel As Boolean
    
    Dim w As Long
    InfoView.Clear
    maxString = ""
    If (Node.Tag = "") Then
        InfoView.AddItem (Node.Text)
        maxString = Node.Text
    Else
        'Make sure that this isn't at the model level
        If (Node <> Node.root) And (Node.Parent.Text <> "Model") Then
            ' retrieve the object
            objID = Node.Tag
            Set PUNode = Node.Parent
            Do While (PUNode <> PUNode.root)
                If (PUNode.Parent.Text = "Model") Then
                       Exit Do
                Else
                    Set PUNode = PUNode.Parent
                End If
            Loop
            bIsModel = False
        Else
            Set PUNode = Node
            bIsModel = True
        End If
            
        Set scSession = m_scSessionCol.Item(val(PUNode.Tag))
        Set scObjCol = scSession.ModelObjects
        If (bIsModel = True) Then
            Set scObj = scObjCol.root
        Else
            Set scObj = scObjCol.Item(objID)
        End If
           
        ' ----------- Display the SCAPI Object properties -------------
        propertyString = "Object ID: " + scObj.ObjectID
        InfoView.AddItem (propertyString)
        If (Len(propertyString) > Len(maxString)) Then
            If (Len(propertyString) > 4000000) Then
                maxString = Left(propertyString, 10000)
            Else
                maxString = propertyString
            End If
        End If
            
        propertyString = "Class: " + scObj.ClassName
        InfoView.AddItem (propertyString)
        If (Len(propertyString) > Len(maxString)) Then
            If (Len(propertyString) > 4000000) Then
                maxString = Left(propertyString, 10000)
            Else
                maxString = propertyString
            End If
        End If
            
        propertyString = "Class ID: " + scObj.ClassId
        InfoView.AddItem (propertyString)
        If (Len(propertyString) > Len(maxString)) Then
            If (Len(propertyString) > 4000000) Then
                maxString = Left(propertyString, 10000)
            Else
                maxString = propertyString
            End If
        End If
        
        Dim firstFlag As Boolean
        firstFlag = False
        propertyString = "Object Flags: "
        If (scObj.Flags = SCD_MOF_DONT_CARE) Then
            propertyString = propertyString + "SCD_MOF_DONT_CARE"
            firstFlag = True
        End If
        If (scObj.Flags And SCD_MOF_PERSISTENCE_UNIT) Then
            If (firstFlag) Then
                propertyString = propertyString + ", "
            End If
            propertyString = propertyString + "SCD_MOF_PERSISTENCE_UNIT"
            firstFlag = True
        End If
        If (scObj.Flags And SCD_MOF_ROOT) Then
            If (firstFlag) Then
                propertyString = propertyString + ", "
            End If
            propertyString = propertyString + "SCD_MOF_ROOT"
            firstFlag = True
        End If
        If (scObj.Flags And SCD_MOF_USER_DEFINED) Then
            If (firstFlag) Then
                propertyString = propertyString + ", "
            End If
            propertyString = propertyString + "SCD_MOF_USER_DEFINED"
            firstFlag = True
        End If
        InfoView.AddItem (propertyString)
        If (Len(propertyString) > Len(maxString)) Then
            If (Len(propertyString) > 4000000) Then
                maxString = Left(propertyString, 10000)
            Else
                maxString = propertyString
            End If
        End If
        
            
        ' ----------- Display the Object Specific properties -------------
        InfoView.AddItem ("-----------------------------------------")
        InfoView.AddItem ("Object specific properties:")
        If (ViewAllProperties.Value = True) Then
            Set scObjProperties = scObj.Properties
        ElseIf (ViewOnlyScalarProperties.Value = True) Then
            Set scObjProperties = scObj.CollectProperties(, SCD_MPF_SCALAR)
        ElseIf (ViewOnlyNonScalarProperties.Value = True) Then
            Set scObjProperties = scObj.CollectProperties(, , SCD_MPF_SCALAR)
        End If
        If (scObjProperties.Count > 0) Then

            For Each scObjProp In scObjProperties
                If (CanDisplayProp(scSession, scObj, scObjProp.ClassName) = True) Then   ' check if this is a UDPValue
                     propertyString = scObjProp.ClassName + " [" + PrintSC_Type(scObjProp.DataType) + "]"
                     If (scObjProp.Flags And SCD_MPF_SCALAR) Then
                         propertyString = propertyString + " (Scalar): "
                     Else
                         propertyString = propertyString + " (Non-Scalar): "
                     End If
                     If (scObjProp.Count > 1) Then
                         ' Non-scalar
                         InfoView.AddItem (propertyString)
                         For Each scPropValue In scObjProp.PropertyValues
                             If (IsArray(scPropValue.Value)) Then
                                 propertyString = "     ("
                                 For j = LBound(scPropValue.Value) To UBound(scPropValue.Value)
                                    propertyString = propertyString + CStr(scPropValue.Value()(j))
                                    If (j < UBound(scPropValue.Value)) Then
                                         propertyString = propertyString + ","
                                    End If
                                       
                                 Next
                                 propertyString = propertyString + ")"
                                 RemoveCarriageReturn propertyString
                                 InfoView.AddItem (propertyString)
                                 If (Len(propertyString) > Len(maxString)) Then
                                     If (Len(propertyString) > 4000000) Then
                                         maxString = Left(propertyString, 10000)
                                     Else
                                         maxString = propertyString
                                     End If
                                 End If
                             Else
                                 If (scPropValue.ValueIdType = SCVT_BSTR) Then
                                     propertyString = "     " + scPropValue.ValueId(SCVT_BSTR) + ": " + CStr(scPropValue.Value)
                                 Else
                                     propertyString = "     " + CStr(scPropValue.Value)
                                 End If
                                 RemoveCarriageReturn propertyString
                                 InfoView.AddItem (propertyString)
                                 If (Len(propertyString) > Len(maxString)) Then
                                     If (Len(propertyString) > 4000000) Then
                                         maxString = Left(propertyString, 10000)
                                     Else
                                         maxString = propertyString
                                     End If
                                 End If
                             End If
                        Next
                     Else     ' If (scObjProp.Count <= 1) Then
                         If (IsArray(scObjProp.Value)) Then
                             InfoView.AddItem (propertyString)
                             For j = LBound(scObjProp.Value) To UBound(scObjProp.Value)
                                 propertyString = "     " + scObjProp.Value(j)
                                 RemoveCarriageReturn propertyString
                                 InfoView.AddItem (propertyString)
                                 If (Len(propertyString) > Len(maxString)) Then
                                     If (Len(propertyString) > 4000000) Then
                                         maxString = Left(propertyString, 10000)
                                     Else
                                         maxString = propertyString
                                     End If
                                 End If
                             Next
                         Else
                             propertyString = propertyString + CStr(scObjProp.Value)
                             RemoveCarriageReturn propertyString
                             InfoView.AddItem (propertyString)
                             If (Len(propertyString) > Len(maxString)) Then
                                 If (Len(propertyString) > 4000000) Then
                                     maxString = Left(propertyString, 10000)
                                 Else
                                     maxString = propertyString
                                 End If
                             End If
                         End If
                    End If  'If (scObjProp.Count > 1) Then
                End If ' If property can be displayed
            Next
        End If
        
    End If
    On Error GoTo ExitSub
    
    w = InfoView.Parent.TextWidth(maxString)

    SendMessageByLong InfoView.hwnd, LB_SETHORIZONTALEXTENT, _
    w / Screen.TwipsPerPixelX + GetSystemMetrics(SM_CXVSCROLL) + 2, 0

    SendMessageByLong InfoView.hwnd, WM_VSCROLL, SB_BOTTOM, 0
ExitSub:
End Sub



Private Sub SaveModel_Click()
    Dim objID As String
    Dim PUNode As Node
    Dim scSession As SCAPI.Session
    Dim scPUnit As SCAPI.PersistenceUnit

    Set Node = ProjectTree.SelectedItem

    'Make sure that this isn't at the model level
    If (Node <> Node.root) And (Node.Parent.Text <> "Model") Then
        ' retrieve the object
        objID = Node.Tag
        Set PUNode = Node.Parent
        Do While (PUNode <> PUNode.root)
            If (PUNode.Parent.Text = "Model") Then
                   Exit Do
            Else
                Set PUNode = PUNode.Parent
            End If
        Loop
        bIsModel = False
    Else
        Set PUNode = Node
    End If
        
    Set scSession = m_scSessionCol.Item(val(PUNode.Tag))
    Set scPUnit = scSession.PersistenceUnit
    Dim propBag As SCAPI.PropertyBag
    Set propBag = scPUnit.PropertyBag("Locator")
    scPUnit.Save propBag.Value(0)
End Sub

Private Sub ViewAllObj_Click()
    LoadPersistenceUnitCollection
End Sub

Private Sub HideUserDefined_Click()
    LoadPersistenceUnitCollection
End Sub


Private Sub ViewOnlyUserDefined_Click()
    LoadPersistenceUnitCollection
End Sub

Private Sub DeleteNode(ByVal delNode As Node)
    Dim objID As String
    Dim PUNode As Node
    Dim scSession As SCAPI.Session
    Dim scObjCol As SCAPI.ModelObjects
    Dim bIsModel As Boolean
    Dim transactionID As Variant
    

    If (delNode <> delNode.root) And (delNode.Parent.Text <> "Model") Then
        ' retrieve the object
        objID = delNode.Tag
        Set PUNode = delNode.Parent
        Do While (PUNode <> PUNode.root)
            If (PUNode.Parent.Text = "Model") Then
                   Exit Do
            Else
                Set PUNode = PUNode.Parent
            End If
        Loop
        bIsModel = False
    Else
        Set PUNode = delNode
        bIsModel = True
    End If
        
    Set scSession = m_scSessionCol.Item(val(PUNode.Tag))
    Set scObjCol = scSession.ModelObjects
    transactionID = scSession.BeginTransaction
    If (bIsModel = True) Then
        bRetVal = scObjCol.Remove(root.ObjectID)
    Else
        bRetVal = scObjCol.Remove(objID)
    End If
    
    scSession.CommitTransaction transactionID
    
    If (bRetVal) Then
        ProjectTree.Nodes.Remove (delNode.index)
    Else
        MsgBox ("Could not delete object")
    End If
    
End Sub

