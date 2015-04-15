/* Class Name :HSFE_CustomConvertLead_Controller
*Description: This is custom lead converion class, which converts leads to account, contact and opportunity, If the account exist, then it will not create a new account.
*Created By :Chiranth Aradhya
*Created On :02/12/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
global class HSFE_CustomConvertLead_Controller{

    webservice static string HSFEConvertLeadMethod(Id leadID, Id accId){
        String strId;
        String descrip;
       try{

            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadID);
            //Set the existing account 
            lc.setAccountId(accId);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            strId = Id.valueOf(accId);
            return strId;
       }
        catch (Exception e){ 
            
            
            
            descrip = e.getMessage();
            
            if(descrip.contains('DUPLICATES_DETECTED')){
                strId = 'Duplicate';
            }else{
                HSFE_ExceptionLogger.createExceptionLog(e);
                strId = 'Error';
            }
             
            return strId;// Create a log file for an exception and return accountId
       }
        finally{
            return strId;
        }
        
    }
}