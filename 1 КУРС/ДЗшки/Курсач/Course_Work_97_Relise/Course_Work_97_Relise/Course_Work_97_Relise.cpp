#include <iostream>
#include <fstream>
#include <ctime>
#include <string.h>
#include <windows.h>
#include <wincrypt.h>

#define PATH "Students.txt"
#define PATH_enc "Students.txt.enc"
#define PATH1 "Students1.txt"
#define PATH2 "Students2.txt"
#define PATH_NEW "Students.new.txt"
#define RUS  SetConsoleCP(1251); SetConsoleOutputCP(1251);

#pragma comment(lib, "crypt32.lib")

using namespace std;

struct Sub {
	char* name = new char[21]();
	int* mark = new int();
};

class Mystr {
private:
	char* data = nullptr;

public:
	Mystr(const char in[]) {
		data = new char[strlen(in) + 1]();
		for (int i = 0; i < strlen(in); i++) {
			*(data + i) = in[i];
		}
		data[strlen(data)] = '\0';
	}

	~Mystr() {
		delete[] data;
	}

	void operator += (const char other[]) {
		char* temp = new char[strlen(data) + strlen(other) + 1]();
		int i = 0;
		for (; i < strlen(data); i++) {
			*(temp + i) = *(data + i);
		}
		for (int j = 0; j < strlen(other); j++) {
			*(temp + i + j) = *(other + j);
		}
		temp[strlen(temp)] = '\0';

		delete[] data;

		data = new char[strlen(temp) + 1]();
		for (int i = 0; i < strlen(temp); i++) {
			*(data + i) = *(temp + i);
		}
		data[strlen(data)] = '\0';
	}
	
	char* Get() {
		return data;
	}
};

class Crypt {
private:
	char* Gen_pass() {
		srand(time(NULL));
		char* pass = new char[17];
		for (int i = 0; i < 16; ++i)
		{
			switch (rand() % 3) {
			case 0:
				pass[i] = rand() % 10 + '0';
				break;
			case 1:
				pass[i] = rand() % 26 + 'A';
				break;
			case 2:
				pass[i] = rand() % 26 + 'a';
			}
		}
		pass[16] = '\0';

		return pass;
	}

public:
	void Encrypt() {
		Mystr PATH_ENC(PATH);
		PATH_ENC += ".enc";

		ifstream File;
		File.open(PATH, ios::binary);
		ofstream File_enc;
		File_enc.open(PATH_ENC.Get(), ios::binary | ios::app);
		File_enc.seekp(0, ios::beg);

		int file_length;
		File.seekg(0, ios::end);
		file_length = File.tellg();
		File.seekg(0, ios::beg);

		char* szPassword = Gen_pass();

		int dwLength = strlen(szPassword);
		File_enc.write((char*)&dwLength, sizeof(dwLength));
		File_enc.write((char*)szPassword, dwLength + 1);

		HCRYPTPROV hProv;
		HCRYPTKEY hKey;
		HCRYPTHASH hHash;

		if (!CryptAcquireContext(&hProv, NULL, NULL, PROV_RSA_AES, CRYPT_VERIFYCONTEXT))
		{
			cout << "Error during CryptAcquireContext!";
		}

		if (!CryptCreateHash(hProv, CALG_MD5, 0, 0, &hHash))
		{
			cout << "Error during CryptCreateHash!";
		}

		if (!CryptHashData(hHash, (BYTE*)szPassword, (DWORD)dwLength, 0))
		{
			cout << "Error during CryptHashData!";
		}

		if (!CryptDeriveKey(hProv, CALG_RC4, hHash, CRYPT_EXPORTABLE, &hKey))
		{
			cout << "Error during CryptDeriveKey!";
		}

		size_t enc_length = 8;
		DWORD dwBlockLen = 1000 - 1000 % enc_length;
		DWORD dwBufferLen = 0;

		if (enc_length > 1)
		{
			dwBufferLen = dwBlockLen + enc_length;
		}
		else
		{
			dwBufferLen = dwBlockLen;
		}

		int count = 0;
		bool final = false;

		while (count != file_length) {
			if (file_length - count < dwBlockLen) {
				dwBlockLen = file_length - count;
				final = true;
			}

			BYTE* temp = new BYTE[dwBufferLen]();
			File.read((char*)temp, dwBlockLen);

			if (!CryptEncrypt(hKey, NULL, final, 0, temp, &dwBlockLen, dwBufferLen))
			{
				cout << "Error during CryptEncrypt. \n";
			}

			File_enc.write((char*)temp, dwBlockLen);

			count = count + dwBlockLen;
		}

		if (hHash)
		{
			if (!(CryptDestroyHash(hHash)))
				cout << "Error during CryptDestroyHash";
		}

		if (hKey)
		{
			if (!(CryptDestroyKey(hKey)))
				cout << "Error during CryptDestroyKey";
		}

		if (hProv)
		{
			if (!(CryptReleaseContext(hProv, 0)))
				cout << "Error during CryptReleaseContext";
		}

		File.close();
		File_enc.close();

		if (remove(PATH) != 0) {
			cout << "ERROR -- ошибка при удалении файла\n";
		}
	}

	void Decrypt() {
		Mystr PATH_ENC(PATH);
		PATH_ENC += ".enc";

		ofstream File;
		File.open(PATH, ios::binary | ios::app);
		ifstream File_enc;
		File_enc.open(PATH_ENC.Get(), ios::binary);

		int file_length;
		File_enc.seekg(0, ios::end);
		file_length = File_enc.tellg();
		File_enc.seekg(0, ios::beg);

		if (file_length == -1 || file_length == 0) {
			return;
		}

		int dwLength;
		File_enc.read((char*)&dwLength, sizeof(dwLength));
		char* szPassword = new char[dwLength];
		File_enc.read((char*)szPassword, dwLength + 1);

		HCRYPTPROV hProv;
		HCRYPTKEY hKey;
		HCRYPTHASH hHash;

		if (!CryptAcquireContext(&hProv, NULL, NULL, PROV_RSA_AES, CRYPT_VERIFYCONTEXT))
		{
			cout << "Error during CryptAcquireContext!";
		}

		if (!CryptCreateHash(hProv, CALG_MD5, 0, 0, &hHash))
		{
			cout << "Error during CryptCreateHash!";
		}

		if (!CryptHashData(hHash, (BYTE*)szPassword, (DWORD)dwLength, 0))
		{
			cout << "Error during CryptHashData!";
		}

		if (!CryptDeriveKey(hProv, CALG_RC4, hHash, CRYPT_EXPORTABLE, &hKey))
		{
			cout << "Error during CryptDeriveKey!";
		}

		size_t enc_length = 8;
		DWORD dwBlockLen = 1000 - 1000 % enc_length;
		DWORD dwBufferLen = 0;

		if (enc_length > 1)
		{
			dwBufferLen = dwBlockLen + enc_length;
		}
		else
		{
			dwBufferLen = dwBlockLen;
		}

		int count = sizeof(dwLength) + strlen(szPassword) + 1;
		bool final = false;

		while (count != file_length) {
			if (file_length - count < dwBlockLen) {
				dwBlockLen = file_length - count;
				final = true;
			}

			BYTE* temp = new BYTE[dwBlockLen];
			File_enc.read((char*)temp, dwBlockLen);

			if (!CryptDecrypt(hKey, 0, final, 0, temp, &dwBlockLen))
			{
				cout << "Error during CryptEncrypt. \n";
			}

			File.write((char*)temp, dwBlockLen);
			count = count + dwBlockLen;
		}

		if (hHash)
		{
			if (!(CryptDestroyHash(hHash)))
				cout << "Error during CryptDestroyHash";
		}

		if (hKey)
		{
			if (!(CryptDestroyKey(hKey)))
				cout << "Error during CryptDestroyKey";
		}

		if (hProv)
		{
			if (!(CryptReleaseContext(hProv, 0)))
				cout << "Error during CryptReleaseContext";
		}

		File.close();
		File_enc.close();
		if (remove(PATH_ENC.Get()) != 0) {
			cout << "ERROR -- ошибка при удалении файла\n";
		}
	}
};

class Functions {
public:
	virtual void studentsPrint(int val) = 0; 

	void print(char* val) {
		cout << val;
	}

	void print(int val) {
		cout << val;
	}

	void print(const char val[]) {
		cout << val;
	}

	void cleanCin() {
		cin.seekg(0, ios::end);
		cin.clear();
	}

	void checkEmptyStr(char* in, int len) {
		char* buf = new char[len+1]();
		cleanCin();
		cin.get(buf, len+1);
		cleanCin();
		bool flag = false;
		int count = 0;
		int k = 0;
		while ((*(buf + k)) != '\0') {
			count++;
			if (count >= len) {
				k = 0;
				count = 0;
				flag = false;
				print("Вы ввели недопустимое количество символов. Повторите ввод.\n");
				cleanCin();
				cin.get(buf, len+1);
				cleanCin();
				continue;
			}
			else {
				flag = true;
			}
			k++;
		}
		cleanCin();
		if (strlen(buf) == 0) {
			print("Вы ввели пустую строку! Повторите ввод:\n");
			checkEmptyStr(in, len);
		}
		if (flag){
			for (int i = 0; i < len; i++) {
				in[i] = *(buf + i);
			}
			delete[] buf;
		}
	}

	bool checkMinus(char* in, int len) {
		if ((in[0] == '-') || (in[strlen(in)-1] == '-')) {
			print("Вводимое значение не может начинаться/заканчиваться с '-'. Повторите ввод.\n");
			return false;
		}
		else {
			return true;
		}
	}

	void backMenu() {
		char temp[2];
		print("Чтобы вернуться в меню нажмите [Enter]");
		cleanCin();
		cin.get(temp, 2);
		cleanCin();
	}

	int checkValue(int value) {
		int _value = value;
		while (true) {
			if (cin.fail()) {
				cin.clear();
				cin.ignore(32767, '\n');
				print("Ошибка! Ожидалось число, повторите ввод------>");
				cin >> value;
				_value = value;
				continue;
			}
			else
				break;
		}
		return _value;
	}

	bool checkMasChar(char* line, int len) {
		int i = 0;
		int x = 1;
		while (line[i] != '\0') {
			if (!((line[i] >= 'а' && line[i] <= 'я') || (line[i] >= 'А' && line[i] <= 'Я'))) {
				i = 0;
				x = 0;
				print("Ожидались символы. Повторите ввод. \n\n");
				break;
			}
			i++;
		}
		if (x == 0) {
			return false;
		}
		else {
			return true;
		}
	}
};

class Student : Functions {
	friend class File;
public:
	Student() {
		surname = new char[31]();
		name = new char[31]();
		middlename = new char[31]();
		day = new int(0);
		month = new int(0);
		year = new int(0);
		yearOfAdmission = new int(0);
		sex = new char[2]();
		faculty = new char[25]();
		departament = new char[25]();
		group = new char[11]();
		recordBookNumber = new char[21]();
	}

	~Student() {
		delete surname;
		delete name;
		delete middlename;
		delete day;
		delete month;
		delete year;
		delete yearOfAdmission;
		delete faculty;
		delete departament;
		delete group;
		delete recordBookNumber;
	}

	void Set() {
		print("Фамилия: ");
		Set(surname, 31);
		if (!strcmp(surname, "-1")) {
			return;
		}
		while (!(checkMasChar(surname, 31))) {
			print("Фамилия: ");
			Set(surname, 31);
		}
		print("Имя: ");
		Set(name, 31);
		while (!(checkMasChar(name, 31))) {
			print("Имя: ");
			Set(name, 31);
		}
		print("Отчество: ");
		Set(middlename, 31);
		while (!(checkMasChar(middlename, 31))) {
			print("Отчество: ");
			Set(middlename, 31);
		}

		print("Дата рождения [дд/мм/гггг]: ");
		while (!checkBirthDay()) {
			print("Дата Рождения [дд/мм/гггг]: ");
		};

		print("Год поступления [1965-2021]: ");
		checkAdmissionYear();

		print("Пол [М/Ж]: ");
		*sex = checkSex();
		*(sex + 1) = '\0';

		print("Факультет: ");
		Set(faculty, 25);
		while (!(checkMasChar(faculty, 25))) {
			print("Факультет: ");
			Set(faculty, 25);
		}

		print("Кафедра: ");
		Set(departament, 25);
		while (!(checkMinus(departament, 25))) {
			print("Кафедра: ");
			Set(departament, 25);
		}

		print("Группа: ");
		Set(group, 11);
		while (!(checkMinus(group, 11))) {
			print("Группа: ");
			Set(group, 11);
		}

		print("Номер зачетной книжки: ");
		checkEmptyStr(recordBookNumber, 21);
		cleanCin();
		while (!(checkMinus(recordBookNumber, 21))) {
			print("Номер зачетной книжки: ");
			Set(recordBookNumber, 21);
		}

		while (!checkRecordBookNumber()) {
			print("Такой номер уже есть в базе\nПопробуйте ввести ещё раз: ");
			checkEmptyStr(recordBookNumber, 21);
			cleanCin();
		}
	}

	bool Edit() {
		int ans;
		cin >> ans;
		cleanCin();
		switch (ans) {
		case 1:
			print("Фамилия: ");
			Set(surname, 31);
			while (!(checkMasChar(surname, 31))) {
				print("Фамилия: ");
				Set(surname, 31);
			}
			break;
		case 2:
			print("Имя: ");
			Set(name, 31);
			while (!(checkMasChar(name, 31))) {
				print("Имя: ");
				Set(name, 31);
			}
			break;
		case 3:
			print("Отчество: ");
			Set(middlename, 31);
			while (!(checkMasChar(middlename, 31))) {
				print("Отчество: ");
				Set(middlename, 31);
			}
			break;
		case 4:
			print("Дата рождения [дд/мм/гггг]: ");
			while (!checkBirthDay()) {
				print("Дата рождения [дд/мм/гггг]: ");
			};
			break;
		case 5:
			print("Год Поступления [1980-2021]: ");
			checkAdmissionYear();
			break;
		case 6:
			print("Пол [м/ж]: ");
			*sex = checkSex();
			*(sex + 1) = '\0';
			break;
		case 7:
			print("Факультет: ");
			Set(faculty, 25);
			while (!(checkMasChar(faculty, 25))) {
				print("Факультет: ");
				Set(faculty, 31);
			}
			break;
		case 8:
			print("Кафедра: ");
			Set(departament, 25);
			while (!(checkMinus(departament, 25))) {
				print("Кафедра: ");
				Set(departament, 25);
			}
			break;
		case 9:
			print("Группа: ");
			Set(group, 11);
			while (!(checkMinus(group, 11))) {
				print("Группа: ");
				Set(group, 11);
			}
			break;
		case 10:
			print("Номер зачетной книжки: ");
			checkEmptyStr(recordBookNumber, 21);
			cleanCin();
			while (!(checkMinus(recordBookNumber, 21))) {
				print("Номер зачетной книжки: ");
				Set(recordBookNumber, 21);
			}
			while (!checkRecordBookNumber()) {
				print("Такой номер зачетной книжки уже существует\n");
				print("Введите Номер зачетной книжки: ");
				checkEmptyStr(recordBookNumber, 21);
				cleanCin();
			}
			break;
		case 11: return true;
		default: {
			print("Введен неверный вариант\n");
			Edit();
		}
		}
		return false;
	}

private:
	char* surname = nullptr;
	char* name = nullptr;
	char* middlename = nullptr;
	int* day = nullptr;
	int* month = nullptr;
	int* year = nullptr;
	int* yearOfAdmission = nullptr;
	char* sex = nullptr;
	char* faculty = nullptr;
	char* departament = nullptr;
	char* group = nullptr;
	char* recordBookNumber = nullptr;

	void studentsPrint(int val) override {
		return;
	}

	void Set(char* in, int len) {
		checkEmptyStr(in, len);
		cleanCin();
	}

	bool checkBirthDay() {
		char* temp = new char[12]();
		*day = 0;
		*month = 0;
		*year = 0;
		cin.get(temp, 12);
		cleanCin();
		bool flag = true;
		int counter1 = 0;
		for (int i = 0; *(temp + i) != '\0'; i++) {
			counter1++;
			flag = true;
			while (flag) {
				if (counter1 >= 11) {
					cout << "Введена слишком длинная строка.\nПовторите ввод в формате [дд/мм/гггг]:";
					cleanCin();
					cin.get(temp, 12);
					cleanCin();
					flag = true;
					i = 0;
					counter1 = 0;
				}
				if ((*(temp + i) >= '0' && *(temp + i) <= '9') || *(temp + i) == ' ' || *(temp + i) == '.' || *(temp + i) == '/' || *(temp + i) == '\0' || *(temp + i) == '\n') {
					flag = false;
				}
				else {
					cout << "В введённой дате рождения содержатся символы отличные от цифр или символов . / [пробел]. Повторите ввод!\nДата рождения [дд/мм/гггг]:";
					cleanCin();
					cin.get(temp, 12);
					cleanCin();
					flag = true;
					i = 0;
					counter1 = 0;
				}
			}
		}
		for (int i = 0; *(temp + i) != '\0'; i++) {
			if (*(temp + i) >= 48 && *(temp + i) <= 57 && ((i >= 0 && i <= 1) || (i >= 3 && i <= 4) || (i >= 6 && i <= 9))) {
				switch (i) {
				case 0: case 1:
					*day = *day * 10 + *(temp + i) - 0x30;
					break;
				case 3: case 4:
					*month = *month * 10 + *(temp + i) - 0x30;
					break;
				case 6: case 7: case 8: case 9:
					*year = *year * 10 + *(temp + i) - 0x30;
					break;
				}
			}
		}
		delete[] temp;
		if (checkDate(*day, *month, *year)) return true;
		else return false;
	}

	void checkAdmissionYear() {
		cin >> *yearOfAdmission;
		while (*yearOfAdmission <= *year || *yearOfAdmission - *year < 15 || *yearOfAdmission < 1965 || *yearOfAdmission > 2021) {
			if (cin.fail()) {
				cin.clear();
				cin.ignore(32767, '\n');
				print("Ошибка! Введите корректные данные\nГод поступления [1965-2021]: ");
				cin >> *yearOfAdmission;
				continue;
			}
			if (*yearOfAdmission - *year <= 15 || *yearOfAdmission < 1965 || *yearOfAdmission > 2021 || *yearOfAdmission <= *year) {
				print("Поступление невозможно в таком возрасте! Повторите ввод\nГод поступления [1965-2021]:");
				cin.ignore(32767, '\n');
				cin >> *yearOfAdmission;
			}
		}
		cleanCin();
	}

	bool checkRecordBookNumber() {
		int* length = new int(0);
		int* len_file = new int(0);
		char* buf = new char[21];
		Crypt crypt;
		crypt.Decrypt();

		ifstream File;
		File.open(PATH, ios::binary);

		File.seekg(0, ios::end);
		*len_file = File.tellg();
		File.seekg(0, ios::beg);

		while (*length != *len_file) {
			File.seekg(171, ios::cur);
			File.read(buf, 21);

			if (!strcmp(buf, recordBookNumber)) {
				File.close();
				crypt.Encrypt();
				return false;
			}

			File.seekg(2290, ios::cur);

			*length += 2482;
		}
		File.close();
		crypt.Encrypt();
		return true;

	}

	bool checkDate(int day, int month, int year) {
		if (day != 0 && month != 0 && year != 0) {
			if (year >= 1950 && year <= 2006) {
				if (month >= 1 && month <= 12) {
					switch (month) {
					case 1: case 3: case 5: case 7: case 8: case 10: case 12:
						if (day >= 1 && day <= 31) {
							return true;
						}
						break;
					case 2:
						if (year % 4 != 0 || year % 100 == 0 && year % 400 != 0) {
							if (day >= 1 && day <= 28) {
								return true;
							}
						}
						else {
							if (day >= 1 && day <= 29) {
								return true;
							}
						}
						break;
					case 4: case 6: case 9: case 11:
						if (day >= 1 && day <= 30) {
							return true;
						}
						break;
					default:
						print("Ошибка! Повторите ввод\n");
						break;
					}
					print("Ошибка! Введите день месяца правильно\n");
				}
				else {
					print("Ошибка! Введите месяц от 1 до 12\n");
				}
			}
			else {
				print("Ошибка! Введите год рождения от 1950 до 2006\n");
			}
		}
		return false;
	}

	char checkSex() {
		char value;
		while (true) {
			cin >> value;
			if (value == 'М' || value == 'Ж' || value == 'ж' || value == 'м') {
				cleanCin();
				return value;
			}
			print("Ошибка! Вводите только буквы М(м)/Ж(ж) \n");
			cleanCin();
		}
	}
};

class Session : Functions {
	friend class File;
public:
	Session() {
		session_count = new int(0);
		sub_count = nullptr;
	}

	~Session() {
		delete session_count;
		delete sub_count;
	}

	void setSession() {
		setSessionCount();
		setSubjCount();
		setSubjects();
	}

	bool editSession() {
		int pos = -1;
		int* temp_2 = nullptr;
		int sum = 0;
		int ans, num = -1, ses;
		cin >> ans;
		cleanCin();
		if (ans == 1) {
			if (*session_count < 9) {
				system("cls");
				print("Введите количество предметов в новой сессии: ");
				cin >> sub_count[*session_count];
				cleanCin();
				for (int j = 0; j < sub_count[*session_count]; j++) {
					subject[*session_count][j].name = new char[21]();
					subject[*session_count][j].mark = new int(0);
					print("Укажите название ");
					print(j + 1);
					print("-го предмета в ");
					print(*session_count + 1);
					print("-й сессии: ");
					checkEmptyStr(subject[*session_count][j].name, 21);
					cleanCin();
					print("Введите оценку за ");
					cout << subject[*session_count][j].name;
					print(": ");
					int buf;
					while (true) {
						cleanCin();
						cin >> buf;
						cleanCin();
						if (buf >= 2 && buf <= 5) {
							*subject[*session_count][j].mark = buf;
							break;
						}
						print("Неверные данные! Вводите значения от 2 до 5\n");
					}
				}
				*(session_count) += 1;
			}
			else {
				print("Достигнуто максимальное количество сессий\n");
				backMenu();
			}
		}
		else if (ans == 2 || ans == 3 || ans == 4) {
			print("Введите номер сессии -----> ");
			cin >> ses;
			if (!(ses != 0 && ses <= *session_count)) {
				print("Номер такой сессии не найден, повторите ввод\n");
				backMenu();
				return false;
			}
			ses -= 1;
			if (ans == 2 || ans == 4)
			{
				print("Введите номер предмета -----> ");
				cin >> num;
				if (!(num <= sub_count[ses] && num != 0)) {
					print("Номер такого предмета не найден, повторите ввод\n");
					backMenu();
					return false;
				}
				num -= 1;
			}
			if (ans == 3) {
				if (*(sub_count + ses) == 10) {
					print("Достигнуто максимальное кол-во предметов\n");
					backMenu();
					return false;
				}
			}
			system("cls");
			if (ans == 2) {
				print("Выбранный предмет: ");
				cout << subject[ses][num].name << "\nОценка: " << *subject[ses][num].mark << "\n";
				print("\nЧто нужно изменить:\n\n[1] Название предмета\n[2] Оценку по предмету\n[3] Вернуться в блок редактирования\n");
				print("-----> ");
				int ans1;
				cin >> ans1;
				switch (ans1) {
				case 1:
					print("Введите название предмета: ");
					checkEmptyStr(subject[ses][num].name, 21);
					break;
				case 2:
					print("Введите оценку: ");
					int buf;
					while (true) {
						cleanCin();
						cin >> buf;
						cleanCin();
						if (buf >= 2 && buf <= 5) {
							*subject[ses][num].mark = buf;
							break;
						}
						print("Неверные данные! Вводите значения от 2 до 5\n");
					}
					break;
				case 3:
					return false;
				}
			}
			if (ans == 3) {
				print("Введите название нового предмета: ");
				checkEmptyStr(subject[ses][sub_count[ses]].name, 21);
				cleanCin();
				print("Введите оценку за ");
				cout << subject[ses][sub_count[ses]].name;
				print(": ");
				int buf;
				while (true) {
					cleanCin();
					cin >> buf;
					cleanCin();
					if (buf >= 2 && buf <= 5) {
						*subject[ses][sub_count[ses]].mark = buf;
						break;
					}
					print("Неверные данные! Вводите значения от 2 до 5\n");
				}
				sub_count[ses] += 1;
			}

			if (ans == 4) {
				if (sub_count[ses] > 1) {
					subject[ses][num].name = subject[ses][sub_count[ses] - 1].name;
					subject[ses][num].mark = subject[ses][sub_count[ses] - 1].mark;
				}
				else {
					subject[ses][num].name = (char*)"\0";
					subject[ses][num].mark = 0;
					(*(session_count))--;
				}
				sub_count[ses]--;
			}
		}
		else if (ans == 5) {
			return true;
		}
		else {
			print("Такого варианта не найдено\n");
			backMenu();
			return false;
		}
		return false;
	}

private:
	int* session_count = nullptr;
	int* sub_count = nullptr;
	Sub subject[9][10];

	void studentsPrint(int val) override {
		return;
	}

	void setSessionCount() {
		print("Введите количество семестров: ");
		int value;
		cin >> value;
		while (value < 1 || value > 9) {
			if (cin.fail()) {
				cin.clear();
				cin.ignore(32767, '\n');
				print("Ошибка! Вводите значения от 1 до 9 \n-----> ");
				cin >> value;
				continue;
			}
			if (value < 1 || value > 9) {
				print("Ошибка! Вводите значения от 1 до 9\n-----> ");
				cin.ignore(32767, '\n');
				cin >> value;
			}
		}
		*session_count = value;
	}

	void setSubjCount() {
		sub_count = new int[9]();
		bool flag = true;
		for (int i = 0; i < *session_count; i++) {
			bool flag = true;
			print("Введите количество предметов в ");
			print(i + 1);
			print("-м семестре: ");
			int* buf = new int();
			cin >> *buf;
			while (*buf < 1 || *buf > 10) {
				if (cin.fail()) {
					cin.clear();
					cin.ignore(32767, '\n');
					print("Ошибка! Вводите значения от 1 до 10 \n-----> ");
					cin >> *buf;
					continue;
				}
				if (*buf < 1 || *buf > 10) {
					print("Ошибка! Вводите значения от 1 до 10\n-----> ");
					cin.ignore(32767, '\n');
					cin >> *buf;
				}
			}
			*(sub_count + i) = *buf;
		}
	}

	void setSubjects() {
		for (int i = 0; i < *session_count; i++) {
			for (int j = 0; j < sub_count[i]; j++) {
				subject[i][j].name = new char[21]();
				subject[i][j].mark = new int(0);
				print("Укажите название ");
				print(j + 1);
				print("-го предмета в ");
				print(i + 1);
				print("-й сессии: ");
				checkEmptyStr(subject[i][j].name, 21);
				cleanCin();
				print("Введите оценку за ");
				cout << subject[i][j].name;
				print(": ");
				int buf;
				while (true) {
					cleanCin();
					cin >> buf;
					cleanCin();
					if (buf >= 2 && buf <= 5) {
						*subject[i][j].mark = buf;
						break;
					}
					print("Неверные данные! Вводите значения от 2 до 5\n");
				}
			}
		}
	}
};

class File : Functions {
public:
	File() {
		file_length = new int(0);
		count = new int(0);
		sum = new int(0);
		rec_book_num = new char[21]();
		edit_student = new Student();
		edit_session = new Session();
	}

	~File() {
		delete file_length;
		delete count;
		delete sum;
	}

	void addStudent() {
		Student* student = new Student;
		Session* session = new Session;
		student->Set();
		if (!strcmp(student->surname, "-1")) {
			delete student;
			delete session;
			return;
		}
		session->setSession();

		Crypt crypt;
		crypt.Decrypt();

		ofstream file(PATH, ios::binary | ios::app);

		file.write(student->surname, 31);
		file.write(student->name, 31);
		file.write(student->middlename, 31);
		file.write((char*)student->day, 4);
		file.write((char*)student->month, 4);
		file.write((char*)student->year, 4);
		file.write((char*)student->sex, 1);
		file.write((char*)student->yearOfAdmission, 4);
		file.write(student->faculty, 25);
		file.write(student->departament, 25);
		file.write(student->group, 11);
		file.write(student->recordBookNumber, 21);

		file.write((char*)session->session_count, 4);

		for (int i = 0; i < 9; i++) {
			file.write((char*)(&*(session->sub_count + i)), 4);
		}

		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 10; j++) {
				file.write((char*)session->subject[i][j].name, 21);
				file.write((char*)session->subject[i][j].mark, 4);
			}
		}

		delete student;
		delete session;
		file.close();

		crypt.Encrypt();
	}

	void editStudent() {
		ofstream test("Students.new.txt", ios::binary);
		test.close();
		Crypt crypt;
		int ans;
		int ans_2;
		if (!isThereStudent()) return;
		system("cls");
		print("Редактирование информации о студенте\n\n");
		printChoice(1);
		while (!findStudent()) {
			print("Такой студент не найден\n");
			print("[1] Чтобы ввести номер другой зачетной книжки, нажмите [1]\n");
			print("[2] Чтобы вернуться в блок редактирования, нажмите [2]\n-----> ");
			cin >> ans_2;
			while (ans_2 != 1 && ans_2 != 2) {
				print("[1] Чтобы ввести другого студента\n");
				print("[2] Чтобы вернуться в блок редактирования, нажмите [2]\n-----> ");
				cin >> ans_2;
			}
			if (ans_2 == 2) return;
		}
		if (pos_f == -1) {
			return;
		}
		bool flag = true;
		while (flag) {
			print("[1] Чтобы редактировать данные о студенте, нажмите [1]\n");
			print("[2] Чтобы редактировать данные о сессии студента, нажмите [2]\n");
			print("[3] Чтобы вернуться в меню, нажмите [3]\n-----> ");
			cin >> ans;
			for (int i = 0; i < *count; i++) {
				pos = i;
				getStudent(PATH_enc);
				if (i != pos_f) {
					fileWriter(PATH_NEW);
				}
				else {
					switch (ans) {
					case 1:
						while (true) {
							system("cls");
							studentsPrint(2);
							print("Это блок редактирования информации о студенте, выберите нужный пункт\n\n");
							print("[1] Чтобы редактировать фамилию студента, нажмите [1]\n");
							print("[2] Чтобы редактировать имя студента, нажмите [2]\n");
							print("[3] Чтобы редактировать отчество студента, нажмите [3]\n");
							print("[4] Чтобы редактировать дату рождения студента, нажмите [4]\n");
							print("[5] Чтобы редактировать год приема студента в университет, нажмите [5]\n");
							print("[6] Чтобы редактировать пол студента, нажмите [6]\n");
							print("[7] Чтобы редактировать факультет студента, нажмите [7]\n");
							print("[8] Чтобы редактировать кафедру студента, нажмите [8]\n");
							print("[9] Чтобы редактировать группу студента, нажмите [9]\n");
							print("[10] Чтобы редактировать номер зачетной книжки студента, нажмите [10]\n");
							print("[11] Чтобы сохранить изменения, нажмите [11]\n\n");
							print("-----> ");
							if (edit_student->Edit()) {
								break;
							}
						}
						break;
					case 2:
						while (true) {
							system("cls");
							print("Это блок редактирования информации о сессии студента\n\n");
							studentsPrint(1);
							studentsPrint(3);
							print("[1] Чтобы добавить новую сессию, нажмите [1]\n");
							print("[2] Чтобы редактировать информацию о предметах студента, нажмите [2]\n");
							print("[3] Чтобы добавить новый предмет в сессию, нажмите [3]\n");
							print("[4] Чтобы удалить предмет из сессии, нажмите [4]\n");
							print("[5] Чтобы сохранить изменения, нажмите [5]\n\n");
							print("-----> ");
							if (edit_session->editSession()) {
								break;
							};
						}
						break;
					case 3:
						flag = false;
						break;
					default:
						if (remove("Students.new.txt") != 0) {
							print("Ошибка при удалении файла!!!\n");
							backMenu();
						}
						print("Такого варианта не найдено\n");
						backMenu();
						break;
					}
					fileWriter(PATH_NEW);
				}
			}
			if (remove("Students.txt.enc") != 0) {
				print("Ошибка при удалении файла!!!\n");
				backMenu();
			}
			if (rename("Students.new.txt", PATH) != 0) {
				print("Ошибка при переименовании файла!!!\n");
				backMenu();
			}
			crypt.Encrypt();
			flag = false;
		}
		delete rec_book_num;
	}

	void delStudent() {
		fstream file(PATH_NEW, ios::binary | ios::out);
		file.close();
		Crypt crypt;
		if (!isThereStudent()) return;
		pos = -1;
		rec_book_num = new char[21]();
		printChoice(1);
		print("Введите номер зачетной книжки(-1 чтобы вернуться назад) >> ");
		cleanCin();
		checkEmptyStr(rec_book_num, 21);
		cleanCin();
		if (!strcmp(rec_book_num, "-1")) {
			return;
		}

		for (int i = 0; i < *count; i++) {
			pos = i;
			getStudent(PATH_enc);
			if (!strcmp(rec_book_num, edit_student->recordBookNumber)) {
				pos_f = i;
				break;
			}
		}
		int pos_w = 0, pos_r = 0;
		if (pos_f != -1) {
			for (int i = 0; i < *count; i++) {
				pos = pos_r;
				getStudent(PATH_enc);
				if (i != pos_f) {
					pos = pos_w;
					fileWriter(PATH_NEW);
					pos_w += 1;
				}
				pos_r++;
			}
			if (remove(PATH_enc) != 0) {
				print("Ошибка при удалении файла!!!\n");
				backMenu();
			};
			if (rename(PATH_NEW, PATH) != 0) {
				print("Ошибка при переименовании файла!!!\n");
				backMenu();
			}
			crypt.Encrypt();
		}
		else {
			print("Такой студент не найден\n");
			delStudent();
		}
		delete rec_book_num;
	}

	void printChoice(int rez) {
		if (!isThereStudent()) return;
		for (int i = 0; i < *count; i++) {
			pos = i;
			getStudent(PATH_enc);
			switch (rez) {
			case 1:
				studentsPrint(1);
				break;
			case 2:
				studentsPrint(2);
				break;
			case 3:
				studentsPrint(1);
				studentsPrint(3);
				break;
			case 4:
				studentsPrint(2);
				studentsPrint(3);
				break;
			}
		}
	}

	void task(int up, int down) {

		fstream file(PATH1, ios::binary | ios::out);
		file.close();
		file.open(PATH2, ios::binary | ios::out);
		file.close();

		if (!isThereStudent()) {
			return;
		}
		for (int i = 0; i < *count; i++) {
			pos = i;
			getStudent(PATH_enc);
			if ((((*(edit_student->surname)) >= 'А') && (((*(edit_student->surname)) <= 'П') ||  ((*(edit_student->surname)) >= 'а')) && ((*(edit_student->surname)) <= 'п'))) {
				pos = count1;
				count1++;
				fileWriter(PATH1);
			}
			else if ((((*(edit_student->surname)) >= 'Р') && (((*(edit_student->surname)) <= 'р') || ((*(edit_student->surname)) >= 'Я')) && ((*(edit_student->surname)) <= 'я'))) {
				pos = count2;
				count2++;
				fileWriter(PATH2);
			}
		}
		print("\n\nСтуденты от А до П: \n\n");
		print("============================================================================================\n\n");
		sort(PATH1, count1);
		for (int i = 0; i < count1; i++) {
			pos = i;
			getStudent(PATH1);
			if ((*(edit_student->year) >= down) && (*(edit_student->year) <= up)) {
				studentsPrint(2);
				double sum = 0;
				double k = 0;
				for (int i = 0; i < *edit_session->session_count; i++) {
					for (int j = 0; j < edit_session->sub_count[i]; j++) {
						sum += *edit_session->subject[i][j].mark;
						k++;
					}
				}
				cout << "Средний балл студента: " << sum / k << endl;
			}
		}
		print("============================================================================================\n\n");
		print("Студенты от Р до Я: \n\n");
		print("============================================================================================\n\n");
		sort(PATH2, count2);
		for (int i = 0; i < count2; i++) {
			pos = i;
			getStudent(PATH2);
			if ((*(edit_student->year) >= down) && (*(edit_student->year) <= up)) {
				studentsPrint(2);
				double sum = 0;
				double k = 0;
				for (int i = 0; i < *edit_session->session_count; i++) {
					for (int j = 0; j < edit_session->sub_count[i]; j++) {
						sum += *edit_session->subject[i][j].mark;
						k++;
					}
				}
				cout << "Средний балл студента: " << sum / k << endl;
			}
		}
		print("============================================================================================\n\n");
	}

	void sort(const char* file_name, int count) {
		int min_index = -1;
		int temp_pos = -1;
		Student* min_student = new Student();
		Student* temp_std = new Student();
		Session* min_session = new Session();
		Session* temp_ses = new Session();

		for (int i = 0; i < count - 1; i++)
		{
			min_index = i;
			pos = i;
			edit_student = min_student;
			edit_session = min_session;
			getStudent(file_name);
			for (int j = i + 1; j < count; j++) {
				pos = j;
				edit_student = temp_std;
				edit_session = temp_ses;
				getStudent(file_name);

				if (!min_sr(*min_session, *temp_ses)) {
					min_index = pos;
					edit_student = min_student;
					edit_session = min_session;
					getStudent(file_name);
				}
			}

			if (i != min_index) {
				pos = i;
				edit_student = temp_std;
				edit_session = temp_ses;
				getStudent(file_name);
				edit_student = min_student;
				edit_session = min_session;
				fileWriter(file_name);
				pos = min_index;
				edit_student = temp_std;
				edit_session = temp_ses;
				fileWriter(file_name);
			}
		}
	}

	bool min_sr(Session& t1, Session& t2) {
		double sr_1 = 0, sr_2 = 0;
		int count_1 = 0, count_2 = 0;

		for (int i = 0; i < *t1.session_count; i++) {
			for (int j = 0; j < t1.sub_count[i]; j++)
			{
				sr_1 += *t1.subject[i][j].mark;
			}
			count_1 += t1.sub_count[i];
		}

		for (int i = 0; i < *t2.session_count; i++) {
			for (int j = 0; j < t2.sub_count[i]; j++)
			{
				sr_2 += *t2.subject[i][j].mark;
			}
			count_2 += t2.sub_count[i];
		}

		sr_1 = sr_1 / count_1;
		sr_2 = sr_2 / count_2;

		if (sr_1 < sr_2) {
			return true;
		}
		else {
			return false;
		}
	}

private:
	Student* edit_student = nullptr;
	Session* edit_session = nullptr;
	int* file_length;
	int pos = -1;
	int pos_f = -1;
	int count1 = 0, count2 = 0;
	int* count;
	int* sum;
	char* rec_book_num;

	bool findStudent() {
		pos_f = -1;
		rec_book_num = new char[21]();
		print("Введите номер зачетной книжки(-1 чтобы вернуться обратно) >> ");
		cleanCin();
		checkEmptyStr(rec_book_num, 21);
		cleanCin();

		if (!strcmp(rec_book_num, "-1")) {
			return true;
		}

		for (int i = 0; i < *count; i++) {
			pos = i;
			getStudent(PATH_enc);
			if (!strcmp(rec_book_num, edit_student->recordBookNumber)) {
				pos_f = i;
				return true;
			}
		}
		return false;
	}

	void getStudent(const char* name_file) {
		Crypt crypt;
		const char* name;
		if (!strcmp(name_file, "Students.txt.enc")) {
			crypt.Decrypt();
			name = "Students.txt";
		}
		else {
			name = name_file;
		}

		ifstream File;
		File.open(name, ios::binary);

		File.seekg(0, ios::end);
		*file_length = File.tellg();
		File.seekg(pos * 2482, ios::beg);

		File.read(edit_student->surname, 31);
		File.read(edit_student->name, 31);
		File.read(edit_student->middlename, 31);
		File.read((char*)edit_student->day, 4);
		File.read((char*)edit_student->month, 4);
		File.read((char*)edit_student->year, 4);
		File.read(edit_student->sex, 1);
		File.read((char*)edit_student->yearOfAdmission, 4);
		File.read(edit_student->faculty, 25);
		File.read(edit_student->departament, 25);
		File.read(edit_student->group, 11);
		File.read(edit_student->recordBookNumber, 21);

		File.read((char*)edit_session->session_count, 4);

		edit_session->sub_count = new int[9];

		for (int i = 0; i < 9; i++) {
			File.read((char*)(&*(edit_session->sub_count + i)), 4);
		}

		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 10; j++) {
				File.read(edit_session->subject[i][j].name, 21);
				File.read((char*)(edit_session->subject[i][j].mark), 4);
			}
		}
		File.close();
		if (!strcmp(name_file, "Students.txt.enc")) {
			crypt.Encrypt();
		}
	}

	void fileWriter(const char* name_file) {
		fstream FILE_NEW;
		if (!strcmp(name_file, PATH)) {
			FILE_NEW.open(name_file, ios::binary | ios::app | ios::out);
		}
		else {
			FILE_NEW.open(name_file, ios::binary | ios::in | ios::out);
			FILE_NEW.seekp(pos * 2482, ios::beg);
		}

		FILE_NEW.write(edit_student->surname, 31);
		FILE_NEW.write(edit_student->name, 31);
		FILE_NEW.write(edit_student->middlename, 31);
		FILE_NEW.write((char*)edit_student->day, 4);
		FILE_NEW.write((char*)edit_student->month, 4);
		FILE_NEW.write((char*)edit_student->year, 4);
		FILE_NEW.write((char*)edit_student->sex, 1);
		FILE_NEW.write((char*)edit_student->yearOfAdmission, 4);
		FILE_NEW.write(edit_student->faculty, 25);
		FILE_NEW.write(edit_student->departament, 25);
		FILE_NEW.write(edit_student->group, 11);
		FILE_NEW.write(edit_student->recordBookNumber, 21);

		FILE_NEW.write((char*)edit_session->session_count, 4);

		for (int i = 0; i < 9; i++) {
			FILE_NEW.write((char*)(&*(edit_session->sub_count + i)), 4);
		}

		for (int i = 0; i < 9; i++)
		{
			for (int j = 0; j < 10; j++) {
				FILE_NEW.write((char*)edit_session->subject[i][j].name, 21);
				FILE_NEW.write((char*)edit_session->subject[i][j].mark, 4);
			}
		}
		FILE_NEW.close();
	}

	bool isThereStudent() {
		fstream file("Students.txt.enc", ios::binary | ios::in);
		file.seekg(0, ios::end);
		if (file.tellg() == -1 || file.tellg() == 0) {
			file.close();
			print("Файл пустой, доступна только функция добавления студентов\n");
			return false;
		}
		file.close();

		Crypt* crypt = new Crypt;
		crypt->Decrypt();
		ifstream File;
		File.open(PATH, ios::binary);

		File.seekg(0, ios::end);
		*file_length = File.tellg();
		*count = *(file_length) / 2482;

		File.close();
		crypt->Encrypt();
		return true;
	}

	void studentsPrint(int rez) override {
		switch (rez) {
		case 1:
			print("--------------------------------------------------------------------------------------------\n\nДАННЫЕ О СТУДЕНТЕ\n\n");
			cout << "ФИО: " << edit_student->surname << " " << edit_student->name << " " << edit_student->middlename << "\n";
			cout << "Номер зачетной книжки: " << edit_student->recordBookNumber << "\n\n";
			break;
		case 2:
			print("--------------------------------------------------------------------------------------------\n\nДАННЫЕ О СТУДЕНТЕ\n\n");
			cout << "ФИО: " << edit_student->surname << " " << edit_student->name << " " << edit_student->middlename << "\n";
			cout << "Дата рождения: " << *edit_student->day << "." << *edit_student->month << "." << *edit_student->year << " Год приема: " << *edit_student->yearOfAdmission << "\n";
			cout << "Пол: " << edit_student->sex << " Факультет: " << edit_student->faculty << " Кафедра: " << edit_student->departament << " Группа: " << edit_student->group << "\n";
			cout << "Номер зачетной книжки: " << edit_student->recordBookNumber << "\n\n";
			break;
		case 3:
			print("ОЦЕНКИ \n\n");
			int sum = 0;
			for (int i = 0; i < *edit_session->session_count; i++) {
				cout << "Cессия " << i + 1 << "\n\n";
				for (int j = 0; j < edit_session->sub_count[i]; j++) {
					cout << j + 1 << ") " << edit_session->subject[i][j].name << " ::: " << *edit_session->subject[i][j].mark << "\n";
					sum++;
				}
				print("\n");
			}
			break;
		}
	}
};

class Menu : Functions {
public:
	Menu() {
		ans = new int;
		file = new File;
	}

	~Menu() {
		delete file;
		delete ans;
	}

	bool hub() {
		file = new File;
		system("cls");
		print("ДОБРО ПОЖАЛОВАТЬ В МЕНЮ ПРОГРАММЫ\n\n");
		print("Нажмите соответствующую цифру, для выбора действия: \n\n");
		print("[1] Чтобы выполнить задание, нажмите [1]\n");
		print("[2] Чтобы добавить в базу нового студента, нажмите [2]\n");
		print("[3] Чтобы удалить студента из базы, нажмите [3]\n");
		print("[4] Чтобы изменить данные о студенте, нажмите [4]\n");
		print("[5] Чтобы вывести на экран всю базу студентов, нажмите [5]\n");
		print("[6] Чтобы выйти из программы, нажмите [6]\n\n-----> ");
		cin >> *ans;
		while (*ans < 1 || *ans>6) {
			if (cin.fail()) {
				cin.clear();
				cin.ignore(32767, '\n');
				print("Ошибка! Введите номер пункта меню, который хотите вывести\n-----> ");
				cin >> *ans;
				continue;
			}
			if (*ans < 1 || *ans>6) {
				print("Вы ввели число не из диапозона [1;6]. Повторите ввод\n-----> ");
				cin.ignore(32767, '\n');
				cin >> *ans;
			}
		}
		cleanCin();
		switch (*ans) {
		case 1: {
			system("cls");
			int yearUp, yearDown;
			print("Чтобы вернуться в меню, введите в одно из полей интервала -1\n\n");
			
			print("Введите нижний предел года рождения для поиска\n\n");
			print("------>");
			cin >> yearDown;
			yearDown = checkValue(yearDown);

			while ((yearDown < 1950) || (yearDown > 2006)) {
				if ((yearDown < 1950) && (yearDown > -1)) {
					print("Нижний предел задан не верно. Минимальный год рождения 1950.\n\n");
					print("Введите нижний предел года рождения для поиска:\n\n");
					print("------>");
					cin >> yearDown;
					yearDown = checkValue(yearDown);
					continue;
				}
				if (yearDown > 2006) {
					print("Нижний предел задан не верно. Введите значение от 1950 до 2006.\n\n");
					print("Введите нижний предел года рождения для поиска:\n\n");
					print("------>");
					cin >> yearDown;
					yearDown = checkValue(yearDown);
					continue;
				}
				if (yearDown < -1) {
					print("Ошибка! Введите -1 или нижний предел года рождения\n\n");
					print("------>");
					cin >> yearDown;
					yearDown = checkValue(yearDown);
					continue;
				}
				if (yearDown == -1) {
					backMenu();
					break;
				}
			}
			if (yearDown == -1) {
				break;
			}

			print("Введите верхний предел года рождения для поиска\n\n");
			print("------>");
			cin >> yearUp;
			yearUp = checkValue(yearUp);

			while ((yearUp < 1950) || (yearUp > 2006)) {
				if (yearUp > 2006) {
					print("Верхний предел задан неверно. Максимальный год рождения 2006.\n\n");
					print("Введите верхний предел года рождения для поиска:\n\n");
					print("------>");
					cin >> yearUp;
					yearUp = checkValue(yearUp);
					continue;
				}
				if ((yearUp < 1950) && (yearUp > -1)) {
					print("Верхний предел задан неверно. Введите значение от 1950 до 2006.\n\n");
					print("Введите верхний предел года рождения для поиска:\n\n");
					print("------>");
					cin >> yearUp;
					yearUp = checkValue(yearUp);
					continue;
				}
				if (yearUp < -1) {
					print("Ошибка! Введите -1 или верхний предел года рождения\n\n");
					print("------>");
					cin >> yearUp;
					yearUp = checkValue(yearUp);
					continue;
				}
				if (yearUp == -1) {
					backMenu();
					break;
				}
			}
			if (yearUp == -1) {
				break;
			}
			
			while (yearUp - yearDown < 0) {
				print("Интервал задан неверно. Нижний предел должен быть МЕНЬШЕ верхнего.\n\n");
				print("Введите интервал заново.\n\n");

				print("Введите нижний предел года рождения для поиска:\n\n");
				print("------>");
				cin >> yearDown;
				yearDown = checkValue(yearDown);

				while ((yearDown < 1950) || (yearDown > 2006)) {
					if (yearDown < 1950) {
						print("Нижний предел задан не верно. Минимальный год рождения 1950.\n\n");
						print("Введите нижний предел года рождения для поиска:\n\n");
						print("------>");
						cin >> yearDown;
						yearDown = checkValue(yearDown);
						continue;
					}
					if (yearDown > 2006) {
						print("Нижний предел задан не верно. Введите значение от 1950 до 2006.\n\n");
						print("Введите нижний предел года рождения для поиска:\n\n");
						print("------>");
						cin >> yearDown;
						yearDown = checkValue(yearDown);
						continue;
					}
					if (yearDown < -1) {
						print("Ошибка! Введите -1 или нижний предел года рождения\n\n");
						print("------>");
						cin >> yearDown;
						yearDown = checkValue(yearDown);
						continue;
					}
					if (yearDown == -1) {
						backMenu();
						break;
					}
				}
				if (yearDown == -1) {
					break;
				}

				print("Введите верхний интервал года рождения для поиска:\n\n");
				print("------>");
				cin >> yearUp;
				yearUp = checkValue(yearUp);

				while ((yearUp < 1950) || (yearUp > 2006)) {
					if (yearUp > 2006) {
						print("Верхний предел задан неверно. Максимальный год рождения 2006.\n\n");
						print("Введите верхний предел года рождения для поиска:\n\n");
						print("------>");
						cin >> yearUp;
						yearUp = checkValue(yearUp);
						continue;
					}
					if (yearUp < 1950) {
						print("Верхний предел задан неверно. Введите значение от 1950 до 2006.\n\n");
						print("Введите верхний предел года рождения для поиска:\n\n");
						print("------>");
						cin >> yearUp;
						yearUp = checkValue(yearUp);
						continue;
					}
					if (yearUp < -1) {
						print("Ошибка! Введите -1 или верхний предел года рождения\n\n");
						print("------>");
						cin >> yearUp;
						yearUp = checkValue(yearUp);
						continue;
					}
					if (yearUp == -1) {
						backMenu();
						break;
					}
				}
				if (yearUp == -1) {
					break;
				}

			}

			if ((yearDown == -1) || (yearUp == -1)) {
				break;
			}

			file->task(yearUp, yearDown);

			backMenu();
			break;
		}
		case 2: {
			system("cls");
			print("Добавление нового студента(Введите -1, чтобы вернуться назад)\n\n");
			file->addStudent();
			backMenu();
			break;
		}
		case 3: {
			system("cls");
			print("Удаление студента\n");
			file->delStudent();
			backMenu();
			break;
		}
		case 4: {
			file->editStudent();
			backMenu();
			break;
		}
		case 5: {
			system("cls");
			print("Какую информацию вы хотите получить:\n\n");
			print("Чтобы получить краткую информацию (без данных о сессии), нажмите [1]\n");
			print("Чтобы получить всю информацию о студентах, нажмите [2]\n");
			print("Чтобы вернуться в меню, нажмите [3]\n\n");
			print("-----> ");
			cin >> *ans;
			switch (*ans) {
			case 1: {
				file->printChoice(2);
				backMenu();
				break;
			}
			case 2: {
				file->printChoice(4);
				backMenu();
				break;
			}
			case 3: {
				break;
			}
			}
			break;
		}
		case 6:
			return false;
		}
		return true;
		delete file;
	}
private:
	File* file = nullptr;
	int* ans = nullptr;

	void studentsPrint(int rez) {
		return;
	}
};

int main()
{
	RUS;
	Menu* menu = new Menu();
	while (menu->hub());
	delete menu;
	return 0;
}