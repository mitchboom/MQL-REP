#include <MQL-REP\Inputs.mqh>


//#property indicator_chart_window
//#property indicator_buffers 2 // Assuming 2 buffers for 2 EMAs
//#property indicator_plots 2   // 2 plots for 2 EMAs
//+------------------------------------------------------------------+
//| Ema alginment check                     
//+------------------------------------------------------------------+
int EmaCondition()
{
    if(inpEmaDirection != EMA_OFF){
       if(ArraySize(MaFast) < 2 || ArraySize(MaSlow) < 2) {
           Print("EMA arrays do not have enough data.");
           return 0; // Not enough data
       }
    }

    if (inpEmaMode == EMA_TWO_LINE){
    
       switch(inpEmaDirection) {
           case EMA_WITH_TREND:
               // Check alignment with the trend
               if (MaFast[1] > MaSlow[1]) return 1; // Bullish trend, Buy
               if (MaFast[1] < MaSlow[1]) return -1; // Bearish trend, Sell
               break;
   
           case EMA_AGAINST_TREND:
               // Check alignment against the trend
               if (MaFast[1] < MaSlow[1]) return 1; // Bearish trend, Buy
               if (MaFast[1] > MaSlow[1]) return -1; // Bullish trend, Sell
               break;
   
           case EMA_OFF:
               // Do not use EMA for trend decision
               return 0; // Neutral condition as EMA checks are off
         }
      }  
      else if (inpEmaMode == EMA_ONE_LINE){
    
      double currentAskPrice = SymbolInfoDouble(gSymbol, SYMBOL_ASK);
      double currentBidPrice = SymbolInfoDouble(gSymbol, SYMBOL_BID);
    
         switch (inpEmaDirection){
            case EMA_WITH_TREND:
                if (currentAskPrice > MaFast[1]) return 1;        // Buy
                if (currentBidPrice < MaFast[1]) return -1;       // Sell
                break;
         
            case EMA_AGAINST_TREND:
                if (currentAskPrice < MaFast[1]) return 1;        // Buy
                if (currentBidPrice > MaFast[1]) return -1;       // Sell
                break;
                
            case EMA_OFF:
               // Do not use EMA for trend decision
               return 0; // Neutral condition as EMA checks are off
         }
      }


    return 0; // Default return for no clear trend or off state
}