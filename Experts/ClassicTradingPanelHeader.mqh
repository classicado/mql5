//+------------------------------------------------------------------+
//|                                          ClassicTradingPanel.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
 #property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.000"
#property description "Control Panels and Dialogs. Demonstration class CButton"
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Controls\Label.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- indents and gaps
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define INDENT_LIMIT_SECTION_TOP                    (71)      // indent from top (with allowance for border width)
#define INDENT_POSITION_SECTION_TOP                    (150)      // indent from top (with allowance for border width)
#define INDENT_TAKEPROFIT_SECTION_TOP                    (200)      // indent from top (with allowance for border width)
#define INDENT_STOPLOSS_SECTION_TOP                    (250)      // indent from top (with allowance for border width)
#define INDENT_SYMBOLDETAILS_SECTION_TOP                    (300)      // indent from top (with allowance for border width)
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate
#define CONTROLS_GAP_Y                      (5)       // gap by Y coordinate
//--- for buttons
#define BUTTON_WIDTH                        (100)     // size by X coordinate
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate
//---
//+------------------------------------------------------------------+
//| Class CControlsDialog                                            |
//| Usage: main dialog of the Controls application                   |
//+------------------------------------------------------------------+
class CAppWindowTwoButtons : public CAppDialog
  {
protected:
   CPositionInfo     m_position;                      // trade position object
   CTrade            m_trade;                         // trading object
   CAccountInfo      m_account;                       // account info wrapper

private:
   CButton           m_buttonBuy;                       // the button object
   CButton           m_buttonSell;                       // the button object
   CButton           m_buttonCloseAll;                       // the button object   
   CButton           m_buttonCloseAllBuy;                       // the button object     
   CButton           m_buttonCloseAllSell;                       // the button object     

   CButton           m_buttonBuyLimit;                       // the button object
   CButton           m_buttonSellLimit;                       // the button object
   CButton           m_buttonCloseAllLimit;                       // the button object  
   CButton           m_buttonCloseAllLimitBuy;                       // the button object  
   CButton           m_buttonCloseAllLimitSell;                       // the button object  
      
   CLabel            m_label;                         // CLabel object
   CEdit             m_edit;                          // CEdit object

   CLabel            m_labelOrderInformation;                         // CLabel object
   CLabel            m_labelOrders;                         // CLabel object
   CEdit             m_editOrders;                          // CEdit object
   CLabel            m_labelLots;                         // CLabel object
   CEdit             m_editLots;                          // CEdit object

   CLabel            m_labelTakeProfit;                         // CLabel object
   CLabel            m_labelTakeProfitPrice;                         // CLabel object
   CEdit             m_editTakeProfitPrice;                          // CEdit object
   CLabel            m_labelTakeProfitPoints;                         // CLabel object
   CEdit             m_editTakeProfitPoints;                          // CEdit object

   CLabel            m_labelStopLoss;                         // CLabel object
   CLabel            m_labelStopLossPrice;                         // CLabel object
   CEdit             m_editStopLossPrice;                          // CEdit object
   CLabel            m_labelStopLossPoints;                         // CLabel object
   CEdit             m_editStopLossPoints;                          // CEdit object

   CLabel            m_labelSymbolDetails;                         // CLabel object
   CLabel            m_labelBID;                         // CLabel object
   CLabel            m_labelSPREAD;                         // CLabel object
   CLabel            m_labelASK;                         // CLabel object
   CLabel            m_labelPositionType;                         // CLabel object

public:
                     CAppWindowTwoButtons(void);
                    ~CAppWindowTwoButtons(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual void      SetPositionPrice(double price);
   double            GetPositionPrice();
   
   bool              UpdateForm();
   double            GetTakeProfitPrice(double price);
   void              SetTakeProfitPrice(double price); 
   
   double            GetStopLossPrice(double price);
   void              SetStopLossPrice(double price);   
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

protected:
   //--- create dependent controls
   bool              CreateButtonBuy(void);
   bool              CreateButtonSell(void);
   bool              CreateButtonCloseAll(void);
   bool              CreateButtonCloseAllBuy(void);
   bool              CreateButtonCloseAllSell(void);

   bool              CreateButtonBuyLimit(void);
   bool              CreateButtonSellLimit(void);
   bool              CreateButtonCloseAllLimit(void);
   bool              CreateButtonCloseAllLimitBuy(void);
   bool              CreateButtonCloseAllLimitSell(void);

   bool              CreateLabel(void);
   bool              CreateEdit(void);
  
   bool              CreateLabelOrderInformation(void);   
   bool              CreateEditLabelOrders(void); 
   bool              CreateEditLabelLots(void);
   bool              CreateLabelTakeProfit(void); 
   bool              CreateEditLabelTakeProfitPrice(void); 
   bool              CreateEditLabelTakeProfitPoints(void);
   bool              CreateLabelStopLoss(void); 
   bool              CreateEditLabelStopLossPrice(void); 
   bool              CreateEditLabelStopLossPoints(void);
   bool              CreateLabelSymbolDetails(void);
   bool              CreateLabelBID(void);
   bool              CreateLabelSPREAD(void);
   bool              CreateLabelASK(void);
   bool              CreateLabelPositionType(void);   

   //--- handlers of the dependent controls events
   void              OnClickButtonBuy(void);
   void              OnClickButtonSell(void);
   void              OnClickButtonCloseAll(void);
   void              OnClickButtonCloseAllBuy(void);
   void              OnClickButtonCloseAllSell(void);

   void              OnClickButtonBuyLimit(void);
   void              OnClickButtonSellLimit(void);
   void              OnClickButtonCloseAllLimit(void);
   void              OnClickButtonCloseAllLimitBuy(void);
   void              OnClickButtonCloseAllLimitSell(void);

   void              OnClickLabelASK(void);   
   void              OnClickLabelBID(void);   
  };
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAppWindowTwoButtons)
ON_EVENT(ON_CLICK,m_buttonBuy,OnClickButtonBuy)
ON_EVENT(ON_CLICK,m_buttonSell,OnClickButtonSell)
ON_EVENT(ON_CLICK,m_buttonCloseAll,OnClickButtonCloseAll)
ON_EVENT(ON_CLICK,m_buttonCloseAllBuy,OnClickButtonCloseAllBuy)
ON_EVENT(ON_CLICK,m_buttonCloseAllSell,OnClickButtonCloseAllSell)

ON_EVENT(ON_CLICK,m_buttonBuyLimit,OnClickButtonBuyLimit)
ON_EVENT(ON_CLICK,m_buttonSellLimit,OnClickButtonSellLimit)
ON_EVENT(ON_CLICK,m_buttonCloseAllLimit,OnClickButtonCloseAllLimit)
ON_EVENT(ON_CLICK,m_buttonCloseAllLimitBuy,OnClickButtonCloseAllLimitBuy)
ON_EVENT(ON_CLICK,m_buttonCloseAllLimitSell,OnClickButtonCloseAllLimitSell)

ON_EVENT(ON_CLICK,m_labelASK,OnClickLabelASK)
ON_EVENT(ON_CLICK,m_labelBID,OnClickLabelBID)
EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAppWindowTwoButtons::CAppWindowTwoButtons(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CAppWindowTwoButtons::~CAppWindowTwoButtons(void)
  {
  }
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
   if(!CreateButtonBuy())
      return(false);
   if(!CreateButtonSell())
      return(false);        
   if(!CreateButtonCloseAll())
      return(false);
   if(!CreateButtonCloseAllBuy())
      return(false);
   if(!CreateButtonCloseAllSell())
      return(false);

   if(!CreateButtonBuyLimit())
      return(false);
   if(!CreateButtonSellLimit())
      return(false);        
   if(!CreateButtonCloseAllLimit())
      return(false);    
   if(!CreateButtonCloseAllLimitBuy())
      return(false);   
   if(!CreateButtonCloseAllLimitSell())
      return(false);   
       
   if(!CreateLabel())
      return(false);   
   if(!CreateEdit())
      return(false);                  

   if(!CreateLabelOrderInformation())
      return(false);
    if(!CreateEditLabelOrders())
       return(false); 
   if(!CreateEditLabelLots())
      return(false);
   if(!CreateLabelTakeProfit())
      return(false); 
   if(!CreateEditLabelTakeProfitPrice())
      return(false); 
   if(!CreateEditLabelTakeProfitPoints())
      return(false);
   if(!CreateLabelStopLoss())
      return(false); 
   if(!CreateEditLabelStopLossPrice())
      return(false); 
   if(!CreateEditLabelStopLossPoints())
      return(false);
   if(!CreateLabelSymbolDetails())
      return(false);
   if(!CreateLabelBID())
      return(false);
   if(!CreateLabelSPREAD())
      return(false);
   if(!CreateLabelASK())
      return(false);
   if(!CreateLabelPositionType())
      return(false);

//--- succeed
   return(true);
  }
  
  






 




























  
  
  
  
  
  
  
  
  
//+------------------------------------------------------------------+
//| Create the "ButtonBuy" button                                      |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonBuy(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;        // x1            = 11  pixels
   int y1=INDENT_TOP;         // y1            = 11  pixels
   int x2=x1+BUTTON_WIDTH;    // x2 = 11 + 100 = 111 pixels
   int y2=y1+BUTTON_HEIGHT;   // y2 = 11 + 20  = 32  pixels
//--- create
   if(!m_buttonBuy.Create(0,"ButtonBuy",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonBuy.Text("Open BUY"))
      return(false);
   if(!Add(m_buttonBuy))
      return(false);
//--- succeed
   return(true);
  }

  //+------------------------------------------------------------------+
//| Create the "ButtonSell"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonSell(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;        // x1            = 11  pixels
   int y1=INDENT_TOP+33;         // y1            = 11  pixels
   int x2=x1+BUTTON_WIDTH;    // x2 = 11 + 100 = 111 pixels
   int y2=y1+BUTTON_HEIGHT;   // y2 = 11 + 20  = 32  pixels
//--- create
   if(!m_buttonSell.Create(0,"ButtonSell",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonSell.Text("Open SELL"))
      return(false);
   if(!Add(m_buttonSell))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "ButtonCloseAll"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonCloseAll(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X);   // x1 = 11  + 2 * (100 + 5) = 221 pixels
   int y1=INDENT_TOP;                                    // y1                       = 11  pixels
   int x2=x1+BUTTON_WIDTH;                               // x2 = 221 + 100           = 321 pixels
   int y2=y1+BUTTON_HEIGHT;                              // y2 = 11  + 20            = 31  pixels
//--- create
   if(!m_buttonCloseAll.Create(0,"ButtonCloseAll",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonCloseAll.Text("Close All"))
      return(false);
   if(!Add(m_buttonCloseAll))
      return(false);
//--- succeed
   return(true);
  }
  
//+------------------------------------------------------------------+
//| Create the "ButtonCloseAll"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonCloseAllBuy(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+1*(BUTTON_WIDTH+CONTROLS_GAP_X);   // x1 = 11  + 2 * (100 + 5) = 221 pixels
   int y1=INDENT_TOP;                                    // y1                       = 11  pixels
   int x2=x1+BUTTON_WIDTH;                               // x2 = 221 + 100           = 321 pixels
   int y2=y1+BUTTON_HEIGHT;                              // y2 = 11  + 20            = 31  pixels
//--- create
   if(!m_buttonCloseAllBuy.Create(0,"ButtonCloseAllBuy",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonCloseAllBuy.Text("Close All Buy"))
      return(false);
   if(!Add(m_buttonCloseAllBuy))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "ButtonCloseAll"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonCloseAllSell(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+1*(BUTTON_WIDTH+CONTROLS_GAP_X);   // x1 = 11  + 2 * (100 + 5) = 221 pixels
   int y1=INDENT_TOP+33;                                    // y1                       = 11  pixels
   int x2=x1+BUTTON_WIDTH;                               // x2 = 221 + 100           = 321 pixels
   int y2=y1+BUTTON_HEIGHT;                              // y2 = 11  + 20            = 31  pixels
//--- create
   if(!m_buttonCloseAllSell.Create(0,"ButtonCloseAllSell",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonCloseAllSell.Text("Close All Sell"))
      return(false);
   if(!Add(m_buttonCloseAllSell))
      return(false);
//--- succeed
   return(true);
  }


  
 //+------------------------------------------------------------------+
//| Create the "ButtonBuy" button                                      |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonBuyLimit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;        // x1            = 11  pixels
   int y1=INDENT_LIMIT_SECTION_TOP;         // y1            = 11  pixels
   int x2=x1+BUTTON_WIDTH;    // x2 = 11 + 100 = 111 pixels
   int y2=y1+BUTTON_HEIGHT;   // y2 = 11 + 20  = 32  pixels
//--- create
   if(!m_buttonBuyLimit.Create(0,"ButtonBuyLimit",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonBuyLimit.Text("Open BUY Limit"))
      return(false);
   if(!Add(m_buttonBuyLimit))
      return(false);
//--- succeed
   return(true);
  }

  //+------------------------------------------------------------------+
//| Create the "ButtonSell"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonSellLimit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;        // x1            = 11  pixels
   int y1=INDENT_LIMIT_SECTION_TOP+33;         // y1            = 11  pixels
   int x2=x1+BUTTON_WIDTH;    // x2 = 11 + 100 = 111 pixels
   int y2=y1+BUTTON_HEIGHT;   // y2 = 11 + 20  = 32  pixels
//--- create
   if(!m_buttonSellLimit.Create(0,"ButtonSellLimit",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonSellLimit.Text("Open SELL Limit"))
      return(false);
   if(!Add(m_buttonSellLimit))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "ButtonCloseAll"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonCloseAllLimit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X);   // x1 = 11  + 2 * (100 + 5) = 221 pixels
   int y1=INDENT_LIMIT_SECTION_TOP;                                    // y1                       = 11  pixels
   int x2=x1+BUTTON_WIDTH;                               // x2 = 221 + 100           = 321 pixels
   int y2=y1+BUTTON_HEIGHT;                              // y2 = 11  + 20            = 31  pixels
//--- create
   if(!m_buttonCloseAllLimit.Create(0,"ButtonCloseAllLimit",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonCloseAllLimit.Text("Close All Limit"))
      return(false);
   if(!Add(m_buttonCloseAllLimit))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "ButtonCloseAll Buy"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonCloseAllLimitBuy(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+1*(BUTTON_WIDTH+CONTROLS_GAP_X);   // x1 = 11  + 2 * (100 + 5) = 221 pixels
   int y1=INDENT_LIMIT_SECTION_TOP;                                    // y1                       = 11  pixels
   int x2=x1+BUTTON_WIDTH;                               // x2 = 221 + 100           = 321 pixels
   int y2=y1+BUTTON_HEIGHT;                              // y2 = 11  + 20            = 31  pixels
//--- create
   if(!m_buttonCloseAllLimitBuy.Create(0,"ButtonCloseAllLimitBuy",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonCloseAllLimitBuy.Text("Close All Limit Buy"))
      return(false);
   if(!Add(m_buttonCloseAllLimitBuy))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "ButtonCloseAll Limit"                                             |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateButtonCloseAllLimitSell(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+1*(BUTTON_WIDTH+CONTROLS_GAP_X);   // x1 = 11  + 2 * (100 + 5) = 221 pixels
   int y1=INDENT_LIMIT_SECTION_TOP+33;                                    // y1                       = 11  pixels
   int x2=x1+BUTTON_WIDTH;                               // x2 = 221 + 100           = 321 pixels
   int y2=y1+BUTTON_HEIGHT;                              // y2 = 11  + 20            = 31  pixels
//--- create
   if(!m_buttonCloseAllLimitSell.Create(0,"ButtonCloseAllLimitSell",0,x1,y1,x2,y2))
      return(false);
   if(!m_buttonCloseAllLimitSell.Text("Close All Limit Sell"))
      return(false);
   if(!Add(m_buttonCloseAllLimitSell))
      return(false);
//--- succeed
   return(true);
  }       
 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabel(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+CONTROLS_GAP_Y+120;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_label.Create(m_chart_id,m_name+"Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_label.Text("Price : "))
      return(false);
   if(!Add(m_label))
      return(false);
//--- succeed
   return(true);
  }  
//+------------------------------------------------------------------+
//| Create the display field                                         |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT  + 100;
   int y1=INDENT_TOP+120;
   int x2=x1+70;
   int y2=y1+20;
//--- create
   if(!m_edit.Create(m_chart_id,m_name+"Edit",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_edit.Text(SymbolInfoDouble(Symbol(),SYMBOL_BID)))
      return(false);
   if(!m_edit.ReadOnly(false))
      return(false);
   if(!Add(m_edit))
      return(false);
//--- succeed
   return(true);
  }  
 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelOrderInformation(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_POSITION_SECTION_TOP;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelOrderInformation.Create(m_chart_id,m_name+"LabelOrderInformation",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelOrderInformation.Text("*********Order Information*********"))
      return(false);
   if(!Add(m_labelOrderInformation))
      return(false);
//--- succeed
   return(true);
  }    
//+------------------------------------------------------------------+
//| Create the display field                                         |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateEditLabelOrders(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_POSITION_SECTION_TOP+20;
   int x2=x1+50;
   int y2=y1+20;
 
//--- create
   if(!m_labelOrders.Create(m_chart_id,m_name+"LabelOrders",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelOrders.Text("Orders : "))
      return(false);
   if(!Add(m_labelOrders))
      return(false);
 
//--- create
   if(!m_editOrders.Create(m_chart_id,m_name+"EditOrders",m_subwin,x1 + 100,y1,x2+100,y2))
      return(false);
//--- allow editing the content
   if(!m_editOrders.Text("5"))
      return(false);
   if(!m_editOrders.ReadOnly(false))
      return(false);
   if(!Add(m_editOrders))
      return(false);
 
//--- succeed
   return(true);
  } 
//+------------------------------------------------------------------+
//| Create the display field                                         |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateEditLabelLots(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+160;
   int y1=INDENT_POSITION_SECTION_TOP+20;
   int x2=x1+50;
   int y2=y1+20;
 
//--- create
   if(!m_labelLots.Create(m_chart_id,m_name+"LabelLots",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelLots.Text("Lots : "))
      return(false);
   if(!Add(m_labelLots))
      return(false);
 
//--- create
   if(!m_editLots.Create(m_chart_id,m_name+"EditLots",m_subwin,x1 + 100,y1,x2+100,y2))
      return(false);
//--- allow editing the content
   //if(!m_editLots.Text(DoubleToString(Spread, Digits)))
   if(!m_editLots.Text("0.01"))
      return(false);
   if(!m_editLots.ReadOnly(false))
      return(false);
   if(!Add(m_editLots))
      return(false);

//--- succeed
   return(true);
  } 
 
 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelTakeProfit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TAKEPROFIT_SECTION_TOP;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelTakeProfit.Create(m_chart_id,m_name+"LabelTakeProfit",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelTakeProfit.Text("*********Take Profit*********"))
      return(false);
   if(!Add(m_labelTakeProfit))
      return(false);
//--- succeed
   return(true);
  }  

//+------------------------------------------------------------------+
//| Create the display field                                         |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateEditLabelTakeProfitPrice(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TAKEPROFIT_SECTION_TOP+20;
   int x2=x1+50;
   int y2=y1+20;
 
//--- create
   if(!m_labelTakeProfitPrice.Create(m_chart_id,m_name+"LabelTakeProfitPrice",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelTakeProfitPrice.Text("TakeProfitPrice : "))
      return(false);
   if(!Add(m_labelTakeProfitPrice))
      return(false);
 
//--- create
   if(!m_editTakeProfitPrice.Create(m_chart_id,m_name+"EditTakeProfitPrice",m_subwin,x1 + 100,y1,x2+100,y2))
      return(false);
//--- allow editing the content
   if(!m_editTakeProfitPrice.ReadOnly(false))
      return(false);
   if(!Add(m_editTakeProfitPrice))
      return(false);

//--- succeed
   return(true);
  } 

//+------------------------------------------------------------------+
//| Create the display field                                         |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateEditLabelTakeProfitPoints(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+160;
   int y1=INDENT_TAKEPROFIT_SECTION_TOP+20;
   int x2=x1+50;
   int y2=y1+20;
 
//--- create
   if(!m_labelTakeProfitPoints.Create(m_chart_id,m_name+"LabelTakeProfitPoints",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelTakeProfitPoints.Text("TakeProfitPoints : "))
      return(false);
   if(!Add(m_labelTakeProfitPoints))
      return(false);
 
//--- create
   if(!m_editTakeProfitPoints.Create(m_chart_id,m_name+"EditTakeProfitPoints",m_subwin,x1 + 100,y1,x2+100,y2))
      return(false);
//--- allow editing the content
    if(!m_editTakeProfitPoints.Text("100"))
      return(false);
   if(!m_editTakeProfitPoints.ReadOnly(false))
      return(false);
   if(!Add(m_editTakeProfitPoints))
      return(false);

//--- succeed
   return(true);
  } 

 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelStopLoss(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_STOPLOSS_SECTION_TOP;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelStopLoss.Create(m_chart_id,m_name+"LabelStopLoss",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelStopLoss.Text("*********STOP LOSS*********"))
      return(false);
   if(!Add(m_labelStopLoss))
      return(false);
//--- succeed
   return(true);
  }  

//+------------------------------------------------------------------+
//| Create the display field                                         |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateEditLabelStopLossPrice(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_STOPLOSS_SECTION_TOP+20;
   int x2=x1+50;
   int y2=y1+20;
 
//--- create
   if(!m_labelStopLossPrice.Create(m_chart_id,m_name+"LabelStopLossPrice",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelStopLossPrice.Text("StopLossPrice : "))
      return(false);
   if(!Add(m_labelStopLossPrice))
      return(false);
 
//--- create
   if(!m_editStopLossPrice.Create(m_chart_id,m_name+"EditStopLossPrice",m_subwin,x1 + 100,y1,x2+100,y2))
      return(false);
//--- allow editing the content
   if(!m_editStopLossPrice.ReadOnly(false))
      return(false);
   if(!Add(m_editStopLossPrice))
      return(false);

//--- succeed
   return(true);
  } 

//+------------------------------------------------------------------+
//| Create the display field                                         |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateEditLabelStopLossPoints(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+160;
   int y1=INDENT_STOPLOSS_SECTION_TOP+20;
   int x2=x1+50;
   int y2=y1+20;
 
//--- create
   if(!m_labelStopLossPoints.Create(m_chart_id,m_name+"LabelStopLossPoints",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelStopLossPoints.Text("StopLossPoints : "))
      return(false);
   if(!Add(m_labelStopLossPoints))
      return(false);
 
//--- create
   if(!m_editStopLossPoints.Create(m_chart_id,m_name+"EditStopLossPoints",m_subwin,x1 + 100,y1,x2+100,y2))
      return(false);
//--- allow editing the content
   if(!m_editStopLossPoints.Text("50"))
      return(false);
   if(!m_editStopLossPoints.ReadOnly(false))
      return(false);
   if(!Add(m_editStopLossPoints))
      return(false);

//--- succeed
   return(true);
  } 
 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelSymbolDetails(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_SYMBOLDETAILS_SECTION_TOP;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelSymbolDetails.Create(m_chart_id,m_name+"LabelSymbolDetails",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelSymbolDetails.Text("**************SYMBOL**********"))
      return(false);
   if(!Add(m_labelSymbolDetails))
      return(false);
//--- succeed
   return(true);
  }  
 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelBID(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_SYMBOLDETAILS_SECTION_TOP+20;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelBID.Create(m_chart_id,m_name+"LabelBID",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelBID.Text("****BID****"))
      return(false);
   if(!Add(m_labelBID))
      return(false);
//--- succeed
   return(true);
  }  
 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelSPREAD(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+100;
   int y1=INDENT_SYMBOLDETAILS_SECTION_TOP+20;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelSPREAD.Create(m_chart_id,m_name+"LabelSPREAD",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelSPREAD.Text("****SPREAD****"))
      return(false);
   if(!Add(m_labelSPREAD))
      return(false);
//--- succeed
   return(true);
  }  
 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelASK(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+200;
   int y1=INDENT_SYMBOLDETAILS_SECTION_TOP+20;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelASK.Create(m_chart_id,m_name+"LabelASK",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelASK.Text("****ASK****"))
      return(false);
   if(!Add(m_labelASK))
      return(false);
//--- succeed
   return(true);
  }  

 //+------------------------------------------------------------------+
//| Create the "CLabel"                                              |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::CreateLabelPositionType(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_SYMBOLDETAILS_SECTION_TOP+40;
   int x2=x1+100;
   int y2=y1+20;
//--- create
   if(!m_labelPositionType.Create(m_chart_id,m_name+"LabelPositionType",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_labelPositionType.Text("########POSITION TYPE = "))
      return(false);
   if(!Add(m_labelPositionType))
      return(false);
//--- succeed
   return(true);
  } 






















   
   
   
   
   
   
   
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonBuy(void)
  {
   //CSymbolInfo mysymbol;
   //mysymbol.Name( Symbol() );
  
   int Stoploss = 100;
   int Takeprofit = 50; 
   double Lots = 1.00;
   int numberOfOrders = 5;
 
   Stoploss = StringToInteger(m_editStopLossPoints.Text());;
   Takeprofit = StringToInteger(m_editTakeProfitPoints.Text());; 
   numberOfOrders = StringToInteger(m_editOrders.Text());
   Lots = StringToDouble(m_editLots.Text()); 
 
   // Stoploss must have been defined 
   double SL = SymbolInfoDouble(_Symbol,SYMBOL_ASK) - Stoploss*_Point; 
   //Takeprofit must have been defined
   double TP = SymbolInfoDouble(_Symbol,SYMBOL_ASK) +Takeprofit*_Point;
   // latest ask price using CSymbolInfo class object
   double Oprice = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   // open a buy trade
   
   
   //OR
  // m_trade.Buy(Lots,NULL,0.0,0.0,0.0,â€œBuy Tradeâ€);
   // modify position later

  // if(m_account.TradeMode()==ACCOUNT_TRADE_MODE_DEMO){
       
      for(int x = 0; x<numberOfOrders; x++){
         m_trade.Buy(Lots,NULL,Oprice,SL,TP,"Buy Trade");
      }
   
   /*
      m_trade.Buy(0.01); 
      m_trade.Buy(0.01);*/
  // } 
  }
  //+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonSell(void)
  {
 //  if(m_account.TradeMode()==ACCOUNT_TRADE_MODE_DEMO){
   
   int Stoploss =100;
   int Takeprofit = 50; 
   double Lots = 1.00;
   int numberOfOrders = 5;
   
   Stoploss = StringToInteger(m_editStopLossPoints.Text());;
   Takeprofit = StringToInteger(m_editTakeProfitPoints.Text());; 
   numberOfOrders = StringToInteger(m_editOrders.Text());
   Lots = StringToDouble(m_editLots.Text()); 
   
   
   // Stoploss must have been defined 
   double SL = SymbolInfoDouble(_Symbol,SYMBOL_BID) + Stoploss*_Point; 
   //Takeprofit must have been defined
   double TP = SymbolInfoDouble(_Symbol,SYMBOL_BID) -Takeprofit*_Point;
   // latest ask price using CSymbolInfo class object
   double Oprice = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   
   for(int x = 0; x<numberOfOrders; x++){
     m_trade.Sell(Lots,NULL,Oprice,SL,TP,"Sell Trade");
   }
  
 // Print("Currently",m_edit.Text() );
   /*
      m_trade.Sell(0.01);
      m_trade.Sell(0.01); 
      */
 //  } 
  }
  
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonCloseAll(void)
  {
   //if(m_account.TradeMode()==ACCOUNT_TRADE_MODE_DEMO)
      for(int i=PositionsTotal()-1;i>=0;i--) // returns the number of current positions
         if(m_position.SelectByIndex(i)) // selects the position by index for further access to its properties
            if(m_position.Symbol()==Symbol())
               m_trade.PositionClose(m_position.Ticket()); // close a position by the specified symbol
  }
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonCloseAllBuy(void)
  {
   //if(m_account.TradeMode()==ACCOUNT_TRADE_MODE_DEMO)
      for(int i=PositionsTotal()-1;i>=0;i--) // returns the number of current positions
         if(m_position.SelectByIndex(i)) // selects the position by index for further access to its properties
            if(m_position.Symbol()==Symbol())
               if( m_position.Type() == POSITION_TYPE_BUY )
                  m_trade.PositionClose(m_position.Ticket()); // close a position by the specified symbol
  }  
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonCloseAllSell(void)
  {
   //if(m_account.TradeMode()==ACCOUNT_TRADE_MODE_DEMO)
      for(int i=PositionsTotal()-1;i>=0;i--) // returns the number of current positions
         if(m_position.SelectByIndex(i)) // selects the position by index for further access to its properties
            if(m_position.Symbol()==Symbol())
               if( m_position.Type() == POSITION_TYPE_SELL )
                  m_trade.PositionClose(m_position.Ticket()); // close a position by the specified symbol
  }  
  
  
  
   
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonBuyLimit(void)
  {
   int Stoploss =10;
   int Takeprofit = 20; 
   double Lots = 0.01;
   int numberOfOrders = 5;
   double price = 138.985;


   Stoploss = StringToInteger(m_editStopLossPoints.Text());
   Takeprofit = StringToInteger(m_editTakeProfitPoints.Text()); 
   numberOfOrders = StringToInteger(m_editOrders.Text());
   Lots = StringToDouble(m_editLots.Text());
   price = StringToDouble( m_edit.Text());

    
   double SL = price - Stoploss*_Point;  
   double TP = price + Takeprofit*_Point;  
   
   for(int x = 0; x<numberOfOrders; x++){
    uint res=SendRandomPendingOrder(44444,ORDER_TYPE_BUY_STOP,price,SL,TP);
      Print("Return code of the trade server ",res);
   } 
  }
  //+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonSellLimit(void)
  { 
   int Stoploss =10;
   int Takeprofit = 10; 
   double Lots = 0.01;
   int numberOfOrders = 5;
   double price = 136.685;
 
   Stoploss = StringToInteger(m_editStopLossPoints.Text());
   Takeprofit = StringToInteger(m_editTakeProfitPoints.Text()); 
   numberOfOrders = StringToInteger(m_editOrders.Text());
   Lots = StringToDouble(m_editLots.Text());
   price = StringToDouble( m_edit.Text());

   double SL = price + Stoploss*_Point;  
   double TP = price - Takeprofit*_Point;  
   
   for(int x = 0; x<numberOfOrders; x++){
    uint res=SendRandomPendingOrder(55555,ORDER_TYPE_SELL_STOP,price,SL,TP);
      Print("Return code of the trade server ",res);
   } 
  }
  
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonCloseAllLimit(void)
  {
   DeleteAllOrdersByMagic(44444);
   DeleteAllOrdersByMagic(55555);
  }
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonCloseAllLimitBuy(void)
  {
   DeleteAllOrdersByMagic(44444);
  }
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickButtonCloseAllLimitSell(void)
  {
   DeleteAllOrdersByMagic(55555);
  }  
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickLabelASK(void)
  {
    m_edit.Text(SymbolInfoDouble(Symbol(),SYMBOL_ASK) );
  }  
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::OnClickLabelBID(void)
  {
    m_edit.Text(SymbolInfoDouble(Symbol(),SYMBOL_BID) );
  }  

//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
bool CAppWindowTwoButtons::UpdateForm()
  {


 //  Print("SYMBOL_ASK  ",SymbolInfoDouble(Symbol(),SYMBOL_ASK)); 

 //--- update the content
   if(!m_labelASK.Text("ASK="+ SymbolInfoDouble(Symbol(),SYMBOL_ASK)))
      return(false);
   if(!m_labelBID.Text("BID="+ SymbolInfoDouble(Symbol(),SYMBOL_BID)))
      return(false);
   if(!m_labelSPREAD.Text("SPREAD="+ SymbolInfoInteger(Symbol(),SYMBOL_SPREAD) ))
      return(false); 

double RiskRewardRatio = (GetPositionPrice() - GetStopLossPrice(GetPositionPrice())) / ( GetTakeProfitPrice(GetPositionPrice()) - GetPositionPrice());
string newTradeInfo = "POSITION TYPE=";

   if( GetPositionPrice() <  SymbolInfoDouble(Symbol(),SYMBOL_ASK)  ){ 
      newTradeInfo += "BUY LIMIT ";      
   }else{
      newTradeInfo += "SELL LIMIT "; 
   }

   newTradeInfo += " RRR=" +  DoubleToString(RiskRewardRatio,2);

   if( DoubleToString(RiskRewardRatio,2) >= 1.0){
      newTradeInfo += " Class= BAD";
   }else{
      newTradeInfo += " Class= Good";
   }

   if(!m_labelPositionType.Text(newTradeInfo))
         return(false);   
   
//--- succeed
   return(true);
 
  }   
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CAppWindowTwoButtons::SetPositionPrice(double price)
  {

      m_edit.Text(price);
      m_editTakeProfitPrice.Text(GetTakeProfitPrice(price));
      m_editStopLossPrice.Text(GetStopLossPrice(price)); 
     
 
  }   
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
double CAppWindowTwoButtons::GetTakeProfitPrice(double price)
  { 
      double p = 0.00;
      if( price > SymbolInfoDouble(Symbol(),SYMBOL_BID) ){  //BUY LIMIT
            p = price + StringToInteger(m_editTakeProfitPoints.Text()) *_Point;
      }else{
            p = price - StringToInteger(m_editTakeProfitPoints.Text()) *_Point;
      }

      return p;
  }   
double CAppWindowTwoButtons::GetStopLossPrice(double price)
  { 
      double p = 0.00;
      if( price < SymbolInfoDouble(Symbol(),SYMBOL_ASK) ){  //BUY LIMIT
            p = price + StringToInteger(m_editStopLossPoints.Text()) *_Point;
      }else{
            p = price - StringToInteger(m_editStopLossPoints.Text()) *_Point;
      }

      return p;
  }   
double CAppWindowTwoButtons::GetPositionPrice()
  {  
      return StringToDouble(m_edit.Text());
  }   
         
   
void CAppWindowTwoButtons::SetTakeProfitPrice(double price)
  { 
      m_editTakeProfitPrice.Text(price); 
      m_editTakeProfitPoints.Text( MathAbs(( GetPositionPrice() - price ) / _Point ));  
  }     

void CAppWindowTwoButtons::SetStopLossPrice(double price)
  { 
      m_editStopLossPrice.Text(price); 
      m_editStopLossPoints.Text(  MathAbs(( GetPositionPrice() - price ) / _Point )); 
  }    
  
  
  
  
  
  
  
  
  
  
  
  
  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Sets a pending order in a random way                             |
//+------------------------------------------------------------------+
uint SendRandomPendingOrder(long const magic_number,ENUM_ORDER_TYPE type, double price ,double Stoploss,double Takeprofit)
  {
//--- prepare a request
   MqlTradeRequest request={};
   request.action=TRADE_ACTION_PENDING;         // setting a pending order
   request.magic=magic_number;                  // ORDER_MAGIC
   request.symbol=_Symbol;                      // symbol
   request.volume=0.1;                          // volume in 0.1 lots
   request.sl=Stoploss;                                // Stop Loss is not specified
   request.tp=Takeprofit;                                // Take Profit is not specified     
//--- form the order type
   request.type=type;                // order type
//--- form the price for the pending order
   request.price=price;  // open price
//--- send a trade request
   MqlTradeResult result={};
   OrderSend(request,result);
//--- write the server reply to log  
   Print(__FUNCTION__,":",result.comment);
   if(result.retcode==10016) Print(result.bid,result.ask,result.price);
//--- return code of the trade server reply
   return result.retcode;
  }
  
//+------------------------------------------------------------------+
//| Deletes all pending orders with specified ORDER_MAGIC            |
//+------------------------------------------------------------------+
void DeleteAllOrdersByMagic(long const magic_number)
  {
   ulong order_ticket;
//--- go through all pending orders
   for(int i=OrdersTotal()-1;i>=0;i--)
      if((order_ticket=OrderGetTicket(i))>0)
         //--- order with appropriate ORDER_MAGIC
         if(magic_number==OrderGetInteger(ORDER_MAGIC))
           {
            MqlTradeResult result={};
            MqlTradeRequest request={};
            request.order=order_ticket;
            request.action=TRADE_ACTION_REMOVE;
            OrderSend(request,result);
            //--- write the server reply to log
            Print(__FUNCTION__,": ",result.comment," reply code ",result.retcode);
           }
//---
  }