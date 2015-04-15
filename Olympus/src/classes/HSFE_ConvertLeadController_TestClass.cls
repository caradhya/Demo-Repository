/* 
*Class Name :HSFE_ConvertLeadController_TestClass 
*Description :This test class test the functionlity and covers the code for HSFEContactTriggerHandler trigger.
*Created By  :Chiranth Aradhya
*Created On  :02/17/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
@isTest   
private class HSFE_ConvertLeadController_TestClass {
   
    static testMethod void test(){
        //Insert the account record       
        Account acc = HSFE_TestUtility_Class.createAccountRecord();
        insert acc;
        
        //Insert the lead record 
        Lead l1 = HSFE_TestUtility_Class.createLeadRecord(acc);
        l1.Status='Converted';
        insert l1;
        
        HSFE_CustomConvertLead_Controller.HSFEConvertLeadMethod(l1.Id,acc.Id);
    }
    
    
    
}