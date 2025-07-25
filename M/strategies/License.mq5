//+------------------------------------------------------------------+
//|                                                      License.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Founder of the ocean"
#property link      "https://www.mql5.com"
#property version   "1.00"

   /*
   //checking the license by initializing the expert advisor
   static bool isInit = false;
   if(!isInit){
      isInit = true;
      
      //check if user is allowed to use the program
      long Customer1 = 7478389; //Mitch STRATO Basis VPS
      long Customer2 = 51753980; //Mitch Macbook
      long Customer3 = 51753980; //Mitch VPS Goud server
      long Customer4 = 51738747; //Mitch Backtest server 48 core
      
      long Customer5 = 51806904; //Dave Lenovo laptop
      long Customer6 = 5023183985; //Dave server
      long Customer7 = 51788033; //Dave server
      long Customer8 = 51788032; //Dave server
      
      long accountNo = AccountInfoInteger(ACCOUNT_LOGIN);
      if(Customer1 == accountNo || 
         Customer2 == accountNo || 
         Customer3 == accountNo || 
         Customer4 == accountNo || 
         Customer5 == accountNo || 
         Customer6 == accountNo || 
         Customer7 == accountNo || 
         Customer8 == accountNo){
         
         Print(__FUNCTION__," > License verified");
      }
      else{
         Print(__FUNCTION__," > License is invalid");
         ExpertRemove();
         return INIT_FAILED;
      }
   }
   */

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

/*
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
*/



   string url = "https://mt5-license-api.onrender.com/validate";  // Your working endpoint
   string headers = "Content-Type: application/x-www-form-urlencoded\r\n";

   string postData = "account_no=" + IntegerToString((int)AccountInfoInteger(ACCOUNT_LOGIN));
   char post[];
   StringToCharArray(postData, post, 0, WHOLE_ARRAY, CP_UTF8);

   char result[];
   string resultHeaders;
   int timeout = 5000;

   int response = WebRequest("POST", url, headers, timeout, post, result, resultHeaders);

   if(response == -1)
   {
      Print("License check failed. Error: ", GetLastError());
      Alert("Connection to license server failed.");
      return INIT_FAILED;
   }

   string resultText = CharArrayToString(result);
   Print("License Server Response: ", resultText);

   if(resultText != "success")
   {
      Alert("❌ Invalid license for this account.");
      ExpertRemove();
      return INIT_FAILED;
   }

   Alert("✅ License verified. Welcome!");
   return INIT_SUCCEEDED;
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
