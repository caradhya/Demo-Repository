/* 
*Class Name :HSFE_LeadTriggerHandler_TestClass 
*Description :This test class test the functionlity and covers the code for HSFE_Lead_TriggerHandler trigger.
*Created By  :Sunil Kumar
*Created On  :02/26/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sunil              2/26/2015                      Created                          
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
@isTest 
private class HSFE_LeadTriggerHandler_TestClass {
    static testmethod void testmethod1() {
    
        //Insert Role
        UserRole r = HSFE_TestUtility_Class.createRole();
        insert r;
       //Insert User record
        User Usr =  HSFE_TestUtility_Class.createUser(r);
        insert Usr;
        
        System.runAs(usr){         
	       //Insert the account record       
	        Account acc = HSFE_TestUtility_Class.createAccountRecord();
	        insert acc;
	        
	        //check whether account is inserted properly
	        System.Assert(acc.Id != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');
	        
	         //Insert Territory record
	        HSEF_Territory__c terry = HSFE_TestUtility_Class.createTerritory();
	        insert terry;
	        
	        //Insert Territory to User
	        HSFE_Territory_To_User__c trrToUsr= HSFE_TestUtility_Class.createTerritoryUser(Usr,terry);
	        insert trrToUsr;
	        
	        //Insert Zip to Territory
	        HSFE_Zip_To_Territory__c zipToTerr=  HSFE_TestUtility_Class.createHSFEZipterr(terry);
	        insert zipToTerr;        
	        system.debug('**********createHSFEZipterrcombination*********'+zipToTerr.HSFE_Combination_Key__c);
	        
	        //Insert the Lead record
	        Lead lead = HSFE_TestUtility_Class.createLeadRecord(acc);
	        insert lead;       
	        
	        //Check account name populated is based on the SAP ID
	        System.Assert(lead.HSFE_Account__c != null, 'Validate Account is populated based on the SAP ID');
	        Lead l = [select HSFE_Territory__c,ownerID from lead where id =: lead.id];
	        System.Assert(l.HSFE_Territory__c == terry.id); //Validate territroy.
	        System.Assert(l.ownerid == Usr.id); // Validate Lead Owner 
        }   
    }	
    
    public static testMethod void testmethod2(){
        //test.startTest();
        //Insert Role
        UserRole r = HSFE_TestUtility_Class.createRole();
        insert r;
       //Insert User record
        User Usr =  HSFE_TestUtility_Class.createUser(r);
        insert Usr;
        System.runAs(usr){ 
         	   //Insert the account record       
	        Account acc = HSFE_TestUtility_Class.createAccountRecord();
	        insert acc;
	        
	        //check whether account is inserted properly
	        System.Assert(acc.Id != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');
	        
	         //Insert Territory record
	        HSEF_Territory__c terry = HSFE_TestUtility_Class.createTerritory();
	        insert terry;
	        
	        //Insert Territory to User
	        HSFE_Territory_To_User__c trrToUsr= HSFE_TestUtility_Class.createTerritoryUser(Usr,terry);
	        insert trrToUsr;
	        
            //Insert Territory Exception
            HSFE_Territory_Exception__c trrException = HSFE_TestUtility_class.createHSFETerritoryException(terry);
            insert trrException;
            
	        //Insert Zip to Territory
	        HSFE_Zip_To_Territory__c zipToTerr=  HSFE_TestUtility_Class.createHSFEZipterr3(terry);
	        insert zipToTerr;        
	        system.debug('**********createHSFEZipterrcombination*********'+zipToTerr.HSFE_Combination_Key__c);
	        
	        //Insert the Lead record
	        Lead lead1 = HSFE_TestUtility_Class.createLeadRecord2(acc);
	        insert lead1; 
            
            System.debug('Lead Inserted : ' + lead1.Id + ' :' + lead1.HSFE_Territory__c);
	        
	        //Check account name populated is based on the SAP ID
	        System.Assert(lead1.HSFE_Account__c != null, 'Validate Account is populated based on the SAP ID');
	        Lead l = [select ownerID from lead where id =: lead1.id];
	        System.Assert(l.HSFE_Territory__c == terry.id); //Validate territory.
	        System.Assert(l.ownerid == Usr.id); // Validate Lead Owner 
        }
            
    }
}