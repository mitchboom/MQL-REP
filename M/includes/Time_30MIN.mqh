
// Dropdown Variables for Time Input:
enum ENUM_TIME_30 {
   tijd00_00,/*00:00*/ tijd00_30,/*00:30*/
   tijd01_00,/*01:00*/ tijd01_30,/*01:30*/
   tijd02_00,/*02:00*/ tijd02_30,/*02:30*/
   tijd03_00,/*03:00*/ tijd03_30,/*03:30*/
   tijd04_00,/*04:00*/ tijd04_30,/*04:30*/
   tijd05_00,/*05:00*/ tijd05_30,/*05:30*/
   tijd06_00,/*06:00*/ tijd06_30,/*06:30*/
   tijd07_00,/*07:00*/ tijd07_30,/*07:30*/
   tijd08_00,/*08:00*/ tijd08_30,/*08:30*/
   tijd09_00,/*09:00*/ tijd09_30,/*09:30*/
   tijd10_00,/*10:00*/ tijd10_30,/*10:30*/
   tijd11_00,/*11:00*/ tijd11_30,/*11:30*/
   tijd12_00,/*12:00*/ tijd12_30,/*12:30*/
   tijd13_00,/*13:00*/ tijd13_30,/*13:30*/
   tijd14_00,/*14:00*/ tijd14_30,/*14:30*/
   tijd15_00,/*15:00*/ tijd15_30,/*15:30*/
   tijd16_00,/*16:00*/ tijd16_30,/*16:30*/
   tijd17_00,/*17:00*/ tijd17_30,/*17:30*/
   tijd18_00,/*18:00*/ tijd18_30,/*18:30*/
   tijd19_00,/*19:00*/ tijd19_30,/*19:30*/
   tijd20_00,/*20:00*/ tijd20_30,/*20:30*/
   tijd21_00,/*21:00*/ tijd21_30,/*21:30*/
   tijd22_00,/*22:00*/ tijd22_30,/*22:30*/
   tijd23_00,/*23:00*/ tijd23_30/*23:30*/
};


// Function to convert DropdownOptions_Time to a time string
string TimeEnumToString(ENUM_TIME_30 timeEnum30) {
    switch(timeEnum30) {
        case tijd00_00: return "00:00"; case tijd00_30: return "00:30";
        case tijd01_00: return "01:00"; case tijd01_30: return "01:30";
        case tijd02_00: return "02:00"; case tijd02_30: return "02:30";
        case tijd03_00: return "03:00"; case tijd03_30: return "03:30";
        case tijd04_00: return "04:00"; case tijd04_30: return "04:30";
        case tijd05_00: return "05:00"; case tijd05_30: return "05:30";
        case tijd06_00: return "06:00"; case tijd06_30: return "06:30";
        case tijd07_00: return "07:00"; case tijd07_30: return "07:30";
        case tijd08_00: return "08:00"; case tijd08_30: return "08:30";
        case tijd09_00: return "09:00"; case tijd09_30: return "09:30";
        case tijd10_00: return "10:00"; case tijd10_30: return "10:30";
        case tijd11_00: return "11:00"; case tijd11_30: return "11:30";
        case tijd12_00: return "12:00"; case tijd12_30: return "12:30";
        case tijd13_00: return "13:00"; case tijd13_30: return "13:30";
        case tijd14_00: return "14:00"; case tijd14_30: return "14:30";
        case tijd15_00: return "15:00"; case tijd15_30: return "15:30";
        case tijd16_00: return "16:00"; case tijd16_30: return "16:30";
        case tijd17_00: return "17:00"; case tijd17_30: return "17:30";
        case tijd18_00: return "18:00"; case tijd18_30: return "18:30";
        case tijd19_00: return "19:00"; case tijd19_30: return "19:30";
        case tijd20_00: return "20:00"; case tijd20_30: return "20:30";
        case tijd21_00: return "21:00"; case tijd21_30: return "21:30";
        case tijd22_00: return "22:00"; case tijd22_30: return "22:30";
        case tijd23_00: return "23:00"; case tijd23_30: return "23:30";

        default: return "00:00"; // Default case to handle any unhandled scenarios
    }
}
