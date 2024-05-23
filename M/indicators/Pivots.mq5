//+------------------------------------------------------------------+
//|                                                      Swings.mq5 |
//|                                      Rajesh Nait, Copyright 2023 |
//|                  https://www.mql5.com/en/users/rajeshnait/seller |
//+------------------------------------------------------------------+
#property copyright "Ocean Sunboy, Copyright 2024"
#property link      "https://www.mql5.com/en/users/rajeshnait/seller"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2

//--- plot Bullish Marubozu
#property indicator_label1  "+S"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrBlueViolet
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Bearish Marubozu
#property indicator_label2  "-S"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrBlueViolet
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1 

//--- input parameters

uchar               InpSwingLowCode              = 233;         // Swing Low: code for style DRAW_ARROW (font Wingdings)
int                 InpSwingLowShift             = 10;          // Swing Low: vertical shift of arrows in pixels
uchar               InpSwingHighCode             = 234;         // SwingHigh: code for style DRAW_ARROW (font Wingdings)
int                 InpSwingHighShift            = 10;          // SwingHigh: vertical shift of arrows in pixels

//--- indicator buffers
double   SwingLowBuffer[];
double   SwingHighBuffer[];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
//--- indicator buffers mapping
//--- indicator buffers mapping
   SetIndexBuffer(0,SwingLowBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,SwingHighBuffer,INDICATOR_DATA);

   IndicatorSetInteger(INDICATOR_DIGITS,Digits());
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,InpSwingLowCode);
   PlotIndexSetInteger(1,PLOT_ARROW,InpSwingHighCode);
//--- set the vertical shift of arrows in pixels
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,InpSwingLowShift);
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,-InpSwingHighShift);
//--- set as an empty value 0.0
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
//---
   return(INIT_SUCCEEDED);
}



//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

// Input parameters for lookback periods
input int      SwingHighLookBack                = 15;       // Lookback period for swing highs
input int      SwingLowLookBack                 = 15;       // Lookback period for swing lows

//Input for ATR
input int      ATRPeriod                        = 14;       // The period over which to calculate the ATR

// Input tresholds
input double   inpPriceChangeTreshold           = 0;        // Minimium price change in lookback period (pips) Doet eigenlijk helemaal niks daarom op 0 gezet. Bij 1 pip krijg je geen pivot points
input double   inpHighLowDistanceThreshold      = 10;        // Minimium distance between high and low (pips)
input double   inpVolatilityThreshold           = 10;       // Minimum volatility between the lookback period (pips)

// Input for price action movements
input double   SharpMovementMultiplier          = 1.0;      // Multiplier for sharp price movement
input int      WicksLookBack                    = 5;        // Number of candles to check for wicks


// Define a threshold for significant price change
const double PriceChangeThreshold = inpPriceChangeTreshold * _Point * 10; // Example: 10 pips for a 5-digit broker

int lastSwingHighIndex = -SwingHighLookBack;
int lastSwingLowIndex = -SwingLowLookBack;

double HighLowDistanceThreshold = inpHighLowDistanceThreshold * _Point * 10;
double VolatilityThreshold = inpVolatilityThreshold * _Point * 10;






//+------------------------------------------------------------------+
//| Start the Calculation (STEP 1)                                   |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
                
    // Initialization and validation
    if (rates_total < MathMax(SwingHighLookBack, SwingLowLookBack) + 1)
        return 0;

    int limit = prev_calculated > 1 ? prev_calculated - 1 : MathMax(SwingHighLookBack, SwingLowLookBack);

    // Find the most recent low and high before the limit
    double lastLow = DBL_MAX;
    double lastHigh = 0;
    for (int i = 0; i < limit; ++i) {
        if (low[i] < lastLow) lastLow = low[i];
        if (high[i] > lastHigh) lastHigh = high[i];
    }



   // Main calculation loop (STEP 2)
   for (int i = limit; i < rates_total; ++i) {
      SwingHighBuffer[i] = EMPTY_VALUE;
      SwingLowBuffer[i] = EMPTY_VALUE;
      
      
      
      // Calculating the Volatility
      double maxRange = 0.0;
      // Calculate the maximum range within the lookback period
      for (int j = 1; j <= MathMax(SwingHighLookBack, SwingLowLookBack); ++j){
      
         int adjustedIndex = i - j - 1 >= 0 ? i - j - 1 : 0;               // Adjust index to prevent going beyond the start of the data
         double range = MathAbs(high[adjustedIndex] - low[adjustedIndex]);
         maxRange += range;
      }
      
      
      
      // Volatility check starts here (STEP 3)
      if (maxRange > VolatilityThreshold) {                                // Only checks for pivots points if the volatility is higher than the treshold
      
      
         // CHECK 1: Engulfing patterns (STEP 3A)
         
         //Determine the highest high and lowest low in the lookback period
         double highestHigh = 0.0;
         double lowestLow = DBL_MAX;
         for (int j = 1; j <= SwingHighLookBack; ++j) {
           int index = i - j;
           if (index < 0) continue; // Prevent indexing before the start of the array
           if (high[index] > highestHigh) highestHigh = high[index];
           if (low[index] < lowestLow) lowestLow = low[index];
         }
         
         // Check for Bullish Engulfing pattern as a potential pivot low
         if (i > 0 && low[i] == lowestLow && // Check if it's the lowest in the lookback period
            close[i] > open[i] && close[i - 1] < open[i - 1] &&
            close[i] > open[i - 1] && open[i] < close[i - 1] &&
            MathAbs(close[i] - open[i]) > MathAbs(close[i - 1] - open[i - 1])) {
            // A bullish engulfing pattern is found at a pivot low
            SwingLowBuffer[i] = low[i];
            lastLow = low[i];
            lastSwingLowIndex = i;   
         }
         
         // Check for Bearish Engulfing pattern as a potential pivot high
         if (i > 0 && high[i] == highestHigh && // Check if it's the highest in the lookback period
            close[i] < open[i] && close[i - 1] > open[i - 1] &&
            open[i] > close[i - 1] && close[i] < open[i - 1] &&
            MathAbs(open[i] - close[i]) > MathAbs(open[i - 1] - close[i - 1])) {
            // A bearish engulfing pattern is found at a pivot high
            SwingHighBuffer[i] = high[i];
            lastHigh = high[i];
            lastSwingHighIndex = i;
         }
         
         // END OF CHECK 1: Engulfing patterns (STEP 3A)
         
         
         
         // CHECK 2: Sharp price action (STEP 3B)
         
         // Price action check for sharp movements and wicks
         double averageRange = 0;
         double totalVolatility = 0.0;
         for (int j = 1; j <= SwingHighLookBack; ++j) {
            int adjustedIndex = i - j;
            if (adjustedIndex < 0) adjustedIndex = 0;
            double range = high[adjustedIndex] - low[adjustedIndex];
            averageRange += range;
            totalVolatility += MathAbs(close[adjustedIndex] - open[adjustedIndex]);
         }
         averageRange /= SwingHighLookBack;
         
         // Check for wicks and pullback
         int wicksCount = 0;
         for (int k = i - WicksLookBack; k < i; ++k) {
            int adjustedIndex = k >= 0 ? k : 0;
            double wickSize = MathMax(high[adjustedIndex] - MathMax(open[adjustedIndex], close[adjustedIndex]), MathMin(open[adjustedIndex], close[adjustedIndex]) - low[adjustedIndex]);
            if (wickSize > averageRange * SharpMovementMultiplier) {
                wicksCount++;
            }
         }
         
         if (wicksCount >= WicksLookBack - 1) { // Allow one candle not to have a large wick
            // A pullback is detected, potentially a pivot point
            // Handling wicks and pullback for pivot points
            if (wicksCount >= WicksLookBack - 1) {
               // Check for a pullback indicating a pivot point
               if ((close[i] > open[i] && close[i - 1] < open[i - 1]) || // Bullish pullback
                  (close[i] < open[i] && close[i - 1] > open[i - 1])) { // Bearish pullback
                  // If there's a bullish pullback, mark as potential bullish pivot point
                  if (close[i] > open[i]) {
                     SwingLowBuffer[i] = low[i]; // Mark the low of this bar as a potential bullish pivot point
                  }
                  // If there's a bearish pullback, mark as potential bearish pivot point
                  else {
                     SwingHighBuffer[i] = high[i]; // Mark the high of this bar as a potential bearish pivot point
                  }
               }
            }
         }
           
         
         // END OF CHECK 2: Sharp price action (STEP 3B)
         
         
         
         // CHECK 3: Check for treshold price change and high low (STEP 3C)
         
         // Check for single-bar and two-bar swing high
         if (i >= lastSwingHighIndex + SwingHighLookBack) {
           bool isSwingHigh = true;
           double tolerance = 1*10*_Point;
           bool isTwoBarSwingHigh = (i + 1 < rates_total && MathAbs(high[i] - high[i + 1]) <= tolerance);
         
           for (int j = 1; j <= SwingHighLookBack && (isSwingHigh || isTwoBarSwingHigh); ++j) {
               if (i - j < 0 || i + j >= rates_total) continue;
               
               // Check for single-bar swing high
               if (isSwingHigh && (high[i] <= high[i - j] + PriceChangeThreshold || high[i] <= high[i + j] + PriceChangeThreshold)) {
                   isSwingHigh = false;
               }
               
               // Check for two-bar swing high
               if (isTwoBarSwingHigh && (MathMax(high[i] , high[i + 1]) <= high[i - j] + PriceChangeThreshold || (i + 2 < rates_total && MathMax(high[i] , high[i + 1]) <= high[i + j] + PriceChangeThreshold))) {
                   isTwoBarSwingHigh = false;
               }
           }
         
           // Confirm and mark swing highs
           if (isSwingHigh && high[i] - lastLow >= HighLowDistanceThreshold) {
               SwingHighBuffer[i] = high[i];
               lastHigh = high[i];
               lastSwingHighIndex = i;
           } 
           else if (isTwoBarSwingHigh && MathMax(high[i] , high[i + 1]) - lastLow >= HighLowDistanceThreshold) {
               SwingHighBuffer[i] = high[i];
               SwingHighBuffer[i + 1] = high[i + 1];
               lastHigh = high[i];
               lastSwingHighIndex = i + 1; // Ensure we skip the next bar when checking for the next high.
            }
         }
         
         // Check for single-bar and two-bar swing low
         if (i >= lastSwingLowIndex + SwingLowLookBack) {
             bool isSwingLow = true;
             double tolerance = 1*10*_Point;
             bool isTwoBarSwingLow = (i + 1 < rates_total && MathAbs(low[i] - low[i + 1]) <= tolerance);
         
             for (int j = 1; j <= SwingLowLookBack && (isSwingLow || isTwoBarSwingLow); ++j) {
                 if (i - j < 0 || i + j >= rates_total) continue;
         
                 // Check for single-bar swing low
                 if (isSwingLow && (low[i] >= low[i - j] - PriceChangeThreshold || low[i] >= low[i + j] - PriceChangeThreshold)) {
                     isSwingLow = false;
                 }
                 
                 // Check for two-bar swing low
                 if (isTwoBarSwingLow && (MathMin(low[i] , low[i + 1]) >= low[i - j] - PriceChangeThreshold || (i + 2 < rates_total && MathMin(low[i] , low[i + 1]) >= low[i + j] - PriceChangeThreshold))) {
                     isTwoBarSwingLow = false;
                 }
             }
         
             // Confirm and mark swing lows
             if (isSwingLow && lastHigh - low[i] >= HighLowDistanceThreshold) {
                 SwingLowBuffer[i] = low[i];
                 lastLow = low[i];
                 lastSwingLowIndex = i;
             } 
             else if (isTwoBarSwingLow && lastHigh - MathMin(low[i] , low[i + 1]) >= HighLowDistanceThreshold) {
                 SwingLowBuffer[i] = low[i];
                 SwingLowBuffer[i + 1] = low[i + 1];
                 lastLow = low[i];
                 lastSwingLowIndex = i + 1; // Ensure we skip the next bar when checking for the next low.
             }
             
         }
         
         // END CHECK 3: Check for treshold price change and high low (STEP 3C)
         
         
      } // END of the if statement volatility check (STEP 3)
    
   } // END of calculation loop (STEP 2)

   return rates_total;
    
} // END int calculation (STEP 1)   



//+------------------------------------------------------------------+
//| Function ATR  - DOESN'T WORK!!!!  Wilde ik proberen te intergreren                    
//+------------------------------------------------------------------+
double ATR(int index) {

   int handleATR = iATR(_Symbol, PERIOD_CURRENT, ATRPeriod);
   double atrBuffer[];
   CopyBuffer(handleATR, 0, 0, index + 1, atrBuffer);
   ArraySetAsSeries(atrBuffer, true);
   return atrBuffer[index];
}