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
#include "Rectangle.mqh"
 





  
  
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
   
   
   
   //--- number of visible bars in the chart window
   int bars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);
//--- price array size
   int accuracy=1000;
//--- arrays for storing the date and price values to be used
//--- for setting and changing rectangle anchor points' coordinates
   datetime date[];
   double   pprice[];
//--- memory allocation
   ArrayResize(date,bars);
   ArrayResize(pprice,accuracy);
//--- fill the array of dates
   ResetLastError();
   if(CopyTime(Symbol(),Period(),0,bars,date)==-1)
     {
      Print("Failed to copy time values! Error code = ",GetLastError());
      return;
     }
//--- fill the array of prices
//--- find the highest and lowest values of the chart
   double max_price=ChartGetDouble(0,CHART_PRICE_MAX);
   double min_price=ChartGetDouble(0,CHART_PRICE_MIN);
//--- define a change step of a price and fill the array
   double step=(max_price-min_price)/accuracy;
   for(int i=0;i<accuracy;i++)
      pprice[i]=min_price+i*step;
//--- define points for drawing the rectangle
   int d1=InpDate1*(bars-1)/100;
   int d2=InpDate2*(bars-1)/100;
   int p1=InpPrice1*(accuracy-1)/100;
   int p2=InpPrice2*(accuracy-1)/100;
//--- create a rectangle
   //if(!RectangleCreate(0,InpName,0,date[d1],price[p1],date[d2],price[p2],InpColor,

            
                  if( price < ExtDialog.GetPositionPrice() ){
                     ObjectDelete(0,"H Line SL"); 
                     ObjectCreate(0,"H Line SL",OBJ_HLINE,window,dt,price);  
                     ObjectSetInteger(0,"H Line SL",OBJPROP_COLOR,Red);   
                     ObjectSetInteger(0,"H Line SL",OBJPROP_WIDTH,4);
                     ExtDialog.SetStopLossPrice(price);   
                     
   if(!RectangleCreate(0,"RectangleStopLoss",0,date[d1],ExtDialog.GetPositionPrice(),date[d2],ExtDialog.GetStopLossPrice(),clrRed,
      InpStyle,InpWidth,InpFill,InpBack,InpSelection,InpHidden,InpZOrder))
     {
      return;
     }
                                    
                  }else if( price > ExtDialog.GetPositionPrice() ){
                     ObjectDelete(0,"H Line TP"); 
                     ObjectCreate(0,"H Line TP",OBJ_HLINE,window,dt,price);  
                     ObjectSetInteger(0,"H Line TP",OBJPROP_COLOR,Blue);   
                     ObjectSetInteger(0,"H Line TP",OBJPROP_WIDTH,4);  
                     ExtDialog.SetTakeProfitPrice(price);    
                     
   if(!RectangleCreate(0,"RectangleTakeProfit",0,date[d1],ExtDialog.GetPositionPrice(),date[d2],ExtDialog.GetTakeProfitPrice(),clrGreen,
      InpStyle,InpWidth,InpFill,InpBack,InpSelection,InpHidden,InpZOrder))
     {
      return;
     }
                                    
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
  
  
  
  
   
  
   