VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form ModifyObjectForm 
   Caption         =   "Modify Object"
   ClientHeight    =   6840
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   7965
   LinkTopic       =   "Form1"
   ScaleHeight     =   6840
   ScaleWidth      =   7965
   StartUpPosition =   3  'Windows Default
   Begin MSFlexGridLib.MSFlexGrid PropertyGrid 
      Height          =   4815
      Left            =   240
      TabIndex        =   7
      Top             =   1200
      Width           =   7455
      _ExtentX        =   13150
      _ExtentY        =   8493
      _Version        =   393216
      Cols            =   4
      FixedCols       =   3
   End
   Begin VB.TextBox Text1 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   6480
      TabIndex        =   6
      Text            =   "Text1"
      Top             =   6360
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton OKBtn 
      Caption         =   "&OK"
      Height          =   375
      Left            =   2655
      TabIndex        =   5
      Top             =   6240
      Width           =   1215
   End
   Begin VB.CommandButton CancelBtn 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4095
      TabIndex        =   4
      Top             =   6240
      Width           =   1215
   End
   Begin VB.TextBox ObjectID 
      Enabled         =   0   'False
      Height          =   375
      Left            =   1080
      TabIndex        =   3
      Top             =   600
      Width           =   4815
   End
   Begin VB.TextBox ClassType 
      Enabled         =   0   'False
      Height          =   375
      Left            =   1080
      TabIndex        =   2
      Top             =   120
      Width           =   4815
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   7920
      Y1              =   0
      Y2              =   0
   End
   Begin VB.Label Label2 
      Caption         =   "Object ID:"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   600
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Class:"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   735
   End
   Begin VB.Menu PropertyValMenu 
      Caption         =   "Edit"
      Begin VB.Menu ReallocateArray 
         Caption         =   "Reallocate array"
      End
      Begin VB.Menu DeleteProperty 
         Caption         =   "Delete"
      End
   End
End
Attribute VB_Name = "ModifyObjectForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public m_bCancel As Boolean
Public m_scObj As SCAPI.ModelObject ' object being created or modified
Public m_selectedNode As Node

' Variables for creating new object
Public m_bIsNewObject As Boolean
Public m_scChildObjs As SCAPI.ModelObjects
Public m_newObjType As String

Public m_scSession As SCAPI.Session

Public m_scTransactionId As Variant

Const ASC_ENTER = 13        ' ASCII code of ENTER key.
Dim gRow As Integer
Dim gCol As Integer



Private Sub DeleteProperty_Click()
Dim propName As String
Dim modelProp As SCAPI.ModelProperty
Dim bRetVal As Boolean
Dim index As Long

    m_scTransactionId = m_scSession.BeginTransaction
    
    bRetVal = False
    PropertyGrid.Col = 0 ' Name
    propName = PropertyGrid.Text
    PropertyGrid.Col = 1 ' Scalar
    If PropertyGrid.Text = "Y" Then
        bRetVal = m_scObj.Properties.Remove(propName)
    Else
        DeleteNonScalarValue.Show 1, Me
        If (DeleteNonScalarValue.m_bDeleteEntireProperty) Then
            bRetVal = m_scObj.Properties.Remove(propName)
        End If
        If (DeleteNonScalarValue.m_bDeleteSelectedValue) Then
            Set modelProp = m_scObj.Properties.Item(propName)
            PropertyGrid.Col = 2 ' Index
            index = val(PropertyGrid.Text)
            If (str(index) <> PropertyGrid.Text) Then ' index is already a string
                bRetVal = modelProp.RemoveValue(PropertyGrid.Text)
            Else
                bRetVal = modelProp.RemoveValue(index)
            End If
        End If
        
    End If
    
    If (bRetVal) Then
        currentRow = PropertyGrid.Row     ' save the old row
        LoadPropertiesInGrid
        PropertyGrid.Row = currentRow
        PropertyGrid.Col = 3
        Text1.Text = PropertyGrid.Text
    Else
        MsgBox ("Could not delete property.")
    End If
    
End Sub

Private Sub Form_Load()

    m_bDelete = False
    PropertyGrid.Rows = 2
    PropertyGrid.Cols = 4
    PropertyGrid.ColWidth(0) = 10 * (PropertyGrid.Width / 32)
    PropertyGrid.ColWidth(1) = 3 * (PropertyGrid.Width / 32)
    PropertyGrid.ColWidth(2) = 5 * (PropertyGrid.Width / 32)
    PropertyGrid.ColWidth(3) = 14 * (PropertyGrid.Width / 32)
    PropertyGrid.Row = 0
    PropertyGrid.Col = 0
    PropertyGrid.Text = "Property Name"
    PropertyGrid.Col = 1
    PropertyGrid.Text = "Scalar"
    PropertyGrid.Col = 2
    PropertyGrid.Text = "Index"
    PropertyGrid.Col = 3
    PropertyGrid.Text = "Value"
    
    If (m_bIsNewObject) Then
        Me.Caption = "Create New Object"
        Set m_scObj = Nothing
        ' Load empty properties for the meta-object
        Set m_scObj = m_scChildObjs.Add(m_newObjType)
        ClassType.Text = m_newObjType
        ObjectID.Text = m_scObj.ObjectID
    End If
    
    
    If (m_scObj Is Nothing) Then
        Exit Sub
    End If
    
    LoadPropertiesInGrid
    
    ReallocateArray.Enabled = False
    DeleteProperty.Enabled = False
    
End Sub

Private Sub LoadPropertiesInGrid()

    Dim rowNum As Integer
    Dim colNum As Integer
    
    rowNum = 1
    numRows = 1
    
    
    ' Load the properties
    Dim scObjProperties As SCAPI.ModelProperties
    Dim scObjProp As SCAPI.ModelProperty
    Dim propertyString As String
    
    Set scObjProperties = m_scObj.Properties
    If (scObjProperties.Count > 0) Then
        If (m_scObj.ClassName = "PMUDPValue") Then
            numRows = 2
        Else
            numRows = scObjProperties.Count + 1
            ' Calculate the number of rows needed
            For Each scObjProp In scObjProperties
                If (scObjProp.Count > 1) Then
                    numRows = numRows + scObjProp.Count
                End If
            Next
        End If
        
        ' Remove excess rows if necessary
        If (PropertyGrid.Rows > numRows) Then
            numRemoveRows = PropertyGrid.Rows - 1
            For i = numRows To numRemoveRows
                PropertyGrid.RemoveItem (PropertyGrid.Rows - 1)
            Next
        End If
        PropertyGrid.Rows = numRows
        ' Fill in the property values
        For Each scObjProp In scObjProperties
            If (CanDisplayProp(m_scSession,m_scObj, scObjProp.ClassName)) Then  ' Check if this is a UPDValue
                 PropertyGrid.Row = rowNum
                 If (scObjProp.Count > 1) Then
                     ' Non-scalar
                     Dim scPropValue As SCAPI.PropertyValue
                     index = 0
                     For Each scPropValue In scObjProp.PropertyValues
                         PropertyGrid.Row = rowNum
                         PropertyGrid.Col = 0   ' Name
                         PropertyGrid.Text = scObjProp.ClassName
                         PropertyGrid.Col = 1   ' IsScalar
                         If (scObjProp.Flags And SCD_MPF_SCALAR) Then
                             PropertyGrid.Text = "Y"
                         Else
                             PropertyGrid.Text = "N"
                         End If
                         If (IsArray(scPropValue.Value)) Then
                             PropertyGrid.Col = 2   ' Index
                             PropertyGrid.Text = CStr(index)
                             propertyString = "("
                             For j = LBound(scPropValue.Value) To UBound(scPropValue.Value)
                                propertyString = propertyString + CStr(scPropValue.Value()(j))
                                If (j < UBound(scPropValue.Value)) Then
                                     propertyString = propertyString + ","
                                End If
                             Next
                             propertyString = propertyString + ")"
                             RemoveCarriageReturn propertyString
                             PropertyGrid.Col = 3 '  Value
                             PropertyGrid.CellAlignment = 1
                             PropertyGrid.Text = propertyString
                         Else
                             PropertyGrid.Col = 2   ' Index
                             If (scPropValue.ValueIdType = SCVT_BSTR) Then
                                 PropertyGrid.Text = scPropValue.ValueId(SCVT_BSTR)
                             Else
                                 PropertyGrid.Text = CStr(index)
                             End If
                             propertyString = CStr(scPropValue.Value)
                             RemoveCarriageReturn propertyString
                             PropertyGrid.Col = 3  ' Value
                             PropertyGrid.CellAlignment = 1
                             PropertyGrid.Text = propertyString
                         End If
                         index = index + 1
                         rowNum = rowNum + 1
                    Next
                 Else ' If (scObjProp.Count <= 1) Then
                     PropertyGrid.Col = 0   ' Name
                     PropertyGrid.Text = scObjProp.ClassName
                     PropertyGrid.Col = 1   ' IsScalar
                     If (scObjProp.Flags And SCD_MPF_SCALAR) Then
                         PropertyGrid.Text = "Y"
                     Else
                         PropertyGrid.Text = "N"
                     End If
                     
                     If (IsArray(scObjProp.Value)) Then
                             PropertyGrid.Col = 2   ' Index
                             PropertyGrid.Text = "0"
                             propertyString = ""
                             For j = LBound(scObjProp.Value) To UBound(scObjProp.Value)
                                propertyString = propertyString + CStr(scObjProp.Value()(j))
                             Next
                     Else
                         PropertyGrid.Col = 2 ' Index
                         PropertyGrid.Text = ""
                         propertyString = CStr(scObjProp.Value)
                     End If
                     PropertyGrid.Col = 3 ' Value
                     PropertyGrid.CellAlignment = 1
                     RemoveCarriageReturn propertyString
                     PropertyGrid.Text = propertyString
                     rowNum = rowNum + 1
                End If
            End If ' If property can be displayed
        Next
    End If

End Sub



Private Sub CancelBtn_Click()
    ' ********** ROLLBACK TRANSACTIONS HERE
    If (IsEmpty(m_scTransactionId) = False) Then
        m_scSession.RollbackTransaction m_scTransactionId
    End If
    If (m_bIsNewObject) Then
        m_scChildObjs.Remove m_scObj
        ' **** Remove m_scObj here
    End If
    m_bCancel = True
    Unload Me
End Sub
Private Sub OKBtn_Click()
Dim objName As String
    If (IsEmpty(m_scTransactionId) = False) Then
        m_scSession.CommitTransaction m_scTransactionId
    End If

    m_bCancel = False
    '   ********** COMMIT TRANSACTIONS HERE
    ' If a new object was created, add it to the tree
    objName = m_scObj.Name
    If (objName = "") Then
       objName = "[Unnamed " + m_scObj.ClassName + "]"
    Else
       RemoveCarriageReturn objName
    End If
    
    If (m_bIsNewObject) Then
        Dim newNode As Node
        Dim parentNode As Node
        
        If (m_selectedNode.Tag = "") Then
            Set parentNode = m_selectedNode
        Else
            ' find the folder that's going to be the parent node.  if
            ' one does not exist, create one
            Set parentNode = Nothing
            If (m_selectedNode.Children > 0) Then
                Dim objTypeFolder As Node
                bFound = False
                Set objTypeFolder = m_selectedNode.Child
                Do
                    If (objTypeFolder.Text = m_newObjType) Then
                        Set parentNode = objTypeFolder
                        Exit Do
                    End If
                    If (objTypeFolder = objTypeFolder.LastSibling) Then
                        Exit Do
                    End If
                    Set objTypeFolder = objTypeFolder.Next
                Loop
            End If
            If (parentNode Is Nothing) Then
                ' create the parent node
                Set parentNode = ProjectView.ProjectTree.Nodes.Add(m_selectedNode, tvwChild, , m_newObjType, "Folder")
            End If
        End If
        Set newNode = ProjectView.ProjectTree.Nodes.Add(parentNode, tvwChild, , objName)
        newNode.Tag = m_scObj.ObjectID
        newNode.Sorted = True
    Else
        ' Check if there was a name change
        If (objName <> m_selectedNode.Text) Then
            m_selectedNode.Text = objName
        End If
    End If

    
    Unload Me
End Sub

Private Sub PropertyGrid_Click()
Dim propName As String
Dim propValue As String
      
      If (PropertyGrid.Col <> 3) Then
        Exit Sub ' not in correct column
      End If
    
      PropertyGrid.Col = 0
      propName = PropertyGrid.Text
      PropertyGrid.Col = 3
      propValue = PropertyGrid.Text
      Set modelProp = m_scObj.Properties.Item(propName)
      If (modelProp.Count = 0 Or IsArray(modelProp.Value) Or IsArray(modelProp.Value(0))) Then
            ReallocateArray.Enabled = True
      Else
            ReallocateArray.Enabled = False
      End If
      DeleteProperty.Enabled = True
      
      Call grid_text_move(PropertyGrid, Text1)

      ' Save the position of the grids Row and Col for later:
      gRow = PropertyGrid.Row
      gCol = PropertyGrid.Col

      ' Make text box same size as current grid cell:
      Text1.Width = PropertyGrid.ColWidth(PropertyGrid.Col) - 2 * PropertyGrid.GridLineWidth
      Text1.Height = PropertyGrid.RowHeight(PropertyGrid.Row) - 2 * PropertyGrid.GridLineWidth

      ' Transfer the grid cell text:
      Text1.Text = propValue

      ' Show the text box:
      Text1.Visible = True
      Text1.ZOrder 0
      Text1.SetFocus

End Sub

Private Sub PropertyGrid_KeyPress(KeyAscii As Integer)

      If (PropertyGrid.Col <> 3) Then
        Exit Sub ' not in correct column
      End If

      Call grid_text_move(PropertyGrid, Text1)

       ' Save the position of the grids Row and Col for later:
      gRow = PropertyGrid.Row
      gCol = PropertyGrid.Col

      ' Make text box same size as current grid cell:
      Text1.Width = PropertyGrid.ColWidth(PropertyGrid.Col) - 2 * PropertyGrid.GridLineWidth
      Text1.Height = PropertyGrid.RowHeight(PropertyGrid.Row) - 2 * PropertyGrid.GridLineWidth

      ' Transfer the grid cell text:
      Text1.Text = PropertyGrid.Text

      ' Show the text box:
      Text1.Visible = True
      Text1.ZOrder 0
      Text1.SetFocus
      ' Redirect this KeyPress event to the text box:
      If KeyAscii <> ASC_ENTER Then
         SendKeys Chr$(KeyAscii)
      End If

End Sub


Private Sub ReallocateArray_Click()
Dim propName As String
Dim modelProp As SCAPI.ModelProperty
Dim NumElements As Integer


      ReallocateArrayForm.Show 1, Me
      If (ReallocateArrayForm.m_bCancel = True) Then
        Exit Sub
      End If
      NumElements = ReallocateArrayForm.m_numElements
      PropertyGrid.Col = 0
      propName = PropertyGrid.Text
      Set modelProp = m_scObj.Properties.Item(propName)
      ' To set a two dimensional array for points, do the following:
      ' Dim v As Variant
      ' ReDim v(NumElements - 1, 2) As Long
      ' Dim i As Integer
      ' For i = 0 To (NumElements - 1)
      '   v(i, 0) = [x-value]
      '   v(i, 1) = [y-value]
      ' Next
      
      Dim v As Variant
      ReDim v(NumElements - 1) As String
      Dim i As Integer
      For i = 0 To (NumElements - 1)
         v(i) = ""
      Next
      modelProp.Value() = v
      
      LoadPropertiesInGrid

End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
      If KeyAscii = ASC_ENTER Then
         PropertyGrid.SetFocus  ' Set focus back to grid, see Text_LostFocus.
         KeyAscii = 0    ' Ignore this KeyPress.
      End If

End Sub

Private Sub Text1_LostFocus()
      Dim tmpRow As Integer
      Dim tmpCol As Integer
      Dim bTextChange As Boolean

      ' Save current settings of Grid Row and col. This is needed only if
      ' the focus is set somewhere else in the Grid.
      tmpRow = PropertyGrid.Row
      tmpCol = PropertyGrid.Col

      ' Set Row and Col back to what they were before Text1_LostFocus:
      PropertyGrid.Row = gRow
      PropertyGrid.Col = gCol
      
      If (PropertyGrid.Text = Text1.Text) Then
        bTextChange = False
      Else
        bTextChange = True
      End If

      PropertyGrid.Text = Text1.Text  ' Transfer text back to grid.
      Text1.SelStart = 0       ' Return caret to beginning.
      Text1.Visible = False    ' Disable text box.

      If (bTextChange = False) Then
        ' Return row and Col contents:
        PropertyGrid.Row = tmpRow
        PropertyGrid.Col = tmpCol
        Exit Sub
      End If

      m_scTransactionId = m_scSession.BeginTransaction

      ' ********  THIS IS WHERE THE PROPERTY MODIFICATION OCCURS
      ' Rows:
      ' 0 - Name
      ' 1 - IsScalar
      ' 2 - Index
      ' 3 - Value
      Dim propName As String
      Dim isScalar As String
      Dim index As String
      Dim val As String
      
      PropertyGrid.Col = 0
      propName = PropertyGrid.Text
      PropertyGrid.Col = 1
      isScalar = PropertyGrid.Text
      If (isScalar = "N") Then
        PropertyGrid.Col = 2
        index = PropertyGrid.Text
      End If
      PropertyGrid.Col = 3
      val = PropertyGrid.Text
      
      Dim modelProp As SCAPI.ModelProperty
      Set modelProp = m_scObj.Properties.Item(propName)
      If (isScalar = "N") Then
         '   To create a VT_ARRAY|VT_I4:
         
         '   Dim v As Variant
         '   ReDim v(2) As Long
         '   v(0) = 100
         '   v(1) = 200
         '   modelProp.Value() = v
        modelProp.Value(index, SCVT_BSTR) = val
      Else
        modelProp.Value = val
      End If
      
      ' Return row and Col contents:
      PropertyGrid.Row = tmpRow
      PropertyGrid.Col = tmpCol
      
End Sub


Sub grid_text_move(Grid As Control, TextBox As Control)

   ' Move a text box to the position of the current cell in a grid:
   Dim X As Single   ' x position of current grid cell.
   Dim Y As Single   ' y position of current grid cell.
   Dim i As Integer  ' Column/row index.

   ' Skip grid border:
   X = Grid.Left
   Y = Grid.Top
   If Grid.BorderStyle = 1 Then
      X = X + Screen.TwipsPerPixelX
      Y = Y + Screen.TwipsPerPixelY
   End If

   ' Skip fixed columns and rows:
   For i = 0 To Grid.FixedCols - 1
      X = X + Grid.ColWidth(i)
      If Grid.GridLines Then
         X = X + Screen.TwipsPerPixelX
      End If
   Next
   For i = 0 To Grid.FixedRows - 1
      Y = Y + Grid.RowHeight(i)
      If Grid.GridLines Then
         Y = Y + Grid.GridLineWidth
      End If
   Next

   ' Find current data cell:
   For i = Grid.LeftCol To Grid.Col - 1
       X = X + Grid.ColWidth(i)
       If Grid.GridLines Then
           X = X + Grid.GridLineWidth
       End If
   Next
   For i = Grid.TopRow To Grid.Row - 1
       Y = Y + Grid.RowHeight(i)
       If Grid.GridLines Then
           Y = Y + Grid.GridLineWidth
       End If
   Next

   ' Move the Text Box, and make small adjustments:
   ' TextBox.Move X + Screen.TwipsPerPixelX, Y + Screen.TwipsPerPixelY
   
   TextBox.Move X, Y + 2 * Grid.GridLineWidth
End Sub

