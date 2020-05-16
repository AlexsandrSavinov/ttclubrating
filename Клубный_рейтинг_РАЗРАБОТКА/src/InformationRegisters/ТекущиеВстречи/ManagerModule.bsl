
//--------ПРОЦЕДУРЫ ВЫЗЫВАЮТСЯ ПРИ ВВОДЕ СТОЛА В ФОРМАХ И ПРИ ВВОДЕ ОКОНЧАТЕЛЬНОГО СЧЕТА

//передаем
// - ИДФормы для поддержки уникальности
//- Номерстола - куда вызываем
//И участников кого вызываем
Процедура ДобавитьВстречуЗаСтол(Данные) Экспорт
	
	Если ПроверкаЗаписиПоСтолу(Данные) Тогда //никто не играет можно добавлять
		МенеджерЗаписи = РегистрыСведений.ТекущиеВстречи.СоздатьМенеджерЗаписи();	
		МенеджерЗаписи.ИДФормы 		= Данные.ИДФормы;
		МенеджерЗаписи.НомерСтола 	= Данные.НомерСтола;
		МенеджерЗаписи.Участник1		= Данные.Участник1;
		МенеджерЗаписи.Участник2		= Данные.Участник2;
		МенеджерЗаписи.ДатаВызова	= ТекущаяДата();
		МенеджерЗаписи.Записать();
	КонецЕсли; 
	
КонецПроцедуры

//-достаточно передать ИДФормы, и номер стола
Процедура УдалитьВстречуЗаСтолом(Данные) Экспорт
	
	Если Не ПроверкаЗаписиПоСтолу(Данные) Тогда //запись по столу есть можно удалить
		НаборЗаписи = РегистрыСведений.ТекущиеВстречи.СоздатьНаборЗаписей();
		НаборЗаписи.Отбор.ИДФормы.Установить(Данные.ИДФормы);
		НаборЗаписи.Отбор.НомерСтола.Установить(Данные.НомерСтола);
		НаборЗаписи.Прочитать();
		НаборЗаписи.Очистить();
		НаборЗаписи.Записать();
	КонецЕсли; 
	
КонецПроцедуры

Функция ПроверкаЗаписиПоСтолу(Данные) //скорей всего пока, что будет проводиться одно соревнование по базе
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИДФормы",Данные.ИДФормы);	
	Если Данные.Свойство("Участник1") И Данные.Свойство("Участник2") Тогда
		Запрос.Текст = "ВЫБРАТЬ
		|	ТекущиеВстречи.НомерСтола,
		|	ТекущиеВстречи.Участник1,
		|	ТекущиеВстречи.Участник2
		|ИЗ
		|	РегистрСведений.ТекущиеВстречи КАК ТекущиеВстречи
		|ГДЕ
		|	ТекущиеВстречи.ИДФормы = &ИДФормы
		|	И ТекущиеВстречи.Участник1 = &Участник1
		|	И ТекущиеВстречи.Участник2 = &Участник2";
		Запрос.УстановитьПараметр("Участник1",Данные.Участник1);
		Запрос.УстановитьПараметр("Участник2",Данные.Участник2);
		Результат = Запрос.Выполнить().Выгрузить(); //здесь можно просто поменять номер стола
		Если Результат.Количество() > 0 Тогда
			МенЗаписи = РегистрыСведений.ТекущиеВстречи.СоздатьМенеджерЗаписи();
			МенЗаписи.ИДФормы		= Данные.ИДФормы;
			МенЗаписи.НомерСтола	= Результат[0].НомерСтола;
			МенЗаписи.Участник1 		= Данные.Участник1;
			МенЗаписи.Участник2 		= Данные.Участник2;
			МенЗаписи.Прочитать();
			МенЗаписи.НомерСтола = Данные.НомерСтола;
			МенЗаписи.ДатаВызова = ТекущаяДата();
			МенЗаписи.Записать();
		КонецЕсли; 
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		|	ТекущиеВстречи.НомерСтола,
		|	ТекущиеВстречи.Участник1,
		|	ТекущиеВстречи.Участник2
		|ИЗ
		|	РегистрСведений.ТекущиеВстречи КАК ТекущиеВстречи
		|ГДЕ
		|	ТекущиеВстречи.ИДФормы = &ИДФормы
		|	И ТекущиеВстречи.НомерСтола = &НомерСтола";
		Запрос.УстановитьПараметр("НомерСтола",Данные.НомерСтола);	
		Результат = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	Если Результат.Количество() > 0 Тогда //за столом по этому соревнованию уже играют
		Возврат Ложь;
	Иначе	
		Возврат Истина;
	КонецЕсли; 
	
КонецФункции
 