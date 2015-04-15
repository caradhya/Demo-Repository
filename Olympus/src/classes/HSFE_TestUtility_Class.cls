/* 
*Class Name :HSFE_TestUtility_Class 
*Description :This is common test utility class that contain reusable code for test data creation.
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
public class HSFE_TestUtility_Class {
    
    public static UserRole createRole(){
        UserRole r = new UserRole(name =HSFE_Constant.INSIDESALES);
        return r;
    }
    

    public static User createUser(UserRole r){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
       // UserRole r = [Select id from userrole where name='AVP'];
        User u = new User(Alias = 'standt', Email='testUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = r.id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stestUser@testorg.com');
            return u;
     }
     public static User createUser2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        // UserRole r = [Select id from userrole where name='AVP'];
        User u = new User(Alias = 'standt', Email='testStdUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stestStdUser@testorg.com');
            return u;
     }  
     
     public static List<Account> createmultipleAccount(){
         List<Account> accs = new List<Account>();
         for (Integer i = 0; i < 200; i++) {
            Account acct = new Account();
            acct.Name='Test Account';
            acct.HSFE_SAP_ID__c = '12345';
            String zip= String.valueOf(1000 + i);
            acct.BillingPostalCode='zip';
            accs.add(acct);
         }
         return accs;
     }     
     
    public static Account createAccountRecord() {       

        Account acct= new Account();             
        acct.Name='Test Account';
        acct.HSFE_SAP_ID__c = '12345';
        acct.BillingPostalCode='123456';     
        return acct;
            
    }
    
    public static Account createInactiveContacts() {       

        Account acct= new Account();             
        acct.Name='Inactive Contacts';
        acct.HSFE_SAP_ID__c = '12345';
        acct.BillingPostalCode='123456';     
        return acct;
            
    }
    
    public static Lead createLeadRecord(Account acc){
        Lead l = new Lead();
        l.LastName='test';
        l.Company='test';
        l.Email='test@test.com';
        l.HSFE_Account__c =acc.Id;
        l.Status='Qualified';
        l.HSFE_SAP_ID__c = '12345';
        l.PostalCode='1234';
        l.HSFE_Specialty__c ='Medical';
        l.HSFE_Sub_Speciality__c='Endoscopy';
        l.HSFE_Ex_Territory_Assignment_Rule__c = false;
        return l;
    }
    public static Lead createLeadRecord2(Account acc){
        Lead l = new Lead();
        l.LastName='test';
        l.Company='test';
        l.Email='test@test.com';
        l.HSFE_Account__c =acc.Id;
        l.Status='Qualified';
        l.HSFE_SAP_ID__c = '12345';
        l.PostalCode='123456';
        l.HSFE_Specialty__c ='Surgical';
        l.HSFE_Sub_Speciality__c='Energy';
        l.HSFE_Ex_Territory_Assignment_Rule__c = false;
        return l;
    }
    public static Lead createLeadwithTerr(Account acc, HSEF_Territory__c  tr){
        Lead l = new Lead();
        l.LastName='test1';
        l.Company='test';
        l.Email='test1@test.com';
        l.HSFE_Account__c =acc.Id;
        l.Status='Qualified';
        l.HSFE_SAP_ID__c = '12345';
        l.HSFE_Territory__c =tr.id;
        return l;
    }
    public static Contact createContactRecord( Account acc) {       

        Contact con= new Contact();
        con.LastName='Test contact';
        con.Email='test@test.com';     
        con.AccountId = acc.Id;
        return con;
            
    }
    public static List<Contact> createmultipleContactRecord( Account acc) {
         List<Contact > conss = new List<Contact >();
         for (Integer i = 0; i < 200; i++) {
            Contact con= new Contact();
            con.LastName='Test5 contact';
            con.Email='test5@test.com';     
            con.AccountId = acc.Id;
            conss.add(con);
         }
         return conss;
    }
    public static void createPriceBook(){
        Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
    }
    
    
    
    public static Opportunity createOpportunityRecord( Account acc) {       
        
        Opportunity opp= new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name='Test';
        opp.HSFE_Opportunity_Type__c='New Business';
        opp.CloseDate=System.Today();
        opp.StageName='Prospecting';
        return opp;
            
    }
     
      public static Opportunity createOpportunityRecord2( Account acc) {       
        
        Opportunity opp= new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name='Test';
        opp.CloseDate=System.Today();
        opp.StageName='Prospecting';
        return opp;
            
    }
    public static HSFE_Opportunity_Record_Type_Mapping__c  createCustomSetting() { 
       
        HSFE_Opportunity_Record_Type_Mapping__c mycs =  new HSFE_Opportunity_Record_Type_Mapping__c (Name= 'Test');
        mycs.HSFE_Record_Type_Ids__c ='Test';
        return mycs;
    }
    
    public static HSEF_Territory__c createTerritory(){
        HSEF_Territory__c terty= new HSEF_Territory__c();
        terty.Name='test';
        terty.HSFE_Territory_Name__c ='t1';
        return terty;
    }
    
    public static HSFE_Territory_To_User__c createTerritoryUser(User usr,HSEF_Territory__c terty ){
        HSFE_Territory_To_User__c tusr = new HSFE_Territory_To_User__c ();
        tusr.HSFE_Territory__c =terty.Id;
        tusr.HSFE_User__c=usr.Id;       
        return tusr;
    }
    
    public static HSFE_Zip_To_Territory__c createHSFEZipterr(HSEF_Territory__c terty){
        HSFE_Zip_To_Territory__c zipTr = new HSFE_Zip_To_Territory__c();
        zipTr.HSFE_Specialty__c = 'Medical';
        ziptr.HSFE_Sub_Specialty__c='Endoscopy';
        ziptr.HSFE_Territory__c=terty.Id;
        ziptr.HSFE_Combination_Key__c='1234MedicalEndoscopy';
        ziptr.Name='1234';
        return ziptr;
        
    }
    
    public static HSFE_Zip_To_Territory__c createHSFEZipterr3(HSEF_Territory__c terty){
        HSFE_Zip_To_Territory__c zipTr = new HSFE_Zip_To_Territory__c();
        zipTr.HSFE_Specialty__c = 'Surgical';
        ziptr.HSFE_Sub_Specialty__c='Energy';
        ziptr.HSFE_Territory__c=terty.Id;
        ziptr.HSFE_Combination_Key__c='123456SurgicalEnergy';
        ziptr.Name='123456';
        return ziptr;
    }
    
    public static HSFE_Territory_Exception__c createHSFETerritoryException(HSEF_Territory__c territory){
        HSFE_Territory_Exception__c terrException = new HSFE_Territory_Exception__c();
        terrException.HSFE_Combination_Key__c = '12345123456MedicalEndoscopy';
        terrException.HSFE_Specialty__c = 'Surgical';
        terrException.HSFE_Sub_Specialty__c = 'Energy';
        terrException.HSFE_Territory__c = territory.Id;
		terrException.Rep_Type__c = 'abc';
        terrException.HSFE_Zip_Code__c = '123456';
        terrException.Name = '12345';
        return terrException;
    }
    
    public static List<HSFE_Zip_To_Territory__c> createMultipleZiptoTerr(HSEF_Territory__c terty){
        List<HSFE_Zip_To_Territory__c> zipterrList = new List<HSFE_Zip_To_Territory__c>();
        for (Integer i = 0; i < 200; i++) {
            HSFE_Zip_To_Territory__c zipTr = new HSFE_Zip_To_Territory__c();
            zipTr.HSFE_Specialty__c = 'Medical';
            ziptr.HSFE_Sub_Specialty__c='Endoscopy';
            ziptr.HSFE_Territory__c=terty.Id;
            String zip = String.valueOf(1000 + i);
            ziptr.Name='zip';
            zipterrList.add(ziptr);
        }
    return zipterrList;
    }
    
    public static HSFE_Zip_To_Territory__c createHSFEZipterr2(HSEF_Territory__c terty){
        HSFE_Zip_To_Territory__c zipTr = new HSFE_Zip_To_Territory__c();
        zipTr.HSFE_Specialty__c = 'Surgical';
        ziptr.HSFE_Sub_Specialty__c='Energy';
        ziptr.HSFE_Territory__c=terty.Id;
        ziptr.HSFE_Combination_Key__c='123SurgicalEnergy';
        ziptr.Name='123';
        return ziptr;
        
    }
    
    public static AccountTeamMember  createAccountTeamMember(Account acc, User Usr){
        AccountTeamMember   accTeam = new AccountTeamMember();
        accTeam.AccountId = acc.Id;
        accTeam.TeamMemberRole = 'Sales Rep';
        accTeam.UserId = Usr.Id;
        return accTeam;
    }
    
    public static Group createGroup(){
        Group testGroup = new Group();
        testGroup.Name = 'testGroup';
        testGroup.DeveloperName = 'ABC';
        return testGroup;
    }
    
    public static HSFE_Account_Territory__c createAccountTerritory(Account acc,HSEF_Territory__c terty){
        HSFE_Account_Territory__c accTerr = new HSFE_Account_Territory__c();
        accTerr.Account__c=acc.Id;
        accTerr.Territory__c=terty.Id;
        return accTerr;
    }
    


}