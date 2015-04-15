/* Trigger Name :HSFE_Account_TriggerHandler
*Description:This trigger calls a HSFE_AccountTriggerHandler_Class to execute the trigger logic
*Created By :Sourav Datta
*Created On :04/08/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
trigger HSFE_ZipToTerritory_TriggerHandler on HSFE_Zip_To_Territory__c (after delete, after insert, after update, before update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            HSFE_TerritoryObjsTriggerHandler_Class.handleZipToTerrAfterInsertDelete(trigger.new);
        } else if(trigger.isUpdate){
            HSFE_TerritoryObjsTriggerHandler_Class.handleZipToTerrAfterUpdate(trigger.newMap, trigger.oldMap);
        } else if(trigger.isDelete){
        	HSFE_TerritoryObjsTriggerHandler_Class.handleZipToTerrAfterInsertDelete(trigger.old);
        }
    }
    if(trigger.isBefore){
        if(trigger.isUpdate){
            HSFE_TerritoryObjsTriggerHandler_Class.handleZipToTerrBeforeUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}