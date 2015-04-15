/*Trigger Name :HSFE_Product_TriggerHandler
* Description  :This trigger calls a HSFE_Product_TriggerHandler to execute the trigger logic
* Created By   :Yunus H Navalur 
* Created On   :02/20/2015
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/

trigger HSFE_Product_TriggerHandler on Product2 (Before insert,Before Update) {

    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            /* 
            * Created on : 3/16/2015
            * Author     : Yunus H Navalur
            * Description : Logic to control charge types on product based on Product conditions.
            * Last Mod by: Yunus H Navalur
            */
            HSFE_ProductTriggerHandler_Class ProductHandlr = new HSFE_ProductTriggerHandler_Class();
            ProductHandlr.ProductConditionPopulateLogic_Update(trigger.newmap,trigger.oldmap);          
        }
        if(trigger.isInsert){
            HSFE_ProductTriggerHandler_Class ProductHandlr = new HSFE_ProductTriggerHandler_Class();
            ProductHandlr.ProductConditionPopulateLogic_Insert(trigger.new);        
        }
    }       
}