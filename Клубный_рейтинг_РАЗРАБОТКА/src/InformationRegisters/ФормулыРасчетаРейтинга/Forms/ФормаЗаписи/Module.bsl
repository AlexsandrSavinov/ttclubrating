
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПеременных.Добавить("РТв","РТв");
	СписокПеременных.Добавить("РТп","РТп");
			
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеВызоваСсылки", ЭтотОбъект),
		"http://ttfr.ru/index.html?layer_id=1&id=270&nav_id=286");
КонецПроцедуры

&НаКлиенте
//@skip-warning
Процедура ПослеВызоваСсылки(КодВозврата, ДопПараметры) Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеременныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Запись.Формула  = Запись.Формула + СписокПеременных.НайтиПоИдентификатору(ВыбраннаяСтрока).Значение;
	
КонецПроцедуры

                                                                                        