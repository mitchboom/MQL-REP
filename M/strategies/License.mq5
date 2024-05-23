//+------------------------------------------------------------------+
//|                                                      License.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Founder of the ocean"
#property link      "https://www.mql5.com"
#property version   "1.00"



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){

/*   //checking the license by initializing the expert advisor
   static bool isInit = false;
   if(!isInit){
      isInit = true;
      
      //check if user is allowed to use the program
      long accountCustomer = 51655118; //account number
      long accountNo = AccountInfoInteger(ACCOUNT_LOGIN);
      if(accountCustomer == accountNo){
         Print(__FUNCTION__," > License verified");
      }
      else{
         Print(__FUNCTION__," > License is invalid");
         ExpertRemove();
         return INIT_FAILED;
      }
   }
*/


   string url = "https://algocurve.000webhostapp.com/test.php";
   string headers;
   
   char post[];
   int accountNumber = (int)AccountInfoInteger(ACCOUNT_LOGIN);
   string postText = "account_no="+IntegerToString(accountNumber);
   StringToCharArray(postText,post,0,WHOLE_ARRAY,CP_UTF8);
   
   char result[];
   string resultHeaders;
   int response = WebRequest("POST",url,headers,1000,post,result,resultHeaders);

   Print(__FUNCTION__, " > Serer response is ", response, " and the error is ",GetLastError());
   string resultText = CharArrayToString(result);
   Print(__FUNCTION__, "> ",CharArrayToString(result));

   if(resultText != "success"){
      Alert("You don't have the proper license to use this program");
      return INIT_FAILED;
   }

   return(INIT_SUCCEEDED);
}






//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
