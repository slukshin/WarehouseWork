#Область ПрограммныйИнтерфейс

Функция ПолучитьСсылкуОбъектаПоШтрихкоду(Штрихкод, Менеджер) Экспорт	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Штрихкод, Ложь, Ложь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ШтрихкодВШестнаднадцатиричномВиде = ПреобразоватьДесятичноеЧислоВШестнадцатиричнуюСистемуСчисления(Число(Штрихкод));
	Пока СтрДлина(ШтрихкодВШестнаднадцатиричномВиде) < 32 Цикл
		ШтрихкодВШестнаднадцатиричномВиде = "0" + ШтрихкодВШестнаднадцатиричномВиде;
	КонецЦикла;
	
	Идентификатор =
	        Сред(ШтрихкодВШестнаднадцатиричномВиде, 1,  8)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 9,  4)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 13, 4)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 17, 4)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 21, 12);
	
	Если СтрДлина(Идентификатор) <> 36 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Ссылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Идентификатор));
		Если Ссылка.ПолучитьОбъект() = Неопределено Тогда
			Возврат Неопределено;
		Иначе
			Возврат Ссылка;	
		КонецЕсли;
	Исключение
		Возврат Неопределено;	
	КонецПопытки;	
КонецФункции

Функция ПолучитьДанныеПоШтрихкоду(Знач Штрихкод, КэшированныеЗначения = Неопределено) Экспорт
	
	ДанныеШтрихкода = Неопределено;
	
	Штрихкод = СокрЛП(Штрихкод);
	
	Если Не ЗначениеЗаполнено(ДанныеШтрихкода) Тогда
		
		ДанныеШтрихкода = НайтиДанныеПоШтрихкодуЯчейка(Штрихкод, КэшированныеЗначения);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеШтрихкода) Тогда

		ДанныеШтрихкода = НайтиДанныеПоШтрихкодуНоменклатура(Штрихкод, КэшированныеЗначения);
		
	КонецЕсли;
		
	Возврат ДанныеШтрихкода;		
КонецФункции

Функция НайтиДанныеПоШтрихкодуПользователь(Знач Штрихкод) Экспорт
	
	ДанныеШтрихкода = Неопределено;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Ссылка,
		|	Пользователи.Штрихкод КАК Штрихкод
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Штрихкод = &Штрихкод";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ДанныеШтрихкода = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
	РегистрыСведений.Сканирования.ЗарегистрироватьВводШтрихкода(Штрихкод, ДанныеШтрихкода);
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиДанныеПоШтрихкодуЯчейка(Знач Штрихкод, КэшированныеЗначения = Неопределено)
	
	ДанныеШтрихкода = Неопределено;

	ДанныеШтрихкода = ПолучитьСсылкуОбъектаПоШтрихкоду(Штрихкод, Справочники.Ячейки);
	
	Если КэшированныеЗначения <> Неопределено И ЗначениеЗаполнено(ДанныеШтрихкода) Тогда
		КэшированныеЗначения.Штрихкоды.Вставить(Штрихкод, ДанныеШтрихкода);
	КонецЕсли;
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

Функция НайтиДанныеПоШтрихкодуНоменклатура(Знач Штрихкод, КэшированныеЗначения = Неопределено)
	
	ДанныеШтрихкода = Неопределено;

	ДанныеШтрихкода = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьДанныеПоШтрихкоду(Штрихкод);
	
	Если КэшированныеЗначения <> Неопределено И ЗначениеЗаполнено(ДанныеШтрихкода) Тогда
		КэшированныеЗначения.Штрихкоды.Вставить(Штрихкод, ДанныеШтрихкода);
	КонецЕсли;
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

Функция ПреобразоватьДесятичноеЧислоВШестнадцатиричнуюСистемуСчисления(Знач ДесятичноеЧисло)
	
	Результат = "";
	
	Пока ДесятичноеЧисло > 0 цикл
		ОстатокОтДеления = ДесятичноеЧисло % 16;
		ДесятичноеЧисло  = (ДесятичноеЧисло - ОстатокОтДеления) / 16;
		Результат        = Сред("0123456789abcdef", ОстатокОтДеления + 1, 1) + Результат;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПреобразоватьИзШестнадцатиричнойСистемыСчисленияВДесятичноеЧисло(Знач Значение)
	
	Значение = НРег(Значение);
	ДлинаСтроки = СтрДлина(Значение);
	
	Результат = 0;
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		Результат = Результат * 16 + Найти("0123456789abcdef", Сред(Значение, НомерСимвола, 1)) - 1;
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧГ=0");
	
КонецФункции

#КонецОбласти
