﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеДляФормы = Новый Структура("АдресДокОбъект",ПараметрКоманды);
	ОткрытьФорму("Документ.ПроведениеСоревнования.Форма.НастройкиПечати",ДанныеДляФормы,ПараметрыВыполненияКоманды.Источник,ПараметрыВыполненияКоманды.Уникальность,ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
 
