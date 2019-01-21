﻿
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновлениеСпискаВстреч" Тогда
		Элементы.Список.Обновить();
		//ЭтотОбъект.Заголовок = "* Текущие встречи";
		ЭтотОбъект.Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ЭтотОбъект.Модифицированность Тогда
		ЭтотОбъект.Модифицированность = Ложь;	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Время = Формат(ТекущаяДата(),"ДЛФ=DDT");
	ПодключитьОбработчикОжидания("УстановитьТекущееВремя",1);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущееВремя()
	Время = Формат(ТекущаяДата(),"ДЛФ=DDT");
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВсеСтолы(Команда)
	Серверные.УдалитьВсеТекущиеВстречи();
КонецПроцедуры
 
