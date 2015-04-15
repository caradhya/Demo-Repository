/* Class Name :HSFE_LeadReminderReassignment_TestClass
*Description :This is used to test the functionality for HSFE_LeadReminderReassignment class.
*Created By :Sunil  Kumar
*Created On :02/27/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sunil              2/27/2015                      Created
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
@isTest(SeeAllData=true)
private class HSFE_LeadReminderReassignment_TestClass{ 
       
    static testmethod void test() {
        Test.startTest();
            Datetime dt = Datetime.now().addMinutes(1);
            
            //Dynamically create expression            
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            
            //Insert the account record       
             Account acc = HSFE_TestUtility_Class.createAccountRecord();
             insert acc;        
            //check whether account is inserted properly
            System.Assert(acc.Id != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');
        
            //Insert the Lead record
            Lead lead = HSFE_TestUtility_Class.createLeadRecord(acc);
            lead.HSFE_Reminder_Date__c  =  Date.today();
            lead.HSFE_Reassignment_Date__c  = Date.today();
            insert lead;
            
            //Schedule the class to test the functionality
            HSFE_LeadReminderReassignment  leadReassign = new HSFE_LeadReminderReassignment();
            String jobId = System.schedule('testScheduledApex', CRON_EXP, leadReassign);
            
            //Querying on corntrigger
            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
            
            //To validate job is scheduled
            System.assertEquals(CRON_EXP, ct.CronExpression); 
            System.assertEquals(0, ct.TimesTriggered);
         Test.stopTest();
        
    }
    

}