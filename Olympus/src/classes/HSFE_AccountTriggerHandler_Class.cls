/* Class Name :HSFE_AccountTriggerHandler_Class
*Description :Trigger Handler class for the Account SObject, which implements all the logic of Account trigger.
            1. Update the primary text field on contact based on Is primary checkbox, Primary text field is used in duplicate rules.
*Created By :Sourav Datta
*Created On :03/17/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public with sharing class HSFE_AccountTriggerHandler_Class {
   /*********************************************************************************
     * Method Name:handleAfterUpdate
     * Description:Handle After Update and populate Territory and Account Team
     * Return Type: None.
     ********************************************************************************/
    public static void handleAfterUpdate(Map<Id, Account> newAccMap, Map<Id, Account> oldAccMap) {
		try{
			List<Account> deleteAccountList = new List<Account>();
			Map<Id, Account> accountIdToAccountMap = new Map<Id, Account>();
			Set<String> zipCodeSet = new Set<String>();
			Set<String> SAPIdSet = new Set<String>();
			Set<Account> opptyToUpdAcc = new Set<Account>();
            for(Id idVal:newAccMap.keySet()){
                Account newAcc = newAccMap.get(idVal);
				Account oldAcc = oldAccMap.get(idVal);
				if((newAcc.BillingPostalCode != oldAcc.BillingPostalCode || newAcc.HSFE_SAP_ID__c != oldAcc.HSFE_SAP_ID__c) && HSFE_Utility_Class.stopUpdateAccountTerritory == false){
					opptyToUpdAcc.add(newAcc);
					if (oldAcc.BillingPostalCode != null){
						deleteAccountList.add(oldAcc);
					}
					if (newAcc.BillingPostalCode != null){
						zipCodeSet.add(newAcc.HSFE_Postal_Code_five_digit__c);
						accountIdToAccountMap.put(newAcc.Id, newAcc);
						if(newAcc.HSFE_SAP_ID__c != null && newAcc.HSFE_SAP_ID__c != ''){
							SAPIdSet.add(newAcc.HSFE_SAP_ID__c);
						}
					}
				}
            }
            accTeamTerrHandler(deleteAccountList, accountIdToAccountMap, zipCodeSet, SAPIdSet);
            if(opptyToUpdAcc.size() > 0){
            	opptyUpdateHandler(opptyToUpdAcc);
            }
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
   /*********************************************************************************
     * Method Name:handleAfterInsert
     * Description:Handle After Insert and populate Territory and Account Team 
     * Return Type: None.
     ********************************************************************************/
    public static void handleAfterInsert(Map<Id, Account> newAccMap) {
    	try{
    		List<Account> deleteAccountList = new List<Account>();
			Map<Id, Account> accountIdToAccountMap = new Map<Id, Account>();
			Set<String> zipCodeSet = new Set<String>();
			Set<String> SAPIdSet = new Set<String>();
            for(Id idVal:newAccMap.keySet()){
                Account newAcc = newAccMap.get(idVal);
				if (newAcc.BillingPostalCode != null  && HSFE_Utility_Class.stopUpdateAccountTerritory == false){
					zipCodeSet.add(newAcc.HSFE_Postal_Code_five_digit__c);
					accountIdToAccountMap.put(newAcc.Id, newAcc);
					if(newAcc.HSFE_SAP_ID__c != null && newAcc.HSFE_SAP_ID__c != ''){
						SAPIdSet.add(newAcc.HSFE_SAP_ID__c);
					}
				}
            }
            accTeamTerrHandler(deleteAccountList, accountIdToAccountMap, zipCodeSet, SAPIdSet);
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
   /*********************************************************************************
     * Method Name:accTeamTerrHandler
     * Description: Handle Account Team and Account Territory Insert/Delete
     * Return Type: None.
     ********************************************************************************/
    public static void accTeamTerrHandler(List<Account> deleteAccountList, Map<Id, Account> accountIdToAccountMap, Set<String> zipCodeSet, Set<String> SAPIdSet) {
		try{
			if(deleteAccountList.size()>0){
            	List<AccountTeamMember> toDeleteTeam = new List<AccountTeamMember>([SELECT Id  FROM AccountTeamMember WHERE AccountId IN :deleteAccountList]);
            	List<HSFE_Account_Territory__c> toDeleteAccountTerr = new List<HSFE_Account_Territory__c>([SELECT Id FROM HSFE_Account_Territory__c WHERE Account__c IN :deleteAccountList]);
            	if(toDeleteTeam.size()>0){
            		Delete toDeleteTeam;
            	}
            	if(toDeleteAccountTerr.size()>0){
            		Delete toDeleteAccountTerr;
            	}
            }
            Map<Id, Set<String>> accIdToTerrDetailsSetMap = new Map<Id, Set<String>>();
            Map<Id, Set<Id>> terrIdToUserIdSetMap = new Map<Id, Set<Id>>();
            Set<Id> tempUserIdSet, fullUserIdSet;
            Set<String> tempTerritoryDetailsSet;
            Set<Id> fullTerritoryIdSet = new Set<Id>();
            Map<String,String> terrExeptionMap = new Map<String,String>();
            String key, comb, specialty, subSpecialty, combKey;
            Boolean res;
            Id terrId;
            Map<Id, String> userRoleMap = new Map<Id, String>();
            List<String> terrList;
            List<HSFE_Account_Territory__c> newAccTerrInsertList = new List<HSFE_Account_Territory__c>();
        	List<AccountTeamMember> newAccTeamInsertList =  new List<AccountTeamMember>();
        	HSFE_Account_Territory__c tempAccTerr;
        	AccountTeamMember tempAccTeam;
            if(zipCodeSet.size()>0){
            	List<HSFE_Territory_Exception__c> TerrExceptionList = new List<HSFE_Territory_Exception__c>([SELECT Id,Name, HSFE_Specialty__c, HSFE_Sub_Specialty__c, HSFE_Territory__c, HSFE_Combination_Key__c FROM HSFE_Territory_Exception__c WHERE Name IN :SAPIdSet]);
            	for(HSFE_Territory_Exception__c ex:TerrExceptionList){
            		if(ex.Name != null && ex.HSFE_Specialty__c != null && ex.HSFE_Sub_Specialty__c != null){
            			terrExeptionMap.put(ex.HSFE_Combination_Key__c, ex.HSFE_Territory__c);
            		}
            	}
            	
            	List<HSFE_Zip_To_Territory__c> ZiptoTerrList = new List<HSFE_Zip_To_Territory__c>([SELECT  Id, Name, HSFE_Territory__c, HSFE_Specialty__c, HSFE_Sub_Specialty__c, HSFE_Combination_Key__c FROM HSFE_Zip_To_Territory__c WHERE Name IN :zipCodeSet]);
            	for(Id idVal:accountIdToAccountMap.keySet()){
            		tempTerritoryDetailsSet = new Set<String>();
            		for(HSFE_Zip_To_Territory__c zipToTerr:ZiptoTerrList){
            			comb = ':' + zipToTerr.HSFE_Specialty__c + ':'  + zipToTerr.HSFE_Sub_Specialty__c;
            			if(accountIdToAccountMap.get(idVal).HSFE_Postal_Code_five_digit__c == zipToTerr.Name){
            				key = accountIdToAccountMap.get(idVal).HSFE_SAP_ID__c + zipToTerr.HSFE_Combination_Key__c;
            				if(terrExeptionMap.containsKey(key)){
            					tempTerritoryDetailsSet.add(String.valueOf(terrExeptionMap.get(key)) + comb);
            					fullTerritoryIdSet.add(terrExeptionMap.get(key));
            				}else{
            					tempTerritoryDetailsSet.add(String.valueOf(zipToTerr.HSFE_Territory__c) + comb);
            					fullTerritoryIdSet.add(zipToTerr.HSFE_Territory__c);
            				}
            			}
            		}
            		accIdToTerrDetailsSetMap.put(idVal, tempTerritoryDetailsSet);
            	}
            	List<HSFE_Territory_To_User__c> terrtoUserList= new List<HSFE_Territory_To_User__c>([SELECT Id,HSFE_Territory__c,HSFE_User__c,HSFE_User_Role__c FROM HSFE_Territory_To_User__c WHERE HSFE_Territory__c IN :fullTerritoryIdSet]);
            	for(HSFE_Territory_To_User__c teToUser: terrtoUserList){
            		tempUserIdSet = new Set<Id>();
            		userRoleMap.put(teToUser.HSFE_User__c, teToUser.HSFE_User_Role__c);
            		if(terrIdToUserIdSetMap.containsKey(teToUser.HSFE_Territory__c)){
            			tempUserIdSet = terrIdToUserIdSetMap.get(teToUser.HSFE_Territory__c);
						tempUserIdSet.add(teToUser.HSFE_User__c);
						terrIdToUserIdSetMap.put(teToUser.HSFE_Territory__c, tempUserIdSet);
            		}else{
            			tempUserIdSet = new Set<Id>();
						tempUserIdSet.add(teToUser.HSFE_User__c);
						terrIdToUserIdSetMap.put(teToUser.HSFE_Territory__c, tempUserIdSet);
            		}
            	}
            	for(Id accId:accIdToTerrDetailsSetMap.keySet()){
            		tempTerritoryDetailsSet = accIdToTerrDetailsSetMap.get(accId);
            		fullUserIdSet = new Set<Id>();
            		for(String terrDet:tempTerritoryDetailsSet){
            			terrList = terrDet.split(':');
            			terrId = Id.valueOf(terrList[0]);
            			specialty = terrList[1];
            			subSpecialty = terrList[2];
            			combKey = String.valueOf(accId).left(15) + specialty + subSpecialty;
            			tempAccTerr = new HSFE_Account_Territory__c(Account__c = accId,Territory__c=terrId, HSFE_Specialty__c=specialty, HSFE_Sub_Specialty__c=subSpecialty, HSFE_Combination_Key__c = combKey);
            			newAccTerrInsertList.add(tempAccTerr);
            			if(terrIdToUserIdSetMap.containsKey(terrId)){
            				tempUserIdSet = terrIdToUserIdSetMap.get(terrId);
            				res = fullUserIdSet.addAll(tempUserIdSet);
            			}
            		}
            		for(Id UserId:fullUserIdSet){
            			String tempRole = '';
            			if(userRoleMap.containsKey(UserId)){
            				tempRole = userRoleMap.get(UserId);
            			}
            			tempAccTeam = new AccountTeamMember(AccountId = accId,UserId = UserId, TeamMemberRole = tempRole);
		            	newAccTeamInsertList.add(tempAccTeam);
            		}
            	}
            	if(newAccTerrInsertList.size()>0){
	            	insert newAccTerrInsertList;
	            }
	            if(newAccTeamInsertList.size()>0){
	            	insert newAccTeamInsertList;
	            	List<AccountShare> updateAccountShareList = new List<AccountShare>();
	            	List<AccountShare> shares = [select Id, OpportunityAccessLevel,AccountAccessLevel,AccountId from AccountShare where AccountId IN :accIdToTerrDetailsSetMap.keySet() 
	            								and AccountAccessLevel != 'All' and AccountAccessLevel !='Edit' and RowCause= 'Team'];
	                if(shares.size()>0){
	                    for(AccountShare accshare:shares ){
	                        accshare.AccountAccessLevel='Edit';
	                        accshare.OpportunityAccessLevel='Read';
	                        updateAccountShareList.add(accshare);
	                    }
	                }
	                if(updateAccountShareList.size()>0){
	                    update updateAccountShareList;
	                }
	            }
            }
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
   /*********************************************************************************
     * Method Name:accTeamTerrHandler
     * Description: Handle Account Team and Account Territory Insert/Delete
     * Return Type: None.
     ********************************************************************************/
    public static void opptyUpdateHandler(Set<Account> opptyToUpdAcc){
    	try{
	    	Map<Id, Opportunity> opptyToUpdateMap = new Map<Id, Opportunity>();
			Map<Id, Opportunity> opptyToDeleteMap = new Map<Id, Opportunity>();
			Set<String> accountQuerySet = new Set<String>();
	    	List<Opportunity> toUpdateOpptyList = new List<Opportunity>([SELECT Id, OwnerId, HSFE_Territory__c, HSFE_Combination_Key__c, HSFE_Sub_Specialty__c, HSFE_Specialty__c, AccountId,CreatedById FROM Opportunity WHERE AccountId IN : opptyToUpdAcc]);
	    	for(Opportunity veryNewOppty:toUpdateOpptyList){
				if(HSFE_Utility_Class.stopUpdateOpptyTerritory == false){ // Stop the logic to excute when a batch class run.
					opptyToDeleteMap.put(veryNewOppty.Id, veryNewOppty);
					veryNewOppty.HSFE_Territory__c = null;
					if(veryNewOppty.HSFE_Specialty__c != null && veryNewOppty.HSFE_Sub_Specialty__c!= null){
	                    opptyToUpdateMap.put(veryNewOppty.Id, veryNewOppty);
	                    accountQuerySet.add(veryNewOppty.HSFE_Combination_Key__c);
					}
				}
	    	}
	    	System.debug('*********************tempTerritoryDetailsSet' + opptyToUpdateMap);
	    	HSFE_OpportunityTriggerHandler_Class.assignTerritory(opptyToUpdateMap, opptyToDeleteMap, accountQuerySet, true);
	    	if(opptyToDeleteMap.size() > 0){
	    		update opptyToDeleteMap.values();
	    	}else if(opptyToUpdateMap.size() > 0){
	    		update opptyToUpdateMap.values();
	    	}
    	}catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
}