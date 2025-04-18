
#include <MQL-REP\Inputs.mqh>



double FIB_Level_SL = FIB_Level_Entry - MathAbs(FIB_Level_TP - FIB_Level_Entry)*(1/RR);
double FIB_Level_Hedge_SL = FIB_Level_SL + MathAbs(FIB_Level_Hedge_TP - FIB_Level_SL)*(1/RR_Hedge);
double Reversed_FIB_Level_Hedge_SL = FIB_Level_TP - MathAbs(Reversed_FIB_Level_Hedge_TP - FIB_Level_TP)*(1/RR_Hedge);
double Reversed_FIB_Level_TP = FIB_Level_Entry - MathAbs(FIB_Level_TP - FIB_Level_Entry)*RR;
double Reversed_FIB_Level_SL = FIB_Level_TP;


datetime Start_FIB, End_FIB, Start_Order_timerange, End_Order_timerange, End_Day, Clear_Time;


struct FibLevels {
    double High_of_FIB_Range;
    double Low_of_FIB_Range;
    double Entry_BUY_STOP;
    double TP_BUY_STOP;
    double SL_BUY_STOP;
    double Entry_SELL_STOP;
    double TP_SELL_STOP;
    double SL_SELL_STOP;
    double TP_BUY_STOP_HEDGE;
    double SL_BUY_STOP_HEDGE;
    double TP_SELL_STOP_HEDGE;
    double SL_SELL_STOP_HEDGE;
    double Entry_SELL_LIMIT;
    double SL_SELL_LIMIT;
    double TP_SELL_LIMIT;
    double Entry_BUY_LIMIT;
    double SL_BUY_LIMIT;
    double TP_BUY_LIMIT;
    double TP_SELL_LIMIT_HEDGE;
    double SL_SELL_LIMIT_HEDGE;
    double TP_BUY_LIMIT_HEDGE;
    double SL_BUY_LIMIT_HEDGE;
};


FibLevels myLevels;


//if(End_FIB_timerange < TimeGMT() && End_FIB_timerange + 60 > TimeGMT()){
FibLevels F_CalculateFibLevels() {
    FibLevels levels;
    
    if(EntryMode == PIP_MODE){
    
      // CODE FOR PIP WITH THE SAME INPUTS FIB_Level_Entry, Fib_Level_TP, RR, FIB_Level_Hedge_TP, RR_Hedge
      // Only now those inputs are filled in with pip values instead of fib levels. 
      
       int Start_bars = iBarShift(_Symbol, PERIOD_CURRENT, Start_FIB, true);
       int End_bars = iBarShift(_Symbol, PERIOD_CURRENT, End_FIB, true);
   
       double PriceHigh = iHigh(_Symbol, PERIOD_CURRENT, iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, Start_bars - (End_bars - 1), End_bars + 1));
       double PriceLow = iLow(_Symbol, PERIOD_CURRENT, iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, Start_bars - (End_bars - 1), End_bars + 1));
       
      
       double pointSize = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
       int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
       double pip;
   
       switch (digits) {
           case 1:
               pip = pointSize * 1000;
               break;
           case 2:
               pip = pointSize * 100;
               break;
           case 3:
           case 4:
           case 5:
               pip = pointSize * 10;
               break;
           default:
               pip = pointSize;
       }
   
       double entryOffset = FIB_Level_Entry * pip;
       double tpOffset = FIB_Level_TP * pip;
       double slOffset = tpOffset / RR;
   
       double hedge_tp_offset = FIB_Level_Hedge_TP * pip;
       double hedge_sl_offset = hedge_tp_offset / RR_Hedge;
   
       double GlobalFibLevels[8];
       double GlobalFibLevelsHedge[4];
   
       if (Choose_Direction == Normal_Order) {
           // BUY_STOP above, SELL_STOP below
           GlobalFibLevels[0] = PriceHigh + entryOffset + tpOffset;     // TP_BUY_STOP
           GlobalFibLevels[1] = PriceHigh + entryOffset;                // Entry_BUY_STOP
           GlobalFibLevels[2] = PriceHigh;                              // High_of_FIB_Range
           GlobalFibLevels[3] = PriceLow - entryOffset + slOffset;     // SL_SELL_STOP
           GlobalFibLevels[4] = PriceHigh + entryOffset - slOffset;     // SL_BUY_STOP
           GlobalFibLevels[5] = PriceLow;                              // Low_of_FIB_Range
           GlobalFibLevels[6] = PriceLow - entryOffset;                // Entry_SELL_STOP
           GlobalFibLevels[7] = PriceLow - entryOffset - tpOffset;     // TP_SELL_STOP
   
           GlobalFibLevelsHedge[0] = GlobalFibLevels[4] - hedge_tp_offset;  // TP_BUY_STOP_HEDGE
           GlobalFibLevelsHedge[1] = GlobalFibLevels[3] - hedge_sl_offset;  // SL_SELL_STOP_HEDGE
           GlobalFibLevelsHedge[2] = GlobalFibLevels[4] + hedge_sl_offset;  // SL_BUY_STOP_HEDGE
           GlobalFibLevelsHedge[3] = GlobalFibLevels[3] + hedge_tp_offset;  // TP_SELL_STOP_HEDGE
   
           levels.High_of_FIB_Range       = NormalizeDouble(GlobalFibLevels[2],_Digits);
           levels.Low_of_FIB_Range        = NormalizeDouble(GlobalFibLevels[5],_Digits);
           levels.Entry_BUY_STOP          = NormalizeDouble(GlobalFibLevels[1],_Digits);
           levels.TP_BUY_STOP             = NormalizeDouble(GlobalFibLevels[0],_Digits);
           levels.SL_BUY_STOP             = NormalizeDouble(GlobalFibLevels[4],_Digits);
           levels.Entry_SELL_STOP         = NormalizeDouble(GlobalFibLevels[6],_Digits);
           levels.TP_SELL_STOP            = NormalizeDouble(GlobalFibLevels[7],_Digits);
           levels.SL_SELL_STOP            = NormalizeDouble(GlobalFibLevels[3],_Digits);
           levels.TP_BUY_STOP_HEDGE       = NormalizeDouble(GlobalFibLevelsHedge[0],_Digits);
           levels.SL_BUY_STOP_HEDGE       = NormalizeDouble(GlobalFibLevelsHedge[2],_Digits);
           levels.TP_SELL_STOP_HEDGE      = NormalizeDouble(GlobalFibLevelsHedge[3],_Digits);
           levels.SL_SELL_STOP_HEDGE      = NormalizeDouble(GlobalFibLevelsHedge[1],_Digits);
       }
       else if (Choose_Direction == Reversed_Order) {
           // SELL_LIMIT above, BUY_LIMIT below
           GlobalFibLevels[0] = PriceHigh + entryOffset + slOffset;     // SL_SELL_LIMIT
           GlobalFibLevels[1] = PriceHigh + entryOffset;                // Entry_SELL_LIMIT
           GlobalFibLevels[2] = PriceHigh;                              // High_of_FIB_Range
           GlobalFibLevels[3] = PriceHigh + entryOffset - tpOffset;     // TP_SELL_LIMIT
           GlobalFibLevels[4] = PriceLow - entryOffset + tpOffset;     // TP_BUY_LIMIT
           GlobalFibLevels[5] = PriceLow;                              // Low_of_FIB_Range
           GlobalFibLevels[6] = PriceLow - entryOffset;                // Entry_BUY_LIMIT
           GlobalFibLevels[7] = PriceLow - entryOffset - slOffset;     // SL_BUY_LIMIT
   
           GlobalFibLevelsHedge[0] = GlobalFibLevels[0] + hedge_tp_offset;  // TP_SELL_LIMIT_HEDGE
           GlobalFibLevelsHedge[1] = GlobalFibLevels[0] - hedge_sl_offset;  // SL_SELL_LIMIT_HEDGE
           GlobalFibLevelsHedge[2] = GlobalFibLevels[4] + hedge_sl_offset;  // SL_BUY_LIMIT_HEDGE
           GlobalFibLevelsHedge[3] = GlobalFibLevels[4] - hedge_tp_offset;  // TP_BUY_LIMIT_HEDGE
   
           levels.High_of_FIB_Range        = NormalizeDouble(GlobalFibLevels[2],_Digits);
           levels.Low_of_FIB_Range         = NormalizeDouble(GlobalFibLevels[5],_Digits);
           levels.Entry_SELL_LIMIT         = NormalizeDouble(GlobalFibLevels[1],_Digits);
           levels.SL_SELL_LIMIT            = NormalizeDouble(GlobalFibLevels[0],_Digits);
           levels.TP_SELL_LIMIT            = NormalizeDouble(GlobalFibLevels[3],_Digits);
           levels.Entry_BUY_LIMIT          = NormalizeDouble(GlobalFibLevels[6],_Digits);
           levels.SL_BUY_LIMIT             = NormalizeDouble(GlobalFibLevels[7],_Digits);
           levels.TP_BUY_LIMIT             = NormalizeDouble(GlobalFibLevels[4],_Digits);
           levels.TP_SELL_LIMIT_HEDGE      = NormalizeDouble(GlobalFibLevelsHedge[0],_Digits);
           levels.SL_SELL_LIMIT_HEDGE      = NormalizeDouble(GlobalFibLevelsHedge[1],_Digits);
           levels.TP_BUY_LIMIT_HEDGE       = NormalizeDouble(GlobalFibLevelsHedge[3],_Digits);
           levels.SL_BUY_LIMIT_HEDGE       = NormalizeDouble(GlobalFibLevelsHedge[2],_Digits);
       }
      
    }
    
    else if(EntryMode == FIB_MODE){
    
       double GlobalFibLevels[8];
       double GlobalFibLevelsHedge[4];
   
       int Start_bars = iBarShift(_Symbol, PERIOD_CURRENT, Start_FIB, true);
       int End_bars = iBarShift(_Symbol, PERIOD_CURRENT, End_FIB, true);
   
       double PriceStart = iHigh(_Symbol, PERIOD_CURRENT, iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, Start_bars - (End_bars - 1), End_bars + 1));
       double PriceEnd = iLow(_Symbol, PERIOD_CURRENT, iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, Start_bars - (End_bars - 1), End_bars + 1));
   
       double priceRange = PriceStart - PriceEnd;
   
       if (Choose_Direction == Normal_Order) {
           double fibLevels[] = {FIB_Level_TP, FIB_Level_Entry, 1.0, (1-FIB_Level_SL), FIB_Level_SL, 0.0, (1-FIB_Level_Entry), (1-FIB_Level_TP)};
           for (int i = 0; i < ArraySize(fibLevels); i++) {
               GlobalFibLevels[i] = PriceEnd + priceRange * fibLevels[i];
           }
   
           double fibLevels_hedge[] = {FIB_Level_Hedge_TP, (1-FIB_Level_Hedge_SL), FIB_Level_Hedge_SL, (1-FIB_Level_Hedge_TP)};
           for (int i = 0; i < ArraySize(fibLevels_hedge); i++) {
               GlobalFibLevelsHedge[i] = PriceEnd + priceRange * fibLevels_hedge[i];
           }
   
           levels.High_of_FIB_Range = NormalizeDouble(GlobalFibLevels[2],_Digits);
           levels.Low_of_FIB_Range = NormalizeDouble(GlobalFibLevels[5],_Digits);
           levels.Entry_BUY_STOP = NormalizeDouble(GlobalFibLevels[1],_Digits);
           levels.TP_BUY_STOP = NormalizeDouble(GlobalFibLevels[0],_Digits);
           levels.SL_BUY_STOP = NormalizeDouble(GlobalFibLevels[4],_Digits);
           levels.Entry_SELL_STOP = NormalizeDouble(GlobalFibLevels[6],_Digits);
           levels.TP_SELL_STOP = NormalizeDouble(GlobalFibLevels[7],_Digits);
           levels.SL_SELL_STOP = NormalizeDouble(GlobalFibLevels[3],_Digits);
           levels.TP_BUY_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[0],_Digits);
           levels.SL_BUY_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[2],_Digits);
           levels.TP_SELL_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[3],_Digits);
           levels.SL_SELL_STOP_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[1],_Digits);
       }
       else if (Choose_Direction == Reversed_Order) {
           double fibLevels[] = {Reversed_FIB_Level_SL, FIB_Level_Entry, 1.0, Reversed_FIB_Level_TP, (1-Reversed_FIB_Level_TP), 0.0, (1-FIB_Level_Entry), (1-Reversed_FIB_Level_SL)};
           for (int i = 0; i < ArraySize(fibLevels); i++) {
               GlobalFibLevels[i] = PriceEnd + priceRange * fibLevels[i];
           }
   
           double fibLevels_hedge[] = {Reversed_FIB_Level_Hedge_TP, Reversed_FIB_Level_Hedge_SL, (1-Reversed_FIB_Level_Hedge_SL), (1-Reversed_FIB_Level_Hedge_TP)};
           for (int i = 0; i < ArraySize(fibLevels_hedge); i++) {
               GlobalFibLevelsHedge[i] = PriceEnd + priceRange * fibLevels_hedge[i];
           }
   
           levels.High_of_FIB_Range = NormalizeDouble(GlobalFibLevels[2],_Digits);
           levels.Low_of_FIB_Range = NormalizeDouble(GlobalFibLevels[5],_Digits);
           levels.Entry_SELL_LIMIT = NormalizeDouble(GlobalFibLevels[1],_Digits);
           levels.SL_SELL_LIMIT = NormalizeDouble(GlobalFibLevels[0],_Digits);
           levels.TP_SELL_LIMIT = NormalizeDouble(GlobalFibLevels[3],_Digits);
           levels.Entry_BUY_LIMIT = NormalizeDouble(GlobalFibLevels[6],_Digits);
           levels.SL_BUY_LIMIT = NormalizeDouble(GlobalFibLevels[7],_Digits);
           levels.TP_BUY_LIMIT = NormalizeDouble(GlobalFibLevels[4],_Digits);
           levels.TP_SELL_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[0],_Digits);
           levels.SL_SELL_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[1],_Digits);
           levels.TP_BUY_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[3],_Digits);
           levels.SL_BUY_LIMIT_HEDGE = NormalizeDouble(GlobalFibLevelsHedge[2],_Digits);
       }
    }

    return levels;
}