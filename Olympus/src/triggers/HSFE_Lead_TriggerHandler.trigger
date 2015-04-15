/*************************************************************************************
* Name          :    HSFE_Lead_TriggerHandler.
* Description   :    Trigger used to update account based on the SAP ID.
                :    
* Author        :    Deloitte/Sunil
 
Modification Log
----------------
Date             Developer       Comments
---------------------------------------------------------------------------------------
2/26/2015       Sunil            Created
               

**************************************************************************************/

trigger HSFE_Lead_TriggerHandler on Lead (before insert,before update, after update) {
    //if(HSFE_Utility_Class.runOnce()){
       if(trigger.isBefore){
            if(trigger.isInsert){
                HSFE_LeadTriggerHandler_Class.handleBeforeInsert(trigger.new);
            }else if(trigger.isUpdate){
                HSFE_LeadTriggerHandler_Class.handleBeforeUpdate(trigger.oldMap, trigger.newMap);
            }
        }
        if(trigger.IsAfter){
         
           if(trigger.IsUpdate){
                HSFE_LeadTriggerHandler_Class.handleAfterUpdate(trigger.new,trigger.oldMap);
            }
          
        }
   
}