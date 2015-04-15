/* Class Name : HSFE_TerritoryManagement_Class
*Description :  This is used in Territory Management VF page. It contains the logic for TM VF page.
*Created By :   Sunil Kumar
*Created On :   03/12/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sunil              3/12/2015                      Created                               
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/

public with sharing class HSFE_TerritoryManagement_Class {
    public boolean showMsg{get;set;}     
    
  /*********************************************************************************
     * Method Name:runLeadBatchJob
     * Description:Excute batch class
     * Return Type: None.
  ********************************************************************************/
 public void runLeadBatchJob(){
    try{
        showMsg = true;
        HSFE_LeadTerritoryAssignment_BatchClass b = new HSFE_LeadTerritoryAssignment_BatchClass();
        database.executebatch(b);        
    }catch(Exception e){
       HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
    }
 }   
}