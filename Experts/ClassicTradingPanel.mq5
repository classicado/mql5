//+------------------------------------------------------------------+
//|                                          ClassicTradingPanel.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
 #property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.000"
#property description "Control Panels and Dialogs. Demonstration class CButton"
 
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include "ClassicTradingPanelHeader.mqh"

 





  
  
//+------------------------------------------------------------------+
//| Global Variable                                                  |
//+------------------------------------------------------------------+
CAppWindowTwoButtons ExtDialog;
bool inPriceSelectionMode;
bool riskManagementMode;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create application dialog
   if(!ExtDialog.Create(0,"ClassicTrading",0,40,90,380,500))
      return(INIT_FAILED);
//--- run application
   ExtDialog.Run();

   inPriceSelectionMode = false;
//--- succeed
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Comment("");
//--- destroy dialog
   ExtDialog.Destroy(reason);
  }
//+------------------------------------------------------------------+
//| Expert chart event function                                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // event ID  
                  const long& lparam,   // event parameter of the long type
                  const double& dparam, // event parameter of the double type
                  const string& sparam) // event parameter of the string type
  {
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);


//--- the left mouse button has been pressed on the chart 
   if(id==CHARTEVENT_CLICK) 
     { 
      //Print("The coordinates of the mouse click on the chart are: x = ",lparam,"  y = ",dparam);
      datetime time;
      double price;
      int subwindow;
      ChartXYToTimePrice(0,lparam,dparam,subwindow,time,price);
  //    Print(" Subwindow: ",IntegerToString(subwindow)," Time: ",TimeToString(time,TIME_SECONDS)," Price: ",DoubleToString(price));
        
     } 
//--- the mouse has been clicked on the graphic object 
   if(id==CHARTEVENT_OBJECT_CLICK) 
     { 
      //Print("The mouse has been clicked on the object with name '"+sparam+"'"); 
     }






//--- Show the event parameters on the chart 
   Comment(__FUNCTION__,": id=",id," lparam=",lparam," dparam=",dparam," sparam=",sparam); 
//--- If this is an event of a mouse click on the chart 
   if(id==CHARTEVENT_CLICK) 
   //if(id==CHARTEVENT_OBJECT_DRAG) 
     { 

         //--- Prepare variables 
         int      x     =(int)lparam; 
         int      y     =(int)dparam; 
         datetime dt    =0; 
         double   price =0; 
         int      window=0; 
         if(ChartXYToTimePrice(0,x,y,window,dt,price)) 
         {     
            if( inPriceSelectionMode == true && riskManagementMode == false){
       
               //--- Convert the X and Y coordinates in terms of date/time 
               
               /*   PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price); 
                  //--- Perform reverse conversion: (X,Y) => (Time,Price) 
                  if(ChartTimePriceToXY(0,window,dt,price,x,y)) 
                     PrintFormat("Time=%s  Price=%G  =>  X=%d  Y=%d",TimeToString(dt),price,x,y); 
                  else 
                     Print("ChartTimePriceToXY return error code: ",GetLastError()); 
                     */
                  //--- delete lines  
                  ObjectDelete(0,"H Line TP"); 
                  ObjectDelete(0,"H Line"); 
                  ObjectDelete(0,"H Line SL");  
          
                  ObjectCreate(0,"H Line TP",OBJ_HLINE,window,dt, ExtDialog.GetTakeProfitPrice(price)); 
                  ObjectCreate(0,"H Line",OBJ_HLINE,window,dt,price); 
                  ObjectCreate(0,"H Line SL",OBJ_HLINE,window,dt,ExtDialog.GetStopLossPrice(price));   
                  ExtDialog.SetPositionPrice(price); 
                
                  ObjectSetInteger(0,"H Line TP",OBJPROP_COLOR,Blue);
                  ObjectSetInteger(0,"H Line",OBJPROP_COLOR,Green);
                  ObjectSetInteger(0,"H Line SL",OBJPROP_COLOR,Red);
                  ChartRedraw(0); 
           
            }else if(  inPriceSelectionMode == true && riskManagementMode == true){
            
                  if( price < ExtDialog.GetPositionPrice() ){
                     ObjectDelete(0,"H Line SL"); 
                     ObjectCreate(0,"H Line SL",OBJ_HLINE,window,dt,price);  
                     ObjectSetInteger(0,"H Line SL",OBJPROP_COLOR,Red);   
                     ExtDialog.SetStopLossPrice(price);               
                  }else if( price > ExtDialog.GetPositionPrice() ){
                     ObjectDelete(0,"H Line TP"); 
                     ObjectCreate(0,"H Line TP",OBJ_HLINE,window,dt,price);  
                     ObjectSetInteger(0,"H Line TP",OBJPROP_COLOR,Blue);   
                     ExtDialog.SetTakeProfitPrice(price);                
                  }

                  ChartRedraw(0); 
                  
            }
         } 
         /*else 
            Print("ChartXYToTimePrice return error code: ",GetLastError()); 
         Print("+--------------------------------------------------------------+"); */
         
          
     } 
  
    if(id==CHARTEVENT_OBJECT_DRAG) 
     { 
      //--- Prepare variables 
      int      x     =(int)lparam; 
      int      y     =(int)dparam; 
      datetime dt    =0; 
      double   price =0; 
      int      window=0; 
      //--- Convert the X and Y coordinates in terms of date/time 
      if(ChartXYToTimePrice(0,x,y,window,dt,price)) 
        { 
         PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price); 
         
         //--- Perform reverse conversion: (X,Y) => (Time,Price) 
         if(ChartTimePriceToXY(0,window,dt,price,x,y)) 
            PrintFormat("Time=%s  Price=%G  =>  X=%d  Y=%d",TimeToString(dt),price,x,y); 
         else 
            Print("ChartTimePriceToXY return error code: ",GetLastError()); 
            
         //--- delete lines  
         //ObjectDelete(0,"HH Line"); 
         //--- create horizontal and vertical lines of the crosshair 
         ObjectCreate(0,"HH Line",OBJ_HLINE,window,dt,price);  
         ChartRedraw(0); 
        } 
      else 
         Print("ChartXYToTimePrice return error code: ",GetLastError()); 
      Print("+---------------------DRAGEDD-----------------------------------------+"); 
     } 






 if(id==CHARTEVENT_KEYDOWN)
     {

      if (lparam == 'P' || lparam == 'P') {
         inPriceSelectionMode = !inPriceSelectionMode;
         
         if(inPriceSelectionMode == false)
            riskManagementMode = false;  //Clear risk management mode if not in select mode
      }else if (lparam == 'L' || lparam == 'l') {
      
         if(inPriceSelectionMode)
            riskManagementMode = !riskManagementMode;
      }


      
     }


	 
        
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
     
   ExtDialog.UpdateForm();  


  }
//+------------------------------------------------------------------+  
  
  
  
  
   
  
   