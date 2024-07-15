//+------------------------------------------------------------------+
//|                                    Market_Excecutions_Ctrade.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"



#include <Trade/SymbolInfo.mqh>
#include <Trade/OrderInfo.mqh>
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>

CTrade  trade;  // Single trading object
CPositionInfo PositionInfo;
CSymbolInfo m_symbol; // Symbol info object

// | Excecute a MARKET BUY
//----------------------------
void Execute_BUY(double lotsize_f, double SL_f, double TP_f) {
    
    double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
    ask = NormalizeDouble(ask,_Digits);
    
   if (!trade.Buy(lotsize_f,_Symbol,ask,SL_f,TP_f,"EXCUTED BUY")){
      Print("Order failed, ERROR: ", trade.ResultRetcode(), " - ", trade.ResultComment());
   }
}



// | Excecute a MARKET SELL
//-----------------------------
void Execute_SELL(double lotsize_f, double SL_f, double TP_f) {
    
    double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
    bid = NormalizeDouble(bid,_Digits);
    
   if (!trade.Sell(lotsize_f,_Symbol,bid,SL_f,TP_f,"EXCUTED SELL")){
      Print("Order failed, ERROR: ", trade.ResultRetcode(), " - ", trade.ResultComment());
   }
}