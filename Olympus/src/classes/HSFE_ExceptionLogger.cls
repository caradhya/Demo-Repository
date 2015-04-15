/*Class Name : HSFE_ExceptionLogger
*Description : Create exception log record.
*Created By :  Sunil Kumar
*Created On :  03/2/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                          Modification Id                       Description
Deloitte/Sunil              3/2/2015                      Created                               
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

public class HSFE_ExceptionLogger{
   
    public static void createExceptionLog(Exception e){
      HSFE_Exception_Log__c exceptionObj = new HSFE_Exception_Log__c();
      exceptionObj.HSFE_ExceptionDescription__c = e.getMessage();
      exceptionObj.HSFE_Exception_Stack_Trace__c = e.getStackTraceString();
      exceptionObj.HSFE_Exception_Type__c = e.getTypeName();      
      exceptionObj.HSFE_Exception_Line_Number__c = e.getLineNumber();
      insert exceptionObj;
       
    }

}