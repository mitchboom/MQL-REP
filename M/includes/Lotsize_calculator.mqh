#include <MQL-REP\Inputs.mqh>



// | POSITION SIZE CALCULATOR NUMBER 1: Lot size calculator for risking a value
//-----------------------------------------------------------------------------

double F_positionsize_value(double openPrice, double slPrice, double risk_value_f){
   
   //Creating variables:
   double size=0; //lotsize you want to determine
   double distance=0; //distance between openPrice en slPrice 
   double stopValue=0; 
   double tickValue= SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE); //Based on 1 Lot Size
   double tickSize= SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   
   //calculate distance:
   distance = openPrice - slPrice;
   if(distance<0){
      distance /= -1; // a/=b same as a = a / b
   }
   
   //calculate SL value for 1 lot
   stopValue = distance/tickSize;
   stopValue *= tickValue;
   
   //calculate max. size value
   size=risk_value_f / stopValue;
   
   //round size value
   size *= 100;
   size = MathFloor(size);
   size /= 100;
   size = MathMax(0.01, size); //To make sure every position gets opened with at least the minimum lot size of 0.01
   
   //returning size
   return size;
    
}



// | POSITION SIZE CALCULATOR NUMBER 2: Lot size calculator for risking a percentage
//----------------------------------------------------------------------------------

double F_positionsize_percentage(double openPrice, double slPrice, double risk_percentage_f){
   
   //Creating variables:
   double size=0; //lotsize you want to determine
   double distance=0; //distance between openPrice en slPrice 
   double stopValue=0; 
   double tickValue= SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE); //Based on 1 Lot Size
   double tickSize= SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   
   //calculate distance:
   distance = openPrice - slPrice;
   if(distance<0){
      distance /= -1; // a/=b same as a = a / b
   }
   
   //calculate SL value for 1 lot
   stopValue = distance/tickSize;
   stopValue *= tickValue;
   
   //calculating risk percentage
   risk_percentage_f /= 100;
   risk_percentage_f *= AccountInfoDouble(ACCOUNT_BALANCE);
   
   //calculate max. size value
   size=risk_percentage_f / stopValue;
   
   //round size value
   size *= 100;
   size = MathFloor(size);
   size /= 100;
   size = MathMax(0.01, size); //To make sure every position gets opened with at least the minimum lot size of 0.01
   
   //returning size
   return size;
     
}


// Function to calculate lot size based on risk type
double F_calculateLotSize(double entryPrice, double stopLossPrice, double risk, double riskPercentage, int riskType) {
    double lotSize = 0.0;

    switch(riskType) {
        case Option1:
            lotSize = F_positionsize_value(entryPrice, stopLossPrice, risk);
            break;
        case Option2:
            lotSize = F_positionsize_percentage(entryPrice, stopLossPrice, riskPercentage);
            break;
    }

    return lotSize;
}
