//+------------------------------------------------------------------+
//|                                                     DXObject.mqh |
//|                             Copyright 2000-2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "DXObjectBase.mqh"
#include "DXMath.mqh"

//--- forward declaration
class CCanvas3D;
//+------------------------------------------------------------------+
//| Class CDXObject                                                  |
//+------------------------------------------------------------------+
class CDXObject : public CDXObjectBase
  {
public:
   //--- render function
   virtual bool      Render(void)=0;
  };
//+------------------------------------------------------------------+
