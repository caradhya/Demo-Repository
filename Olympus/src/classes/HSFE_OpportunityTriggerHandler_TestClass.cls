/* 
*Class Name :HSFE_OpportunityTriggerHandler_TestClass 
*Description :This test class test the functionlity and covers the code for HSFEOpportunityTriggerHandler trigger.
*Created By  :Chiranth Aradhya
*Created On  :02/24/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
@isTest                    
private class HSFE_OpportunityTriggerHandler_TestClass {
    @isTest(SeeAllData=true)
    static void testmethod1() {
    
        //Insert  account record       
        Account acc = HSFE_TestUtility_Class.createAccountRecord();
        insert acc;
        
        //check whether account is inserted properly
        System.Assert(acc.Id != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');        

        //Insert  contact record      
        Contact con = HSFE_TestUtility_Class.createContactRecord(acc);
        con.HSFE_Primary__c = True;
        insert con;
        
         //check whether the contact is inserted properly
        System.Assert(con.Id != null, 'The Test Contact did not insert properly, please check validation rules and other mechanisms');
        
        //Insert Custom Setting
        HSFE_Opportunity_Record_Type_Mapping__c   oppRecMaping = HSFE_TestUtility_Class.createCustomSetting();
        insert oppRecMaping ;
        
       
        //Insert Opporuntiy record
        Opportunity opp = HSFE_TestUtility_Class.createOpportunityRecord(acc);
        insert opp;
        
         //check whether the opportunity is inserted properly
         System.Assert(opp.Id != null, 'The Test opportunity did not insert properly, please check validation rules and other mechanisms');
        
     }
     
     @isTest(SeeAllData=true)
    static void testmethod2() {
    
        //Insert  account record       
        Account acc = HSFE_TestUtility_Class.createAccountRecord();
        insert acc;
        
        //check whether account is inserted properly
        System.Assert(acc.Id != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');        

        //Insert  contact record      
        Contact con = HSFE_TestUtility_Class.createContactRecord(acc);
        con.HSFE_Primary__c = True;
        insert con;
        
         //check whether the contact is inserted properly
        System.Assert(con.Id != null, 'The Test Contact did not insert properly, please check validation rules and other mechanisms');
        
        //Insert Custom Setting
        HSFE_Opportunity_Record_Type_Mapping__c   oppRecMaping = HSFE_TestUtility_Class.createCustomSetting();
        insert oppRecMaping ;
        
       
        //Insert Opporuntiy record
        Opportunity opp = HSFE_TestUtility_Class.createOpportunityRecord2(acc);
        opp.HSFE_Opportunity_Type__c='testtype';
        insert opp;
        
        //check whether the opportunity is inserted properly
        System.Assert(opp.Id != null, 'The Test opportunity did not insert properly, please check validation rules and other mechanisms');
        
     }
     
     
}