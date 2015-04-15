/* 
*Class Name :HSFE_ContactTriggerHandler_TestClass 
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
private class HSFE_ContactTriggerHandler_TestClass {
   
    static testmethod void testmethod1() {
    
        //Insert the account record       
        Account acc = HSFE_TestUtility_Class.createAccountRecord();
        insert acc;
        
         //Insert the account record 
        Account acc1= HSFE_TestUtility_Class.createInactiveContacts();
        insert acc1;
        
        //check whether account is inserted properly
        System.Assert(acc.Id != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');        

        //Insert the contact record      
        Contact con = HSFE_TestUtility_Class.createContactRecord(acc);
        con.HSFE_Primary__c = True;
        con.HSFE_Active__c =False;    
        insert con;
        
        //check whether the contact is inserted properly
        System.Assert(con.Id != null, 'The Test Contact did not insert properly, please check validation rules and other mechanisms');
        
        //Update the contact record
        con.HSFE_Primary__c = False;        
        con.HSFE_Active__c =True;    
        con.AccountId=acc1.Id;
        update con;
        
        
        //insert the contact record
        List<Contact> insertContactList = new List<Contact>();
        List<Contact> conList = HSFE_TestUtility_Class.createmultipleContactRecord(acc);
        for(Contact con1:conList){
            con1.HSFE_Active__c =False;
            insertContactList.add(con1);
        }
        insert insertContactList;
        
        List<Contact> updateContactList = new List<Contact>();
        for(Contact con2:conList){
            con2.HSFE_Active__c =True;   
            con2.AccountId=acc.Id;
            updateContactList.add(con2);
        }
        update updateContactList;
        
        List<Contact> updateContactList2 = new List<Contact>();
        for(Contact con3:updateContactList){
            con3.HSFE_Active__c =False;   
            updateContactList2.add(con3);
        }
         update updateContactList2;
        
        //check whether the contact is updated properly
        System.Assert(con.HSFE_Primary__c != True,'Contact was not able to update, please check validation rules and other mechanisms');
       
       
      
        
    }
    static testmethod void testmethod2() {
        
        //Insert the account record 
        Account acc = HSFE_TestUtility_Class.createAccountRecord();
        insert acc;
        
        //check whether the account is inserted properly
        System.Assert(acc.Id != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');
        
        //insert the contact record
        List<Contact> insertContactList = new List<Contact>();
        List<Contact> conList = HSFE_TestUtility_Class.createmultipleContactRecord(acc);
        for(Contact con:conList){
            con.HSFE_Primary__c = True;
            con.HSFE_Active__c =True;
            insertContactList.add(con);
        }
        insert insertContactList;
        
        List<Contact> updateContactList = new List<Contact>();
        for(Contact con:conList){
            con.HSFE_Active__c =False;   
            updateContactList.add(con);
        }
        update updateContactList;
        
        List<Contact> updateContactList2 = new List<Contact>();
        for(Contact con:updateContactList){
            con.HSFE_Active__c =True;   
            con.AccountId=acc.Id;
            updateContactList2.add(con);
        }
         update updateContactList2;
        
        //check whether the contact is inserted properly
        System.Assert(conList.size() > 0, 'The Test Contact did not insert properly, please check validation rules and other mechanisms');
        
        //Insert the contact record      
        Contact con = HSFE_TestUtility_Class.createContactRecord(acc);
        con.HSFE_Primary__c = False;
        con.HSFE_Active__c =True;    
        insert con;
        
        //check whether the contact is inserted properly
        System.Assert(con.Id != null, 'The Test Contact did not insert properly, please check validation rules and other mechanisms');
        
        
        //update the contact record
        con.HSFE_Primary__c = True;    
        con.HSFE_Active__c =False;    
        con.AccountId=acc.Id;
        update con;

        //check whether the contact is updated properly
        System.Assert(con.HSFE_Primary__c != False,'Contact was not able to update, please check validation rules and other mechanisms'); 
        
    }
    
}