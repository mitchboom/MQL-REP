

#include <MQL-REP\Time_30MIN.mqh>
#include <MQL-REP\Time_5MIN.mqh>




//+------------------------------------------------------------------+
//| Global or static variables                                       |
//+------------------------------------------------------------------+

// storing the Symbol
const string gSymbol = _Symbol;
const int gDigits = _Digits;


// Lotsizes
double lotsize, lotsize_hedge;


// Ema handles
int emaHandleFast, emaHandleMid, emaHandleSlow;
double MaFast[], MaMid[], MaSlow[];




//+------------------------------------------------------------------+
//| Declirations                                                     |
//+------------------------------------------------------------------+


enum CUSTOM_TIMEFRAMES {

   CUSTOM_M1 =    PERIOD_M1,  // M1 
   CUSTOM_M5 =    PERIOD_M5,  // M5
   CUSTOM_M15 =   PERIOD_M15, // M15 
   CUSTOM_M30 =   PERIOD_M30, // M30
   CUSTOM_H1 =    PERIOD_H1,  // H1 
   CUSTOM_H4 =    PERIOD_H4   // H4
};



int ConvertCustomTimeframe(CUSTOM_TIMEFRAMES customTimeframe) {
    switch (customTimeframe) {
        case CUSTOM_M1: return PERIOD_M1;
        case CUSTOM_M5: return PERIOD_M5;
        case CUSTOM_M15: return PERIOD_M15;
        case CUSTOM_M30: return PERIOD_M30;
        case CUSTOM_H1: return PERIOD_H1;
        case CUSTOM_H4: return PERIOD_H4;
        default: return PERIOD_CURRENT; // Default fallback
    }
}



// Dropdown Variables for Risk Input:
enum DropdownOptions_Risk {
    Option1, // Value (in €/$)
    Option2 // Percentage (in %)
};

// Dropdown Variables for Hedge:
enum DropdownOptions_Hedge {
    Hedge_Yes, // Apply hedge
    Hedge_No // No hedge
};

// Dropdown Variables for Hedge:
enum DropdownOptions_Reversed_Order {
    Normal_Order, // Normal
    Reversed_Order // Reversed Order
};


enum ENUM_TIME_INTERVAL {
   INTERVAL_5_MIN, // 5 MIN
   INTERVAL_30_MIN // 30 MIN
};


enum ENUM_VISUAL_MODE {
   YES,
   NO
};


enum ENTRY_MODE {
   FIB_MODE,   // Fib level
   PIP_MODE    // Pips
};



enum EMA_SETTING {
   EMA_OFF,             // Off
   EMA_WITH_TREND,      // Trade with Trend
   EMA_AGAINST_TREND    // Trade against Trend
};


enum ENUM_EMA_MODE {
    EMA_ONE_LINE,  // Price vs. EMA Line
    EMA_TWO_LINE   // Fast EMA vs. Slow EMA
};



//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input group                               "General Settings"
input int                                 Magic_Number = 2222;                                  //Magic Number


input group                               "Visual mode"
input ENUM_VISUAL_MODE                    inpVisualMode = NO;                                   // Show Fibonacci levels in chart                 

input group                               "Order Type"
input DropdownOptions_Reversed_Order      Choose_Direction = Normal_Order;                      // Reversed Order

input group                               "Time Interval"
input ENUM_TIME_INTERVAL                  Time_Interval = INTERVAL_30_MIN;                      // Choose between 5 or 30 min timesteps


input group                               "Time Settings 30 MIN"
input ENUM_TIME_30                        Start_Fibonacci_Timerange_30 = M30tijd07_00;          //Start Fibonacci Timerange
input ENUM_TIME_30                        End_Fibonacci_Timerange_30 = M30tijd10_00;            //End Fibonacci Timerange
input ENUM_TIME_30                        End_Trade_Order_Timerange_30 = M30tijd20_00;          //End of Trade Order
input ENUM_TIME_30                        End_Of_Trading_Day_30 = M30tijd22_00;                 // End of Trading Day


input group                               "Time Settings 5 MIN"
input ENUM_TIME_5                         Start_Fibonacci_Timerange_5 = tijd07_00;              //Start Fibonacci Timerange
input ENUM_TIME_5                         End_Fibonacci_Timerange_5 = tijd10_00;                //End Fibonacci Timerange
input ENUM_TIME_5                         End_Trade_Order_Timerange_5 = tijd20_00;              //End of Trade Order
input ENUM_TIME_5                         End_Of_Trading_Day_5 = tijd22_00;                     // End of Trading Day


input group                               "Fibonacci Level Settings"
input ENTRY_MODE                          EntryMode = FIB_MODE;                                 //Fib level or Pips
input double                              FIB_Level_Entry = 1.1;                                //Fib Level Entry
input double                              FIB_Level_TP = 2.0;                                   //Fib Level TP (SL for reversed order)


input group                               "Pips Range: range of the high and low"
input double                              min_pips_range = 10;                                  //min PIPS range
input double                              max_pips_range = 1000;                                //max PIPS range


input group                               "Risk Settings"
input DropdownOptions_Risk                Risk_Type = Option1;                                  //Choose your Risk type
input double                              Risk = 1000;                                          // Risk (percentage when <1, value when >=1)
input double                              RR = 1;                                               //Risk Reward (RR)
input double                              RR_Hedge = 1;                                         //Risk Reward (RR) of Hedge


input group                               "Hedge"
input DropdownOptions_Hedge               Choose_Hedge = Hedge_Yes;                             //Choose Hedge
input double                              Hedge_Multiplier = 2.00;                              //Hedge multiplier
input double                              FIB_Level_Hedge_TP = -0.40;                           //Fib Level TP Hedge
input double                              Reversed_FIB_Level_Hedge_TP = 2.5;                    //Fib Level TP Hedge for reversed order


input group                               "EMA Settings"
input EMA_SETTING                         inpEmaDirection = EMA_OFF;                            // Use EMA
input ENUM_EMA_MODE                       inpEmaMode = EMA_ONE_LINE;                            // 1 or 2 EMA line
input CUSTOM_TIMEFRAMES                   inpEmaTimeFrame = CUSTOM_H1;                          // EMA Timeframe 
input int                                 inpEmaFast = 20;                                      // EMA Fast Period    
input int                                 inpEmaSlow = 50;                                      // EMA Slow Period   


input group                               "Choose Days"
// Input parameters to enable/disable custom trading days and to specify which days to exclude
input bool                                excludeMonday = false;
input bool                                excludeTuesday = false;
input bool                                excludeWednesday = false;
input bool                                excludeThursday = false;
input bool                                excludeFriday = false;
input bool                                excludeSaturday = true;
input bool                                excludeSunday = true;



