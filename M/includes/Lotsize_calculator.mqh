#include <MQL-REP\Inputs.mqh>



// | POSITION SIZE CALCULATOR NUMBER 1: Lot size calculator for risking a value
//-----------------------------------------------------------------------------

double F_positionsize_value(double openPrice, double slPrice, double risk_value_f){
   
   //Creating variables:
   double size=0; //lotsize you want to determine
   double distance=0; //distance between openPrice en slPrice 
   double stopValue=0; 
   double tickValue= SymbolInfoDouble(gSymbol,SYMBOL_TRADE_TICK_VALUE); //Based on 1 Lot Size
   double tickSize= SymbolInfoDouble(gSymbol,SYMBOL_TRADE_TICK_SIZE);
   double VolumeStep = SymbolInfoDouble(gSymbol,SYMBOL_VOLUME_STEP);
   
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
   size = MathMax( VolumeStep , size); //To make sure every position gets opened with at least the minimum lot size of 0.01
   size = (int)(size / VolumeStep) * VolumeStep; //To get the least possible volume (lots) step
   
   double lots = NormalizeDouble(size, CountDecimals(VolumeStep));
   
   //returning lots
   return lots;
    
}



// | POSITION SIZE CALCULATOR NUMBER 2: Lot size calculator for risking a percentage
//----------------------------------------------------------------------------------

double F_positionsize_percentage(double openPrice, double slPrice, double risk_percentage_f){
   
   //Creating variables:
   double size=0; //lotsize you want to determine
   double distance=0; //distance between openPrice en slPrice 
   double stopValue=0; 
   double tickValue= SymbolInfoDouble(gSymbol,SYMBOL_TRADE_TICK_VALUE); //Based on 1 Lot Size
   double tickSize= SymbolInfoDouble(gSymbol,SYMBOL_TRADE_TICK_SIZE);
   double VolumeStep = SymbolInfoDouble(gSymbol,SYMBOL_VOLUME_STEP);
   
   //calculate distance:
   distance = openPrice - slPrice;
   if(distance<0){
      distance /= -1; // a/=b same as a = a / b
   }
   
   //calculate SL value for 1 lot
   stopValue = distance/tickSize;
   stopValue *= tickValue;
   
   //calculating risk percentage
   //risk_percentage_f /= 100;
   risk_percentage_f *= AccountInfoDouble(ACCOUNT_BALANCE);
   
   //calculate max. size value
   size=risk_percentage_f / stopValue;
   
   //round size value
   size *= 100;
   size = MathFloor(size);
   size /= 100;
   size = MathMax(VolumeStep, size); //To make sure every position gets opened with at least the minimum lot size of 0.01
   size = (int)(size / VolumeStep) * VolumeStep; //To get the least possible volume (lots) step
   
   double lots = NormalizeDouble(size, CountDecimals(VolumeStep));
   
   //returning lots
   return lots;
     
}


// Function to calculate lot size based on risk type
double F_calculateLotSize(double entryPrice, double stopLossPrice) {
    double lotSize = 0.0;   

    switch(Risk_Type) {
        case Option1:
            lotSize = F_positionsize_value(entryPrice, stopLossPrice, Risk);
            break;
        case Option2:
            lotSize = F_positionsize_percentage(entryPrice, stopLossPrice, Risk);
            break;
    }

    return lotSize;
}



int CountDecimals(double number) {
    string numStr = DoubleToString(number, 16);  // Convert number to string with maximum precision
    int pointPos = StringFind(numStr, ".");      // Find position of the decimal point
    if (pointPos < 0) return 0;                  // No decimal point found
    
    // Count the number of digits after the decimal point
    return StringLen(numStr) - pointPos - 1;
}