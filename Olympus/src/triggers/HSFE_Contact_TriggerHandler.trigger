/* Trigger Name :HSFE_Contact_TriggerHandler
*Description:This trigger calls a HSFE_ContactTriggerHandler_Class to execute the trigger logic
*Created By :Chiranth Aradhya 
*Created On :02/17/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
trigger HSFE_Contact_TriggerHandler on Contact (before insert, before update) {
    
    if(trigger.isBefore){
    
        if(trigger.isInsert){
        
            HSFE_ContactTriggerHandler_Class.handleBeforeInsert(trigger.new);
            HSFE_ContactTriggerHandler_Class.deactivateBeforeInsert(trigger.new);
            //HSFE_ContactTriggerHandler_Class.assignTerritory(trigger.new);
            
        } else if(trigger.isUpdate){
        
            HSFE_ContactTriggerHandler_Class.handleBeforeUpdate(trigger.new);
            //HSFE_ContactTriggerHandler_Class.assignTerritory(trigger.new);
            HSFE_ContactTriggerHandler_Class.activateDeactivateBeforeUpdate(trigger.newMap, trigger.oldMap);
        
        }
    }
}