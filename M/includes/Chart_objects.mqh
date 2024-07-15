
#include <MQL-REP\FIB_level_calculation.mqh>


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