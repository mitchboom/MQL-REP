#include <MQL-REP\Inputs.mqh>
#include <MQL-REP\FIB_level_calculation.mqh>


// Global variable to control buy execution
bool buyTriggeredToday = false;
bool sellTriggeredToday = false;
bool hedgeTriggered = false;

bool tpbuyHit = false;
bool tpsellHit = false;   




// FUNCTION: Global pip size variable
double F_getUniversalPipSize() {
    double pointSize = SymbolInfoDouble(gSymbol, SYMBOL_POINT);
    int digits = (int)SymbolInfoInteger(gSymbol, SYMBOL_DIGITS);

    // Adjust pip size calculation based on the number of digits
    switch (digits) {
        case 1:
            return pointSize * 1000;   // Example: XAUUSD, US30 (index)
        case 2:
            return pointSize * 100;    // Example: some commodities or indices
        case 3:
            return pointSize * 10;     // Example: JPY pairs
        case 4:
        case 5:
            return pointSize * 10;     // Example: most forex pairs
        default:
            return pointSize;          // Default case, if none of the above
    }
}

double pipSize = F_getUniversalPipSize();



// FUNCTION: Check for PIP range
bool F_in_pip_range(){
   // calculating the PRICE RANGE of the Fibonacci high and low:  
   double range_price = NormalizeDouble(myLevels.High_of_FIB_Range - myLevels.Low_of_FIB_Range, gDigits);
   double range_price_in_pips = NormalizeDouble(range_price / pipSize, 1);
   double min_tick_range = NormalizeDouble(min_pips_range * pipSize, gDigits);
   double max_tick_range = NormalizeDouble(max_pips_range * pipSize, gDigits);
   

   if (range_price >= min_tick_range && range_price <= max_tick_range){
      return true;
   }
   
   return false;
}



// FUNCTION: Is order in timerange:
bool F_time_in_order_range(){
   if(TimeGMT() >= Start_Order_timerange && TimeGMT() < End_Order_timerange){
      return true;
   }

   return false;   
}



// FUNCTION: Is hedge in trading time:
bool F_time_in_trade_range(){
   if(TimeGMT() >= Start_Order_timerange && TimeGMT() < End_Day){
      return true;
   }

   return false;   
}



// FUNCTION: use hedging
bool F_use_hedging(){
   switch(Choose_Hedge) {
     case Hedge_Yes:
         return true;
         break;
     case Hedge_No:
         return false;
         break;
     default:
         // Handle unexpected case, for safety no hedge
         return false;  
   }
}



// FUNCTION: custom trading days
bool F_CheckTradingDays()
  {
   
   // Get the current day of the week
   MqlDateTime currentMqlDateTime;
   TimeToStruct(TimeCurrent(), currentMqlDateTime);
   int day_of_week = currentMqlDateTime.day_of_week;

   // Check if today is one of the excluded days
   switch (day_of_week)
     {
      case 0: return !excludeSunday;    // Sunday
      case 1: return !excludeMonday;    // Monday
      case 2: return !excludeTuesday;   // Tuesday
      case 3: return !excludeWednesday; // Wednesday
      case 4: return !excludeThursday;  // Thursday
      case 5: return !excludeFriday;    // Friday
      case 6: return !excludeSaturday;  // Saturday
      default: return true;  // Should never happen, but just in case
     }
  }