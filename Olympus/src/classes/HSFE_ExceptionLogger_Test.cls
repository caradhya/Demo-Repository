/* Class Name : HSFE_ExceptionLogger_Test
*Description :  This is used to test the exceptionlogger class functionality.
*Created By :   Sunil Kumar
*Created On :   03/2/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sunil              3/2/2015                      Created                               
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
@isTest
private class  HSFE_ExceptionLogger_Test{

    static testmethod void testmethod1() {
        // To test the exception 
        Account acc = HSFE_TestUtility_Class.createAccountRecord();        
        
        try{
            acc.OwnerId = 'Test Owner';
            insert acc;
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);
            //Assert Error Message
            System.assert(e.getMessage().contains('Invalid id'),e.getMessage());
            HSFE_Exception_Log__c excObj = [select id,HSFE_ExceptionDescription__c ,HSFE_Exception_Stack_Trace__c ,HSFE_Exception_Type__c  from HSFE_Exception_Log__c limit 1];
            System.assert(excObj.HSFE_ExceptionDescription__c!= null, 'This test the exception record created with a decription');
        }
    }
}