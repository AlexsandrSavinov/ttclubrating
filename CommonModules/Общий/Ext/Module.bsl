﻿
Функция ВыделитьСлово(ИсходнаяСтрока,СтрокаПоиска = " ") Экспорт
	
	Буфер = СокрЛ(ИсходнаяСтрока);
	ПозицияПослПробела = Найти(Буфер, СтрокаПоиска);

	Если ПозицияПослПробела = 0 Тогда
		ИсходнаяСтрока = "";
		Возврат Буфер;
	КонецЕсли;
	
	ВыделенноеСлово = СокрЛП(Лев(Буфер, ПозицияПослПробела));
	ИсходнаяСтрока = Сред(ИсходнаяСтрока, ПозицияПослПробела + 1);
	
	Возврат ВыделенноеСлово;
	
КонецФункции

Функция ОбработатьСекундыНаВремя(КолСекунд) Экспорт
	
	Если КолСекунд = 60 Тогда
		Возврат "1 мин.";
	КонецЕсли; 
	Если КолСекунд < 60 Тогда
		Возврат ""+КолСекунд + " сек.";
	ИначеЕсли КолСекунд > 60 Тогда //уже как минимум 1 минута
		Час1 = 60*60;
		Если КолСекунд > Час1 Тогда
			//1 мин = 60 сек
			//60 мин = 3600 сек
			//24*60 = 3600*24 сек = 86400 сутки;
			секунды = КолСекунд;
			Дни=цел(секунды/24/60/60);
			секунды=секунды - дни*24*60*60;
			Часы=цел(секунды/60/60);
			секунды=секунды-часы*60*60;
			минуты=цел(секунды/60);
			секунды=секунды-минуты*60;
			Возврат ""+Дни+" дн. "+Часы+" ч. "+минуты+" мин. "+секунды+ " сек.";
		Иначе 
			КолМинут = Цел(КолСекунд/60);
			КолСекундДляОбработки = КолСекунд - (КолМинут*60); //на всякий )))
			Возврат ""+КолМинут+" мин. "+КолСекундДляОбработки+ " сек.";
		КонецЕсли;
	КонецЕсли; 
	
КонецФункции

//формирует строковое значение Фамилия И.О.
Функция СформироватьИмяИгрока(Участник) Экспорт 
	
	//глНаименование = Участник.Наименование;
	глНаименование = Строка(Участник);
	
	Если глНаименование <> "" Тогда
		Фам 	= ВыделитьСлово(глНаименование);
		Имя  	= ВыделитьСлово(глНаименование);
		Отч 	= ВыделитьСлово(глНаименование);
		Если Фам <> "" И Имя <> "" И Отч <> "" Тогда
			Возврат Фам +" "+ВРег(Лев(Имя,1))+"."+ВРег(Лев(Отч,1))+".";
		ИначеЕсли Отч = "" И Имя <> "" Тогда //Фамилия и имя уж точно должны быть заполнены
			Возврат Фам +" "+ВРег(Лев(Имя,1))+".";
		ИначеЕсли Отч = "" И Имя = "" Тогда
			Возврат Фам;
		Иначе
			Возврат Строка(Участник);
		КонецЕсли;
	Иначе
		Возврат Строка(Участник);
	КонецЕсли;
	
КонецФункции

Функция ОпределитьКолПартий(КолПартий) Экспорт
	
	Если КолПартий = 3 Тогда
		ИтогСтроки = 2;
	ИначеЕсли КолПартий = 5 Тогда
		ИтогСтроки = 3;
	ИначеЕсли КолПартий = 7 Тогда
		ИтогСтроки = 4;
	КонецЕсли;
	Возврат ИтогСтроки;
	
КонецФункции

Функция ПриведениеИзСтрокиВДату(стрДата) Экспорт
	
	Если стрДата = "" Или стрДата = Неопределено Тогда
		Возврат Дата('00010101');
	ИначеЕсли ТипЗнч(стрДата) = Тип("Дата") Тогда
		Возврат стрДата;
	ИначеЕсли ЗначениеЗаполнено(стрДата) Тогда  //должен быть по формату
		//день.месяц.год 	//01.01.1999
		//заменим точки
		стрДата = СтрЗаменить(стрДата,".","");
		ДеньДаты 	= Строка(Лев(стрДата,2));
		МесяцДаты 	= Строка(Сред(стрДата,3,2));
		ГодДаты 		= Строка(Прав(стрДата,4));
		Возврат Дата(ГодДаты+МесяцДаты+ДеньДаты);
	Иначе
		Возврат Дата('00010101');
	КонецЕсли;
	
КонецФункции

Процедура ЗадатьПараметрыПечатиДляПротокола(ТабличныйДокумент,Режим) Экспорт
	
	Если Режим = ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.Групповой") Тогда
		ТабличныйДокумент.АвтоМасштаб = Истина;
		ТабличныйДокумент.ПолеСверху = 5;
		ТабличныйДокумент.ПолеСнизу = 5;
		ТабличныйДокумент.ПолеСлева = 5;
		ТабличныйДокумент.ПолеСправа = 5;
	Иначе
		ТабличныйДокумент.АвтоМасштаб = Истина;
		ТабличныйДокумент.ПолеСверху = 5;
		ТабличныйДокумент.ПолеСнизу = 5;
		ТабличныйДокумент.ПолеСлева = 5;
		ТабличныйДокумент.ПолеСправа = 5;
		ТабличныйДокумент.РазмерКолонтитулаСверху = 5;
		ТабличныйДокумент.ВерхнийКолонтитул.Выводить = Истина;
		ТабличныйДокумент.ВерхнийКолонтитул.НачальнаяСтраница = 1;
		ТабличныйДокумент.ВерхнийКолонтитул.ТекстСправа = "Стр. [&НомерСтраницы]";
	КонецЕсли; 
	
КонецПроцедуры

Функция ЭтоLinux() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы =  ТипПлатформы.Linux_x86
		Или СистемнаяИнформация.ТипПлатформы =  ТипПлатформы.Linux_x86_64 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли; 
	
КонецФункции
 
Функция ЭтоWindows() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы =  ТипПлатформы.Windows_x86
		Или СистемнаяИнформация.ТипПлатформы =  ТипПлатформы.Windows_x86_64 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли; 
	
КонецФункции
