﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.АдресДокОбъект) = Тип("ДокументСсылка.ПроведениеСоревнования") Тогда //вызов из формы календаря
		мОбъект = Параметры.АдресДокОбъект.ПолучитьОбъект();
	Иначе //вызов из формы документа
		мОбъект = ПолучитьИзВременногоХранилища(Параметры.АдресДокОбъект);
	КонецЕсли; 
	ЗначениеВРеквизитФормы(мОбъект,"ДокОбъект");
	ВыводитьВОдинЛист = Истина;
	перемТЧ = ДокОбъект.ХодСоревнования.Выгрузить();
	ЗаполнитьТаблички(перемТЧ);
	ЭтотОбъект.ЗакрыватьПриВыборе = Ложь;
	ГрупповойВыводитьСРезультатом = Истина;
	МестоС = 1;
	МестоПо = 3;
	Если ДокОбъект.ОбщийРежимСоревнования = 0 Тогда
		Элементы.ГруппаКомандные.Видимость = Ложь;		
	ИначеЕсли ДокОбъект.ОбщийРежимСоревнования = 2 Тогда 
		Элементы.ГрупповойВыводитьСРезультатом.Видимость = Ложь;
		Элементы.ГруппаЛичныеСоревнования.Видимость = Ложь;
		Элементы.ГруппаЭтапов.Видимость = Ложь;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПроведениеСоревнованияУчастникиПоЖеребьевке.НомерСтроки,
	|	ПроведениеСоревнованияУчастникиПоЖеребьевке.РежимТура
	|ПОМЕСТИТЬ втТаблица
	|ИЗ
	|	Документ.ПроведениеСоревнования.УчастникиПоЖеребьевке КАК ПроведениеСоревнованияУчастникиПоЖеребьевке
	|ГДЕ
	|	ПроведениеСоревнованияУчастникиПоЖеребьевке.Ссылка = &Ссылка
	|	И ПроведениеСоревнованияУчастникиПоЖеребьевке.РежимТура <> ЗНАЧЕНИЕ(Перечисление.РежимыТуровСоревнования.Групповой)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПроведениеСоревнованияХодСоревнованияКоманды.НомерСтроки,
	|	ПроведениеСоревнованияХодСоревнованияКоманды.РежимТура
	|ИЗ
	|	Документ.ПроведениеСоревнования.ХодСоревнованияКоманды КАК ПроведениеСоревнованияХодСоревнованияКоманды
	|ГДЕ
	|	ПроведениеСоревнованияХодСоревнованияКоманды.Ссылка = &Ссылка
	|	И ПроведениеСоревнованияХодСоревнованияКоманды.РежимТура <> ЗНАЧЕНИЕ(Перечисление.РежимыТуровСоревнования.Групповой)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втТаблица.НомерСтроки,
	|	втТаблица.РежимТура
	|ИЗ
	|	втТаблица КАК втТаблица
	|
	|СГРУППИРОВАТЬ ПО
	|	втТаблица.НомерСтроки,
	|	втТаблица.РежимТура";
	Запрос.УстановитьПараметр("Ссылка",ДокОбъект.Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 0 Тогда
		Элементы.Группа6.Видимость = Ложь;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблички(ТЧ)
		
	Для каждого ТекСтрока Из ДокОбъект.ХодСоревнования Цикл
		ПроверитьКомментарий(ТекСтрока,ТекСтрока);		
	КонецЦикла;
	
	Для каждого ТекСтрока Из ДокОбъект.ХодСоревнованияКоманды Цикл
		ПроверитьКомментарий(ТекСтрока,ТекСтрока);		
	КонецЦикла;
	
	Для каждого ТекЭтап Из ТЧ Цикл
		НовСтрока = ТаблицаЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока,ТекЭтап);
		ПроверитьКомментарий(ТекЭтап,НовСтрока);
	КонецЦикла;
	//Если ТаблицаЭтапов.Количество() > 0 Тогда
		//ПоследняяСтрока = ТаблицаЭтапов.Получить(ТаблицаЭтапов.Количество()-1);
		//ПоследняяСтрока.Пометка = Истина;
	//КонецЕсли; 
	
КонецПроцедуры

//СтрИсточник - с данными
//СтрПриемник - для установки данных
&НаСервере
Функция ПроверитьКомментарий(СтрИсточник,СтрПриемник)
	Если СтрПриемник.Комментарий = "" Тогда
		СтрПриемник.Комментарий = ""+СтрИсточник.НомерСтроки+" "+Строка(СтрИсточник.РежимТура);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура КомандаПечать(Команда)
	
	ПечатьСНастройкамиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаГрупповойПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаГрупповойПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

 &НаКлиенте
Процедура ПечатьСНастройкамиНаКлиенте()
	
	СИграми = ГрупповойВыводитьСРезультатом;
	Если ВыводитьВОдинЛист Тогда
		глТабДок = Новый ТабличныйДокумент;
	КонецЕсли;
	Если ДокОбъект.ОбщийРежимСоревнования = 0 Тогда // ЛИЧНЫЕ
		мПеремПоХоду = 0;
		Для каждого ТекСтр Из ДокОбъект.ХодСоревнования Цикл
			Если ТекСтр.Пометка Тогда
				мПеремПоХоду = мПеремПоХоду + 1;
			КонецЕсли; 
		КонецЦикла; 
		мПеремЭтапов = 0;
		Для каждого ТекСтр Из ТаблицаЭтапов Цикл
			Если ТекСтр.Пометка Тогда
				мПеремЭтапов = мПеремЭтапов + 1;
			КонецЕсли; 
		КонецЦикла; 
		МаксВсегоСтрок = мПеремПоХоду + мПеремЭтапов + ?(ВыводитьПредварительныйРейтинг,1,0);
		Если МаксВсегоСтрок = 0 Тогда
			Возврат;
		КонецЕсли; 
		Сч = 0;
		Для Каждого ТекСтрока Из ДокОбъект.ХодСоревнования Цикл
			Если Не ТекСтрока.Пометка Тогда
				Продолжить;
			КонецЕсли;
			Сч = Сч + 1;
			Состояние("Печать протоколов соревнований",Сч*100/МаксВсегоСтрок,ТекСтрока.Комментарий,БиблиотекаКартинок.Информация);
			Если ТекСтрока.РежимТура = ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.Групповой") Тогда
				Данные = Новый Структура;
				Данные.Вставить("НомерСтроки",ТекСтрока.НомерСтроки);
				Данные.Вставить("Комментарий",ТекСтрока.Комментарий);
				ТабДокумент = ФормированиеТаблицГрупп(Данные,СИграми);
				Общий.ЗадатьПараметрыПечатиДляПротокола(ТабДокумент,ТекСтрока.РежимТура);
				Если ВыводитьВОдинЛист Тогда
					ВывестиТабДокВОсновной(глТабДок,ТабДокумент);	
				Иначе
					ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",ТабДокумент,ТекСтрока.Комментарий,ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
				КонецЕсли; 
			Иначе
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("НомерТура",ТекСтрока.НомерСтроки);
				ПараметрыФормы.Вставить("ОбъектДок",ДокОбъект);
				ПараметрыФормы.Вставить("РежимТура",ТекСтрока.РежимТура);
				ПараметрыФормы.Вставить("Коммент",ТекСтрока.Комментарий);
				ПараметрыФормы.Вставить("КолПартий",ТекСтрока.КолПартий);
				ПараметрыФормы.Вставить("СеткаНа",ТекСтрока.СеткаНа);
				Форма = ПолучитьФорму("Документ.ПроведениеСоревнования.Форма.ФормаМинус2ИОлимпийка",ПараметрыФормы,ЭтотОбъект);
				ТабДокумент = Форма.ТабДок;
				Если ПромежуточныеПротоколы Тогда
					СеткаНа = ТекСтрока.СеткаНа;
					УстанавливЗнач = ТекСтрока.МестоС;
					Для Н = 1 По СеткаНа Цикл
						Для М = 1 По 2 Цикл
							ИскомаяОбласть = ТабДокумент.НайтиТекст(Формат(Н,"ЧГ=0")+" место",,,,Истина);
							Если ИскомаяОбласть <> Неопределено Тогда
								Если УстанавливЗнач > ТекСтрока.МестоПо Тогда
									ИскомаяОбласть.Текст = "";
								Иначе	
									ИскомаяОбласть.Текст = ""+УстанавливЗнач + " место ";
								КонецЕсли;
							КонецЕсли; 
						КонецЦикла; 
						УстанавливЗнач = УстанавливЗнач + 1;
					КонецЦикла; 
				КонецЕсли; 
				ТабДокумент.Защита = Истина;
				Общий.ЗадатьПараметрыПечатиДляПротокола(ТабДокумент,ТекСтрока.РежимТура);
				Если ВыводитьВОдинЛист Тогда
					ВывестиТабДокВОсновной(глТабДок,ТабДокумент);	
				Иначе
					ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",ТабДокумент,ТекСтрока.Комментарий,ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
				КонецЕсли;
			КонецЕсли; 
		КонецЦикла;
		
		Для Каждого ТекСтрока Из ТаблицаЭтапов Цикл
			Если Не ТекСтрока.Пометка Тогда
				Продолжить;
			КонецЕсли;
			Сч = Сч + 1;
			Состояние("Печать протоколов соревнований",Сч*100/МаксВсегоСтрок,"Итоговые места: "+ТекСтрока.Комментарий,БиблиотекаКартинок.Информация);
			Данные = Новый Структура;
			Данные.Вставить("НомерСтроки",ТекСтрока.НомерСтроки);
			Данные.Вставить("Комментарий",ТекСтрока.Комментарий);
			Данные.Вставить("СеткаНа",ТекСтрока.СеткаНа);
			Данные.Вставить("ПолноеФИО",ПолноеФИО);
			Если ТекСтрока.РежимТура = ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.Групповой") Тогда
				ТабДокумент = ФормированиеТаблицГруппПоМестам(Данные);	
			Иначе
				Данные.Вставить("РежимТура",ТекСтрока.РежимТура);
				ТабДокумент = ПолучитьТабличныйДокументПоМестамСеток(Данные);                          
			КонецЕсли; 
			Если ВыводитьВОдинЛист Тогда
				ВывестиТабДокВОсновной(глТабДок,ТабДокумент);	
			Иначе
				ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",ТабДокумент,ТекСтрока.Комментарий,ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
			КонецЕсли;
		КонецЦикла;
	Иначе //КОМАНДНЫЕ
		мПеремПоХоду = 0;
		Для каждого ТекСтр Из ДокОбъект.ХодСоревнованияКоманды Цикл
			Если ТекСтр.Пометка Тогда
				мПеремПоХоду = мПеремПоХоду + 1;
			КонецЕсли; 
		КонецЦикла; 
		мПеремЭтапов = 0;
		//Для каждого ТекСтр Из ТаблицаЭтапов Цикл
		//	Если ТекСтр.Пометка Тогда
		//		мПеремЭтапов = мПеремЭтапов + 1;
		//	КонецЕсли; 
		//КонецЦикла; 
		МаксВсегоСтрок = мПеремПоХоду + мПеремЭтапов + ?(ВыводитьПредварительныйРейтинг,1,0) + ?(СписокКоманд,1,0);
		Если МаксВсегоСтрок = 0 Тогда
			Возврат;
		КонецЕсли; 
		Сч = 0;	
		Для Каждого ТекСтрока Из ДокОбъект.ХодСоревнованияКоманды Цикл
			Сч = Сч + 1;
			Состояние("Печать протоколов соревнований",Сч*100/МаксВсегоСтрок,ТекСтрока.Комментарий,БиблиотекаКартинок.Информация);
			Если Не ТекСтрока.Пометка Тогда
				Продолжить;
			КонецЕсли;
			Если ТекСтрока.РежимТура = ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.Групповой") Тогда
				Данные = Новый Структура;
				Данные.Вставить("НомерСтроки",ТекСтрока.НомерСтроки);
				Данные.Вставить("Комментарий",ТекСтрока.Комментарий);
				ТабДокумент = ФормированиеТаблицГруппКоманд(Данные,СИграми);
				Общий.ЗадатьПараметрыПечатиДляПротокола(ТабДокумент,ТекСтрока.РежимТура);
				Если ВыводитьВОдинЛист Тогда
					ВывестиТабДокВОсновной(глТабДок,ТабДокумент);	
				Иначе
					ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",ТабДокумент,ТекСтрока.Комментарий,ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
				КонецЕсли; 
			Иначе
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("НомерТура",ТекСтрока.НомерСтроки);
				ПараметрыФормы.Вставить("ОбъектДок",ДокОбъект);
				ПараметрыФормы.Вставить("РежимТура",ТекСтрока.РежимТура);
				ПараметрыФормы.Вставить("Коммент",ТекСтрока.Комментарий);
				ПараметрыФормы.Вставить("КолПартий",ТекСтрока.КолПартий);
				ПараметрыФормы.Вставить("ВидСоревнований",ПредопределенноеЗначение("Перечисление.ВидыСоревнований.Командные"));
				ПараметрыФормы.Вставить("ЖеребьевкаКоманд",ТекСтрока.Жеребьевка);
				Форма = ПолучитьФорму("Документ.ПроведениеСоревнования.Форма.ФормаМинус2ИОлимпийкаКоманды",ПараметрыФормы,ЭтотОбъект);
				ТабДокумент = Форма.ТабДок;
				Общий.ЗадатьПараметрыПечатиДляПротокола(ТабДокумент,ТекСтрока.РежимТура);
				ТабДокумент.Защита = Истина;
				Если ВыводитьВОдинЛист Тогда
					ВывестиТабДокВОсновной(глТабДок,ТабДокумент);	
				Иначе
					ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",ТабДокумент,ТекСтрока.Комментарий,ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
				КонецЕсли;
			КонецЕсли; 
		КонецЦикла;
		Если СписокКоманд Тогда
			ОсновнойДокПолногоПротокола = СформироватьСписокКомандСоревнования();
			//Для Каждого ТекСтрока Из ДокОбъект.ХодСоревнованияКоманды Цикл
			//	Если ТекСтрока.РежимТура = ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.Групповой") Тогда
			//		//Данные = Новый Структура;
			//		//Данные.Вставить("НомерСтроки",ТекСтрока.НомерСтроки);
			//		//Данные.Вставить("Комментарий",ТекСтрока.Комментарий);
			//		//ТабДокумент = ФормированиеТаблицГрупп(Данные,СИграми);
			//		//Если ВыводитьВОдинЛист Тогда
			//		//	ВывестиТабДокВОсновной(глТабДок,ТабДокумент);	
			//		//Иначе
			//		//	ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок",ТабДокумент,ТекСтрока.Комментарий),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
			//		//КонецЕсли; 
			//	Иначе
			//		ПараметрыФормы = Новый Структура;
			//		ПараметрыФормы.Вставить("НомерТура",ТекСтрока.НомерСтроки);
			//		ПараметрыФормы.Вставить("ОбъектДок",ДокОбъект);
			//		ПараметрыФормы.Вставить("РежимТура",ТекСтрока.РежимТура);
			//		ПараметрыФормы.Вставить("Коммент",ТекСтрока.Комментарий);
			//		ПараметрыФормы.Вставить("КолПартий",ТекСтрока.КолПартий);
			//		ПараметрыФормы.Вставить("ВидСоревнований",ПредопределенноеЗначение("Перечисление.ВидыСоревнований.Командные"));
			//		ПараметрыФормы.Вставить("ЖеребьевкаКоманд",ТекСтрока.Жеребьевка);
			//		Форма = ПолучитьФорму("Документ.ПроведениеСоревнования.Форма.ФормаМинус2ИОлимпийкаКоманды",ПараметрыФормы,ЭтотОбъект);
			//		ТабДокумент = Форма.ТабДок;
			//		ТабДокумент.Защита = Истина;
			//		ВывестиТабДокВОсновной(ОсновнойДокПолногоПротокола,ТабДокумент);	
			//	КонецЕсли; 
			//КонецЦикла;
			Если ВыводитьВОдинЛист Тогда
				ВывестиТабДокВОсновной(глТабДок,ОсновнойДокПолногоПротокола);	
			Иначе
				ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",ОсновнойДокПолногоПротокола,ДокОбъект.НазваниеСоревнования,ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ВыводитьПредварительныйРейтинг Тогда
		Сч = Сч + 1;
		Состояние("Печать протоколов соревнований",Сч*100/МаксВсегоСтрок,"Предварительный рейтинг",БиблиотекаКартинок.Информация);
		ТабДокумент = ПолучитьПредварительныйРейтинг();
		Если ВыводитьВОдинЛист Тогда
			ВывестиТабДокВОсновной(глТабДок,ТабДокумент);
		Иначе
			ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",ТабДокумент,"Предварительный рейтинг",ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
		КонецЕсли; 
	КонецЕсли; 
	Если ВыводитьВОдинЛист Тогда
		Общий.ЗадатьПараметрыПечатиДляПротокола(глТабДок,ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.МинусДва"));
		ОткрытьФорму("ОбщаяФорма.ФормаВыводаНаПечать",Новый Структура("ТабДок,Заголовок,Ссылка",глТабДок,ДокОбъект.НазваниеСоревнования,ДокОбъект.Ссылка),ЭтотОбъект,Новый УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВывестиТабДокВОсновной(глТабДок,парТабДок)
	
	глТабДок.Вывести(парТабДок);
	глТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	
КонецПроцедуры 

&НаСервере
Функция ФормированиеТаблицГруппПоМестам(ТекСтр)
	
	НомерТура = ТекСтр.НомерСтроки;
	мОбщаяТаблицаПоТуру = ДокОбъект.ОбщаяТаблицаДанных.Выгрузить(Новый Структура("НомерТура",НомерТура));
	ТабДок = Новый ТабличныйДокумент;
	КоличествоГруппПоТуру = Документы.ПроведениеСоревнования.ОпределитьКоличествоГрупп(ДокОбъект.УчастникиПоЖеребьевке.Выгрузить(),НомерТура,Перечисления.РежимыТуровСоревнования.Групповой);
	мДопИнфа = "от "+Формат(ДокОбъект.Дата,"ДЛФ=DD")+" "+ТекСтр.Комментарий+" "+ДокОбъект.ДопИнф;
	Макет  = Документы.ПроведениеСоревнования.ПолучитьМакет("ТаблицаГрупп");
	ОбластьЗаголовокТабДока = Документы.ПроведениеСоревнования.ПолучитьОбластьЗаголовка(ДокОбъект.НазваниеСоревнования,мДопИнфа);
	ТабДок.Вывести(ОбластьЗаголовокТабДока);
	Для Н = 1 По КоличествоГруппПоТуру Цикл
		ДанныеПоМестамУчастников = Новый ТаблицаЗначений;
		ДанныеПоМестамУчастников.Колонки.Добавить("Участник",Новый ОписаниеТипов("СправочникСсылка.Участники"));
		ДанныеПоМестамУчастников.Колонки.Добавить("Очки",Новый ОписаниеТипов("Число"));
		ДанныеПоМестамУчастников.Колонки.Добавить("Место",Новый ОписаниеТипов("Число"));
		ДанныеПоМестамУчастников.Колонки.Добавить("Соотношение",Новый ОписаниеТипов("Строка"));
		
		//заголовок группы
		ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОбластьЗаголовок.Параметры.НазваниеГруппы = "Группа №"+Н;
		ТабДок.Вывести(ОбластьЗаголовок);
		//шапка таблицы
		ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы | ВертикальШапка");
		ТабДок.Вывести(ОбластьШапка);
		КоличествоУчастников = ДокОбъект.УчастникиПоЖеребьевке.НайтиСтроки(Новый Структура("НомерГруппы,НомерТура,РежимТура",Н,НомерТура,Перечисления.РежимыТуровСоревнования.Групповой));
		ОбластьШапкиКолонки = Макет.ПолучитьОбласть("ШапкаТаблицы | ВертикальКолонка");
		//и еще добавим 2 колонки рейтинг, место
		ОбластьШапкаРейтинга = Макет.ПолучитьОбласть("ШапкаТаблицы | ТекРейтинг");
		ТабДок.Присоединить(ОбластьШапкаРейтинга);
		
		ОбластьШапкиКолонки.Параметры.НомерКолонки = "Место";
		ТабДок.Присоединить(ОбластьШапкиКолонки);
		
		//начинаем выводить строки таблицы
		ОбластьСтрокиРейтинга = Макет.ПолучитьОбласть("СтрокаТаблицы | ТекРейтинг");
		ОбластьСтроки 	     = Макет.ПолучитьОбласть("СтрокаТаблицы | ВертикальШапка");
		ОбластьКолонкиСтроки = Макет.ПолучитьОбласть("СтрокаТаблицы | ВертикальКолонка");
		Ном = 1;
		//заполним таблицу с местами
		Для Мест = 0 По КоличествоУчастников.ВГраница() Цикл
			НовСтрокаДанных = ДанныеПоМестамУчастников.Добавить();
			НовСтрокаДанных["Участник"] = КоличествоУчастников[Мест].Участник; 
		КонецЦикла;
		ТаблицаСМестами = Документы.ПроведениеСоревнования.РасчетМестНаСервере(ДанныеПоМестамУчастников.Скопировать(,"Участник"),мОбщаяТаблицаПоТуру,НомерТура);
		Для каждого ТекСтрРасчета Из ТаблицаСМестами Цикл
			ИскомаяСтрока = ДанныеПоМестамУчастников.Найти(ТекСтрРасчета.Участник,"Участник");
			Если ИскомаяСтрока <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ИскомаяСтрока,ТекСтрРасчета);
			КонецЕсли; 
		КонецЦикла;  
		
		ДанныеПоМестамУчастников.Сортировать("Место ВОЗВ");
		Ном = 0;
		Для Каждого ТекДанныеТаблицы Из ДанныеПоМестамУчастников Цикл
			ТекМестоУчастника = ТекДанныеТаблицы["Место"];
			Если НЕ НужноЛиВыводитьСтрокуПоМесту(ТекМестоУчастника) Тогда
				Продолжить;
			КонецЕсли; 
			Ном = Ном + 1;
			ОбластьСтроки.Параметры.НомерПоПорядку = Ном;
			Если ТекСтр.ПолноеФИО Тогда
				ОбластьСтроки.Параметры.Участник	   = ТекДанныеТаблицы["Участник"];
			Иначе
				ОбластьСтроки.Параметры.Участник	   = Общий.СформироватьИмяИгрока(ТекДанныеТаблицы["Участник"]);
			КонецЕсли; 
			ТабДок.Вывести(ОбластьСтроки);
			//рейтинг
			//место
			СтрокиРейтинга = ДокОбъект.СписокУчастников.НайтиСтроки(Новый Структура("Участник",ТекДанныеТаблицы["Участник"]));
			Если СтрокиРейтинга.Количество() > 0 Тогда
				ТекРейтинг = СтрокиРейтинга[0].ТекущийРейтинг;
			Иначе
				ТекРейтинг = 0;
			КонецЕсли; 
			ОбластьСтрокиРейтинга.Параметры.Рейтинг = ТекРейтинг;
			ТабДок.Присоединить(ОбластьСтрокиРейтинга);
			
			ДанныеПоРимскомуЗначению = ВернутьРимскоеЗначение(ТекМестоУчастника);
			ОбластьКолонкиСтроки.Параметры.ЗначениеКолонки = ДанныеПоРимскомуЗначению.Значение;
			Если ДанныеПоРимскомуЗначению.Выделять Тогда
				ОбластьКолонкиСтроки.Область().Шрифт = Новый Шрифт("Arial",13,Истина);
				ТабДок.Присоединить(ОбластьКолонкиСтроки);
			Иначе
				ОбластьКолонкиСтроки.Область().Шрифт = Новый Шрифт("Arial",11,Ложь);
				ТабДок.Присоединить(ОбластьКолонкиСтроки);
			КонецЕсли; 
		КонецЦикла; 
		ОбластьПробела = Макет.ПолучитьОбласть("ПробелМеждуТаблиц");
		ТабДок.Вывести(ОбластьПробела);
		
	КонецЦикла;
	                  
	Возврат ТабДок;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВернутьРимскоеЗначение(ЗначПеременной)
	
	Данные = Новый Структура;
	Если ЗначПеременной = 1 Или ЗначПеременной = 2 Или ЗначПеременной = 3 Тогда
		Римская = "";
		Для Н = 1 По ЗначПеременной Цикл
			Римская = Римская + "I";
		КонецЦикла; 
		Данные.Вставить("Значение",Римская);
		Данные.Вставить("Выделять",Истина);
		Возврат Данные;
	Иначе
		Данные.Вставить("Значение",ЗначПеременной);
		Данные.Вставить("Выделять",Ложь);
		Возврат Данные;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьТабличныйДокументПоМестамСеток(Данные)
	
	НомерТура = Данные.НомерСтроки;
	РежимТура = Данные.РежимТура;
	мОбщаяТаблицаПоТуру = ДокОбъект.ОбщаяТаблицаДанных.Выгрузить(Новый Структура("НомерТура",НомерТура));
	ТабДок = Новый ТабличныйДокумент;
	мДопИнфа = "от "+Формат(ДокОбъект.Дата,"ДЛФ=DD")+" "+Данные.Комментарий+" "+ДокОбъект.ДопИнф;
	Макет  = Документы.ПроведениеСоревнования.ПолучитьМакет("ТаблицаГрупп");
	ОбластьЗаголовокТабДока = Документы.ПроведениеСоревнования.ПолучитьОбластьЗаголовка(ДокОбъект.НазваниеСоревнования,мДопИнфа);
	ТабДок.Вывести(ОбластьЗаголовокТабДока);
	
	ДанныеПоМестамУчастников = Новый ТаблицаЗначений;
	ДанныеПоМестамУчастников.Колонки.Добавить("РеквизитУчастник",Новый ОписаниеТипов("СправочникСсылка.Участники"));
	ДанныеПоМестамУчастников.Колонки.Добавить("РеквизитОчки",Новый ОписаниеТипов("Число"));
	ДанныеПоМестамУчастников.Колонки.Добавить("РеквизитМесто",Новый ОписаниеТипов("Число"));
	ДанныеПоМестамУчастников.Колонки.Добавить("Соотношение",Новый ОписаниеТипов("Строка"));
	
	//заголовок группы
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьЗаголовок.Параметры.НазваниеГруппы = "Итоговые места";
	ТабДок.Вывести(ОбластьЗаголовок);
	//шапка таблицы
	ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы | ВертикальШапка");
	ТабДок.Вывести(ОбластьШапка);
	КоличествоУчастников = ДокОбъект.УчастникиПоЖеребьевке.НайтиСтроки(Новый Структура("НомерТура,РежимТура",НомерТура,РежимТура));
	ОбластьШапкиКолонки = Макет.ПолучитьОбласть("ШапкаТаблицы | ВертикальКолонка");
	//и еще добавим 2 колонки рейтинг, место
	ОбластьШапкаРейтинга = Макет.ПолучитьОбласть("ШапкаТаблицы | ТекРейтинг");
	ТабДок.Присоединить(ОбластьШапкаРейтинга);
	
	ОбластьШапкиКолонки.Параметры.НомерКолонки = "Место";
	ТабДок.Присоединить(ОбластьШапкиКолонки);
	
	//начинаем выводить строки таблицы
	ОбластьСтрокиРейтинга = Макет.ПолучитьОбласть("СтрокаТаблицы | ТекРейтинг");
	ОбластьСтроки 	     = Макет.ПолучитьОбласть("СтрокаТаблицы | ВертикальШапка");
	ОбластьКолонкиСтроки = Макет.ПолучитьОбласть("СтрокаТаблицы | ВертикальКолонка");
	Ном = 1;
	//заполним таблицу с местами
	Для Мест = 0 По КоличествоУчастников.ВГраница() Цикл
		НовСтрокаДанных = ДанныеПоМестамУчастников.Добавить();
		НовСтрокаДанных["РеквизитУчастник"] = КоличествоУчастников[Мест].Участник; 
	КонецЦикла;
	ТаблицаМестИгр = Новый ТаблицаЗначений;
	ТаблицаМестИгр.Колонки.Добавить("НомерИгры");
	//расчет мест
	Если Данные.СеткаНа = 0 Тогда
		ЧислоУчастников = КоличествоУчастников.Количество();
	Иначе
		ЧислоУчастников = Данные.СеткаНа;
	КонецЕсли; 
	Если ЧислоУчастников >= 4 И ЧислоУчастников <= 8 Тогда //схема 8
		Документы.ПроведениеСоревнования.ТаблицаМестКонечныхИгр(ТаблицаМестИгр,РежимТура,8);
	ИначеЕсли ЧислоУчастников > 8 И ЧислоУчастников <= 16 Тогда //схема на 16
		Документы.ПроведениеСоревнования.ТаблицаМестКонечныхИгр(ТаблицаМестИгр,РежимТура,16);
	ИначеЕсли ЧислоУчастников > 16 И ЧислоУчастников <= 24 Тогда
		Документы.ПроведениеСоревнования.ТаблицаМестКонечныхИгр(ТаблицаМестИгр,РежимТура,24);
	ИначеЕсли ЧислоУчастников > 24 И ЧислоУчастников <= 32 Тогда
		Документы.ПроведениеСоревнования.ТаблицаМестКонечныхИгр(ТаблицаМестИгр,РежимТура,32);
	ИначеЕсли ЧислоУчастников > 32 И ЧислоУчастников <= 48 Тогда
		Документы.ПроведениеСоревнования.ТаблицаМестКонечныхИгр(ТаблицаМестИгр,РежимТура,48);
	ИначеЕсли ЧислоУчастников > 48 И ЧислоУчастников <= 64 Тогда
		Документы.ПроведениеСоревнования.ТаблицаМестКонечныхИгр(ТаблицаМестИгр,РежимТура,64);
	КонецЕсли;
	СчМест = 0;
	//вся таблица идет по порядку мест
	Для каждого ТекИгра Из ТаблицаМестИгр Цикл
		//ищем по номеру игры выигравшего и програвшего из общей таблицы
		ДанныеСтрокиТаблицы = мОбщаяТаблицаПоТуру.НайтиСтроки(Новый Структура("НомерГруппы",ТекИгра.НомерИгры));
		Если ДанныеСтрокиТаблицы.Количество() > 0 Тогда
			СчМест = СчМест + 1;
			перемВыигравший = ДанныеСтрокиТаблицы[0].Выигравший;
			//устанавливаем место
			СтрокаСВыигравшим = ДанныеПоМестамУчастников.Найти(перемВыигравший);
			Если СтрокаСВыигравшим <> Неопределено Тогда
				СтрокаСВыигравшим.РеквизитМесто = СчМест;
			КонецЕсли; 
			СчМест = СчМест + 1;
			перемПроигравший = ДанныеСтрокиТаблицы[0].Проигравший;
			СтрокаСПроигрвшим = ДанныеПоМестамУчастников.Найти(перемПроигравший);
			Если СтрокаСПроигрвшим <> Неопределено Тогда
				СтрокаСПроигрвшим.РеквизитМесто = СчМест;
			КонецЕсли; 
		Иначе
			//возможно еще не сыграли
			Продолжить;
		КонецЕсли; 
	КонецЦикла; 
	ДанныеПоМестамУчастников.Сортировать("РеквизитМесто ВОЗВ");
	Ном = 0;
	Для Каждого ТекДанныеТаблицы Из ДанныеПоМестамУчастников Цикл
		ТекМестоУчастника = ТекДанныеТаблицы.РеквизитМесто;
		Если НЕ НужноЛиВыводитьСтрокуПоМесту(ТекМестоУчастника) Тогда
			Продолжить;
		КонецЕсли; 
		Ном = Ном + 1;
		ОбластьСтроки.Параметры.НомерПоПорядку = Ном;
		Если Данные.ПолноеФИО Тогда
			ОбластьСтроки.Параметры.Участник	   = ТекДанныеТаблицы.РеквизитУчастник;
		Иначе
			ОбластьСтроки.Параметры.Участник	   = Общий.СформироватьИмяИгрока(ТекДанныеТаблицы.РеквизитУчастник);
		КонецЕсли;
		ТабДок.Вывести(ОбластьСтроки);
		//рейтинг
		//место
		СтрокиРейтинга = ДокОбъект.СписокУчастников.НайтиСтроки(Новый Структура("Участник",ТекДанныеТаблицы.РеквизитУчастник));
		Если СтрокиРейтинга.Количество() > 0 Тогда
			ТекРейтинг = СтрокиРейтинга[0].ТекущийРейтинг;
		Иначе
			ТекРейтинг = 0;
		КонецЕсли; 
		ОбластьСтрокиРейтинга.Параметры.Рейтинг = ТекРейтинг;
		ТабДок.Присоединить(ОбластьСтрокиРейтинга);
		
		ДанныеПоРимскомуЗначению = ВернутьРимскоеЗначение(ТекМестоУчастника);
		ОбластьКолонкиСтроки.Параметры.ЗначениеКолонки = ДанныеПоРимскомуЗначению.Значение;
		Если ДанныеПоРимскомуЗначению.Выделять Тогда
			ОбластьКолонкиСтроки.Область().Шрифт = Новый Шрифт("Arial",13,Истина);
			ТабДок.Присоединить(ОбластьКолонкиСтроки);
		Иначе
			ОбластьКолонкиСтроки.Область().Шрифт = Новый Шрифт("Arial",11,Ложь);
			ТабДок.Присоединить(ОбластьКолонкиСтроки);
		КонецЕсли; 
	КонецЦикла; 
	ОбластьПробела = Макет.ПолучитьОбласть("ПробелМеждуТаблиц");
	ТабДок.Вывести(ОбластьПробела);
	
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Функция ПолучитьПредварительныйРейтинг()
	Возврат Документы.ПроведениеСоревнования.ТабличныйДокументРейтинг(ДокОбъект.Ссылка);
КонецФункции
 
//формирует таблицу исходя из рассеивания по группам
&НаСервере
Функция ФормированиеТаблицГрупп(ТекСтр,СИграми = Ложь)
	
	Возврат Документы.ПроведениеСоревнования.ФормированиеТаблицГрупп(ТекСтр,СИграми,ДокОбъект);
	
КонецФункции

&НаСервере
Функция ФормированиеТаблицГруппКоманд(ТекСтр,СИграми = Ложь)
	
	Возврат Документы.ПроведениеСоревнования.ФормированиеТаблицГруппКоманд(ТекСтр,СИграми,ДокОбъект);
	
КонецФункции

//если установлен список мест: с 1 по 3 тогда проверяет нужно ли выводить строчку
//если нужно возврат истина
//иначе ложь
&НаСервере
Функция НужноЛиВыводитьСтрокуПоМесту(ТекМесто)
	
	Если ВсеМеста = 0 Тогда
		Возврат Истина
	ИначеЕсли ВсеМеста = 1 Тогда //период
		Если МестоС =0 И МестоПо = 0 Тогда
			Возврат Истина; //выводим все места
		Иначе
			Если ТекМесто >= МестоС И ТекМесто <= МестоПо Тогда
				Возврат Истина;
			Иначе
				Возврат Ложь;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецФункции
 
&НаКлиенте
Процедура ВсеМестаПриИзменении(Элемент)
	Если ВсеМеста = 0 Тогда
		Элементы.МестоС.Доступность = Ложь;
		Элементы.МестоПо.Доступность = Ложь;
	ИначеЕсли ВсеМеста = 1 Тогда 
		Элементы.МестоС.Доступность = Истина;
		Элементы.МестоПо.Доступность = Истина;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	УстановитьСнятьФлажки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	УстановитьСнятьФлажки(Ложь);
КонецПроцедуры

&НаСервере
Процедура УстановитьСнятьФлажки(парФлага)
	
	Если ДокОбъект.ОбщийРежимСоревнования = 0 Тогда
		Для каждого ТекСтр Из ДокОбъект.ХодСоревнования Цикл ТекСтр.Пометка = парФлага;КонецЦикла;
		Для каждого ТекСтр Из ТаблицаЭтапов Цикл ТекСтр.Пометка = парФлага;КонецЦикла;
	ИначеЕсли ДокОбъект.ОбщийРежимСоревнования = 2 Тогда 	
		Для каждого ТекСтр Из ДокОбъект.ХодСоревнованияКоманды Цикл ТекСтр.Пометка = парФлага;КонецЦикла;
		//Для каждого ТекСтр Из ТаблицаЭтапов Цикл ТекСтр.Пометка = парФлага;КонецЦикла;
		СписокКоманд = парФлага;
	КонецЕсли; 
	ВыводитьПредварительныйРейтинг = парФлага;		
	
КонецПроцедуры

&НаКлиенте
Процедура ДокОбъектХодСоревнованияПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДокОбъектХодСоревнованияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Функция СформироватьСписокКомандСоревнования()
	Возврат Документы.ПроведениеСоревнования.ТабличныйДокументСписокКоманд(ДокОбъект.Ссылка);	
КонецФункции

&НаКлиенте
Процедура ПромежуточныеПротоколыПриИзменении(Элемент)
	
	Элементы.ДокОбъектХодСоревнованияМестоС.Видимость 		= ПромежуточныеПротоколы;
	Элементы.ДокОбъектХодСоревнованияМестоПо.Видимость 	= ПромежуточныеПротоколы;
	
	Если ПромежуточныеПротоколы Тогда
		//ОбщийСч = 1;
		Для каждого ТекСтр Из ДокОбъект.ХодСоревнования Цикл
			Если ТекСтр.РежимТура <> ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.Групповой") Тогда
				ТекСтр.МестоС 	= 1;
				ТекСтр.МестоПо = ТекСтр.СеткаНа;
				ТекСтр.КолМестВСетке = ТекСтр.СеткаНа;
				//ОбщийСч = ОбщийСч + ТекСтр.СеткаНа; 
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДокОбъектХодСоревнованияМестоСПриИзменении(Элемент)
	
	ТекСтрока = Элементы.ДокОбъектХодСоревнования.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		Если ТекСтрока.РежимТура <> ПредопределенноеЗначение("Перечисление.РежимыТуровСоревнования.Групповой") Тогда
			Если ТекСтрока.МестоС = 1 Тогда
				ТекСтрока.МестоПо = ТекСтрока.СеткаНа;	
			Иначе
				ТекСтрока.МестоПо = ТекСтрока.СеткаНа + ТекСтрока.МестоС -1;	
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры
 
