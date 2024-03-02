//+------------------------------------------------------------------+
//|                                                    Time_5MIN.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
// Dropdown Variables for Time Input:
enum DropdownOptions_Time {
   tijd00_00,/*00:00*/ tijd00_05,/*00:05*/ tijd00_10,/*00:10*/ tijd00_15,/*00:15*/ tijd00_20,/*00:20*/ tijd00_25,/*00:25*/ tijd00_30,/*00:30*/ tijd00_35,/*00:35*/ tijd00_40,/*00:40*/ tijd00_45,/*00:45*/ tijd00_50,/*00:50*/ tijd00_55,/*00:55*/
   tijd01_00,/*01:00*/ tijd01_05,/*01:05*/ tijd01_10,/*01:10*/ tijd01_15,/*01:15*/ tijd01_20,/*01:20*/ tijd01_25,/*01:25*/ tijd01_30,/*01:30*/ tijd01_35,/*01:35*/ tijd01_40,/*01:40*/ tijd01_45,/*01:45*/ tijd01_50,/*01:50*/ tijd01_55,/*01:55*/
   tijd02_00,/*02:00*/ tijd02_05,/*02:05*/ tijd02_10,/*02:10*/ tijd02_15,/*02:15*/ tijd02_20,/*02:20*/ tijd02_25,/*02:25*/ tijd02_30,/*02:30*/ tijd02_35,/*02:35*/ tijd02_40,/*02:40*/ tijd02_45,/*02:45*/ tijd02_50,/*02:50*/ tijd02_55,/*02:55*/
   tijd03_00,/*03:00*/ tijd03_05,/*03:05*/ tijd03_10,/*03:10*/ tijd03_15,/*03:15*/ tijd03_20,/*03:20*/ tijd03_25,/*03:25*/ tijd03_30,/*03:30*/ tijd03_35,/*03:35*/ tijd03_40,/*03:40*/ tijd03_45,/*03:45*/ tijd03_50,/*03:50*/ tijd03_55,/*03:55*/
   tijd04_00,/*04:00*/ tijd04_05,/*04:05*/ tijd04_10,/*04:10*/ tijd04_15,/*04:15*/ tijd04_20,/*04:20*/ tijd04_25,/*04:25*/ tijd04_30,/*04:30*/ tijd04_35,/*04:35*/ tijd04_40,/*04:40*/ tijd04_45,/*04:45*/ tijd04_50,/*04:50*/ tijd04_55,/*04:55*/
   tijd05_00,/*05:00*/ tijd05_05,/*05:05*/ tijd05_10,/*05:10*/ tijd05_15,/*05:15*/ tijd05_20,/*05:20*/ tijd05_25,/*05:25*/ tijd05_30,/*05:30*/ tijd05_35,/*05:35*/ tijd05_40,/*05:40*/ tijd05_45,/*05:45*/ tijd05_50,/*05:50*/ tijd05_55,/*05:55*/
   tijd06_00,/*06:00*/ tijd06_05,/*06:05*/ tijd06_10,/*06:10*/ tijd06_15,/*06:15*/ tijd06_20,/*06:20*/ tijd06_25,/*06:25*/ tijd06_30,/*06:30*/ tijd06_35,/*06:35*/ tijd06_40,/*06:40*/ tijd06_45,/*06:45*/ tijd06_50,/*06:50*/ tijd06_55,/*06:55*/
   tijd07_00,/*07:00*/ tijd07_05,/*07:05*/ tijd07_10,/*07:10*/ tijd07_15,/*07:15*/ tijd07_20,/*07:20*/ tijd07_25,/*07:25*/ tijd07_30,/*07:30*/ tijd07_35,/*07:35*/ tijd07_40,/*07:40*/ tijd07_45,/*07:45*/ tijd07_50,/*07:50*/ tijd07_55,/*07:55*/
   tijd08_00,/*08:00*/ tijd08_05,/*08:05*/ tijd08_10,/*08:10*/ tijd08_15,/*08:15*/ tijd08_20,/*08:20*/ tijd08_25,/*08:25*/ tijd08_30,/*08:30*/ tijd08_35,/*08:35*/ tijd08_40,/*08:40*/ tijd08_45,/*08:45*/ tijd08_50,/*08:50*/ tijd08_55,/*08:55*/
   tijd09_00,/*09:00*/ tijd09_05,/*09:05*/ tijd09_10,/*09:10*/ tijd09_15,/*09:15*/ tijd09_20,/*09:20*/ tijd09_25,/*09:25*/ tijd09_30,/*09:30*/ tijd09_35,/*09:35*/ tijd09_40,/*09:40*/ tijd09_45,/*09:45*/ tijd09_50,/*09:50*/ tijd09_55,/*09:55*/
   tijd10_00,/*10:00*/ tijd10_05,/*10:05*/ tijd10_10,/*10:10*/ tijd10_15,/*10:15*/ tijd10_20,/*10:20*/ tijd10_25,/*10:25*/ tijd10_30,/*10:30*/ tijd10_35,/*10:35*/ tijd10_40,/*10:40*/ tijd10_45,/*10:45*/ tijd10_50,/*10:50*/ tijd10_55,/*10:55*/
   tijd11_00,/*11:00*/ tijd11_05,/*11:05*/ tijd11_10,/*11:10*/ tijd11_15,/*11:15*/ tijd11_20,/*11:20*/ tijd11_25,/*11:25*/ tijd11_30,/*11:30*/ tijd11_35,/*11:35*/ tijd11_40,/*11:40*/ tijd11_45,/*11:45*/ tijd11_50,/*11:50*/ tijd11_55,/*11:55*/
   tijd12_00,/*12:00*/ tijd12_05,/*12:05*/ tijd12_10,/*12:10*/ tijd12_15,/*12:15*/ tijd12_20,/*12:20*/ tijd12_25,/*12:25*/ tijd12_30,/*12:30*/ tijd12_35,/*12:35*/ tijd12_40,/*12:40*/ tijd12_45,/*12:45*/ tijd12_50,/*12:50*/ tijd12_55,/*12:55*/
   tijd13_00,/*13:00*/ tijd13_05,/*13:05*/ tijd13_10,/*13:10*/ tijd13_15,/*13:15*/ tijd13_20,/*13:20*/ tijd13_25,/*13:25*/ tijd13_30,/*13:30*/ tijd13_35,/*13:35*/ tijd13_40,/*13:40*/ tijd13_45,/*13:45*/ tijd13_50,/*13:50*/ tijd13_55,/*13:55*/
   tijd14_00,/*14:00*/ tijd14_05,/*14:05*/ tijd14_10,/*14:10*/ tijd14_15,/*14:15*/ tijd14_20,/*14:20*/ tijd14_25,/*14:25*/ tijd14_30,/*14:30*/ tijd14_35,/*14:35*/ tijd14_40,/*14:40*/ tijd14_45,/*14:45*/ tijd14_50,/*14:50*/ tijd14_55,/*14:55*/
   tijd15_00,/*15:00*/ tijd15_05,/*15:05*/ tijd15_10,/*15:10*/ tijd15_15,/*15:15*/ tijd15_20,/*15:20*/ tijd15_25,/*15:25*/ tijd15_30,/*15:30*/ tijd15_35,/*15:35*/ tijd15_40,/*15:40*/ tijd15_45,/*15:45*/ tijd15_50,/*15:50*/ tijd15_55,/*15:55*/
   tijd16_00,/*16:00*/ tijd16_05,/*16:05*/ tijd16_10,/*16:10*/ tijd16_15,/*16:15*/ tijd16_20,/*16:20*/ tijd16_25,/*16:25*/ tijd16_30,/*16:30*/ tijd16_35,/*16:35*/ tijd16_40,/*16:40*/ tijd16_45,/*16:45*/ tijd16_50,/*16:50*/ tijd16_55,/*16:55*/
   tijd17_00,/*17:00*/ tijd17_05,/*17:05*/ tijd17_10,/*17:10*/ tijd17_15,/*17:15*/ tijd17_20,/*17:20*/ tijd17_25,/*17:25*/ tijd17_30,/*17:30*/ tijd17_35,/*17:35*/ tijd17_40,/*17:40*/ tijd17_45,/*17:45*/ tijd17_50,/*17:50*/ tijd17_55,/*17:55*/
   tijd18_00,/*18:00*/ tijd18_05,/*18:05*/ tijd18_10,/*18:10*/ tijd18_15,/*18:15*/ tijd18_20,/*18:20*/ tijd18_25,/*18:25*/ tijd18_30,/*18:30*/ tijd18_35,/*18:35*/ tijd18_40,/*18:40*/ tijd18_45,/*18:45*/ tijd18_50,/*18:50*/ tijd18_55,/*18:55*/
   tijd19_00,/*19:00*/ tijd19_05,/*19:05*/ tijd19_10,/*19:10*/ tijd19_15,/*19:15*/ tijd19_20,/*19:20*/ tijd19_25,/*19:25*/ tijd19_30,/*19:30*/ tijd19_35,/*19:35*/ tijd19_40,/*19:40*/ tijd19_45,/*19:45*/ tijd19_50,/*19:50*/ tijd19_55,/*19:55*/
   tijd20_00,/*20:00*/ tijd20_05,/*20:05*/ tijd20_10,/*20:10*/ tijd20_15,/*20:15*/ tijd20_20,/*20:20*/ tijd20_25,/*20:25*/ tijd20_30,/*20:30*/ tijd20_35,/*20:35*/ tijd20_40,/*20:40*/ tijd20_45,/*20:45*/ tijd20_50,/*20:50*/ tijd20_55,/*20:55*/
   tijd21_00,/*21:00*/ tijd21_05,/*21:05*/ tijd21_10,/*21:10*/ tijd21_15,/*21:15*/ tijd21_20,/*21:20*/ tijd21_25,/*21:25*/ tijd21_30,/*21:30*/ tijd21_35,/*21:35*/ tijd21_40,/*21:40*/ tijd21_45,/*21:45*/ tijd21_50,/*21:50*/ tijd21_55,/*21:55*/
   tijd22_00,/*22:00*/ tijd22_05,/*22:05*/ tijd22_10,/*22:10*/ tijd22_15,/*22:15*/ tijd22_20,/*22:20*/ tijd22_25,/*22:25*/ tijd22_30,/*22:30*/ tijd22_35,/*22:35*/ tijd22_40,/*22:40*/ tijd22_45,/*22:45*/ tijd22_50,/*22:50*/ tijd22_55,/*22:55*/
   tijd23_00,/*23:00*/ tijd23_05,/*23:05*/ tijd23_10,/*23:10*/ tijd23_15,/*23:15*/ tijd23_20,/*23:20*/ tijd23_25,/*23:25*/ tijd23_30,/*23:30*/ tijd23_35,/*23:35*/ tijd23_40,/*23:40*/ tijd23_45,/*23:45*/ tijd23_50,/*23:50*/ tijd23_55/*23:55*/
};

   // Function to convert DropdownOptions_Time to a time string
string TimeEnumToString(DropdownOptions_Time timeEnum) {
    switch(timeEnum) {
      case tijd00_00: return "00:00"; case tijd00_05: return "00:05"; case tijd00_10: return "00:10"; case tijd00_15: return "00:15"; case tijd00_20: return "00:20"; case tijd00_25: return "00:25"; case tijd00_30: return "00:30"; case tijd00_35: return "00:35"; case tijd00_40: return "00:40"; case tijd00_45: return "00:45"; case tijd00_50: return "00:50"; case tijd00_55: return "00:55";
      case tijd01_00: return "01:00"; case tijd01_05: return "01:05"; case tijd01_10: return "01:10"; case tijd01_15: return "01:15"; case tijd01_20: return "01:20"; case tijd01_25: return "01:25"; case tijd01_30: return "01:30"; case tijd01_35: return "01:35"; case tijd01_40: return "01:40"; case tijd01_45: return "01:45"; case tijd01_50: return "01:50"; case tijd01_55: return "01:55";
      case tijd02_00: return "02:00"; case tijd02_05: return "02:05"; case tijd02_10: return "02:10"; case tijd02_15: return "02:15"; case tijd02_20: return "02:20"; case tijd02_25: return "02:25"; case tijd02_30: return "02:30"; case tijd02_35: return "02:35"; case tijd02_40: return "02:40"; case tijd02_45: return "02:45"; case tijd02_50: return "02:50"; case tijd02_55: return "02:55";
      case tijd03_00: return "03:00"; case tijd03_05: return "03:05"; case tijd03_10: return "03:10"; case tijd03_15: return "03:15"; case tijd03_20: return "03:20"; case tijd03_25: return "03:25"; case tijd03_30: return "03:30"; case tijd03_35: return "03:35"; case tijd03_40: return "03:40"; case tijd03_45: return "03:45"; case tijd03_50: return "03:50"; case tijd03_55: return "03:55";
      case tijd04_00: return "04:00"; case tijd04_05: return "04:05"; case tijd04_10: return "04:10"; case tijd04_15: return "04:15"; case tijd04_20: return "04:20"; case tijd04_25: return "04:25"; case tijd04_30: return "04:30"; case tijd04_35: return "04:35"; case tijd04_40: return "04:40"; case tijd04_45: return "04:45"; case tijd04_50: return "04:50"; case tijd04_55: return "04:55";
      case tijd05_00: return "05:00"; case tijd05_05: return "05:05"; case tijd05_10: return "05:10"; case tijd05_15: return "05:15"; case tijd05_20: return "05:20"; case tijd05_25: return "05:25"; case tijd05_30: return "05:30"; case tijd05_35: return "05:35"; case tijd05_40: return "05:40"; case tijd05_45: return "05:45"; case tijd05_50: return "05:50"; case tijd05_55: return "05:55";
      case tijd06_00: return "06:00"; case tijd06_05: return "06:05"; case tijd06_10: return "06:10"; case tijd06_15: return "06:15"; case tijd06_20: return "06:20"; case tijd06_25: return "06:25"; case tijd06_30: return "06:30"; case tijd06_35: return "06:35"; case tijd06_40: return "06:40"; case tijd06_45: return "06:45"; case tijd06_50: return "06:50"; case tijd06_55: return "06:55";
      case tijd07_00: return "07:00"; case tijd07_05: return "07:05"; case tijd07_10: return "07:10"; case tijd07_15: return "07:15"; case tijd07_20: return "07:20"; case tijd07_25: return "07:25"; case tijd07_30: return "07:30"; case tijd07_35: return "07:35"; case tijd07_40: return "07:40"; case tijd07_45: return "07:45"; case tijd07_50: return "07:50"; case tijd07_55: return "07:55";
      case tijd08_00: return "08:00"; case tijd08_05: return "08:05"; case tijd08_10: return "08:10"; case tijd08_15: return "08:15"; case tijd08_20: return "08:20"; case tijd08_25: return "08:25"; case tijd08_30: return "08:30"; case tijd08_35: return "08:35"; case tijd08_40: return "08:40"; case tijd08_45: return "08:45"; case tijd08_50: return "08:50"; case tijd08_55: return "08:55";
      case tijd09_00: return "09:00"; case tijd09_05: return "09:05"; case tijd09_10: return "09:10"; case tijd09_15: return "09:15"; case tijd09_20: return "09:20"; case tijd09_25: return "09:25"; case tijd09_30: return "09:30"; case tijd09_35: return "09:35"; case tijd09_40: return "09:40"; case tijd09_45: return "09:45"; case tijd09_50: return "09:50"; case tijd09_55: return "09:55";
      case tijd10_00: return "10:00"; case tijd10_05: return "10:05"; case tijd10_10: return "10:10"; case tijd10_15: return "10:15"; case tijd10_20: return "10:20"; case tijd10_25: return "10:25"; case tijd10_30: return "10:30"; case tijd10_35: return "10:35"; case tijd10_40: return "10:40"; case tijd10_45: return "10:45"; case tijd10_50: return "10:50"; case tijd10_55: return "10:55";
      case tijd11_00: return "11:00"; case tijd11_05: return "11:05"; case tijd11_10: return "11:10"; case tijd11_15: return "11:15"; case tijd11_20: return "11:20"; case tijd11_25: return "11:25"; case tijd11_30: return "11:30"; case tijd11_35: return "11:35"; case tijd11_40: return "11:40"; case tijd11_45: return "11:45"; case tijd11_50: return "11:50"; case tijd11_55: return "11:55";
      case tijd12_00: return "12:00"; case tijd12_05: return "12:05"; case tijd12_10: return "12:10"; case tijd12_15: return "12:15"; case tijd12_20: return "12:20"; case tijd12_25: return "12:25"; case tijd12_30: return "12:30"; case tijd12_35: return "12:35"; case tijd12_40: return "12:40"; case tijd12_45: return "12:45"; case tijd12_50: return "12:50"; case tijd12_55: return "12:55";
      case tijd13_00: return "13:00"; case tijd13_05: return "13:05"; case tijd13_10: return "13:10"; case tijd13_15: return "13:15"; case tijd13_20: return "13:20"; case tijd13_25: return "13:25"; case tijd13_30: return "13:30"; case tijd13_35: return "13:35"; case tijd13_40: return "13:40"; case tijd13_45: return "13:45"; case tijd13_50: return "13:50"; case tijd13_55: return "13:55";
      case tijd14_00: return "14:00"; case tijd14_05: return "14:05"; case tijd14_10: return "14:10"; case tijd14_15: return "14:15"; case tijd14_20: return "14:20"; case tijd14_25: return "14:25"; case tijd14_30: return "14:30"; case tijd14_35: return "14:35"; case tijd14_40: return "14:40"; case tijd14_45: return "14:45"; case tijd14_50: return "14:50"; case tijd14_55: return "14:55";
      case tijd15_00: return "15:00"; case tijd15_05: return "15:05"; case tijd15_10: return "15:10"; case tijd15_15: return "15:15"; case tijd15_20: return "15:20"; case tijd15_25: return "15:25"; case tijd15_30: return "15:30"; case tijd15_35: return "15:35"; case tijd15_40: return "15:40"; case tijd15_45: return "15:45"; case tijd15_50: return "15:50"; case tijd15_55: return "15:55";
      case tijd16_00: return "16:00"; case tijd16_05: return "16:05"; case tijd16_10: return "16:10"; case tijd16_15: return "16:15"; case tijd16_20: return "16:20"; case tijd16_25: return "16:25"; case tijd16_30: return "16:30"; case tijd16_35: return "16:35"; case tijd16_40: return "16:40"; case tijd16_45: return "16:45"; case tijd16_50: return "16:50"; case tijd16_55: return "16:55";
      case tijd17_00: return "17:00"; case tijd17_05: return "17:05"; case tijd17_10: return "17:10"; case tijd17_15: return "17:15"; case tijd17_20: return "17:20"; case tijd17_25: return "17:25"; case tijd17_30: return "17:30"; case tijd17_35: return "17:35"; case tijd17_40: return "17:40"; case tijd17_45: return "17:45"; case tijd17_50: return "17:50"; case tijd17_55: return "17:55";
      case tijd18_00: return "18:00"; case tijd18_05: return "18:05"; case tijd18_10: return "18:10"; case tijd18_15: return "18:15"; case tijd18_20: return "18:20"; case tijd18_25: return "18:25"; case tijd18_30: return "18:30"; case tijd18_35: return "18:35"; case tijd18_40: return "18:40"; case tijd18_45: return "18:45"; case tijd18_50: return "18:50"; case tijd18_55: return "18:55";
      case tijd19_00: return "19:00"; case tijd19_05: return "19:05"; case tijd19_10: return "19:10"; case tijd19_15: return "19:15"; case tijd19_20: return "19:20"; case tijd19_25: return "19:25"; case tijd19_30: return "19:30"; case tijd19_35: return "19:35"; case tijd19_40: return "19:40"; case tijd19_45: return "19:45"; case tijd19_50: return "19:50"; case tijd19_55: return "19:55";      
      case tijd20_00: return "20:00"; case tijd20_05: return "20:05"; case tijd20_10: return "20:10"; case tijd20_15: return "20:15"; case tijd20_20: return "20:20"; case tijd20_25: return "20:25"; case tijd20_30: return "20:30"; case tijd20_35: return "20:35"; case tijd20_40: return "20:40"; case tijd20_45: return "20:45"; case tijd20_50: return "20:50"; case tijd20_55: return "20:55";
      case tijd21_00: return "21:00"; case tijd21_05: return "21:05"; case tijd21_10: return "21:10"; case tijd21_15: return "21:15"; case tijd21_20: return "21:20"; case tijd21_25: return "21:25"; case tijd21_30: return "21:30"; case tijd21_35: return "21:35"; case tijd21_40: return "21:40"; case tijd21_45: return "21:45"; case tijd21_50: return "21:50"; case tijd21_55: return "21:55";
      case tijd22_00: return "22:00"; case tijd22_05: return "22:05"; case tijd22_10: return "22:10"; case tijd22_15: return "22:15"; case tijd22_20: return "22:20"; case tijd22_25: return "22:25"; case tijd22_30: return "22:30"; case tijd22_35: return "22:35"; case tijd22_40: return "22:40"; case tijd22_45: return "22:45"; case tijd22_50: return "22:50"; case tijd22_55: return "22:55";
      case tijd23_00: return "23:00"; case tijd23_05: return "23:05"; case tijd23_10: return "23:10"; case tijd23_15: return "23:15"; case tijd23_20: return "23:20"; case tijd23_25: return "23:25"; case tijd23_30: return "23:30"; case tijd23_35: return "23:35"; case tijd23_40: return "23:40"; case tijd23_45: return "23:45"; case tijd23_50: return "23:50"; case tijd23_55: return "23:55";

      default: return "00:00"; // Default case to avoid unhandled scenario
    }
}
