
Функция ПроверитьТабличныйДокумент(ТабДок) Экспорт
	
	к = 1;
	
КонецФункции

#Область ВКОНТАКТЕ

Функция ПолучитьПоследнийВариантРазмещенияВВК() Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить("НастройкаРазмещенияВВК");
	
КонецФункции

Процедура СохранитьВариантРазмещенияВВК(парФормат = "") Экспорт
	
	ХранилищеОбщихНастроек.Сохранить("НастройкаРазмещенияВВК",,парФормат);
	
КонецПроцедуры

Функция ПолучитьТокенВК() Экспорт
	Возврат Константы.ТокенВК.Получить();
КонецФункции

#КонецОбласти 

#Область ТЕЛЕГРАММ

Функция АктивныеБоты() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТелеграммБоты.Ссылка КАК Бот,
	|	ТелеграммБоты.Токен КАК Токен
	|ИЗ
	|	Справочник.ТелеграммБоты КАК ТелеграммБоты
	|ГДЕ
	|	ТелеграммБоты.ПометкаУдаления = ЛОЖЬ
	|	И ТелеграммБоты.Активен
	|	И ТелеграммБоты.Токен <> """"";
	 Результат = Запрос.Выполнить().Выгрузить();
	 
	 Возврат Серверные.ТаблицаЗначенийВМассив(Результат);
	 
КонецФункции
 
#КонецОбласти 

Процедура ОбновитьПроксиСервераНаСервере() Экспорт
	
	ИмяСервера = "www.proxy-list.download";
	URL = "api/v1/get?type=https&anon=transparent";
	
	HTTPЗапрос = Новый HTTPЗапрос(URL);
	HTTP = Новый HTTPСоединение(ИмяСервера,,,,,,Новый ЗащищенноеСоединениеOpenSSL());
	ОтветHTTP = HTTP.Получить(HTTPЗапрос);
	Ответ = ОтветHTTP.ПолучитьТелоКакСтроку();
	
	МассивСтрок = Новый Массив();
	Для Н = 1 По СтрЧислоСтрок(Ответ) Цикл
		Строка = СтрЗаменить(СтрПолучитьСтроку(Ответ, Н), Символы.ВК, "");
		МассивСтрок.Добавить(СтрРазделить(Строка, ":"));
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПроксиСервера.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПроксиСервера КАК ПроксиСервера
	|ГДЕ
	|	ПроксиСервера.ПометкаУдаления = ЛОЖЬ
	|	И ПроксиСервера.Наименование = &Наименование
	|	И ПроксиСервера.Порт = &Порт";
	
	Для каждого ТекПрокси  Из МассивСтрок Цикл
		
		ИППрокси 		= СокрЛП(ТекПрокси[0]);
		ПортПрокси 		= Число(ТекПрокси[1]);
		
		Запрос.УстановитьПараметр("Наименование", ИППрокси);
		Запрос.УстановитьПараметр("Порт", ПортПрокси);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			
			НовЭлемент = Справочники.ПроксиСервера.СоздатьЭлемент();
			НовЭлемент.Наименование 	= ИППрокси;
			НовЭлемент.Порт						= ПортПрокси;
			НовЭлемент.Протокол				= "https";
			НовЭлемент.Записать();
			
		КонецЕсли;
		
	КонецЦикла; 
		
КонецПроцедуры

Функция ПолучитьВсеПроксиСервера() Экспорт
	
	Если Константы.ИспользоватьПроксиДляТелеграмма.Получить() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПроксиСервера.Наименование КАК ИПАдрес,
		|	ПроксиСервера.Порт КАК Порт,
		|	ПроксиСервера.Пользователь КАК Пользователь,
		|	ПроксиСервера.Пароль КАК Пароль,
		|	ПроксиСервера.Протокол КАК Протокол,
		|	ПроксиСервера.Ссылка КАК СсылкаНаПроксиСервер
		|ИЗ
		|	Справочник.ПроксиСервера КАК ПроксиСервера
		|ГДЕ
		|	ПроксиСервера.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПроксиСервера.Код";
		
		Результат = Запрос.Выполнить().Выгрузить();
		
		Возврат Серверные.ТаблицаЗначенийВМассив(Результат);
	Иначе
		Возврат Новый Массив;
	КонецЕсли;
	
КонецФункции
 
Функция ЗакодироватьСтроку(парСтрока) Экспорт
	
	Возврат КодироватьСтроку(парСтрока, СпособКодированияСтроки.КодировкаURL, "UTF8");
	
КонецФункции

Процедура ПроверкаПроксиСерверовКТелеграмм() Экспорт
	
	Если Константы.ИспользоватьПроксиДляТелеграмма.Получить() Тогда
		//достаточно одного любого активного бота
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТелеграммБоты.Наименование КАК Наименование,
		|	ТелеграммБоты.Токен КАК Токен
		|ИЗ
		|	Справочник.ТелеграммБоты КАК ТелеграммБоты
		|ГДЕ
		|	ТелеграммБоты.Активен
		|	И ТелеграммБоты.ПометкаУдаления = ЛОЖЬ";
		РезультатБоты = Запрос.Выполнить().Выгрузить();
		Если РезультатБоты.Количество() > 0 Тогда
			ТекБот = РезультатБоты[0];
			СписокПроксиСерверов = ПолучитьВсеПроксиСервера();
			Если СписокПроксиСерверов.Количество() = 0 Тогда
				ОбновитьПроксиСервераНаСервере();	
				СписокПроксиСерверов = ПолучитьВсеПроксиСервера();
			КонецЕсли; 
			
			Для каждого ТекСервер Из СписокПроксиСерверов Цикл
				
				мИнтернетПрокси = РаботаССоциальнымиСетямиКлиентСервер.СоздатьИнтернетПрокси(ТекСервер);
				Соединение = РаботаССоциальнымиСетямиКлиентСервер.УстановитьСоединениеСТелеграмм(мИнтернетПрокси, 5);
				
				Попытка
					ОтветБота = РаботаССоциальнымиСетямиКлиентСервер.ВыполнитьКомандуТелеграммБота(ТекБот, Соединение);
					Если ОтветБота.КодСостояния <> 200 Тогда
						ОБъектСервера = ТекСервер.СсылкаНаПроксиСервер.ПолучитьОбъект();
						ОБъектСервера.УстановитьПометкуУдаления(Истина);
					КонецЕсли; 
				Исключение
					ОБъектСервера = ТекСервер.СсылкаНаПроксиСервер.ПолучитьОбъект();
					ОБъектСервера.УстановитьПометкуУдаления(Истина);
				КонецПопытки; 
				
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

