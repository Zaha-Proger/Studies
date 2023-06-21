Attribute VB_Name = "UtilFunctions"
Public Function PrintSC_Type(sc_Type As SC_ValueTypes) As String
    Select Case sc_Type
        Case SCVT_BLOB
            PrintSC_Type = "SCVT_BLOB"
        Case SCVT_BOOLEAN
            PrintSC_Type = "SCVT_BOOLEAN"
        Case SCVT_BRANCH_LOG
            PrintSC_Type = "SCVT_BRANCH_LOG"
        Case SCVT_BSTR
            PrintSC_Type = "SCVT_BSTR"
        Case SCVT_CURRENCY
            PrintSC_Type = "SCVT_CURRENCY"
        Case SCVT_DATE
            PrintSC_Type = "SCVT_DATE"
        Case SCVT_DEFAULT
            PrintSC_Type = "SCVT_DEFAULT"
        Case SCVT_GUID
            PrintSC_Type = "SCVT_GUID"
        Case SCVT_I1
            PrintSC_Type = "SCVT_I1"
        Case SCVT_I2
            PrintSC_Type = "SCVT_I2"
        Case SCVT_I4
            PrintSC_Type = "SCVT_I4"
        Case SCVT_IDISPATCH
            PrintSC_Type = "SCVT_IDISPATCH"
        Case SCVT_INT
            PrintSC_Type = "SCVT_INT"
        Case SCVT_IUNKNOWN
            PrintSC_Type = "SCVT_IUNKNOWN"
        Case SCVT_NULL
            PrintSC_Type = "SCVT_NULL"
        Case SCVT_OBJID
            PrintSC_Type = "SCVT_OBJID"
        Case SCVT_POINT
            PrintSC_Type = "SCVT_POINT"
        Case SCVT_R4
            PrintSC_Type = "SCVT_R4"
        Case SCVT_R8
            PrintSC_Type = "SCVT_R8"
        Case SCVT_RECT
            PrintSC_Type = "SCVT_RECT"
        Case SCVT_UI1
            PrintSC_Type = "SCVT_UI1"
        Case SCVT_UI2
            PrintSC_Type = "SCVT_UI2"
        Case SCVT_UI4
            PrintSC_Type = "SCVT_UI4"
        Case SCVT_UINT
            PrintSC_Type = "SCVT_UINT"
    End Select
End Function

Public Sub RemoveCarriageReturn(str As String)
    str = Replace(str, Chr$(13), " ")
    str = Replace(str, Chr$(10), " ")
End Sub

Public Function NumDim(ByRef arr) As Integer
Dim numDimensions As Integer
Dim upperBound As Long

    numDimensions = 1
    On Local Error GoTo funcExit
    Do
        upperBound = UBound(arr, numDimensions + 1)
        numDimensions = numDimensions + 1
    Loop
    
funcExit:
    NumDim = numDimensions
End Function

' This function is used to check if a UPDValue's property is valid or not.  A
' UPDValue is a union of properties.  The property value type is kept in the
' parent UDPDefinition object's PMValueType property.
'
' If the object is not a UPDValue, then TRUE is returned
' If the property is the type of the UDP, then TRUE is returned
' If the given property is not the type of the UDP as defined by its definition,
' FALSE is returned.

Public Function CanDisplayProp(scSession As SCAPI.Session, obj As SCAPI.ModelObject, propertyName As String) As Boolean
    If (obj.ClassName <> "PMUDPValue") Then
        CanDisplayProp = True
        Exit Function
    End If
    
    Dim parentObj As SCAPI.ModelObject
    Dim parentProp As SCAPI.ModelProperty
    Dim udpvalue As Byte
    Dim UDPDefRefProp As SCAPI.ModelProperty
    Dim UDPDefinition As SCAPI.ModelObject
    Dim UDPRefString As String
    
    Set parentObj = obj.Context
    If Not (parentObj Is Nothing) Then
        ' Check if this is a UDPDefinition or a UDPInstance
        If (parentObj.ClassName = "PMUDPInstance") Then
            ' Find the definition
            Set UDPDefRefProp = parentObj.Properties.Item("PMDefinedByRef")
            UDPRefString = CStr(UDPDefRefProp.Value)
            Set UDPDefinition = scSession.ModelObjects.Item(UDPRefString)
        Else
            If (parentObj.ClassName = "PMUDPDefinition") Then
                Set UDPDefinition = parentObj
            Else
                CanDisplayProp = False
                Exit Function
            End If
        End If
        Set parentProp = UDPDefinition.Properties.Item("PMValueType")
        udpvalue = parentProp.Value
    Else
        CanDisplayProp = False
        Exit Function
    End If
    
    CanDisplayProp = False
    
    Select Case udpvalue
        Case 1
            If (propertyName = "PMStringUDPValue") Then
                CanDisplayProp = True
            End If
        Case 2
            If (propertyName = "PMStringUDPValue") Then
                CanDisplayProp = True
            End If
        Case 3
            If (propertyName = "PMIntUDPValue") Then
                CanDisplayProp = True
            End If
        Case 4
            If (propertyName = "PMStringUDPValue") Then
                CanDisplayProp = True
            End If
        Case 5
            If (propertyName = "PMStringUDPValue") Then
                CanDisplayProp = True
            End If
        Case 6
            If (propertyName = "PMDateUDPValue") Then
                CanDisplayProp = True
            End If
        Case 7
            If (propertyName = "PMFloatUDPValue") Then
                CanDisplayProp = True
            End If
        Case 8
            If (propertyName = "PMStringUDPValue") Then
                CanDisplayProp = True
            End If
        Case 9
            If (propertyName = "PMIntUDPValue") Then
                CanDisplayProp = True
            End If
        Case 10
            If (propertyName = "PMStringUDPValue") Then
                CanDisplayProp = True
            End If
        Case 11
            If (propertyName = "PMDateUDPValue") Then
                CanDisplayProp = True
            End If
        Case 12
            If (propertyName = "PMFloatUDPValue") Then
                CanDisplayProp = True
            End If
        Case 13
            If (propertyName = "PMStringUDPValue") Then
                CanDisplayProp = True
            End If
        End Select
End Function
