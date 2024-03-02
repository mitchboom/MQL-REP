//+------------------------------------------------------------------+
//|                                                   Time_15MIN.mqh |
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
   tijd00_00,/*00:00*/ tijd00_15,/*00:15*/ tijd00_30,/*00:30*/ tijd00_45,/*00:45*/
   tijd01_00,/*01:00*/ tijd01_15,/*01:15*/ tijd01_30,/*01:30*/ tijd01_45,/*01:45*/
   tijd02_00,/*02:00*/ tijd02_15,/*02:15*/ tijd02_30,/*02:30*/ tijd02_45,/*02:45*/
   tijd03_00,/*03:00*/ tijd03_15,/*03:15*/ tijd03_30,/*03:30*/ tijd03_45,/*03:45*/
   tijd04_00,/*04:00*/ tijd04_15,/*04:15*/ tijd04_30,/*04:30*/ tijd04_45,/*04:45*/
   tijd05_00,/*05:00*/ tijd05_15,/*05:15*/ tijd05_30,/*05:30*/ tijd05_45,/*05:45*/
   tijd06_00,/*06:00*/ tijd06_15,/*06:15*/ tijd06_30,/*06:30*/ tijd06_45,/*06:45*/
   tijd07_00,/*07:00*/ tijd07_15,/*07:15*/ tijd07_30,/*07:30*/ tijd07_45,/*07:45*/
   tijd08_00,/*08:00*/ tijd08_15,/*08:15*/ tijd08_30,/*08:30*/ tijd08_45,/*08:45*/
   tijd09_00,/*09:00*/ tijd09_15,/*09:15*/ tijd09_30,/*09:30*/ tijd09_45,/*09:45*/
   tijd10_00,/*10:00*/ tijd10_15,/*10:15*/ tijd10_30,/*10:30*/ tijd10_45,/*10:45*/
   tijd11_00,/*11:00*/ tijd11_15,/*11:15*/ tijd11_30,/*11:30*/ tijd11_45,/*11:45*/
   tijd12_00,/*12:00*/ tijd12_15,/*12:15*/ tijd12_30,/*12:30*/ tijd12_45,/*12:45*/
   tijd13_00,/*13:00*/ tijd13_15,/*13:15*/ tijd13_30,/*13:30*/ tijd13_45,/*13:45*/
   tijd14_00,/*14:00*/ tijd14_15,/*14:15*/ tijd14_30,/*14:30*/ tijd14_45,/*14:45*/
   tijd15_00,/*15:00*/ tijd15_15,/*15:15*/ tijd15_30,/*15:30*/ tijd15_45,/*15:45*/
   tijd16_00,/*16:00*/ tijd16_15,/*16:15*/ tijd16_30,/*16:30*/ tijd16_45,/*16:45*/
   tijd17_00,/*17:00*/ tijd17_15,/*17:15*/ tijd17_30,/*17:30*/ tijd17_45,/*17:45*/
   tijd18_00,/*18:00*/ tijd18_15,/*18:15*/ tijd18_30,/*18:30*/ tijd18_45,/*18:45*/
   tijd19_00,/*19:00*/ tijd19_15,/*19:15*/ tijd19_30,/*19:30*/ tijd19_45,/*19:45*/
   tijd20_00,/*20:00*/ tijd20_15,/*20:15*/ tijd20_30,/*20:30*/ tijd20_45,/*20:45*/
   tijd21_00,/*21:00*/ tijd21_15,/*21:15*/ tijd21_30,/*21:30*/ tijd21_45,/*21:45*/
   tijd22_00,/*22:00*/ tijd22_15,/*22:15*/ tijd22_30,/*22:30*/ tijd22_45,/*22:45*/
   tijd23_00,/*23:00*/ tijd23_15,/*23:15*/ tijd23_30,/*23:30*/ tijd23_45/*23:45*/
};


// Function to convert DropdownOptions_Time to a time string
string TimeEnumToString(DropdownOptions_Time timeEnum) {
    switch(timeEnum) {
        case tijd00_00: return "00:00"; case tijd00_15: return "00:15"; case tijd00_30: return "00:30"; case tijd00_45: return "00:45";
        case tijd01_00: return "01:00"; case tijd01_15: return "01:15"; case tijd01_30: return "01:30"; case tijd01_45: return "01:45";
        case tijd02_00: return "02:00"; case tijd02_15: return "02:15"; case tijd02_30: return "02:30"; case tijd02_45: return "02:45";
        case tijd03_00: return "03:00"; case tijd03_15: return "03:15"; case tijd03_30: return "03:30"; case tijd03_45: return "03:45";
        case tijd04_00: return "04:00"; case tijd04_15: return "04:15"; case tijd04_30: return "04:30"; case tijd04_45: return "04:45";
        case tijd05_00: return "05:00"; case tijd05_15: return "05:15"; case tijd05_30: return "05:30"; case tijd05_45: return "05:45";
        case tijd06_00: return "06:00"; case tijd06_15: return "06:15"; case tijd06_30: return "06:30"; case tijd06_45: return "06:45";
        case tijd07_00: return "07:00"; case tijd07_15: return "07:15"; case tijd07_30: return "07:30"; case tijd07_45: return "07:45";
        case tijd08_00: return "08:00"; case tijd08_15: return "08:15"; case tijd08_30: return "08:30"; case tijd08_45: return "08:45";
        case tijd09_00: return "09:00"; case tijd09_15: return "09:15"; case tijd09_30: return "09:30"; case tijd09_45: return "09:45";
        case tijd10_00: return "10:00"; case tijd10_15: return "10:15"; case tijd10_30: return "10:30"; case tijd10_45: return "10:45";
        case tijd11_00: return "11:00"; case tijd11_15: return "11:15"; case tijd11_30: return "11:30"; case tijd11_45: return "11:45";
        case tijd12_00: return "12:00"; case tijd12_15: return "12:15"; case tijd12_30: return "12:30"; case tijd12_45: return "12:45";
        case tijd13_00: return "13:00"; case tijd13_15: return "13:15"; case tijd13_30: return "13:30"; case tijd13_45: return "13:45";
        case tijd14_00: return "14:00"; case tijd14_15: return "14:15"; case tijd14_30: return "14:30"; case tijd14_45: return "14:45";
        case tijd15_00: return "15:00"; case tijd15_15: return "15:15"; case tijd15_30: return "15:30"; case tijd15_45: return "15:45";
        case tijd16_00: return "16:00"; case tijd16_15: return "16:15"; case tijd16_30: return "16:30"; case tijd16_45: return "16:45";
        case tijd17_00: return "17:00"; case tijd17_15: return "17:15"; case tijd17_30: return "17:30"; case tijd17_45: return "17:45";
        case tijd18_00: return "18:00"; case tijd18_15: return "18:15"; case tijd18_30: return "18:30"; case tijd18_45: return "18:45";
        case tijd19_00: return "19:00"; case tijd19_15: return "19:15"; case tijd19_30: return "19:30"; case tijd19_45: return "19:45";
        case tijd20_00: return "20:00"; case tijd20_15: return "20:15"; case tijd20_30: return "20:30"; case tijd20_45: return "20:45";
        case tijd21_00: return "21:00"; case tijd21_15: return "21:15"; case tijd21_30: return "21:30"; case tijd21_45: return "21:45";
        case tijd22_00: return "22:00"; case tijd22_15: return "22:15"; case tijd22_30: return "22:30"; case tijd22_45: return "22:45";
        case tijd23_00: return "23:00"; case tijd23_15: return "23:15"; case tijd23_30: return "23:30"; case tijd23_45: return "23:45";

        default: return "00:00"; // Default case to handle any unhandled scenarios
    }
}



