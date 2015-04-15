/* Trigger Name :HSFE_Opportunity_TriggerHandler
*Description:This trigger calls a HSFE_OpportunityTriggerHandler_Class to execute the trigger logic
*Created By :Chiranth Aradhya 
*Created On :02/24/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
trigger HSFE_Opportunity_TriggerHandler on Opportunity (before Insert , before Update, after Insert , after Update) {
      
    if(trigger.isBefore){
        if(trigger.isInsert){
            HSFE_OpportunityTriggerHandler_Class.handleBeforeInsert(trigger.new);
        } 
        if(trigger.isUpdate){
            HSFE_OpportunityTriggerHandler_Class.handleBeforeUpdate(trigger.new, trigger.oldMap);
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            HSFE_OpportunityTriggerHandler_Class.handleAfterInsert(trigger.newMap);
        } 
        if(trigger.isUpdate){
            HSFE_OpportunityTriggerHandler_Class.handleAfterUpdate(trigger.oldMap,trigger.newMap);
        } 
    }
}