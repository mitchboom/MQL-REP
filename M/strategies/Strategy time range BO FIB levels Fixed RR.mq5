//+------------------------------------------------------------------+
//|                            Strategy time range BO FIB levels.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Mitch ."
#property link      "https://www.mql5.com"
#property version   "1.00"


#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <M\includes\Time_30MIN.mqh>
#include <M\includes\Lotsize_calculator.mqh>
#include <M\includes\Market_Excecutions_Ctrade.mqh>




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


// Input Variables:
input group "General Settings"
input int Magic_Number = 2222; //Magic Number
input DropdownOptions_Reversed_Order Choose_Direction = Normal_Order; // Reversed Order
input group "Time Settings"
input DropdownOptions_Time Start_Fibonacci_Timerange = tijd06_00; //Start Fibonacci Timerange
input DropdownOptions_Time End_Fibonacci_Timerange = tijd10_00; //End Fibonacci Timerange
input DropdownOptions_Time End_Trade_Order_Timerange = tijd20_00; //End of Trade Order
input DropdownOptions_Time End_Of_Trading_Day = tijd22_00; // End of Trading Day
input group "Fibonacci Level Settings"
input double FIB_Level_Entry = 1.1; //Fib Level Entry
input double FIB_Level_TP = 1.8; //Fib Level TP (SL for reversed order)
input group "Pips Range: range of the high and low"
input double min_pips_range = 20; //min PIPS range
input double max_pips_range = 1000; //max PIPS range
input group "Risk Settings"
input DropdownOptions_Risk Risk_Type = Option2; //Choose your Risk type
input double Risk_Percentage = 1.00; // Risk percentage
input double Risk = 1000; // Risk value
input double RR = 1; //Risk Reward (RR)
input double RR_Hedge = 1; //Risk Reward (RR) of Hedge
input group "Hedge"
input DropdownOptions_Hedge Choose_Hedge = Hedge_Yes; //Choose Hedge
input double Hedge_Multiplier = 2.00; //Hedge multiplier
input double FIB_Level_Hedge_TP = -0.40; //Fib Level TP Hedge
input double Reversed_FIB_Level_Hedge_TP = 2.0; //Fib Level TP Hedge for reversed order
input group "Choose Days"
// Input parameters to enable/disable custom trading days and to specify which days to exclude
input bool excludeMonday = true;
input bool excludeTuesday = false;
input bool excludeWednesday = false;
input bool excludeThursday = false;
input bool excludeFriday = true;
input bool excludeSaturday = true;
input bool excludeSunday = true;


// Global Variables:
datetime Start_FIB_timerange;
datetime End_FIB_timerange;
datetime Start_Order_timerange;
datetime End_Order_timerange;

datetime Clear_Day, End_of_Day;

double GlobalFibLevels[8];
double GlobalFibLevelsHedge[4];
double High_of_FIB_Range, Low_of_FIB_Range, Entry_BUY_STOP, Entry_SELL_STOP, TP_BUY_STOP, TP_SELL_STOP, SL_BUY_STOP, SL_SELL_STOP;
double TP_BUY_STOP_HEDGE, SL_BUY_STOP_HEDGE, TP_SELL_STOP_HEDGE, SL_SELL_STOP_HEDGE;

double Entry_SELL_LIMIT, SL_SELL_LIMIT, TP_SELL_LIMIT, Entry_BUY_LIMIT, SL_BUY_LIMIT, TP_BUY_LIMIT;
double TP_SELL_LIMIT_HEDGE, SL_SELL_LIMIT_HEDGE, TP_BUY_LIMIT_HEDGE, SL_BUY_LIMIT_HEDGE;


double lotsize, lotsize_hedge;

bool BUY_HIT = false;
bool SELL_HIT = false;
bool TP_BUY_HIT = false;
bool TP_SELL_HIT = false;

    


double FIB_Level_SL = FIB_Level_Entry - MathAbs(FIB_Level_TP - FIB_Level_Entry)*(1/RR);
double FIB_Level_Hedge_SL = FIB_Level_SL + MathAbs(FIB_Level_Hedge_TP - FIB_Level_SL)*(1/RR_Hedge);
double Reversed_FIB_Level_Hedge_SL = FIB_Level_TP - MathAbs(Reversed_FIB_Level_Hedge_TP - FIB_Level_TP)*(1/RR_Hedge);
double Reversed_FIB_Level_TP = FIB_Level_Entry - MathAbs(FIB_Level_TP - FIB_Level_Entry)*RR;
double Reversed_FIB_Level_SL = FIB_Level_TP;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   
   //checking the license by initializing the expert advisor
   static bool isInit = false;
   if(!isInit){
      isInit = true;
      
      //check if user is allowed to use the program
      long Customer1 = 51655118; //Mitch Lenovo laptop
      long Customer2 = 51753980; //Mitch Macbook
      long Customer3 = 51753980; //Mitch VPS Goud server
      long Customer4 = 51738747; //Mitch Backtest server 48 core
      
      long Customer5 = 51806904; //Dave Lenovo laptop
      long Customer6 = 5023183985; //Dave server
      long Customer7 = 51788033; //Dave server
      long Customer8 = 51788032; //Dave server
      
      long accountNo = AccountInfoInteger(ACCOUNT_LOGIN);
      if(Customer1 == accountNo || 
         Customer2 == accountNo || 
         Customer3 == accountNo || 
         Customer4 == accountNo || 
         Customer5 == accountNo || 
         Customer6 == accountNo || 
         Customer7 == accountNo || 
         Customer8 == accountNo){
         
         Print(__FUNCTION__," > License verified");
      }
      else{
         Print(__FUNCTION__," > License is invalid");
         ExpertRemove();
         return INIT_FAILED;
      }
   }
   
   
    // Check if FIB_Level_Entry is within a specific range
    if(FIB_Level_Entry < 1.0) {
        Print("FIB_Level_Entry must be higher than 1.0. Please adjust the setting.");
    }

    // Check if FIB_Level_TP is greater than FIB_Level_Entry
    if(FIB_Level_TP < FIB_Level_Entry) {
        Print("FIB_Level_TP must be higher than FIB_Level_Entry. Please adjust the setting.");
    }

    // Check if FIB_Level_SL is within a specific range
    if(FIB_Level_SL > FIB_Level_Entry) {
        Print("FIB_Level_SL must be lower than FIB_Level_Entry. Please adjust the setting.");
    }


   trade.SetExpertMagicNumber(Magic_Number);
   
   return(INIT_SUCCEEDED);
}
  
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){

   ObjectsDeleteAll(0);
   
}
  



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
double OnTester(){

   double customCriteria = (TesterStatistics(STAT_TRADES)-TesterStatistics(STAT_LOSS_TRADES)) / TesterStatistics(STAT_TRADES) ;
   
   return customCriteria;
 }


  
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){



   Start_FIB_timerange = StringToTime(TimeEnumToString(Start_Fibonacci_Timerange));
   End_FIB_timerange = StringToTime(TimeEnumToString(End_Fibonacci_Timerange));
   Start_Order_timerange = End_FIB_timerange;
   End_Order_timerange = StringToTime(TimeEnumToString(End_Trade_Order_Timerange));
   Clear_Day = StringToTime(TimeEnumToString(End_Of_Trading_Day));
   End_of_Day = StringToTime("23:59");

   if(Clear_Day < TimeCurrent() && End_of_Day > TimeCurrent()){
   
      for(int i = PositionsTotal()-1; i >= 0; i--){
         ulong ticket = PositionGetTicket(i);
         trade.PositionClose(ticket);
      }
      
   
      BUY_HIT = false;
      SELL_HIT = false;
      TP_BUY_HIT = false;
      TP_SELL_HIT = false;     
   }

// Use the CheckTradingDays function to decide whether to trade
if(CheckTradingDays()){

// Showing Ranges en Fibonacci in the chart:
   
   /*
   FIB_Range_Rectangle();
   Order_Range_Rectangle();

   if(Choose_Direction == Normal_Order){
   FIB_Levels_In_Range();
   }
   if(Choose_Direction == Reversed_Order){
   FIB_Levels_In_Range_Reversed();
   }
   */
   
  //Print(FIB_Level_TP); 
  //Print(1-FIB_Level_Hedge_TP);
  //Print(1-FIB_Level_SL); 
  //Print(FIB_Level_Hedge_SL); 
  //Print(1-FIB_Level_Hedge_SL);
  //Print(FIB_Level_SL);
  //Print(1.00-FIB_Level_Entry);
  //Print(FIB_Level_Hedge_TP);
  //Print(1.00-FIB_Level_TP);
   
// --------------------NORMAL ORDER---------------------------------  
if(Choose_Direction == Normal_Order){
   // Searching the Price Values of the FIB Levels:
      if(Start_FIB_timerange < TimeCurrent()){
         
         datetime Start_FIB = Start_FIB_timerange;
         datetime End_FIB = End_FIB_timerange;
         
         if(End_FIB_timerange >= TimeCurrent()){
            End_FIB = TimeCurrent();
         }
         else if(End_FIB_timerange >= TimeCurrent()){
            End_FIB = End_FIB_timerange;
         }
         
         int Start_bars = iBarShift(_Symbol,PERIOD_CURRENT,Start_FIB,true);
         int End_bars = iBarShift(_Symbol,PERIOD_CURRENT,End_FIB,true);
         
         datetime Start_time_bars = iTime(_Symbol,PERIOD_CURRENT,Start_bars);
         datetime End_time_bars = iTime(_Symbol,PERIOD_CURRENT,End_bars);
               
         double PriceStart = iHigh(_Symbol,PERIOD_CURRENT,iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,Start_bars-(End_bars-1),End_bars+1));
         double PriceEnd = iLow(_Symbol,PERIOD_CURRENT,iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,Start_bars-(End_bars-1),End_bars+1));
           
         // Calculate and store Fibonacci levels
         double priceRange = PriceStart - PriceEnd; 
         double fibLevels[] = {FIB_Level_TP, FIB_Level_Entry, 1.0, (1-FIB_Level_SL), FIB_Level_SL, 0.0, (1-FIB_Level_Entry), (1-FIB_Level_TP)}; // Your custom levels     
         for(int i = 0; i < ArraySize(fibLevels); i++) {
             GlobalFibLevels[i] = PriceEnd + priceRange * fibLevels[i];
         }
         
         double fibLevels_hedge[] = {FIB_Level_Hedge_TP, (1-FIB_Level_Hedge_SL), FIB_Level_Hedge_SL, (1-FIB_Level_Hedge_TP)};   
         for(int i = 0; i < ArraySize(fibLevels_hedge); i++) {
             GlobalFibLevelsHedge[i] = PriceEnd + priceRange * fibLevels_hedge[i];
         }      
                 
      } //end of if
   
   
   
   // Determining the Fibonacci levels of the range:  
      High_of_FIB_Range = NormalizeDouble(GlobalFibLevels[2],_Digits);
      Low_of_FIB_Range = NormalizeDouble(GlobalFibLevels[5],_Digits);
      
      Entry_BUY_STOP = NormalizeDouble(GlobalFibLevels[1],_Digits);
      TP_BUY_STOP = NormalizeDouble(GlobalFibLevels[0],_Digits);
      SL_BUY_STOP = NormalizeDouble(GlobalFibLevels[4],_Digits);
      Entry_SELL_STOP = NormalizeDouble(GlobalFibLevels[6],_Digits);
      TP_SELL_STOP = NormalizeDouble(GlobalFibLevels[7],_Digits);
      SL_SELL_STOP = NormalizeDouble(GlobalFibLevels[3],_Digits);
   
      TP_BUY_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[0],_Digits);
      SL_BUY_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[2],_Digits);
      TP_SELL_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[3],_Digits);
      SL_SELL_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[1],_Digits);
      
      
      
   // calculating the PRICE RANGE of the Fibonacci high and low:  
      double ticksize = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      double range_price = NormalizeDouble(High_of_FIB_Range-Low_of_FIB_Range,_Digits);
      double range_price_in_pips = NormalizeDouble( (range_price / ticksize)/10, 1);
      double min_tick_range = NormalizeDouble(ticksize * min_pips_range*10,_Digits);
      double max_tick_range = NormalizeDouble(ticksize * max_pips_range*10,_Digits);
      
/*      Print("BUY_HIT      ",BUY_HIT);
      Print("SELL_HIT     ", SELL_HIT);
      Print("TP_BUY_HIT   ", TP_BUY_HIT);
      Print("TP_SELL_HIT  ", TP_SELL_HIT);
      Print("TP sell stop" ,TP_SELL_STOP);
      Print("Start order timernage ",Start_Order_timerange);
      Print("time current ", TimeCurrent());
      Print("Postions total ",PositionsTotal());
 */     
   // statement if the pips range is in the min value and max value than moving on with the EA
      bool is_in_pips_range = range_price >= min_tick_range && range_price <= max_tick_range;
   
      if(is_in_pips_range){
      
         // Calculating Lotsize value:
         switch(Risk_Type) {
              case Option1:
                  lotsize = Positionsize_value(Entry_BUY_STOP, SL_BUY_STOP,Risk);
                  break;
              case Option2:
                  lotsize = Positionsize_percentage(Entry_BUY_STOP, SL_BUY_STOP,Risk_Percentage);
                  break;
          }
   
         // Calculating Lotsize value Hedge:
               // Calculating Lotsize value:
         switch(Risk_Type) {
              case Option1:
                  lotsize_hedge = Positionsize_value(SL_BUY_STOP,SL_BUY_STOP_HEDGE,Risk);
                  break;
              case Option2:
                  lotsize_hedge = Positionsize_percentage(SL_BUY_STOP,SL_BUY_STOP_HEDGE,Risk_Percentage);
                  break;
          }
   
   
         // Is order in timerange:
         bool is_time_in_order_range = TimeCurrent() >= Start_Order_timerange && TimeCurrent() < End_Order_timerange;
   
         
         // Creating BUY at entry FIB level 1.1 
         int Total_BUY_Positions = 0;
         for(int i=PositionsTotal();i>=0;i--){ 
            if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY && PositionGetInteger(POSITION_MAGIC) == Magic_Number){
              Total_BUY_Positions += 1;
              BUY_HIT = true;
            }      
         }
         
         double current_ask_price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
          
         if(Total_BUY_Positions < 1 && current_ask_price >= Entry_BUY_STOP && is_time_in_order_range && !BUY_HIT && !SELL_HIT){
            Execute_BUY(lotsize,SL_BUY_STOP,TP_BUY_STOP);
            Print("Trade executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total BUY positions now for this EA: ",_Symbol,": ",Total_BUY_Positions+1);
         }
    
         /*
         if (Total_BUY_Positions >= 1) {
            Print("No BUY Trade ", _Symbol, ", already ", Total_BUY_Positions ," BUY trade(s) open for this pair and EA -> MAGIC Nummber: ", Magic_Number);
         }
         if (!is_time_in_order_range) {
          Print("No BUY Trade ", _Symbol, ", not within order time range: ", TimeToString(Start_Order_timerange), " - ", TimeToString(End_Order_timerange));
         }
         else if (current_ask_price < Entry_BUY_STOP) {
             Print("No BUY Trade ", _Symbol, ", market price has not reached the Entry_BUY_STOP: ", Entry_BUY_STOP, " Current Price: ", current_ask_price);
         }
         */
      
   
      
      
         // Creating SELL at entry FIB level -0.1:
         int Total_SELL_Positions = 0;
         for(int i=PositionsTotal();i>=0;i--){ 
            if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL && PositionGetInteger(POSITION_MAGIC) == Magic_Number){
              Total_SELL_Positions += 1;
              SELL_HIT = true;
            }      
         }
       
         double current_bid_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
       
         if(Total_SELL_Positions < 1 && current_bid_price <= Entry_SELL_STOP && is_time_in_order_range && !SELL_HIT && !BUY_HIT){
            Execute_SELL(lotsize,SL_SELL_STOP,TP_SELL_STOP);
            Print("Trade executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total SELL positions now for this EA: ",_Symbol,": ",Total_SELL_Positions+1);
         }
         
         /*
         if (Total_SELL_Positions >= 1) {
            Print("No SELL Trade ", _Symbol, ", already ", Total_SELL_Positions ," BUY trade(s) open for this pair and EA -> MAGIC Nummber: ", Magic_Number);
         }   
         if (!is_time_in_order_range) {
            Print("No SELL Trade ", _Symbol, ", not within order time range: ", TimeToString(Start_Order_timerange), " - ", TimeToString(End_Order_timerange));
         }
         else if (current_bid_price > Entry_SELL_STOP) {
            Print("No SELL Trade ", _Symbol, ", market price has not reached the Entry_BUY_STOP: ", Entry_SELL_STOP, " Current Price: ", current_bid_price);
         }
         */
         
         
         // HEDGING WHEN HEDGING IS APPLIED:
         bool Hedging_true_or_false = true; // Default initialization;
   
         switch(Choose_Hedge) {
              case Hedge_Yes:
                  Hedging_true_or_false = true;
                  break;
              case Hedge_No:
                  Hedging_true_or_false = false;
                  break;
         }
              
         if(Hedging_true_or_false){
         
            //Hedge when BUY position is open: 
            if(TimeCurrent() >= Start_Order_timerange && TimeCurrent() <= Clear_Day && current_bid_price >= TP_BUY_STOP){
               TP_BUY_HIT = true;
            }    
            if(!TP_BUY_HIT && Total_BUY_Positions < 1 && Total_SELL_Positions < 1 && BUY_HIT && !SELL_HIT && current_bid_price <= SL_BUY_STOP){
               Execute_SELL(Hedge_Multiplier*lotsize_hedge,SL_BUY_STOP_HEDGE,TP_BUY_STOP_HEDGE);
               Print("HEDGE executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total SELL positions now for this EA: ",_Symbol,": ",Total_SELL_Positions+1);
            }
             
            //Hedge when SELL position is open: 
            if(TimeCurrent() >= Start_Order_timerange && TimeCurrent() <= Clear_Day && current_ask_price <= TP_SELL_STOP){
               TP_SELL_HIT = true;
            }    
            if(!TP_SELL_HIT && Total_BUY_Positions < 1 && Total_SELL_Positions < 1 && !BUY_HIT && SELL_HIT && current_ask_price >= SL_SELL_STOP){
               Execute_BUY(Hedge_Multiplier*lotsize_hedge,SL_SELL_STOP_HEDGE,TP_SELL_STOP_HEDGE);
               Print("HEDGE executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total SELL positions now for this EA: ",_Symbol,": ",Total_SELL_Positions+1);
            }
            
   
         }
         
      } //END OF IF STATEMENT IF IN PIPS RANGE
      
      //else{
      //Print("PIPS Range of the fibonacci retracement = ", range_price_in_pips, ". Outside allowed pips range of: ", min_pips_range," - ", max_pips_range);
      //}
   
} //END OF NORMAL ORDER




// --------------------REVERSED ORDER---------------------------------  
if(Choose_Direction == Reversed_Order){
   // Searching the Price Values of the FIB Levels:
      if(Start_FIB_timerange < TimeCurrent()){
         
         datetime Start_FIB = Start_FIB_timerange;
         datetime End_FIB = End_FIB_timerange;
         
         if(End_FIB_timerange >= TimeCurrent()){
            End_FIB = TimeCurrent();
         }
         else if(End_FIB_timerange >= TimeCurrent()){
            End_FIB = End_FIB_timerange;
         }
         
         int Start_bars = iBarShift(_Symbol,PERIOD_CURRENT,Start_FIB,true);
         int End_bars = iBarShift(_Symbol,PERIOD_CURRENT,End_FIB,true);
         
         datetime Start_time_bars = iTime(_Symbol,PERIOD_CURRENT,Start_bars);
         datetime End_time_bars = iTime(_Symbol,PERIOD_CURRENT,End_bars);
               
         double PriceStart = iHigh(_Symbol,PERIOD_CURRENT,iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,Start_bars-(End_bars-1),End_bars+1));
         double PriceEnd = iLow(_Symbol,PERIOD_CURRENT,iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,Start_bars-(End_bars-1),End_bars+1));
           
         // Calculate and store Fibonacci levels
         double priceRange = PriceStart - PriceEnd; 
         double fibLevels[] = {Reversed_FIB_Level_SL, FIB_Level_Entry, 1.0, Reversed_FIB_Level_TP, (1-Reversed_FIB_Level_TP), 0.0, (1-FIB_Level_Entry), (1-Reversed_FIB_Level_SL)}; // Your custom levels     
         for(int i = 0; i < ArraySize(fibLevels); i++) {
             GlobalFibLevels[i] = PriceEnd + priceRange * fibLevels[i];
         }
         
         double fibLevels_hedge[] = {Reversed_FIB_Level_Hedge_TP, Reversed_FIB_Level_Hedge_SL, (1-Reversed_FIB_Level_Hedge_SL), (1-Reversed_FIB_Level_Hedge_TP)};   
         for(int i = 0; i < ArraySize(fibLevels_hedge); i++) {
             GlobalFibLevelsHedge[i] = PriceEnd + priceRange * fibLevels_hedge[i];
         }      
                 
      } //end of if
   
   
   
   // Determining the Fibonacci levels of the range:  
      High_of_FIB_Range = NormalizeDouble(GlobalFibLevels[2],_Digits);
      Low_of_FIB_Range = NormalizeDouble(GlobalFibLevels[5],_Digits);
      
      Entry_SELL_LIMIT = NormalizeDouble(GlobalFibLevels[1],_Digits);
      SL_SELL_LIMIT = NormalizeDouble(GlobalFibLevels[0],_Digits);
      TP_SELL_LIMIT = NormalizeDouble(GlobalFibLevels[3],_Digits);
      Entry_BUY_LIMIT = NormalizeDouble(GlobalFibLevels[6],_Digits);
      SL_BUY_LIMIT = NormalizeDouble(GlobalFibLevels[7],_Digits);
      TP_BUY_LIMIT = NormalizeDouble(GlobalFibLevels[4],_Digits);
   
      TP_SELL_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[0],_Digits);
      SL_SELL_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[1],_Digits);
      TP_BUY_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[3],_Digits);
      SL_BUY_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[2],_Digits);
      
      
      
   // calculating the PRICE RANGE of the Fibonacci high and low:  
      double ticksize = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      double range_price = NormalizeDouble(High_of_FIB_Range-Low_of_FIB_Range,_Digits);
      double range_price_in_pips = NormalizeDouble( (range_price / ticksize)/10, 1);
      double min_tick_range = NormalizeDouble(ticksize * min_pips_range*10,_Digits);
      double max_tick_range = NormalizeDouble(ticksize * max_pips_range*10,_Digits);

   // statement if the pips range is in the min value and max value than moving on with the EA
      bool is_in_pips_range = range_price >= min_tick_range && range_price <= max_tick_range;
   
      if(is_in_pips_range){
      
         // Calculating Lotsize value:
         switch(Risk_Type) {
              case Option1:
                  lotsize = Positionsize_value(Entry_SELL_LIMIT, SL_SELL_LIMIT,Risk);
                  break;
              case Option2:
                  lotsize = Positionsize_percentage(Entry_SELL_LIMIT, SL_SELL_LIMIT,Risk_Percentage);
                  break;
          }
   
         // Calculating Lotsize value Hedge:
               // Calculating Lotsize value:
         switch(Risk_Type) {
              case Option1:
                  lotsize_hedge = Positionsize_value(SL_SELL_LIMIT,SL_SELL_LIMIT_HEDGE,Risk);
                  break;
              case Option2:
                  lotsize_hedge = Positionsize_percentage(SL_SELL_LIMIT,SL_SELL_LIMIT_HEDGE,Risk_Percentage);
                  break;
          }
   
   
         // Is order in timerange:
         bool is_time_in_order_range = TimeCurrent() >= Start_Order_timerange && TimeCurrent() < End_Order_timerange;
   
         
         // Creating BUY at entry FIB level -0.1 
         int Total_BUY_Positions = 0;
         for(int i=PositionsTotal();i>=0;i--){ 
            if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY && PositionGetInteger(POSITION_MAGIC) == Magic_Number){
              Total_BUY_Positions += 1;
              BUY_HIT = true;
            }      
         }
         
         double current_ask_price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
          
         if(Total_BUY_Positions < 1 && current_ask_price <= Entry_BUY_LIMIT && is_time_in_order_range && !BUY_HIT && !SELL_HIT){
            Execute_BUY(lotsize,SL_BUY_LIMIT,TP_BUY_LIMIT);
            Print("Trade executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total BUY positions now for this EA: ",_Symbol,": ",Total_BUY_Positions+1);
         }
    
      
   
      
      
         // Creating SELL at entry FIB level 1.1:
         int Total_SELL_Positions = 0;
         for(int i=PositionsTotal();i>=0;i--){ 
            if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL && PositionGetInteger(POSITION_MAGIC) == Magic_Number){
              Total_SELL_Positions += 1;
              SELL_HIT = true;
            }      
         }
       
         double current_bid_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
       
         if(Total_SELL_Positions < 1 && current_bid_price >= Entry_SELL_LIMIT && is_time_in_order_range && !SELL_HIT && !BUY_HIT){
            Execute_SELL(lotsize,SL_SELL_LIMIT,TP_SELL_LIMIT);
            Print("Trade executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total SELL positions now for this EA: ",_Symbol,": ",Total_SELL_Positions+1);
         }
         
         
         
         // HEDGING WHEN HEDGING IS APPLIED:
         bool Hedging_true_or_false = true; // Default initialization;
   
         switch(Choose_Hedge) {
              case Hedge_Yes:
                  Hedging_true_or_false = true;
                  break;
              case Hedge_No:
                  Hedging_true_or_false = false;
                  break;
         }
              
         if(Hedging_true_or_false){
         
            //Hedge when BUY position is open: 
            if(TimeCurrent() >= Start_Order_timerange && TimeCurrent() <= Clear_Day && current_bid_price >= TP_BUY_LIMIT && BUY_HIT){
               TP_BUY_HIT = true;
            }    
            if(!TP_BUY_HIT && Total_BUY_Positions < 1 && Total_SELL_Positions < 1 && BUY_HIT && !SELL_HIT && current_bid_price <= SL_BUY_LIMIT){
               Execute_SELL(Hedge_Multiplier*lotsize_hedge,SL_BUY_LIMIT_HEDGE,TP_BUY_LIMIT_HEDGE);
               Print("HEDGE executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total SELL positions now for this EA: ",_Symbol,": ",Total_SELL_Positions+1);
            }
             
            //Hedge when SELL position is open: 
            if(TimeCurrent() >= Start_Order_timerange && TimeCurrent() <= Clear_Day && current_ask_price <= TP_SELL_LIMIT && SELL_HIT){
               TP_SELL_HIT = true;
            }    
            if(!TP_SELL_HIT && Total_BUY_Positions < 1 && Total_SELL_Positions < 1 && !BUY_HIT && SELL_HIT && current_ask_price >= SL_SELL_LIMIT){
               Execute_BUY(Hedge_Multiplier*lotsize_hedge,SL_SELL_LIMIT_HEDGE,TP_SELL_LIMIT_HEDGE);
               Print("HEDGE executed on: ",_Symbol, " Total positions now: ",PositionsTotal(), "  Total SELL positions now for this EA: ",_Symbol,": ",Total_SELL_Positions+1);
            }
            
   
         }
         
      } //END OF IF STATEMENT IF IN PIPS RANGE
      
      //else{
      //Print("PIPS Range of the fibonacci retracement = ", range_price_in_pips, ". Outside allowed pips range of: ", min_pips_range," - ", max_pips_range);
      //}
   
} //END OF REVERSED ORDER

}
   else
     {
      Print("Today is not a trading day. No trading activities.");
      return;
     }


} // END OF ON TICK









//+-------------------------------------------------------------------------------------------------------------------------------------------------------+
//| FUNCTIONS FOR SHOWING ON THE CHART |                                         
//+-------------------------------------------------------------------------------------------------------------------------------------------------------+



//FUNCTION:    Showing RECTANGLE of the fibonacci retracement range
//----------------------------------------------------------------- 
void FIB_Range_Rectangle(){

   datetime Current_time = TimeCurrent();
   datetime Start_time_range = Start_FIB_timerange;
   datetime End_time_range = End_FIB_timerange;
   
   if(Start_time_range > Current_time){
      long chartID = ChartID();
   }
   else{
      if(End_time_range >= Current_time){
         End_time_range = Current_time;
      }
      
      long chartID = ChartID();
      
      int Start_bars = iBarShift(_Symbol,PERIOD_CURRENT,Start_time_range,true);
      int End_bars = iBarShift(_Symbol,PERIOD_CURRENT,End_time_range,true);
      
      datetime Start_time_bars = iTime(_Symbol,PERIOD_CURRENT,Start_bars);
      datetime End_time_bars = iTime(_Symbol,PERIOD_CURRENT,End_bars);
      
      double PriceStart = iHigh(_Symbol,PERIOD_CURRENT,iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,Start_bars-(End_bars-1),End_bars+1));
      double PriceEnd = iLow(_Symbol,PERIOD_CURRENT,iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,Start_bars-(End_bars-1),End_bars+1));
   
      // Name for the rectangle object
      string objectName = "FIB Rectangle";
   
      // Check if object already exists, if so, delete it
      if(ObjectFind(0, objectName) != -1)
          ObjectDelete(0, objectName);
          
      // Create rectangle to highlight the session
      ObjectCreate(chartID, objectName, OBJ_RECTANGLE, 0, Start_time_bars, PriceStart , End_time_bars, PriceEnd);
      
      // Set color and style of the rectangle
         ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clrLightBlue); // Set color
         ObjectSetInteger(chartID, objectName, OBJPROP_STYLE, STYLE_SOLID); // Set fill style
         ObjectSetInteger(chartID, objectName, OBJPROP_BACK, true); // Place in background
         ObjectSetInteger(chartID, objectName, OBJPROP_FILL, true); // Place in background
         ObjectSetInteger(chartID, objectName, OBJPROP_WIDTH, 1); // Border width
     

   } // end of else
} // end of function





//FUNCTION:    Showing RECTANGLE of the order range
//------------------------------------------------- 
void Order_Range_Rectangle(){

   datetime Current_time = TimeCurrent();
   datetime Start_time_range = Start_FIB_timerange;
   datetime End_time_range = End_FIB_timerange;
   
   datetime Start_Order_range = Start_Order_timerange;
   datetime End_Order_range = End_Order_timerange;
   
   
   if(Start_Order_range > Current_time){
      long chartID = ChartID();
   }
   else{
      if(End_Order_range >= Current_time){
         End_Order_range = Current_time;
      }
      
      long chartID = ChartID();
      
      int Start_bars = iBarShift(_Symbol,PERIOD_CURRENT,Start_Order_range,true);
      int End_bars = iBarShift(_Symbol,PERIOD_CURRENT,End_Order_range,true);
      
      datetime Start_time_bars = iTime(_Symbol,PERIOD_CURRENT,Start_bars);
      datetime End_time_bars = iTime(_Symbol,PERIOD_CURRENT,End_bars);
      
      //High and low of order rectangle based on the High and Low of the FIBONNACCI LEVELS:
      int Start_bars_FIB = iBarShift(_Symbol,PERIOD_CURRENT,Start_time_range,true); 
      int End_bars_FIB = iBarShift(_Symbol,PERIOD_CURRENT,End_time_range,true);
         
      double PriceStart = iHigh(_Symbol,PERIOD_CURRENT,iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,Start_bars_FIB-(End_bars_FIB-1),End_bars_FIB+1));
      double PriceEnd = iLow(_Symbol,PERIOD_CURRENT,iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,Start_bars_FIB-(End_bars_FIB-1),End_bars_FIB+1));
   
      // Name for the rectangle object
      string objectName = "ORDER rectangle";
   
      // Check if object already exists, if so, delete it
      if(ObjectFind(0, objectName) != -1)
          ObjectDelete(0, objectName);
          
      // Create rectangle to highlight the session
      ObjectCreate(chartID, objectName, OBJ_RECTANGLE, 0, Start_time_bars, PriceStart , End_time_bars, PriceEnd);
      
      // Set color and style of the rectangle
         ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clrYellow); // Set color
         ObjectSetInteger(chartID, objectName, OBJPROP_STYLE, STYLE_SOLID); // Set fill style
         ObjectSetInteger(chartID, objectName, OBJPROP_BACK, true); // Place in background
         ObjectSetInteger(chartID, objectName, OBJPROP_FILL, true); // Place in background
         ObjectSetInteger(chartID, objectName, OBJPROP_WIDTH, 1); // Border width
      
         
   } // end of else
} // end of function



//FUNCTION:    Showing FIBONACCI RETRACEMENT LEVELS of the range
//-------------------------------------------------------------- 
void FIB_Levels_In_Range() {

   datetime Current_time = TimeCurrent();
   datetime Start_time_range = Start_FIB_timerange;
   datetime End_time_range = End_FIB_timerange;
   
   if(Start_time_range > Current_time){
      long chartID = ChartID();
   }
   else{
      if(End_time_range >= Current_time){
         End_time_range = Current_time;
      }
      if(End_of_Day >= Current_time){
         End_of_Day = Current_time;
      }
      
      long chartID = ChartID();
      
      int Start_bars = iBarShift(_Symbol,PERIOD_CURRENT,Start_time_range,true);
      int End_bars = iBarShift(_Symbol,PERIOD_CURRENT,End_time_range,true);
      
      datetime Start_time_bars = iTime(_Symbol,PERIOD_CURRENT,Start_bars);
      datetime End_time_bars = iTime(_Symbol,PERIOD_CURRENT,End_bars);
      
      double PriceStart = iHigh(_Symbol,PERIOD_CURRENT,iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,Start_bars-(End_bars-1),End_bars+1));
      double PriceEnd = iLow(_Symbol,PERIOD_CURRENT,iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,Start_bars-(End_bars-1),End_bars+1));
   
      // Name for the FIB object
      string objectName = "FIB LEVELS";
   
      // Check if object already exists, if so, delete it
      if(ObjectFind(0, objectName) != -1)
          ObjectDelete(0, objectName);
          
      // Create rectangle to highlight the session
      ObjectCreate(chartID, objectName, OBJ_FIBO,0 , Start_time_bars, PriceStart , End_of_Day, PriceEnd, clrBlack);
      
      
      // Set color and style of the FIB Levels
      ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clrBlack); // Set color
      ObjectSetInteger(chartID, objectName, OBJPROP_STYLE, STYLE_SOLID); // Set fill style
      ObjectSetInteger(chartID, objectName, OBJPROP_BACK, false); // Place in foreground
      ObjectSetInteger(0, objectName, OBJPROP_WIDTH, 1); // Border width
      
      // Set number of FIB Levels and their parameters
      
      int levels = 10;
      double values[] = {FIB_Level_TP, (1-FIB_Level_Hedge_TP), FIB_Level_Entry, (1-FIB_Level_SL), FIB_Level_Hedge_SL, (1-FIB_Level_Hedge_SL), FIB_Level_SL, (1.00-FIB_Level_Entry), FIB_Level_Hedge_TP, (1.00-FIB_Level_TP)};
      color color_levels[] = {clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack};
      ENUM_LINE_STYLE styles[] ={STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID};
      int widths[] = {1,1,1,1,1,1,1,1,1,1};
      
      
      //--- check array sizes 
      if(levels!=ArraySize(color_levels) || levels!=ArraySize(styles) || levels!=ArraySize(widths)){ 
         Print(__FUNCTION__,": array length does not correspond to the number of levels, error!"); 
      } 
      
      
      ObjectSetInteger(chartID, objectName, OBJPROP_LEVELS, levels); // Set Level color
      
      for(int i=0;i<levels;i++){ 
         //--- level value 
         ObjectSetDouble(chartID, objectName, OBJPROP_LEVELVALUE,i,values[i]); 
         //--- level color 
         ObjectSetInteger(chartID, objectName, OBJPROP_LEVELCOLOR,i,color_levels[i]); 
         //--- level style 
         ObjectSetInteger(chartID, objectName, OBJPROP_LEVELSTYLE,i,styles[i]); 
         //--- level width 
         ObjectSetInteger(chartID, objectName, OBJPROP_LEVELWIDTH,i,widths[i]); 
         //--- level description 
         ObjectSetString(chartID,objectName,OBJPROP_LEVELTEXT,i,DoubleToString(values[i],2)); 
     }   
         
   } //end of else
   
} // end of function



//FUNCTION:    Showing FIBONACCI RETRACEMENT LEVELS of the range
//-------------------------------------------------------------- 
void FIB_Levels_In_Range_Reversed() {

   datetime Current_time = TimeCurrent();
   datetime Start_time_range = Start_FIB_timerange;
   datetime End_time_range = End_FIB_timerange;
   
   if(Start_time_range > Current_time){
      long chartID = ChartID();
   }
   else{
      if(End_time_range >= Current_time){
         End_time_range = Current_time;
      }
      if(End_of_Day >= Current_time){
         End_of_Day = Current_time;
      }
      
      long chartID = ChartID();
      
      int Start_bars = iBarShift(_Symbol,PERIOD_CURRENT,Start_time_range,true);
      int End_bars = iBarShift(_Symbol,PERIOD_CURRENT,End_time_range,true);
      
      datetime Start_time_bars = iTime(_Symbol,PERIOD_CURRENT,Start_bars);
      datetime End_time_bars = iTime(_Symbol,PERIOD_CURRENT,End_bars);
      
      double PriceStart = iHigh(_Symbol,PERIOD_CURRENT,iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,Start_bars-(End_bars-1),End_bars+1));
      double PriceEnd = iLow(_Symbol,PERIOD_CURRENT,iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,Start_bars-(End_bars-1),End_bars+1));
   
      // Name for the FIB object
      string objectName = "FIB LEVELS REVERSED";
   
      // Check if object already exists, if so, delete it
      if(ObjectFind(0, objectName) != -1)
          ObjectDelete(0, objectName);
          
      // Create rectangle to highlight the session
      ObjectCreate(chartID, objectName, OBJ_FIBO,0 , Start_time_bars, PriceStart , End_of_Day, PriceEnd, clrBlack);
      
      
      // Set color and style of the FIB Levels
      ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clrBlack); // Set color
      ObjectSetInteger(chartID, objectName, OBJPROP_STYLE, STYLE_SOLID); // Set fill style
      ObjectSetInteger(chartID, objectName, OBJPROP_BACK, false); // Place in foreground
      ObjectSetInteger(0, objectName, OBJPROP_WIDTH, 1); // Border width
      
      // Set number of FIB Levels and their parameters
      
      int levels = 10;
      double values[] = {Reversed_FIB_Level_Hedge_TP, FIB_Level_TP, Reversed_FIB_Level_Hedge_SL, FIB_Level_Entry, FIB_Level_SL, (1-FIB_Level_SL), (1-FIB_Level_Entry), (1-Reversed_FIB_Level_Hedge_SL), (1-FIB_Level_TP), (1-Reversed_FIB_Level_Hedge_TP)};
      color color_levels[] = {clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack, clrBlack};
      ENUM_LINE_STYLE styles[] ={STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID, STYLE_SOLID};
      int widths[] = {1,1,1,1,1,1,1,1,1,1};
      
      
      //--- check array sizes 
      if(levels!=ArraySize(color_levels) || levels!=ArraySize(styles) || levels!=ArraySize(widths)){ 
         Print(__FUNCTION__,": array length does not correspond to the number of levels, error!"); 
      } 
      
      
      ObjectSetInteger(chartID, objectName, OBJPROP_LEVELS, levels); // Set Level color
      
      for(int i=0;i<levels;i++){ 
         //--- level value 
         ObjectSetDouble(chartID, objectName, OBJPROP_LEVELVALUE,i,values[i]); 
         //--- level color 
         ObjectSetInteger(chartID, objectName, OBJPROP_LEVELCOLOR,i,color_levels[i]); 
         //--- level style 
         ObjectSetInteger(chartID, objectName, OBJPROP_LEVELSTYLE,i,styles[i]); 
         //--- level width 
         ObjectSetInteger(chartID, objectName, OBJPROP_LEVELWIDTH,i,widths[i]); 
         //--- level description 
         ObjectSetString(chartID,objectName,OBJPROP_LEVELTEXT,i,DoubleToString(values[i],2)); 
     }   
         
   } //end of else
   
} // end of function


//+------------------------------------------------------------------+
//| Function to check if today is an excluded trading day            |
//+------------------------------------------------------------------+
bool CheckTradingDays()
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