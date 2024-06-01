//+------------------------------------------------------------------+
//|                                           Lotsize_calculator.mqh |
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



// | POSITION SIZE CALCULATOR NUMBER 1: Lot size calculator for risking a value
//-----------------------------------------------------------------------------
/*
double Positionsize_value(double openPrice, double slPrice, double risk_value_f){
   
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
*/

double Positionsize_value(double openPrice, double slPrice, double risk_value_f){
   
   //Calculate the distance between the open price and stop loss price in pips
   double distance = MathAbs(openPrice - slPrice);

   // Retrieve the tick size and tick value
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);

   // Calculate the number of ticks between the open price and stop loss price
   double ticks = distance / tickSize;

   // Calculate the stop loss value in the quote currency
   double stopLossValueQuote = ticks * tickValue;

   // Adjust the risk value and stop loss value to the account currency if needed
   double accountCurrencyStopLossValue = ConvertToAccountCurrency(stopLossValueQuote);

   // Calculate the lot size based on the risk value and the adjusted stop loss value
   double size = risk_value_f / accountCurrencyStopLossValue;

   // Ensure minimum lot size and rounding to two decimal places
   size = MathRound(size * 100) / 100;
   size = MathMax(0.01, size);  // Ensure a minimum lot size of 0.01

   return size;
}

// Helper function to convert the stop loss value from the quote currency to the account currency
double ConvertToAccountCurrency(double stopLossValueQuote) {
    // Detect the base and quote currencies from the symbol
    string baseCurrency = StringSubstr(_Symbol, 0, 3);
    string quoteCurrency = StringSubstr(_Symbol, 3, 3);

    // Determine the conversion rate
    double conversionRate = 1.0;
    if (quoteCurrency != AccountInfoString(ACCOUNT_CURRENCY)) {
        string pair = AccountInfoString(ACCOUNT_CURRENCY) + quoteCurrency;
        if (SymbolInfoDouble(pair, SYMBOL_BID) > 0) {
            conversionRate = SymbolInfoDouble(pair, SYMBOL_BID);
        } else {  // If direct rate is not available, check the inverse rate
            pair = quoteCurrency + AccountInfoString(ACCOUNT_CURRENCY);
            if (SymbolInfoDouble(pair, SYMBOL_BID) > 0) {
                conversionRate = 1.0 / SymbolInfoDouble(pair, SYMBOL_BID);
            } else {
                Print("Error: Currency conversion rate not found.");
                return -1;  // Error code
            }
        }
    }

    // Calculate and return the stop loss value in the account currency
    return stopLossValueQuote * conversionRate;
}


double Positionsize_percentage(double openPrice, double slPrice, double risk_percentage_f){
   
   // Calculate the distance between the open price and stop loss price in pips
   double distance = MathAbs(openPrice - slPrice);

   // Retrieve the tick size and tick value
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);

   // Calculate the number of ticks between the open price and stop loss price
   double ticks = distance / tickSize;

   // Calculate the stop loss value in the quote currency for 1 lot
   double stopLossValueQuote = ticks * tickValue;

   // Adjust the risk value to the account currency if needed
   double accountCurrencyStopLossValue = ConvertToAccountCurrency(stopLossValueQuote);

   // Calculating the risk percentage of the account balance
   double risk_amount = risk_percentage_f / 100 * AccountInfoDouble(ACCOUNT_BALANCE);

   // Calculate the lot size based on the risk amount and the adjusted stop loss value
   double size = risk_amount / accountCurrencyStopLossValue;

   // Ensure minimum lot size and rounding to two decimal places
   size = MathRound(size * 100) / 100;
   size = MathMax(0.01, size);  // Ensure a minimum lot size of 0.01

   return size;
}


// | POSITION SIZE CALCULATOR NUMBER 2: Lot size calculator for risking a percentage
//----------------------------------------------------------------------------------
/*
double Positionsize_percentage(double openPrice, double slPrice, double risk_percentage_f){
   
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
*/

