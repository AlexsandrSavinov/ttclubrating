
Процедура ПриНачалеРаботыСистемы()
	
	КлиентскиеКлиент.ДействияПриНачалеРаботыСистемыКлиент();
	ТекстСообщения = СерверныеСервер.ПроверкаВерсииПлатформы();
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	Отказ = Истина;
	ТекстПредупреждения = "Завершить работу с программой ?";
	
КонецПроцедуры