/* Trigger Name :HSFE_Account_TriggerHandler
*Description:This trigger calls a HSFE_AccountTriggerHandler_Class to execute the trigger logic
*Created By :Sourav Datta
*Created On :03/17/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
trigger HSFE_Account_TriggerHandler on Account (after insert, after update) {
    if(trigger.isAfter){
    
        if(trigger.isInsert){
        
            HSFE_AccountTriggerHandler_Class.handleAfterInsert(trigger.newMap);
            
        } else if(trigger.isUpdate){
        
            HSFE_AccountTriggerHandler_Class.handleAfterUpdate(trigger.newMap, trigger.oldMap);
        
        }
    }

}