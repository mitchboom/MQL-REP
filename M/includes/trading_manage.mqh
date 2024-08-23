#include <MQL-REP\Inputs.mqh>
#include <MQL-REP\FIB_level_calculation.mqh>
#include <MQL-REP\Market_Excecutions_Ctrade.mqh>
#include <MQL-REP\trading_check.mqh>






// FUNCTION: Check BUY conditions
bool F_CheckBuyConditions() {
    if (buyTriggeredToday) return false;  // Prevents re-triggering within the same day

    double currentAskPrice = SymbolInfoDouble(gSymbol, SYMBOL_ASK);
    int relevantTradesCount = 0;  // To count relevant trades

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == gSymbol &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            relevantTradesCount++;
        }
    }
    
    if(relevantTradesCount >= 1){
      activateHedge = true;
    }

    if(relevantTradesCount < 1 && currentAskPrice >= myLevels.Entry_BUY_STOP && !buyTriggeredToday && !sellTriggeredToday) {
        buyTriggeredToday = true;  // Set the flag to true after buy condition is met
        return true;
    }
    return false;
}



// FUNCTION: Check SELL conditions
bool F_CheckSellConditions() {
    if (sellTriggeredToday) return false;  // Prevents re-triggering within the same day

    double currentBidPrice = SymbolInfoDouble(gSymbol, SYMBOL_BID);
    int relevantTradesCount = 0;  // To count relevant trades

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == gSymbol &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            relevantTradesCount++;
        }
    }
    
    if(relevantTradesCount >= 1){
      activateHedge = true;
    }

    if(relevantTradesCount < 1 && currentBidPrice <= myLevels.Entry_SELL_STOP && !buyTriggeredToday && !sellTriggeredToday) {
        sellTriggeredToday = true;  // Set the flag to true after sell condition is met
        
        return true;
    }
    return false;
}



// FUNCTION: Check and Execute Hedge Sell
bool F_CheckHedgeSell() {
    if (tpbuyHit || hedgeTriggered || !activateHedge) return false;  // Prevents re-triggering within the same day or de-activating when no normal trade is placed
    
    double currentBidPrice = SymbolInfoDouble(gSymbol, SYMBOL_BID); // Using bid price for buy position tp check


    if (currentBidPrice >= myLevels.TP_BUY_STOP) {
       tpbuyHit = true; // TP for buy position is hit
    }
    
    // Re-check tpbuyHit
    if (tpbuyHit) return false;  // Return false immediately if TP has been hit
    
    if (!hedgeTriggered && !sellTriggeredToday && currentBidPrice <= myLevels.SL_BUY_STOP) {
    
        hedgeTriggered = true;
        
        return true;
    }
    return false;
}



// FUNCTION: Check and Execute Hedge Buy
bool F_CheckHedgeBuy() {
    if (tpsellHit || hedgeTriggered || !activateHedge) return false;  // Prevents re-triggering within the same day or de-activating when no normal trade is placed
    
    double currentAskPrice = SymbolInfoDouble(gSymbol, SYMBOL_ASK); // Using ask price for sell position tp check

    if (currentAskPrice <= myLevels.TP_SELL_STOP) {
       tpsellHit = true; // TP for buy position is hit
    }
    
    // Re-check tpsellHit
    if (tpsellHit) return false;  // Return false immediately if TP has been hit
    
    if (!hedgeTriggered && !buyTriggeredToday && currentAskPrice >= myLevels.SL_SELL_STOP) {
    
        hedgeTriggered = true;
        
        return true;
    }
    return false;
}



//-----------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------



// FUNCTION: Check BUY conditions
bool F_CheckBuyLimitConditions() {
    if (buyTriggeredToday) return false;  // Prevents re-triggering within the same day

    double currentAskPrice = SymbolInfoDouble(gSymbol, SYMBOL_ASK);
    int relevantTradesCount = 0;  // To count relevant trades

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == gSymbol &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            relevantTradesCount++;
        }
    }
    
    if(relevantTradesCount >= 1){
      activateHedge = true;
    }

    if(relevantTradesCount < 1 && currentAskPrice <= myLevels.Entry_BUY_LIMIT && !buyTriggeredToday && !sellTriggeredToday) {
        buyTriggeredToday = true;  // Set the flag to true after buy condition is met
        return true;
    }
    return false;
}



// FUNCTION: Check SELL conditions
bool F_CheckSellLimitConditions() {
    if (sellTriggeredToday) return false;  // Prevents re-triggering within the same day

    double currentBidPrice = SymbolInfoDouble(gSymbol, SYMBOL_BID);
    int relevantTradesCount = 0;  // To count relevant trades

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == gSymbol &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            relevantTradesCount++;
        }
    }
    
    if(relevantTradesCount >= 1){
      activateHedge = true;
    }

    if(relevantTradesCount < 1 && currentBidPrice >= myLevels.Entry_SELL_LIMIT && !buyTriggeredToday && !sellTriggeredToday) {
        sellTriggeredToday = true;  // Set the flag to true after sell condition is met
        return true;
    }
    return false;
}



// FUNCTION: Check and Execute Hedge Sell
bool F_CheckHedgeSellReversed() {
    if (tpbuyHit || hedgeTriggered || !activateHedge) return false;  // Prevents re-triggering within the same day or de-activating when no normal trade is placed
    
    double currentBidPrice = SymbolInfoDouble(gSymbol, SYMBOL_BID); // Using bid price for buy position tp check

    if (currentBidPrice >= myLevels.TP_BUY_LIMIT) {
       tpbuyHit = true; // TP for buy position is hit
    }
    
    // Re-check tpbuyHit
    if (tpbuyHit) return false;  // Return false immediately if TP has been hit
    
    if (!hedgeTriggered && !sellTriggeredToday && currentBidPrice <= myLevels.SL_BUY_LIMIT) {
        hedgeTriggered = true;
        return true;
    }
    return false;
}



// FUNCTION: Check and Execute Hedge Buy
bool F_CheckHedgeBuyReversed() {
    if (tpsellHit || hedgeTriggered || !activateHedge) return false;  // Prevents re-triggering within the same day or de-activating when no normal trade is placed
    
    double currentAskPrice = SymbolInfoDouble(gSymbol, SYMBOL_ASK); // Using ask price for sell position tp check

    if (currentAskPrice <= myLevels.TP_SELL_LIMIT) {
       tpsellHit = true; // TP for sell position is hit
    }
    
    // Re-check tpsellHit
    if (tpsellHit) return false;  // Return false immediately if TP has been hit
    
    if (!hedgeTriggered && !buyTriggeredToday && currentAskPrice >= myLevels.SL_SELL_LIMIT) {
        hedgeTriggered = true;
        return true;
    }
    return false;
}

