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
input double   inpPriceChangeTreshold           = 1;        // Minimium price change in lookback period (pips)
input double   inpHighLowDistanceThreshold      = 30;       // Minimium distance between high and low (pips)
input double   inpVolatilityThreshold           = 1;        // Minimum volatility between the lookback period (Multiplier of the ATR)



// Define a threshold for significant price change
const double PriceChangeThreshold = inpPriceChangeTreshold * _Point * 10; // Example: 10 pips for a 5-digit broker

int lastSwingHighIndex = -SwingHighLookBack;
int lastSwingLowIndex = -SwingLowLookBack;

double HighLowDistanceThreshold = inpHighLowDistanceThreshold * _Point * 10;



// Calculate the ATR and define threshold for volatility
double atr = iATR(_Symbol, PERIOD_CURRENT, ATRPeriod);
double volatilityThreshold = atr * inpVolatilityThreshold;


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

   // Main calculation loop
for (int i = limit; i < rates_total; ++i) {
    SwingHighBuffer[i] = EMPTY_VALUE;
    SwingLowBuffer[i] = EMPTY_VALUE;

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
        } else if (isTwoBarSwingHigh && MathMax(high[i] , high[i + 1]) - lastLow >= HighLowDistanceThreshold) {
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
          } else if (isTwoBarSwingLow && lastHigh - MathMin(low[i] , low[i + 1]) >= HighLowDistanceThreshold) {
              SwingLowBuffer[i] = low[i];
              SwingLowBuffer[i + 1] = low[i + 1];
              lastLow = low[i];
              lastSwingLowIndex = i + 1; // Ensure we skip the next bar when checking for the next low.
          }
      }
   }

    return rates_total;
}