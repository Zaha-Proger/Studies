/////////////////////////////////////////////////////////////////////////////////////////////

var WshShell = WScript.CreateObject ("WScript.Shell");
// ---- 1.start ----------------------------------------------------------------------------------------------------------------
var colUsrEnvVars = WshShell.Environment("PROCESS");
var isConsole = colUsrEnvVars("MY_CONSOLE_CHECK");
if (isConsole != "1") 
{
	WScript.Echo ("Use cmd-file (*.cmd) to run this script!");
	WScript.Quit(2);
}
// ---- 1.end ----------------------------------------------------------------------------------------------------------------

WScript.Echo ("All USB Devices on this computer (except hubs)");
WScript.Echo ("Parametrs:");
WScript.Echo ("\t -legal %filename% - takes the numders of legal usb devices from this file");
WScript.Echo ("\t -output %filename% - writes the html-table to this file");
WScript.Echo ();

// WScript.Echo("����������� �������������� ��������� AutoItX3 ��� ������ �������");
var libAutoIt="AutoItX3.dll";
var filename = null;
var outputFile = null;

var fs0 = WScript.CreateObject ("Scripting.FileSystemObject");
var objArgs = WScript.Arguments;
for (var i=0; i < objArgs.Count(); i++)
{
	if (objArgs(i) == "-x64") libAutoIt = "AutoItX3_x64.dll";
	if (objArgs(i) == "-legal") 
		if ( (i+1) < objArgs.Count() && fs0.FileExists (objArgs(i+1)) ) filename = objArgs(i+1);
	if (objArgs(i) == "-output") 
		if ( (i+1) < objArgs.Count() && objArgs(i+1) != "-legal") outputFile = objArgs(i+1);
}

res = WshShell.Run ("regsvr32.exe /s \".\\"+ libAutoIt +"\"", 8, true);
if (res != 0) 
{
	WScript.Echo(" �� ������� ���������������� ���������� "+ libAutoIt);
	WScript.Echo(" ( ��������� ������� ����� "+ libAutoIt +" � ������� �������� ) ");
	WScript.Echo(" ������ �������� ��������� ������ ... ");
	
	WScript.Quit(-1);
}
/**/

var objReg = new ObjectReg ();
var OSSerial = objReg.TryGetValue ("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", "ProductId");
var winVer = objReg.TryGetValue ("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", "CurrentVersion");

//	������ ��� ����� ���������� ��������� (���� 'USB\Vid_03f0&Pid_2b17\JL3Q3ZL' - �.�. ��������� �������)
//		��� ���� ����� ���������� ��� ������������� ����������
var sSerialNs = Array();		
	//	������ ���  ����� ����������  ������������������ ���������
	var sWhiteSerialNs = Array();	
	if (filename != null) sWhiteSerialNs = GetStrings (filename);
var storCount = 0; 	// ���� ���������� ��������� ��� �������� ������

var fv = null;
var curTime = new Date();
if (outputFile == null) outputFile = "view_USB_on_" + OSSerial + "_"+ curTime.getHours() +"-"+ curTime.getMinutes() +".html";

	var fso = WScript.CreateObject ("Scripting.FileSystemObject");
	fv = fso.CreateTextFile (outputFile, true);
	fv.writeLine ("<html><head><meta http-equiv=Content-Type content=\"text/html; charset=windows-1251\"></head><body> ");
	fv.writeLine (" ��� USB-����������� ����������, ������� ������������ � ������ �� (����� USB-hub) <br>");
	fv.writeLine (" <font color='#0000FF'> ����� </font> �������� ������������������ ������. <br>");
	fv.writeLine ("<table border=1> ");
	fv.writeLine ("<tr class=\"header\"><th>&nbsp; ��� ���������� ���������� &nbsp;</th> <th>&nbsp; ��������������&nbsp; </th> <th>&nbsp; �������� &nbsp;</th> <th colwidth=10>&nbsp; ��� &nbsp;</th> </tr>");

/**/

USBRegView ("HKLM\\SYSTEM", null);
/**/
 /*	������ ��������� ��������� ����� (����� ��������������),  ������� ������� �������� */
var isSRDisabled = objReg.TryGetValue ("HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore", "DisableSR");
if (isSRDisabled == null || isSRDisabled == 1) 
{	
	WScript.Echo ("�������������� ������� ��������� (����� ������������� ���).");
	if (fv != null) 
	{
		fv.writeLine (" </table> ");
		fv.writeLine ("�������������� ������� ��������� (����� ������������� ���).");
	}
}
else
{
	var restoreGuid = objReg.GetValue ("HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore\\Cfg", "MachineGuid");
	var sysDrive = fs0.GetDriveName (WshShell.ExpandEnvironmentStrings("%WinDir%"));

	var SRFolder = fs0.GetFolder (sysDrive + "\\System Volume Information\\_restore" + restoreGuid);
	var SRSubFolders = new Enumerator(SRFolder.SubFolders);
	var reg_sys_restore_point = 0;

   for (; !SRSubFolders.atEnd(); SRSubFolders.moveNext()) 
   {
      WScript.Echo (SRSubFolders.item());
	  
	  // find file snapshot\HKLM_SYSTEM
	  if (!fs0.FileExists (SRSubFolders.item() + "\\snapshot\\_REGISTRY_MACHINE_SYSTEM")) continue;
	  var HiveFile = fs0.GetFile (SRSubFolders.item() + "\\snapshot\\_REGISTRY_MACHINE_SYSTEM");
	  reg_sys_restore_point++;
	  var tmpHive = "HKLM\\old_SYSTEM";
	  
	  // load the hive by the mean of  reg.exe load
	  ourDir = WshShell.CurrentDirectory;	//	 ���������� ���������� �������
	  WshShell.CurrentDirectory = SRSubFolders.item() + "\\snapshot"; //	��������� � ���������� � ��������� ������
	  res = WshShell.Run ("reg.exe load " + tmpHive + " _REGISTRY_MACHINE_SYSTEM", 0, true);
	  WshShell.CurrentDirectory = ourDir;//	 ������������� ������� ���������� �������
	  if (res != 0) 
	  {
		WScript.Echo ("�� ������� ���������� � ������� ���� ����� " + SRSubFolders.item() + "\\snapshot\\_REGISTRY_MACHINE_SYSTEM");	
	  }
	  else
	  {
		  // look for usb devices in this hive
		  USBRegView (tmpHive, " �.�. �� " + new Date(HiveFile.DateLastModified).toLocaleString());
		  // unload the hive by the mean of  reg.exe unload
		  res = WshShell.Run ("reg.exe unload " + tmpHive, 0, true);
		  if (res != 0) 
		  {
			WScript.Echo ("�� ������� ��������� ��������� ������ �������");
		  }
		  // ������� ���� _REGISTRY_MACHINE_SYSTEM.LOG
		  fs0.DeleteFile (SRSubFolders.item() + "\\snapshot\\_REGISTRY_MACHINE_SYSTEM.LOG", 0);
	  } 
   }
	if (fv != null) 
	{
		fv.writeLine (" </table> ");
		fv.writeLine (" * �.�. - ����� �������������� (����������� �������� ������ �� �������������)");
		fv.writeLine ("<br>������� "+ reg_sys_restore_point +" ��������� ����� �������.");
		WScript.Echo ("����� ������� "+ reg_sys_restore_point +" ��������� ����� �������.");
	}
}
if (fv != null) fv.writeLine ("<br> ����� ���� ���������� <b>"+ storCount +"</b> USB-��������� ��� �������� ������ (������, ��, ������ ���������).");

/**/

if (winVer.charAt(0) == '5')
{
	//	�������� ����� setupapi.log � ����� ������ setupapi.log.0.old � �.�.
	var setupapiF = WshShell.ExpandEnvironmentStrings("%WinDir%") + "\\setupapi.log";
	var nn = 0;

	do
	{
		var fs1 = WScript.CreateObject ("Scripting.FileSystemObject");
		var SetupF = fs1.OpenTextFile (setupapiF, 1, false);
		
		var doWrite = true;
		var pos1, pos2;
		var code = String ();
		var action = String ();
		
		while (!SetupF.AtEndOfStream) 
		{
			curs = SetupF.ReadLine();
			if (curs.charAt(0) == '[')	doWrite = true;
			else if (doWrite && (curs.indexOf ("\"USB\\VID") != -1) )
			{
				//	�������� �� ������ ��� ���������� ����������
				pos1 = curs.indexOf ("\"");
				pos2 = curs.lastIndexOf ("\"");
				if (pos1 != -1 && pos2 != -1)
				{
					code = curs.slice (pos1 + 1, pos2);
					if (!checkN (code, sSerialNs) ) 
					{	
						doWrite = false; //	������ ����, ����� �� ������������� ��������� ������ � ������ ������� ������� '[    ]'
						action = curs.slice (0 , pos1 - 1);
						if (action.indexOf("�������")  != -1) logDevInstall (setupapiF, code);
						else if (action.indexOf("������")  != -1) logDevUninstall (setupapiF, code);
					}
				}
			}		
		}
		SetupF.Close ();
		
		setupapiF =  WshShell.ExpandEnvironmentStrings("%WinDir%") + "\\setupapi.log." + nn + ".old";
		nn++;
	} while (fs0.FileExists (setupapiF));
}
else if (winVer.charAt(0) == '6') 
{
	//	�������� ����� setupapi.dev.log
	var setupapiF = WshShell.ExpandEnvironmentStrings("%WinDir%") + "\\inf\\setupapi.dev.log";

	var fs1 = WScript.CreateObject ("Scripting.FileSystemObject");
	var SetupF = fs1.OpenTextFile (setupapiF, 1, false);
	
	var doWrite = true;
	var pos1, pos2;
	var code = String ();
	var action = String ();
	
	while (!SetupF.AtEndOfStream) 
	{
		curs = SetupF.ReadLine();
		if (curs.charAt(0) == '>')	// Look only first line in every section
		{
			//	�������� �� ������ ��� ���������� ����������
			pos1 = curs.indexOf ("USB\\VID");
			pos2 = curs.lastIndexOf ("]");
			if (pos1 != -1 && pos2 != -1)
			{
				code = curs.slice (pos1, pos2);
				if (!checkN (code, sSerialNs) ) 
				{	
					action = curs.slice (0 , pos1 - 1);
					if (action.indexOf(" Install")  != -1) logDevInstall (setupapiF, code);
					else if (action.indexOf(" Uninstall")  != -1) logDevUninstall (setupapiF, code);
				}
			}
		}		
	}
	SetupF.Close ();
}
else WScript.Echo ("������ ������ Windows �� ��������������.");
 /**/
EndOfScript();
//=====================================================================================================================================
//-----------------------------------------------------------------------------------------------------------------------------------
function EndOfScript()
{
	if (fv != null) 
	{
		fv.writeLine (" ");
		fv.writeLine (" </body></html>");
		fv.Close();
		WshShell.Run (outputFile);
	}
	
	// WScript.Echo("������ ����������� �������������� ��������� AutoItX3 ��� ������ �������");
	WshShell.Run ("regsvr32.exe /s /u \".\\"+ libAutoIt +"\"");

	WScript.Echo ("������ ������� ����������.");
	WScript.Quit(1);
}

function logDevInstall (setupFn, dC)
{
	WScript.Echo ("� ����� " + setupFn + " ����� ������� ������ �� ��������� ���������� " + dC);
	if (fv != null) fv.writeLine ("<br>� ����� <i>" + setupFn + "</i> ����� ������� ������ �� ��������� ���������� " + dC);
}

function logDevUninstall (setupFn, dC)
{
	WScript.Echo ("� ����� " + setupFn + " ����� ������� ������ �� �������� ���������� " + dC);
	if (fv != null) fv.writeLine ("<br>� ����� <i>" + setupFn + "</i> ����� ������� ������ �� �������� ���������� " + dC);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	����� ������� USB-��������� � ������� ������� RegSection
//		strComment	- ������ � ������������� (� �� ������������ ���� ��������� �����, ���� ����� ������������ �� �� ��������� �������
//	������ ������������ � ���������� ���� fv, ������������ ������ ����������� � ���������� �������  sSerialNs
//-----------------------------------------------------------------------------------------------------------------------------------
function USBRegView (RegSection, strComment)
{

	var sSets = objReg.EnumSubKeys (RegSection);

	for (var n=0; n<sSets.length; n++)
	{
		if (sSets[n].substr (0, 10) == "ControlSet")
		{
			var controlSet = RegSection + "\\" + sSets[n];
			
			var strKeyPath = controlSet + "\\Enum";
			var arrSub = objReg.EnumSubKeys (strKeyPath + "\\USB");	
			if 	(arrSub == null) continue;
			for (var i=0; i< arrSub.length; i++)
			{
				var sSub = strKeyPath + "\\USB\\" + arrSub[i];
				var sInsts = objReg.EnumSubKeys (sSub);
				if 	(sInsts == null) continue;
				for (var j=0; j<sInsts.length; j++)
				{
					var serialN = "USB\\" + arrSub[i] + "\\" + sInsts[j];
					var serv = objReg.TryGetValue (strKeyPath + "\\" + serialN, "Service");
					// 	���� ��� ���, �� ����������
					if (checkN (serialN, sSerialNs)) continue;	//	���� ��� ����
					
					// ���������� �������� �����, ����� �� �������� ��������
					sSerialNs [sSerialNs.length] = serialN;				
					if (serv != null && serv.toUpperCase() == "USBHUB") continue; //	������������� ����������
					
					var serv2 = objReg.TryGetValue (strKeyPath + "\\" + serialN, "DeviceDesc");
					var name = objReg.TryGetValue (strKeyPath + "\\" + serialN, "LocationInformation");
					var storeN = objReg.TryGetValue (strKeyPath + "\\" + serialN, "ParentIdPrefix");
					if (storeN == null) storeN = sInsts[j];
					else 
					{
						var jn = storeN.lastIndexOf("&");
						storeN = storeN.substring (0, jn); 
					}
					// ����� ���������� �� ������ \Enum\USBSTOR
					var sProd = "";
					if (serv != null && serv.toUpperCase() == "USBSTOR" ) 
					{	
						storCount++;
						storSect = objReg.GetUSBSTOR (controlSet, storeN);
						if (storSect!=null) sProd = objReg.TryGetValue (storSect, "FriendlyName");
					}
								
					//	����� �� �����, � ����
					if (strComment == null)
						WScript.Echo (serialN + "\t\t" + serv + " - " + serv2 + "\t\t" + sProd + "\t" + name);	
					else 	
						WScript.Echo (strComment + ":  " + serialN + "\t\t" + serv + " - " + serv2 + "\t\t" + sProd + "\t" + name);	
					//	������ � ���� html
					if (checkWhite (serialN, sWhiteSerialNs)) serialN = "<font color='#0000FF'>" + serialN + "</font>";
					if (fv != null) 
						if (strComment == null) 
							fv.writeLine ("<tr><td>" + serialN + "</td> <td>&nbsp;" + 
								serv + " - " + serv2 + "</td> <td>&nbsp;" + name + "&nbsp;</td> <td>&nbsp;" + sProd + "&nbsp;</td> </tr>");
						else 
							fv.writeLine ("<tr><td>" + serialN + "<br>" + strComment + "&nbsp; </td> <td>&nbsp;" + 
								serv + " - " + serv2 + "</td> <td>&nbsp;" + name + "&nbsp;</td> <td>&nbsp;" + sProd + "&nbsp;</td> </tr>");
				}			
			}	
		}
	}
}



//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
////		��������������� �������
////

//-----------------------------------------------------------------------------------------------------------------------------------
//	������ �� ����� ������� �����
//-----------------------------------------------------------------------------------------------------------------------------------
function GetStrings (filename)
{
	var fs = WScript.CreateObject ("Scripting.FileSystemObject");
	var stream = fs.OpenTextFile (filename,1,false);
	var arr = Array ();

	while (!stream.AtEndOfStream) 
	{
		sn = stream.ReadLine();
		arr [arr.length] = sn;		// arr.push (sn);
	}
	stream.Close();

	return arr;
}


//-----------------------------------------------------------------------------------------------------------------------------------
//	��������, ���� �� ����� ��������� ������� cSerialNs ������ serialN
//-----------------------------------------------------------------------------------------------------------------------------------
function checkN (sN, sArr)
{
	if (sArr == null) return false;
	cN=sN.toUpperCase();
	for (var jj=0; jj<sArr.length; jj++)
	{
		if (sArr[jj].toUpperCase() == cN) return true;
	}
	return false;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	��������, ���� �� ����� ��������� ������� cSerialNs ������ serialN
//-----------------------------------------------------------------------------------------------------------------------------------
function checkWhite (sN, sArr)
{
	if (sArr == null) return false;
	nn=sN.indexOf ("\\5&");
	if (nn != -1) cN=sN.slice(0, nn+3); else cN=sN;
	cN=cN.toUpperCase();
	for (var jj=0; jj<sArr.length; jj++)
	{
		if (sArr[jj].toUpperCase() == cN) return true;
	}
	return false;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	�������������� ����������������� ������� ����� � ������ (����� ����� ������� ����� �����������)
//		�������� arr - ������ ����
//-----------------------------------------------------------------------------------------------------------------------------------
function ArrToStr (arr)
{
	var sT = new String ();
	var cod;
	
	for (var i=0; i<arr.length; i+=4)
	{
		cod = parseInt (arr.substring (i,i+2), 16 );
		sT = sT + String.fromCharCode(cod);
	}
	return sT;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	������ �������� s2 � ������ s1 �� ������ s3
//-----------------------------------------------------------------------------------------------------------------------------------
function replaceStr (s1, s2, s3)
{
	if (s2 == "") s2 = " ";
	sNew = "";
	while (true)
	{
		ii = s1.indexOf (s2);
		if  (ii>=0)
		{
			sNew = sNew + s1.substr (0, ii) + s3;
			s1 = s1.substr (ii + s2.length);
		}
		else break;
	}
	return sNew + s1;
}

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
////		��������������� ������� ������ ��� ������ � ��������
//// 

//-----------------------------------------------------------------------------------------------------------------------------------
//	����������� ������� �������
//-----------------------------------------------------------------------------------------------------------------------------------
function ObjectReg ()
{
	this.objAutoItX = WScript.CreateObject("AutoItX3.Control");
	this.EnumSubKeys = EnumRegKey;
	this.EnumValues = EnumRegValues;
	this.GetValue = GetRegValue;
	this.TryGetValue = TryGetRegValue;
	this.GetUSBSTOR = GetRegUSBSTOR;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	��� ������� ��������� ������������ ��������� �������
//	(��� ��������� ����� �������)
//-----------------------------------------------------------------------------------------------------------------------------------
function EnumRegKey (RegKey)
{
	var ii = 1;
	var arrSub = new Array();
	while (true)
	{
		strSubKeyName = this.objAutoItX.RegEnumKey (RegKey, ii);
		if (this.objAutoItX.error != 0) 
		{
			if (this.objAutoItX.error == 1) 
				if (ii == 1) return null;
				else WScript.Echo ("������ ��� ������ ���������� #" + ii + " � ������� '" + RegKey + "'");
			break;
		}
		arrSub [ii-1] = strSubKeyName;
		ii++;
	}
    return arrSub;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	��� ������� ��������� ������������ ���������� 
//	(��� ��������� ����� �������)
//		������������ ������ ����� ����������, ��� �������� �� �����
//-----------------------------------------------------------------------------------------------------------------------------------
function EnumRegValues (RegKey)
{
	var ii = 1;
	var arrSub = new Array();
	while (true)
	{
		strSubKeyName = this.objAutoItX.RegEnumVal (RegKey, ii);
		if (this.objAutoItX.error != 0) 
		{
			if (this.objAutoItX.error == 1) 
				if (ii == 1) return null;
				else WScript.Echo ("������ ��� ������ ��������� #" + ii + " � ������� '" + RegKey + "'");
			break;
		}
		arrSub [ii-1] = strSubKeyName;
		ii++;
	}
    return arrSub;
}
//-----------------------------------------------------------------------------------------------------------------------------------
//	��� ������� ���������� �������� ��������� 
//	(��� ��������� ����� �������)
//-----------------------------------------------------------------------------------------------------------------------------------
function GetRegValue (RegKey, ValueName)
{
	var val = this.objAutoItX.RegRead(RegKey, ValueName);
	
	if (this.objAutoItX.error != 0) 
	{
		WScript.Echo ("������ ��� ������ �������� ��������� " + ValueName + " � ������� '" + RegKey + "'");
		return null;
	}
	else return val;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	��� ������� ���������� �������� ���������
//	(��� ��������� ����� �������)
//		���� ������ �������/��������� �� ����������, �� ��������� �� ������ �� ��������
//-----------------------------------------------------------------------------------------------------------------------------------
function TryGetRegValue (RegKey, ValueName)
{
	var val = this.objAutoItX.RegRead(RegKey, ValueName);
	
	if (this.objAutoItX.error != 0) return null;
	else return val;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	��� ������� ���������� ���� � ���������� ������  controlSet + \Enum\USBSTOR
//		� ������� ���������� ���������� � USB ��������� � ������� storeN
//-----------------------------------------------------------------------------------------------------------------------------------
function GetRegUSBSTOR (sControlKey, sStoreN)
{
	var sSubs = this.EnumSubKeys (sControlKey + "\\Enum\\USBSTOR");
	for (var k=0; k<sSubs.length; k++)
	{
		var sSub = sControlKey + "\\Enum\\USBSTOR\\" + sSubs[k];
		var sStores = this.EnumSubKeys (sSub);
		for (var kk=0; kk<sStores.length ; kk++)
		{
			var ln = sStores[kk].lastIndexOf ("&");
			if (ln == -1) { ln = sStores[kk].length; }
			if (sStores[kk].substr(0, ln) == sStoreN)
				return sSub + "\\" + sStores[kk];
		}
	}
	return null;
}
