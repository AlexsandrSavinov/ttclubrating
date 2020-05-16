
&НаКлиенте
Процедура КомандаЗагрузитьФайл(Команда)
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("КомандаЗагрузитьФайлЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьФайлЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Фильтр = "Все файлы|*.epf;*.erf|Внешние обработки|*.epf|Внешние отчеты|*.erf";
		ДиалогОткрытияФайла.МножественныйВыбор = Истина;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл'");
		
		ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("КомандаЗагрузитьФайлЗавершениеЗавершение", ЭтотОбъект, Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));
        Возврат;
	Иначе
		
	КонецЕсли;
	КомандаЗагрузитьФайлЗавершениеФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьФайлЗавершениеЗавершение(ВыбранныеФайлы1, ДополнительныеПараметры1) Экспорт
	
	ДиалогОткрытияФайла = ДополнительныеПараметры1.ДиалогОткрытияФайла;
	
	
	Если (ВыбранныеФайлы1 <> Неопределено) Тогда
		ВыбранныеФайлы = ДиалогОткрытияФайла.ВыбранныеФайлы;
		СоздатьВнешниеОтчетыИОбработки(ВыбранныеФайлы);
		Если ВыбранныеФайлы.Количество() > 1 Тогда
			Текст = "Файлы успешно загружены";
		Иначе
			Текст = "Файл успешно загружен";
		КонецЕсли;
		ПоказатьОповещениеПользователя("Внимание",,Текст,БиблиотекаКартинок.Информация);
	КонецЕсли;
	
	КомандаЗагрузитьФайлЗавершениеФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьФайлЗавершениеФрагмент()
	
	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Процедура СоздатьВнешниеОтчетыИОбработки(МассивФайлов)
	
	Для Каждого ТекФайл Из МассивФайлов Цикл
		Файл = Новый Файл(ТекФайл);
		КомментарийКФайлу = Файл.Имя + Символы.ПС + "размер:" + Файл.Размер()+" байт; изменен:" + Файл.ПолучитьВремяИзменения() + "; сохранен в ИБ:" + ТекущаяДата();
		ДвоичныеДанные = Новый ДвоичныеДанные(ТекФайл);
		Если Файл.Расширение = ".epf" Тогда //обработка
			ВидФайла = Перечисления.ВидыФайлов.Обработка;
			ВТ = ВнешниеОбработки.Создать(ТекФайл,Ложь);
			ЗаголовокФайла = Вт.Метаданные().Синоним;
		Иначе //внешний отчет
			ВидФайла = Перечисления.ВидыФайлов.Отчет;
			ВТ = ВнешниеОтчеты.Создать(ТекФайл,Ложь);
			ЗаголовокФайла = Вт.Метаданные().Синоним;
		КонецЕсли;
		НовЭлемент = Справочники.ДополнительныеОтчетыИОбработки.СоздатьЭлемент();
		НовЭлемент.Наименование = ЗаголовокФайла;
		НовЭлемент.ВидФайла = 	ВидФайла;
		НовЭлемент.КомментарийКФайлуИсточнику = КомментарийКФайлу;
		НовЭлемент.ХранилищеВнешнейОбработки = Новый ХранилищеЗначения(ДвоичныеДанные,Новый СжатиеДанных(8));
		НовЭлемент.Записать();
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗапустить(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекСтрока = Элементы.Список.ТекущиеДанные;	
	АдресХранилища = "";
    Результат = Неопределено;
    НачатьПомещениеФайла(Новый ОписаниеОповещения("КомандаЗапуститьЗавершение", ЭтотОбъект, Новый Структура("АдресХранилища, ТекСтрока", АдресХранилища, ТекСтрока)), АдресХранилища, СохранитьВоВременныйФайл(ТекСтрока.Ссылка),, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗапуститьЗавершение(Результат1, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	АдресХранилища = ДополнительныеПараметры.АдресХранилища;
	ТекСтрока = ДополнительныеПараметры.ТекСтрока;
	
	Результат = Результат1;           
	
	ИмяОбработки = ПодключитьВнешнююОбработку(АдресХранилища,ТекСтрока.ВидФайла);
	// Откроем форму подключенной внешней обработки
	Если ТекСтрока.ВидФайла = ПредопределенноеЗначение("Перечисление.ВидыФайлов.Обработка") Тогда
		ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма");
	Иначе //отчет
		ОткрытьФорму("ВнешнийОтчет."+ ИмяОбработки +".Форма");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СохранитьВоВременныйФайл(СсылкаЭлемента)
	
	//получим из хранилища данные
	ДвоичныеДанные = СсылкаЭлемента.ХранилищеВнешнейОбработки.Получить();
	
	Если СсылкаЭлемента.ВидФайла = Перечисления.ВидыФайлов.Обработка Тогда
		ЭтоОбработка = Истина;
		Расширение = ".epf";
	Иначе
		ЭтоОбработка = Ложь;
		Расширение = ".erf";
	КонецЕсли;	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	//проверим файл
	Файл = Новый Файл(ИмяВременногоФайла);
	Если Файл.Существует() Тогда
		СписокВременныхФайлов.Добавить(ИмяВременногоФайла);
		Возврат ИмяВременногоФайла;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресХранилища,ВидФайла)
	Если ВидФайла = Перечисления.ВидыФайлов.Обработка Тогда
		Возврат ВнешниеОбработки.Подключить(АдресХранилища,,Ложь);
	Иначе
		Возврат ВнешниеОтчеты.Подключить(АдресХранилища,,Ложь);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	КомандаЗапустить(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Для Каждого ТекФайл Из СписокВременныхФайлов Цикл
		Попытка
			НачатьУдалениеФайлов(,ТекФайл.Значение);
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

