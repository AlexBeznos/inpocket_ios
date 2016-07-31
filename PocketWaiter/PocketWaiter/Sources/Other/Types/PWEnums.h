//
//  PWEnums.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, PWProductType)
{
	kPWProductTypeRegular = 1 << 0,
	kPWProductTypeFirstPresent = 1 << 1,
	kPWProductTypeBestForDay = 1 << 2,
};

typedef NS_ENUM(NSUInteger, PWPriceCurrency)
{
	kPWPriceCurrencyUAH,
	kPWPriceCurrencyUSD,
	kPWPriceCurrencyEU,
	kPWPriceCurrencyRUB,
	kPWPriceCurrencyFUNT,
	kPWPriceCurrencyCustom
};

typedef NS_ENUM(NSUInteger, PWWeekDayName)
{
	kPWWeekDaNameMon,
	kPWWeekDaNameTue,
	kPWWeekDaNameWen,
	kPWWeekDaNameThu,
	kPWWeekDaNameFri,
	kPWWeekDaNameSat,
	kPWWeekDaNameSun
};

