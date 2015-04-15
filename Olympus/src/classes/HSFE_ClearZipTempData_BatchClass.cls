/* Class Name : HSFE_ClearZipTempData_BatchClass
*Description :  This class used to delete all the data from tempoaray table.
*Created By :   Sunil Kumar
*Created On :   04/07/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sunil              4/07/2015                      Created                               
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public class HSFE_ClearZipTempData_BatchClass implements Database.Batchable<sObject>, Database.Stateful {
	
	public Database.QueryLocator start(Database.BatchableContext BC){
		
		String query = 'Select name from HSFE_Updated_Zip_Code_Temporary__c';
		System.debug('query**********>'+query);
		return Database.getQueryLocator(query); // return all the temp zip codes 
	}
	public void execute(Database.BatchableContext BC,List<sObject> scope){
		List<HSFE_Updated_Zip_Code_Temporary__c> tempZipList = new List<HSFE_Updated_Zip_Code_Temporary__c>();
		 for(Sobject s : scope){
		 	HSFE_Updated_Zip_Code_Temporary__c tempZip = (HSFE_Updated_Zip_Code_Temporary__c)s;
		 	tempZipList.add(tempZip);		 	
		 }
		 List<Database.DeleteResult> sr = Database.delete(tempZipList, false); //Delete Temp ZipCode.
	}
	public void finish(Database.BatchableContext ctx){
       AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :ctx.getJobId()];
        String emailMessage = System.Label.HSEF_BatchJob_Msg1
              
             +'  '     
             + a.totalJobItems
             
			  +'  '
             + System.Label.HSFE_BatchJob_Msg2 +'  '+  a.jobitemsprocessed  +'  '

             + System.Label.HSFE_BatchJob_Msg3  +'  '
             
             + a.numberOfErrors+' '
             
             +System.Label.HSFE_BatchJob_Msg4;
            
             
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.createdBy.email};
        mail.setToAddresses(toAddresses);       
        mail.setSenderDisplayName(System.Label.HSFE_BatchJob_SenderDisplay);
        mail.setSubject(System.Label.HSFE_BatchJobSubject);
        mail.setPlainTextBody(emailMessage);
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 	
    }
}