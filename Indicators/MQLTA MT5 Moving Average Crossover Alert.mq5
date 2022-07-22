#property link          "https://www.earnforex.com/metatrader-indicators/moving-average-crossover-alert/"
#property version       "1.03"
#property strict
#property copyright     "EarnForex.com - 2020-2021"
#property description   "The Moving Average Crossover Alert"
#property description   " "
#property description   " "
#property description   " "
#property description   "Find More on EarnForex.com"
#property icon          "\\Files\\EF-Icon-64x64px.ico"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 2
#property indicator_color1 clrRed
#property indicator_color2 clrGreen
#property indicator_type1 DRAW_LINE
#property indicator_type2 DRAW_LINE
#property indicator_width1  1
#property indicator_width2  1
#property indicator_label1  "Fast MA"
#property indicator_label2  "Slow MA"

#include <MQLTA ErrorHandling.mqh>
#include <MQLTA Utils.mqh>

enum ENUM_TRADE_SIGNAL{
   SIGNAL_BUY=1,     //BUY
   SIGNAL_SELL=-1,   //SELL
   SIGNAL_NEUTRAL=0  //NEUTRAL
};

enum ENUM_CANDLE_TO_CHECK{
   CURRENT_CANDLE=0,    //CURRENT CANDLE
   CLOSED_CANDLE=1      //PREVIOUS CANDLE
};

enum ENUM_ALERT_SIGNAL{

};

input string Comment1="========================";     //MQLTA Moving Average Crossover Alert
input string IndicatorName="MQLTA-MACA";              //Indicator Short Name

input string Comment2="========================";     //Indicator Parameters
input int MAFastPeriod=25;                                //Fast Moving Average Period
input int MAFastShift=0;                                  //Fast Moving Average Shift
input ENUM_MA_METHOD MAFastMethod=MODE_SMA;               //Fast Moving Average Method
input ENUM_APPLIED_PRICE MAFastAppliedPrice=PRICE_CLOSE;  //Fast Moving Average Applied Price
input int MASlowPeriod=50;                                //Slow Moving Average Period
input int MASlowShift=0;                                  //Slow Moving Average Shift
input ENUM_MA_METHOD MASlowMethod=MODE_SMA;               //Slow Moving Average Method
input ENUM_APPLIED_PRICE MASlowAppliedPrice=PRICE_CLOSE;  //Slow Moving Average Applied Price
//input ENUM_ALERT_SIGNAL AlertSignal=ON_BREAK_OUT;       //Alert Signal When
input ENUM_CANDLE_TO_CHECK CandleToCheck=CURRENT_CANDLE;    //Candle To Use For Analysis
input int BarsToScan=500;                                   //Number Of Candles To Analyse

input string Comment_3="====================";     //Notification Options
input bool EnableNotify=false;                    //Enable Notifications Feature
input bool SendAlert=true;                        //Send Alert Notification
input bool SendApp=true;                          //Send Notification to Mobile
input bool SendEmail=true;                        //Send Notification via Email
input int WaitTimeNotify=5;                        //Wait time between notifications (Minutes)

input string Comment_4="====================";     //Drawing Options
input bool EnableDrawArrows=true;                  //Draw Signal Arrows
input int ArrowBuy=241;                            //Buy Arrow Code
input int ArrowSell=242;                           //Sell Arrow Code
input int ArrowSize=3;                             //Arrow Size (1-5)

double BufferMASlow[];
double BufferMAFast[];

int BufferMASlowHandle,BufferMAFastHandle;

double Open[],Close[],High[],Low[];
datetime Time[];

datetime LastNotificationTime;
int Shift=0;


int OnInit(void){

   IndicatorSetString(INDICATOR_SHORTNAME,IndicatorName);

   OnInitInitialization();
   if(!OnInitPreChecksPass()){
      return(INIT_FAILED);
   }   

   InitialiseHandles();
   InitialiseBuffers();

   return(INIT_SUCCEEDED);
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){

   if(rates_total<=MASlowPeriod || MASlowPeriod<=0)
      return(0);
   
   if(rates_total<=MAFastPeriod || MAFastPeriod<=0)
      return(0);
      
   if(MAFastPeriod>MASlowPeriod)
      return(0);
   
   bool IsNewCandle=CheckIfNewCandle();
   int i,pos,upTo;

   pos=0;
   if(prev_calculated==0 || IsNewCandle)
      upTo=BarsToScan-1;
   else
      upTo=0;

   if(IsStopped()) return(0);
   if(CopyBuffer(BufferMAFastHandle,0,-MAFastShift,upTo+1,BufferMAFast)<=0 ||
      CopyBuffer(BufferMASlowHandle,0,-MASlowShift,upTo+1,BufferMASlow)<=0
   ){
      Print("Failed to create the Indicator! Error ",GetLastErrorText(GetLastError())," - ",GetLastError());
      return(0);
   }

   for(i=pos; i<=upTo && !IsStopped(); i++){
      Open[i]=iOpen(Symbol(),PERIOD_CURRENT,i);
      Low[i]=iLow(Symbol(),PERIOD_CURRENT,i);
      High[i]=iHigh(Symbol(),PERIOD_CURRENT,i);
      Close[i]=iClose(Symbol(),PERIOD_CURRENT,i);
      Time[i]=iTime(Symbol(),PERIOD_CURRENT,i);
   }  
  
   if(IsNewCandle || prev_calculated==0){
      if(EnableDrawArrows) DrawArrows();
   }
   
   if(EnableDrawArrows)
      DrawArrow(0);

   if(EnableNotify)
      NotifyHit();
      
   return(rates_total);
}
  
  
void OnDeinit(const int reason){
   CleanChart();
}  


void OnInitInitialization(){
   LastNotificationTime=TimeCurrent();
   Shift=CandleToCheck;
}


bool OnInitPreChecksPass(){
   if(MASlowPeriod<=0 || MAFastPeriod<=0 || MAFastPeriod>MASlowPeriod){
      Print("Wrong input parameter");
      return false;
   }   
   if(Bars(Symbol(),PERIOD_CURRENT)<MASlowPeriod+MASlowShift){
      Print("Not Enough Historical Candles");
      return false;
   }   
   return true;
}


void CleanChart(){
   int Window=0;
   for(int i=ObjectsTotal(ChartID(),Window,-1)-1;i>=0;i--){
      if(StringFind(ObjectName(0,i),IndicatorName,0)>=0){
         ObjectDelete(0,ObjectName(0,i));
      }
   }
}


void InitialiseHandles(){
   BufferMAFastHandle=iMA(Symbol(),PERIOD_CURRENT,MAFastPeriod,MAFastShift,MAFastMethod,MAFastAppliedPrice);
   BufferMASlowHandle=iMA(Symbol(),PERIOD_CURRENT,MASlowPeriod,MASlowShift,MASlowMethod,MASlowAppliedPrice);
   ArrayResize(Open,BarsToScan);
   ArrayResize(High,BarsToScan);
   ArrayResize(Low,BarsToScan);
   ArrayResize(Close,BarsToScan);
   ArrayResize(Time,BarsToScan);
}

void InitialiseBuffers(){
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   ArraySetAsSeries(BufferMAFast,true);
   ArraySetAsSeries(BufferMASlow,true);
   SetIndexBuffer(0,BufferMAFast,INDICATOR_DATA);
   SetIndexBuffer(1,BufferMASlow,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_SHIFT,MAFastShift);
   PlotIndexSetInteger(1,PLOT_SHIFT,MASlowShift);
}


datetime NewCandleTime=TimeCurrent();
bool CheckIfNewCandle(){
   if(NewCandleTime==iTime(Symbol(),0,0)) return false;
   else{
      NewCandleTime=iTime(Symbol(),0,0);
      return true;
   }
}


// Check if it is a trade Signla 0 - Neutral, 1 - Buy, -1 - Sell
ENUM_TRADE_SIGNAL IsSignal(int i)
{
   int j = i + Shift;
   
   // Prevent array out of range error (negative index) for when the MA shift is negative.
   if ((j + MAFastShift < 0) || (j + MASlowShift < 0)) return SIGNAL_NEUTRAL;
   
   if ((BufferMAFast[j + 1 + MAFastShift] < BufferMASlow[j + 1 + MASlowShift]) && (BufferMAFast[j + MAFastShift] > BufferMASlow[j + MASlowShift])) return SIGNAL_BUY;
   if ((BufferMAFast[j + 1 + MAFastShift] > BufferMASlow[j + 1 + MASlowShift]) && (BufferMAFast[j + MAFastShift] < BufferMASlow[j + MASlowShift])) return SIGNAL_SELL;

   return SIGNAL_NEUTRAL;
}


datetime LastNotification=TimeCurrent()-WaitTimeNotify*60;

void NotifyHit(){
   if(!EnableNotify || TimeCurrent()<(LastNotification+WaitTimeNotify*60)) return;
   if(!SendAlert && !SendApp && !SendEmail) return;
   if(Time[0]==LastNotificationTime) return;
   ENUM_TRADE_SIGNAL Signal=IsSignal(0);
   if(Signal==SIGNAL_NEUTRAL) return;
   string EmailSubject=IndicatorName+" "+Symbol()+" Notification ";
   string EmailBody="\r\n"+AccountCompany()+" - "+AccountName()+" - "+IntegerToString(AccountNumber())+"\r\n\r\n"+IndicatorName+" Notification for "+Symbol()+"\r\n\r\n";
   string AlertText=IndicatorName+" - "+Symbol()+" Notification\r\n";
   string AppText=AccountCompany()+" - "+AccountName()+" - "+IntegerToString(AccountNumber())+" - "+IndicatorName+" - "+Symbol()+" - ";
   string Text="";
   
   if(Signal!=SIGNAL_NEUTRAL){      
      Text+="Slow and Fast Moving Average Crossed";
   }
   
   EmailBody+=Text+"\r\n\r\n";
   AlertText+=Text+"\r\n";
   AppText+=Text+"";
   if(SendAlert) Alert(AlertText);
   if(SendEmail){
      if(!SendMail(EmailSubject,EmailBody)) Print("Error sending email "+IntegerToString(GetLastError()));
   }
   if(SendApp){
      if(!SendNotification(AppText)) Print("Error sending notification "+IntegerToString(GetLastError()));
   }
   LastNotification=TimeCurrent();
   Print(IndicatorName+"-"+Symbol()+" last notification sent "+TimeToString(LastNotification));
}


void DrawArrows(){
   RemoveArrows();
   if(!EnableDrawArrows || BarsToScan==0) return;
   int MaxBars=Bars(Symbol(),PERIOD_CURRENT);
   if(MaxBars>BarsToScan) MaxBars=BarsToScan;
   for(int i=MaxBars-2;i>=1;i--){
      DrawArrow(i);
   }
}


void RemoveArrows(){
   int Window=-1;
   for(int i=ObjectsTotal(ChartID(),Window,-1)-1;i>=0;i--){
      if(StringFind(ObjectName(0,i),IndicatorName+"-ARWS-",0)>=0){
         ObjectDelete(0,ObjectName(0,i));
      }
   }
}

int SignalWidth=0;

void DrawArrow(int i){
   RemoveArrowCurr();
   if(!EnableDrawArrows){
      RemoveArrows();
      return;
   }
   ENUM_TRADE_SIGNAL Signal=IsSignal(i);
   if(Signal==SIGNAL_NEUTRAL) return;
   datetime ArrowDate=iTime(Symbol(),0,i);
   string ArrowName=IndicatorName+"-ARWS-"+IntegerToString(ArrowDate);
   double ArrowPrice=0;
   ENUM_OBJECT ArrowType=OBJ_ARROW;
   color ArrowColor=0;
   int ArrowAnchor=0;
   string ArrowDesc="";
   if(Signal==SIGNAL_BUY){
      ArrowPrice=Low[i];
      ArrowType = (ENUM_OBJECT)ArrowBuy; 
      ArrowColor=clrGreen;  
      ArrowAnchor=ANCHOR_TOP;
      ArrowDesc="BUY";
   }
   if(Signal==SIGNAL_SELL){
      ArrowPrice=High[i];
      ArrowType = (ENUM_OBJECT)ArrowSell;
      ArrowColor=clrRed;
      ArrowAnchor=ANCHOR_BOTTOM;
      ArrowDesc="SELL";
   }
   ObjectCreate(0,ArrowName,OBJ_ARROW,0,ArrowDate,ArrowPrice);
   ObjectSetInteger(0,ArrowName,OBJPROP_COLOR,ArrowColor);
   ObjectSetInteger(0,ArrowName,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,ArrowName,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,ArrowName,OBJPROP_ANCHOR,ArrowAnchor);
   ObjectSetInteger(0,ArrowName,OBJPROP_ARROWCODE,ArrowType);
   SignalWidth=ArrowSize;
   ObjectSetInteger(0,ArrowName,OBJPROP_WIDTH,SignalWidth);
   ObjectSetInteger(0,ArrowName,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,ArrowName,OBJPROP_BGCOLOR,ArrowColor);
   ObjectSetString(0,ArrowName,OBJPROP_TEXT,ArrowDesc);
   datetime CurrTime=iTime(Symbol(),0,0);

}


void RemoveArrowCurr(){
   datetime ArrowDate=iTime(Symbol(),0,Shift);
   string ArrowName=IndicatorName+"-ARWS-"+IntegerToString(ArrowDate);
   ObjectDelete(0,ArrowName);
}

