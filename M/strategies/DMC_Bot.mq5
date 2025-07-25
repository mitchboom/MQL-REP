//+------------------------------------------------------------------+
//|                            Strategy time range BO FIB levels.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, DMC GROUP"
#property link      "https://www.mql5.com"
#property version   "1.00"


#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>

#include <MQL-REP\Inputs.mqh>
#include <MQL-REP\Chart_objects.mqh>
#include <MQL-REP\FIB_level_calculation.mqh>
#include <MQL-REP\Lotsize_calculator.mqh>
#include <MQL-REP\Market_Excecutions_Ctrade.mqh>
#include <MQL-REP\trading_check.mqh>
#include <MQL-REP\trading_manage.mqh>
#include <MQL-REP\EMA_condition.mqh>


//+------------------------------------------------------------------+
//| Global or static variables                                       |
//+------------------------------------------------------------------+
bool InOrderRange = false;
bool InTradeRange = false;
bool InPipRange = false;
bool NormalOrder;

string Start_Fibonacci_Timerange;
string End_Fibonacci_Timerange;
string End_Trade_Order_Timerange;
string End_Of_Trading_Day;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   
// Skip license check in strategy tester
   if (MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_VISUAL_MODE)) {
      //checking the license by initializing the expert advisor
      static bool isInit = false;
      if(!isInit){
         isInit = true;
         
         //check if user is allowed to use the program
         long Customer1 = 7478389; //Mitch STRATO Basis VPS
         long Customer2 = 662474; //Mitch Backtest server STRATO VC80
         long Customer3 = 658262; //Mitch VPS Goud server
         long Customer4 = 51738747; //Mitch Backtest server 48 core
         
         long Customer5 = 660175; //Dave Lenovo laptop
         long Customer6 = 660248; //Dave server
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
   }
   else {
      string url = "https://mt5-license-api.onrender.com/validate";
      string headers = "Content-Type: application/x-www-form-urlencoded\r\n";

      string postData = "account_no=" + IntegerToString((int)AccountInfoInteger(ACCOUNT_LOGIN));
      char post[];
      StringToCharArray(postData, post, 0, WHOLE_ARRAY, CP_UTF8);

      char result[];
      string resultHeaders;
      int timeout = 5000;

      int response = WebRequest("POST", url, headers, timeout, post, result, resultHeaders);

      if(response == -1) {
         Print("License check failed. Error: ", GetLastError());
         Alert("Connection to license server failed.");
         return INIT_FAILED;
      }

      string resultText = CharArrayToString(result);
      Print("License Server Response: ", resultText);

      if(resultText != "success") {
         Alert("❌ Invalid license for this account. Try Again 3 times");
         ExpertRemove();
         return INIT_FAILED;
      }

      Alert("✅ License verified. Welcome!");
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
   
  
     
   //+------------------------------------------------------------------+
   //| Timestemps                                                       |
   //+------------------------------------------------------------------+
   switch (Time_Interval)
   {
      case INTERVAL_30_MIN:
         Start_Fibonacci_Timerange      = TimeEnumToString(Start_Fibonacci_Timerange_30);
         End_Fibonacci_Timerange        = TimeEnumToString(End_Fibonacci_Timerange_30);
         End_Trade_Order_Timerange      = TimeEnumToString(End_Trade_Order_Timerange_30);
         End_Of_Trading_Day             = TimeEnumToString(End_Of_Trading_Day_30);
         break;
   
      case INTERVAL_5_MIN:
         Start_Fibonacci_Timerange      = TimeEnumToString5(Start_Fibonacci_Timerange_5);
         End_Fibonacci_Timerange        = TimeEnumToString5(End_Fibonacci_Timerange_5);
         End_Trade_Order_Timerange      = TimeEnumToString5(End_Trade_Order_Timerange_5);
         End_Of_Trading_Day             = TimeEnumToString5(End_Of_Trading_Day_5);
         break;
   }
   
   // Calculate the delay until the target time  
   datetime Clear_End_Day = StringToTime(End_Of_Trading_Day); 
   datetime currentTime = TimeGMT();
   long delay = Clear_End_Day - currentTime;
   
   // Set the timer to trigger at the target time
   EventSetTimer(int(delay));


   NormalOrder = (Choose_Direction == Normal_Order) ? true : false;  
   
   
   
   
   
   //+------------------------------------------------------------------+
   //| Indicators                                                       |
   //+------------------------------------------------------------------+
   
   // Ema settings
   if (inpEmaDirection != EMA_OFF){
      emaHandleFast = iMA(gSymbol, (ENUM_TIMEFRAMES)inpEmaTimeFrame, inpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
      emaHandleSlow = iMA(gSymbol, (ENUM_TIMEFRAMES)inpEmaTimeFrame, inpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
      ArraySetAsSeries(MaFast, true);
      ArraySetAsSeries(MaSlow, true);
      
      if (emaHandleFast < 0 || emaHandleSlow < 0) {
         Print("Error: EMA Handles smaller than zero, Error code: ", GetLastError());
         return INIT_FAILED;
      } 
   }

   
   return(INIT_SUCCEEDED);
}




//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   // Code to execute at the end of the trading day
   buyTriggeredToday = false;
   sellTriggeredToday = false;
   hedgeTriggered = false;
   activateHedge = false;
   
   tpbuyHit = false;
   tpsellHit = false; 
   
   buyInvalid = false;
   sellInvalid = false;
   
    // Close positions for this magic number
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == gSymbol &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            ulong ticket = PositionGetInteger(POSITION_TICKET);
            trade.PositionClose(ticket);
        }
    }   

   // Reset the timer to trigger again in 24 hours
   EventSetTimer(86400); // 86400 seconds in a day
}

  
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){

   ObjectsDeleteAll(0);
   
   // Kill the timer when the EA is removed or stopped
   EventKillTimer();
   
}
  



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
double OnTester(){

   double customCriteria = (TesterStatistics(STAT_TRADES)-TesterStatistics(STAT_LOSS_TRADES)) / TesterStatistics(STAT_TRADES) ;
   
   return customCriteria;
 }


  
   
//+------------------------------------------------------------------+
//| Expert tick function                                            |
//+------------------------------------------------------------------+
void OnTick(){

   datetime CurrentTime = TimeGMT();  

   if(F_CheckTradingDays()){
   
      if (F_IsNewBar()) {
      
         F_UpdateIndicators();      
         Draw_EMA_Visuals();

      
         End_FIB = StringToTime(End_Fibonacci_Timerange);
         
                           
         if(CurrentTime >= End_FIB && CurrentTime < End_FIB + 60){
         
            Start_FIB = StringToTime(Start_Fibonacci_Timerange);
            Start_Order_timerange = End_FIB;
            End_Order_timerange = StringToTime(End_Trade_Order_Timerange);
            Clear_Time = StringToTime(End_Of_Trading_Day);
            End_Day = StringToTime(End_Of_Trading_Day);
         
            myLevels = F_CalculateFibLevels();
            
            InPipRange = (F_in_pip_range()) ? true : false;  
   
            
            if(inpVisualMode == YES){
               FIB_Range_Rectangle();      
               if(NormalOrder){
                  FIB_Levels_In_Range();
               } else if(!NormalOrder){
                  FIB_Levels_In_Range_Reversed();
               }
            }
            
         }
         
      } // END F_IsNewBar
   
      InOrderRange = (F_time_in_order_range()) ? true : false;
      InTradeRange = (F_time_in_trade_range()) ? true : false;
      
      if (InPipRange){
      
         if (InOrderRange){
         
            if (NormalOrder){
            
               if (F_CheckBuyConditions()){                 

                  lotsize = F_calculateLotSize(myLevels.Entry_BUY_STOP, myLevels.SL_BUY_STOP);
                  Execute_BUY(lotsize, myLevels.SL_BUY_STOP, myLevels.TP_BUY_STOP);
               }
               
               else if (F_CheckSellConditions()){               

                  lotsize = F_calculateLotSize(myLevels.Entry_SELL_STOP, myLevels.SL_SELL_STOP);
                  Execute_SELL(lotsize, myLevels.SL_SELL_STOP, myLevels.TP_SELL_STOP);      
               }         
      
            }
            else if (!NormalOrder){
            
               if (F_CheckBuyLimitConditions()){                 

                  lotsize = F_calculateLotSize(myLevels.Entry_BUY_LIMIT, myLevels.SL_BUY_LIMIT);
                  Execute_BUY(lotsize, myLevels.SL_BUY_LIMIT, myLevels.TP_BUY_LIMIT);
               }
               
               else if (F_CheckSellLimitConditions()){               

                  lotsize = F_calculateLotSize(myLevels.Entry_SELL_LIMIT, myLevels.SL_SELL_LIMIT);
                  Execute_SELL(lotsize, myLevels.SL_SELL_LIMIT, myLevels.TP_SELL_LIMIT);      
               }                
      
            }
            
         } // End InOrderRange
         
         
         if (InTradeRange && Choose_Hedge == Hedge_Yes){
         
            if (NormalOrder){           
            
               if (buyTriggeredToday && F_CheckHedgeSell()){
               
                  lotsize = F_calculateLotSize(myLevels.SL_BUY_STOP, myLevels.SL_BUY_STOP_HEDGE);
                  Execute_SELL(Hedge_Multiplier * lotsize, myLevels.SL_BUY_STOP_HEDGE, myLevels.TP_BUY_STOP_HEDGE);
               }
               
               else if (sellTriggeredToday && F_CheckHedgeBuy()){      

                  lotsize = F_calculateLotSize(myLevels.SL_SELL_STOP, myLevels.SL_SELL_STOP_HEDGE);
                  Execute_BUY(Hedge_Multiplier * lotsize, myLevels.SL_SELL_STOP_HEDGE, myLevels.TP_SELL_STOP_HEDGE);   
               }         
      
            }
            else if (!NormalOrder){

               if (buyTriggeredToday && F_CheckHedgeSellReversed()){
               
                  lotsize = F_calculateLotSize(myLevels.SL_BUY_LIMIT, myLevels.SL_BUY_LIMIT_HEDGE);
                  Execute_SELL(Hedge_Multiplier * lotsize, myLevels.SL_BUY_LIMIT_HEDGE, myLevels.TP_BUY_LIMIT_HEDGE);
               }
               
               else if (sellTriggeredToday && F_CheckHedgeBuyReversed()){      

                  lotsize = F_calculateLotSize(myLevels.SL_SELL_LIMIT, myLevels.SL_SELL_LIMIT_HEDGE);
                  Execute_BUY(Hedge_Multiplier * lotsize, myLevels.SL_SELL_LIMIT_HEDGE, myLevels.TP_SELL_LIMIT_HEDGE);   
               }   
      
            }      
         
         } // End 
         
      } // End InPipRange

   } // End F_CheckTradingDays


} // END OF ON TICK



//+------------------------------------------------------------------+
//| Function to check if a new bar has been formed                   |
//+------------------------------------------------------------------+
bool F_IsNewBar() {
    static ulong lastBar = 0; // Keep track of the last bar index
    ulong currentBars = Bars(gSymbol, PERIOD_M1); // Get current bar count

    // Check if the current bar count is different from the last recorded bar count
    if (lastBar != currentBars) {
        lastBar = currentBars; // Update the last bar count to the current
        return true; // New bar detected
    }

    return false; // No new bar
}



void F_UpdateIndicators(){

   int fastMinBars = inpEmaFast * 3;  // Example EMA period
   int slowMinBars = inpEmaSlow * 3;  // Example EMA period

   // EMA
   if (inpEmaDirection != EMA_OFF){
      if (
      CopyBuffer(emaHandleFast, 0, 0, fastMinBars, MaFast)         < 0     ||
      CopyBuffer(emaHandleSlow, 0, 0, slowMinBars, MaSlow)         < 0     )
      {
      Alert("Error copying the EMA's to buffers - Error", GetLastError(), "!");
      }
   }

}




void Draw_EMA_Visuals()
{
    if (inpEmaDirection == EMA_OFF || inpVisualMode != YES)
        return;

    if (!(MQLInfoInteger(MQL_VISUAL_MODE) || !MQLInfoInteger(MQL_TESTER)))
        return;

    ENUM_TIMEFRAMES tf = (ENUM_TIMEFRAMES)inpEmaTimeFrame;
    datetime time1 = iTime(gSymbol, tf, 1);
    datetime time0 = iTime(gSymbol, tf, 0);

    if (ArraySize(MaFast) < 2 || (inpEmaMode == EMA_TWO_LINE && ArraySize(MaSlow) < 2))
        return;

    long chartID = ChartID();

    // === FAST EMA ===
    string fastLabel = "EMA_FAST";
    ObjectDelete(chartID, fastLabel);  // Ensure it's clean
    ObjectCreate(chartID, fastLabel, OBJ_TREND, 0, time1, MaFast[1], time0, MaFast[0]);
    ObjectSetInteger(chartID, fastLabel, OBJPROP_COLOR, clrGreen);
    ObjectSetInteger(chartID, fastLabel, OBJPROP_WIDTH, 2);
    ObjectSetInteger(chartID, fastLabel, OBJPROP_RAY_RIGHT, false);

    // === SLOW EMA ===
    string slowLabel = "EMA_SLOW";
    ObjectDelete(chartID, slowLabel);
    if (inpEmaMode == EMA_TWO_LINE) {
        ObjectCreate(chartID, slowLabel, OBJ_TREND, 0, time1, MaSlow[1], time0, MaSlow[0]);
        ObjectSetInteger(chartID, slowLabel, OBJPROP_COLOR, clrRed);
        ObjectSetInteger(chartID, slowLabel, OBJPROP_WIDTH, 2);
        ObjectSetInteger(chartID, slowLabel, OBJPROP_RAY_RIGHT, false);
    }
}


