#include <MQL-REP\Inputs.mqh>
#include <MQL-REP\FIB_level_calculation.mqh>
#include <MQL-REP\Market_Excecutions_Ctrade.mqh>
#include <MQL-REP\trading_check.mqh>






// FUNCTION: Check BUY conditions
bool F_CheckBuyConditions() {
    if (buyTriggeredToday) return false;  // Prevents re-triggering within the same day

    double currentAskPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    int relevantTradesCount = 0;  // To count relevant trades

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == gSymbol &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            relevantTradesCount++;
        }
    }

    if(relevantTradesCount < 1 && currentAskPrice >= myLevels.Entry_BUY_STOP && F_time_in_order_range() && !buyTriggeredToday) {
        buyTriggeredToday = true;  // Set the flag to true after buy condition is met
        return true;
    }
    return false;
}




// FUNCTION: Check and Execute Hedge Sell
void CheckAndExecuteHedge() {
    double currentBidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    if (!hedgeTriggered && buyHit && !sellHit && currentBidPrice <= myLevels.SL_BUY_STOP) {
    
        hedgeTriggered = true;
    }
}



// Global variable to control sell execution


// FUNCTION: Check SELL conditions
bool F_CheckSellConditions() {
    if (sellTriggeredToday) return false;  // Prevents re-triggering within the same day

    double currentBidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    int relevantTradesCount = 0;  // To count relevant trades

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == gSymbol &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            relevantTradesCount++;
        }
    }

    if(relevantTradesCount < 1 && currentBidPrice <= myLevels.Entry_SELL_STOP && F_time_in_order_range() && !sellTriggeredToday) {
        sellTriggeredToday = true;  // Set the flag to true after sell condition is met
        return true;
    }
    return false;
}



// FUNCTION: Check and Execute Hedge Sell
void CheckAndExecuteHedgeSell() {
    double currentAskPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    if (!hedgeTriggered && sellHit && !buyHit && currentAskPrice >= myLevels.SL_SELL_STOP) {
    
        hedgeTriggered = true;

    }
}




//-----------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------



// FUNCTION: Check BUY LIMIT conditions
bool F_CheckBuyLimitConditions() {
    if (buyTriggeredToday) return false; // Prevents re-triggering within the same day

    double currentAskPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    int totalBuyPositions = 0;
    buyHit = false;

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == _Symbol &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            totalBuyPositions++;
            buyHit = true;
        }
    }

    if (totalBuyPositions < 1 && currentAskPrice <= myLevels.Entry_BUY_LIMIT && F_time_in_order_range() && !buyHit) {
        // Execute buy limit order logic here
        Execute_BUY(lotsize, myLevels.SL_BUY_LIMIT, myLevels.TP_BUY_LIMIT);
        Print("BUY LIMIT executed on: ", _Symbol, " Total positions now: ", PositionsTotal(), " Total BUY positions now for this EA: ", _Symbol, ": ", totalBuyPositions + 1);
        buyTriggeredToday = true; // Set the flag to true after condition is met
        return true;
    }
    return false;
}



// FUNCTION: Check and Execute Hedge for Buy Limit
void CheckAndExecuteHedgeBuyLimit() {
    double currentBidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    int totalBuyPositions = 0;


    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == _Symbol &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            totalBuyPositions++;
        }
    }
    
    if (tpbuyHit && totalBuyPositions < 1 && !sellHit && currentBidPrice <= myLevels.SL_BUY_LIMIT) {

    }
}




// FUNCTION: Check SELL LIMIT conditions
bool F_CheckSellLimitConditions() {
    if (sellTriggeredToday) return false; // Prevents re-triggering within the same day

    double currentBidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    int totalSellPositions = 0;
    sellHit = false;

    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == _Symbol &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            totalSellPositions++;
            sellHit = true;
        }
    }

    if (totalSellPositions < 1 && currentBidPrice >= myLevels.Entry_SELL_LIMIT && F_time_in_order_range() && !sellHit) {

        
        sellTriggeredToday = true; // Set the flag to true after condition is met
        return true;
    }
    return false;
}




// FUNCTION: Check and Execute Hedge for Sell Limit
void CheckAndExecuteHedgeSellLimit() {
    double currentAskPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    
    int totalSellPositions = 0;


    // Check open positions and gather data
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionInfo.SelectByIndex(i) &&
            PositionGetString(POSITION_SYMBOL) == _Symbol &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY &&
            PositionGetInteger(POSITION_MAGIC) == Magic_Number) {
            totalSellPositions++;
        }
    }    
    
    if (tpsellHit && totalSellPositions < 1 && !buyHit && currentAskPrice >= myLevels.SL_SELL_LIMIT) {

    }
}