﻿
&НаКлиенте
Процедура КомндаСформировать(Команда)
	
	СформироватьОтчетНаСервере();	
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетНаСервере()
	
	Если Участник = Справочники.Участники.ПустаяСсылка() Тогда
		Возврат;
	КонецЕсли;
	
	ТабДок.Очистить();
	мОбъект = РеквизитФормыВЗначение("Отчет");
	Данные = Новый Структура;
	Данные.Вставить("Участник",Участник);
	Данные.Вставить("ВидРейтинга",ВидРейтинга);
	Данные.Вставить("НачалоПериода",Период.ДатаНачала);
	Данные.Вставить("КонецПериода",Период.ДатаОкончания);
	Адрес = ПоместитьВоВременноеХранилище(Данные);
	ТабДок.Вывести(мОбъект.СформироватьКарточкуУчастника(Адрес));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Период.ДатаНачала = НачалоГода(ТекущаяДата());
	Период.ДатаОкончания = КонецГода(ТекущаяДата());
	Если Параметры.Свойство("Участник") Тогда
		Участник = Параметры.Участник;
	КонецЕсли;
	ВидРейтинга = Константы.ВидРейтинга.Получить();
	Если Участник <> Справочники.Участники.ПустаяСсылка() И Параметры.СформироватьПриОткрытии Тогда
		СформироватьОтчетНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидРейтингаПриИзменении(Элемент)
	СформироватьОтчетНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УчастникПриИзменении(Элемент)
	СформироватьОтчетНаСервере();
КонецПроцедуры
