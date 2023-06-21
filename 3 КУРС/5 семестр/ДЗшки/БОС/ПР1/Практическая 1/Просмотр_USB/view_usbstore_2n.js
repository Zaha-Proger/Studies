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

// WScript.Echo("регистрация дополнительной билиотеки AutoItX3 для чтения реестра");
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
	WScript.Echo(" Не удалось зарегестрировать библиотеку "+ libAutoIt);
	WScript.Echo(" ( Проверьте наличие файла "+ libAutoIt +" в текущем каталоге ) ");
	WScript.Echo(" Скрипт аварийно завершает работу ... ");
	
	WScript.Quit(-1);
}
/**/

var objReg = new ObjectReg ();
var OSSerial = objReg.TryGetValue ("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", "ProductId");
var winVer = objReg.TryGetValue ("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", "CurrentVersion");

//	массив для кодов экземляров устройств (вида 'USB\Vid_03f0&Pid_2b17\JL3Q3ZL' - т.е. подраздел реестра)
//		для того чтобы запоминать уже просмотренные устройства
var sSerialNs = Array();		
	//	массив для  кодов экземляров  зарегистрированных устройств
	var sWhiteSerialNs = Array();	
	if (filename != null) sWhiteSerialNs = GetStrings (filename);
var storCount = 0; 	// учет количества устройств для хранения данных

var fv = null;
var curTime = new Date();
if (outputFile == null) outputFile = "view_USB_on_" + OSSerial + "_"+ curTime.getHours() +"-"+ curTime.getMinutes() +".html";

	var fso = WScript.CreateObject ("Scripting.FileSystemObject");
	fv = fso.CreateTextFile (outputFile, true);
	fv.writeLine ("<html><head><meta http-equiv=Content-Type content=\"text/html; charset=windows-1251\"></head><body> ");
	fv.writeLine (" Все USB-совместимые устройства, которые подключались в данной ОС (кроме USB-hub) <br>");
	fv.writeLine (" <font color='#0000FF'> синим </font> выделены зарегистрированные номера. <br>");
	fv.writeLine ("<table border=1> ");
	fv.writeLine ("<tr class=\"header\"><th>&nbsp; Код экземпляра устройства &nbsp;</th> <th>&nbsp; Предназначение&nbsp; </th> <th>&nbsp; Описание &nbsp;</th> <th colwidth=10>&nbsp; Имя &nbsp;</th> </tr>");

/**/

USBRegView ("HKLM\\SYSTEM", null);
/**/
 /*	теперь проверяем резервные копии (точки восстановления),  которые сделаны системой */
var isSRDisabled = objReg.TryGetValue ("HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore", "DisableSR");
if (isSRDisabled == null || isSRDisabled == 1) 
{	
	WScript.Echo ("Восстановление системы отключено (точек восстаноления нет).");
	if (fv != null) 
	{
		fv.writeLine (" </table> ");
		fv.writeLine ("Восстановление системы отключено (точек восстаноления нет).");
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
	  ourDir = WshShell.CurrentDirectory;	//	 запоминаем директорию скрипта
	  WshShell.CurrentDirectory = SRSubFolders.item() + "\\snapshot"; //	переходим в директорию с резервной копией
	  res = WshShell.Run ("reg.exe load " + tmpHive + " _REGISTRY_MACHINE_SYSTEM", 0, true);
	  WshShell.CurrentDirectory = ourDir;//	 устанавливаем обратно директорию скрипта
	  if (res != 0) 
	  {
		WScript.Echo ("Не удалось подключить к реестру файл куста " + SRSubFolders.item() + "\\snapshot\\_REGISTRY_MACHINE_SYSTEM");	
	  }
	  else
	  {
		  // look for usb devices in this hive
		  USBRegView (tmpHive, " т.в. от " + new Date(HiveFile.DateLastModified).toLocaleString());
		  // unload the hive by the mean of  reg.exe unload
		  res = WshShell.Run ("reg.exe unload " + tmpHive, 0, true);
		  if (res != 0) 
		  {
			WScript.Echo ("Не удалось отключить временный раздел реестра");
		  }
		  // удалить файл _REGISTRY_MACHINE_SYSTEM.LOG
		  fs0.DeleteFile (SRSubFolders.item() + "\\snapshot\\_REGISTRY_MACHINE_SYSTEM.LOG", 0);
	  } 
   }
	if (fv != null) 
	{
		fv.writeLine (" </table> ");
		fv.writeLine (" * т.в. - точка восстановления (указывается наиболее ранняя из встречающихся)");
		fv.writeLine ("<br>Найдено "+ reg_sys_restore_point +" резервных копий реестра.");
		WScript.Echo ("ВСЕГО найдено "+ reg_sys_restore_point +" резервных копий реестра.");
	}
}
if (fv != null) fv.writeLine ("<br> Всего было обнаружено <b>"+ storCount +"</b> USB-устройств для хранения данных (флэшки, ЖД, память телефонов).");

/**/

if (winVer.charAt(0) == '5')
{
	//	Проверка файла setupapi.log а также файлов setupapi.log.0.old и т.д.
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
				//	выделяем из строки код экземпляра устройства
				pos1 = curs.indexOf ("\"");
				pos2 = curs.lastIndexOf ("\"");
				if (pos1 != -1 && pos2 != -1)
				{
					code = curs.slice (pos1 + 1, pos2);
					if (!checkN (code, sSerialNs) ) 
					{	
						doWrite = false; //	меняем флаг, чтобы не рассматривать остальные строки в рамках данного раздела '[    ]'
						action = curs.slice (0 , pos1 - 1);
						if (action.indexOf("установ")  != -1) logDevInstall (setupapiF, code);
						else if (action.indexOf("удален")  != -1) logDevUninstall (setupapiF, code);
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
	//	Проверка файла setupapi.dev.log
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
			//	выделяем из строки код экземпляра устройства
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
else WScript.Echo ("Данная версия Windows не поддерживается.");
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
	
	// WScript.Echo("снятие регистрации дополнительной билиотеки AutoItX3 для чтения реестра");
	WshShell.Run ("regsvr32.exe /s /u \".\\"+ libAutoIt +"\"");

	WScript.Echo ("Скрипт успешно завершился.");
	WScript.Quit(1);
}

function logDevInstall (setupFn, dC)
{
	WScript.Echo ("В файле " + setupFn + " также найдена запись об установке устройства " + dC);
	if (fv != null) fv.writeLine ("<br>В файле <i>" + setupFn + "</i> также найдена запись об установке устройства " + dC);
}

function logDevUninstall (setupFn, dC)
{
	WScript.Echo ("В файле " + setupFn + " также найдена запись об удалении устройства " + dC);
	if (fv != null) fv.writeLine ("<br>В файле <i>" + setupFn + "</i> также найдена запись об удалении устройства " + dC);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	Поиск номеров USB-устройств в разделе реестра RegSection
//		strComment	- строка с комментариями (в неё записывается дата резервной копии, если поиск производится не по основному реестру
//	запись производится в глобальный файл fv, обнаруженные номера сохраняются в глобальном массиве  sSerialNs
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
					// 	если уже был, то пропускаем
					if (checkN (serialN, sSerialNs)) continue;	//	если уже было
					
					// запоминаем серийный номер, чтобы не выводить повторно
					sSerialNs [sSerialNs.length] = serialN;				
					if (serv != null && serv.toUpperCase() == "USBHUB") continue; //	концентраторы пропускаем
					
					var serv2 = objReg.TryGetValue (strKeyPath + "\\" + serialN, "DeviceDesc");
					var name = objReg.TryGetValue (strKeyPath + "\\" + serialN, "LocationInformation");
					var storeN = objReg.TryGetValue (strKeyPath + "\\" + serialN, "ParentIdPrefix");
					if (storeN == null) storeN = sInsts[j];
					else 
					{
						var jn = storeN.lastIndexOf("&");
						storeN = storeN.substring (0, jn); 
					}
					// поиск информации по секции \Enum\USBSTOR
					var sProd = "";
					if (serv != null && serv.toUpperCase() == "USBSTOR" ) 
					{	
						storCount++;
						storSect = objReg.GetUSBSTOR (controlSet, storeN);
						if (storSect!=null) sProd = objReg.TryGetValue (storSect, "FriendlyName");
					}
								
					//	вывод на экран, в файл
					if (strComment == null)
						WScript.Echo (serialN + "\t\t" + serv + " - " + serv2 + "\t\t" + sProd + "\t" + name);	
					else 	
						WScript.Echo (strComment + ":  " + serialN + "\t\t" + serv + " - " + serv2 + "\t\t" + sProd + "\t" + name);	
					//	запись в файл html
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
////		Вспомогательные функции
////

//-----------------------------------------------------------------------------------------------------------------------------------
//	Чтение из файла массива строк
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
//	проверка, есть ли среди элементов массива cSerialNs строка serialN
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
//	проверка, есть ли среди элементов массива cSerialNs строка serialN
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
//	преобразование шестнадцатирычных массива чисел в строку (точки после каждого числа опускаються)
//		параметр arr - строка цифр
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
//	Замена подстрок s2 в строке s1 на строку s3
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
////		Вспомогательные функции класса для работы с реестром
//// 

//-----------------------------------------------------------------------------------------------------------------------------------
//	Конструктор объекта реестра
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
//	Эта функция выполняет перечисление подключей реестра
//	(для заданного ключа реестра)
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
				else WScript.Echo ("Ошибка при чтении подраздела #" + ii + " в разделе '" + RegKey + "'");
			break;
		}
		arrSub [ii-1] = strSubKeyName;
		ii++;
	}
    return arrSub;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	Эта функция выполняет перечисление параметров 
//	(для заданного ключа реестра)
//		возвращаются только имена параемтров, без указания их типов
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
				else WScript.Echo ("Ошибка при чтении параметра #" + ii + " в разделе '" + RegKey + "'");
			break;
		}
		arrSub [ii-1] = strSubKeyName;
		ii++;
	}
    return arrSub;
}
//-----------------------------------------------------------------------------------------------------------------------------------
//	Эта функция возвращает значение параметра 
//	(для заданного ключа реестра)
//-----------------------------------------------------------------------------------------------------------------------------------
function GetRegValue (RegKey, ValueName)
{
	var val = this.objAutoItX.RegRead(RegKey, ValueName);
	
	if (this.objAutoItX.error != 0) 
	{
		WScript.Echo ("Ошибка при чтении значения параметра " + ValueName + " в разделе '" + RegKey + "'");
		return null;
	}
	else return val;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	Эта функция возвращает значение параметра
//	(для заданного ключа реестра)
//		если такого раздела/параметра не существует, то сообщение об ошибке не выдается
//-----------------------------------------------------------------------------------------------------------------------------------
function TryGetRegValue (RegKey, ValueName)
{
	var val = this.objAutoItX.RegRead(RegKey, ValueName);
	
	if (this.objAutoItX.error != 0) return null;
	else return val;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//	Эта функция возвращает путь к подразделу секции  controlSet + \Enum\USBSTOR
//		в котором содержится информация о USB хранилище с номером storeN
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
