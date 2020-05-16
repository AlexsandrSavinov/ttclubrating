
&НаКлиенте
Процедура НумерацияУчастниковВСеткеПриИзменении(Элемент)
	УстановкаИнформацииПоНумерацииСеток();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановкаИнформацииПоНумерацииСеток();
	ОбновитьСтраницу();
КонецПроцедуры

&НаСервере
Процедура УстановкаИнформацииПоНумерацииСеток()
	Если НаборКонстант.НумерацияУчастниковВСетке = ПредопределенноеЗначение("Перечисление.НумерацияВСетке.ПоПорядку") Тогда
		Элементы.Декорация3.Заголовок = "На примере сетки из 8 участников: 1. 1-2, 2. 3-4, 3. 5-6, 4. 7-8";
	ИначеЕсли НаборКонстант.НумерацияУчастниковВСетке = ПредопределенноеЗначение("Перечисление.НумерацияВСетке.ПервыйПоследний") Тогда
		Элементы.Декорация3.Заголовок = "На примере сетки из 8 участников: 1. 1-8, 2. 5-4, 3. 3-6, 4. 7-2";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокОкнаПриИзменении(Элемент)
	Если НаборКонстант.ЗаголовокОкна <> "" Тогда
		УстановитьЗаголовокПриложения(НаборКонстант.ЗаголовокОкна);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПутьКImagemagickНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Если Общий.ЭтоWindows() Тогда
		Диалог.Фильтр = "Исполняемые файлы (*.exe) | *.exe";
		Диалог.Заголовок = "Выберите исполнямый файл wkhtmltoimage.exe";
	Иначе
		//Диалог.Фильтр = "Исполняемые файлы (*.exe) | *.exe";
		Диалог.Заголовок = "Выберите исполнямый файл wkhtmltoimage";
	КонецЕсли; 
	Диалог.Показать(Новый ОписаниеОповещения("ПослеВыбора",ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбора(ВыбранныеФайлы,ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		НаборКонстант.ПутьКwkhtmltoimage_exe= ВыбранныеФайлы[0];	
		Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация5Нажатие(Элемент)
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеСсылки",ЭтотОбъект),"https://wkhtmltopdf.org/downloads.html");	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСсылки(КодВозврата,ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОткрытияПодбораОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НаборКонстант.СпособОткрытияПодбора = ВыбранноеЗначение;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображениеСтраницыДокументСформирован(Элемент)
		
	Если Элемент.Документ.location.host = "oauth.vk.com" Тогда
		hash = Сред(Элемент.Документ.location.hash, 2);
		МассивСтрок = СтрРазделить(hash, "&");
		
		Для каждого Параметр ИЗ МассивСтрок Цикл
			
			ИмяПараметра = "";
			ЗначениеПараметра = "";
			
			Поз = Найти(Параметр, "=");
			Если Поз = 0 Тогда
				ИмяПараметра = Параметр;
				ЗначениеПараметра = "";
			Иначе
				ИмяПараметра = НРег(СокрЛП(Лев(Параметр,Поз-1)));
				ЗначениеПараметра = СокрЛП(Сред(Параметр, Поз+1));
			КонецЕсли;
			
			Если ИмяПараметра = "access_token" Тогда
				Если Не ЗначениеЗаполнено(НаборКонстант.ТокенВК) Тогда
					НаборКонстант.ТокенВК = ЗначениеПараметра;
					Модифицированность = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
					Сообщение.Текст = "Токен вконтакте успешно получен.";
					Сообщение.Сообщить(); 
				КонецЕсли; 
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИДПриложенияПриИзменении(Элемент)
	
	НаборКонстант.ИДПриложения = СокрЛП(НаборКонстант.ИДПриложения);
	ОбновитьСтраницу();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтраницу()
	
	Если ЗначениеЗаполнено(НаборКонстант.ИДПриложения) Тогда
		ОтображениеСтраницы = "https://oauth.vk.com/authorize?client_id="+НаборКонстант.ИДПриложения+"&scope=wall,offline,docs,photos&redirect_uri=https://oauth.vk.com/blank.html&display=page&response_type=token";
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	НаборКонстант.ТокенВК = "";
	ОбновитьСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСоздатьПриложение(Команда)
	
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеОткрытияСсылки",ЭтотОбъект),"https://vk.com/editapp?act=create");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияСсылки(КодВозврата,ДопПараметры) Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Общий.ЭтоWindows() Тогда
		
	ИначеЕсли Общий.ЭтоLinux() Тогда 
		Элементы.ПутьКImagemagick.ПодсказкаВвода = "wkhtmltoimage"
	КонецЕсли; 
	ОбновитьВидимостьЭлементов();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПомощьНажатие(Элемент)
	
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеЗапускаПриложения",ЭтотОбъект),"https://youtu.be/PvKJPIx5ihU");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаПриложения(КодВозврата,ДопПараметры) Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПроксиСервера(Команда)
	РаботаССоциальнымиСетямиСервер.ОбновитьПроксиСервераНаСервере();
	Элементы.ПроксиСервера.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьЭлементов()
			
	Элементы.ПроксиСервера.Видимость = НаборКонстант.ИспользоватьПроксиДляТелеграмма;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПроксиДляТелеграммаПриИзменении(Элемент)
	ОбновитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПроверитьСервераНаДоступность(Команда)
	РаботаССоциальнымиСетямиСервер.ПроверкаПроксиСерверовКТелеграмм();
	Элементы.ПроксиСервера.Обновить();
	ПоказатьОповещениеПользователя("Внимание",,"Проверка прокси серверов закончена", БиблиотекаКартинок.ДиалогИнформация);
КонецПроцедуры
 
