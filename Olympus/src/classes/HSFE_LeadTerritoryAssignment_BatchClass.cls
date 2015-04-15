/* Class Name : HSFE_LeadTerritoryAssignment_BatchClass
*Description :  This class used to assign territory based on zipcode,speciality and sub speciality.
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
public class HSFE_LeadTerritoryAssignment_BatchClass implements Database.Batchable<sObject>, Database.Stateful{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        try{
            //Query all the leads which contains speciallity,sub speciallity and postalcode.
            
            String query = 'Select HSFE_Specialty__c,HSFE_Sub_Speciality__c,postalcode,HSFE_Territory__c,HSFE_Territory_User__c,HSFE_Combination_Key__c,HSFE_Exception_Combination_Key__c,'+
                            'ownerid from lead where HSFE_Specialty__c!= null and HSFE_Sub_Speciality__c!=null and postalcode!=null and HSFE_Ex_Territory_Assignment_Rule__c = false and isConverted = false';
            system.debug('Query*****>'+query);
            return Database.getQueryLocator(query);// return  leads.
            
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception. 
            return null;
        }
    }
    
    public void execute(Database.BatchableContext BC,List<sObject> scope){
        try{
            HSFE_Utility_Class.stopUpdateLeadTerritory = true; //Stop trigger logic for TM.
            Set<String> postalCodeSet = new Set<String>();
            Map<String,String> tempZipMap = new Map<String,String>();
            List<Lead> leadList = new List<Lead>();
            List<Group> groupList = new List<Group>();
            Set<String> exepCombKeySet = new Set<String>();
            Set<String> terrCombKeySet = new Set<String>();
            Set<Id> terrIdSet = new Set<Id>();
            Map<String, Id> exepCombKeyToTerrIdMap = new Map<String, Id>();
            Map<String, Id> terrCombKeyToTerrIdMap = new Map<String, Id>();
            List<Lead> finalUpdateLead = new List<Lead>();
            
            groupList = [select Id from Group where Name = :HSFE_Constant.QUEUENAME and Type = 'Queue' Limit 1];
            for(Sobject s : scope){
                Lead le = (Lead)s;
                postalCodeSet.add(le.postalCode);
            }
            System.debug('postalCodeSet**********>'+postalCodeSet);           
            for(HSFE_Updated_Zip_Code_Temporary__c tempZip : [select name from HSFE_Updated_Zip_Code_Temporary__c where name=:postalCodeSet]){
            	tempZipMap.put(tempZip.name,tempZip.name);
            }
            for(Sobject s : scope){
            	Lead le = (Lead)s;
            	if(tempZipMap.containsKey(le.postalCode)){
            		leadList.add(le);
            	}            	
            }
            for(Lead l : leadList){
              if(l.HSFE_SAP_ID__c != null && l.HSFE_SAP_ID__c != ''){
            	exepCombKeySet.add(l.HSFE_Exception_Combination_Key__c);
              }else{
              	terrCombKeySet.add(l.HSFE_Combination_Key__c);
              }            
            }
            List<HSFE_Territory_Exception__c> TerrExceptionList = new List<HSFE_Territory_Exception__c>([SELECT Id,Name, HSFE_Specialty__c, HSFE_Sub_Specialty__c, HSFE_Territory__c, HSFE_Combination_Key__c FROM HSFE_Territory_Exception__c WHERE HSFE_Combination_Key__c IN :exepCombKeySet]);
            for(HSFE_Territory_Exception__c terrExep:TerrExceptionList){
                exepCombKeyToTerrIdMap.put(terrExep.HSFE_Combination_Key__c, terrExep.HSFE_Territory__c);
                terrIdSet.add(terrExep.HSFE_Territory__c);
            }
            List<HSFE_Zip_To_Territory__c> ZipToTerrList = new List<HSFE_Zip_To_Territory__c>([Select Id,HSFE_Territory__c,HSFE_Combination_Key__c from HSFE_Zip_To_Territory__c where HSFE_Combination_Key__c IN :terrCombKeySet]);
            for(HSFE_Zip_To_Territory__c zipte:ZipToTerrList){
                terrCombKeyToTerrIdMap.put(zipte.HSFE_Combination_Key__c, zipte.HSFE_Territory__c);
                terrIdSet.add(zipte.HSFE_Territory__c);
            }
            Map<String,HSFE_Territory_To_User__c> tempMap;
            Map<Id, Map<String,HSFE_Territory_To_User__c >> territoryToRoleToUserMapMap = new Map<Id, Map<String,HSFE_Territory_To_User__c >>();
            List<HSFE_Territory_To_User__c> terrToUserList= new List<HSFE_Territory_To_User__c>([Select Id, HSFE_User_Role__c,HSFE_Territory__c, HSFE_User__c from HSFE_Territory_To_User__c where HSFE_Territory__c IN :terrIdSet]);
            for(HSFE_Territory_To_User__c terrUser: terrToUserList){
                if(terrUser.HSFE_User_Role__c != null){
                    if(territoryToRoleToUserMapMap.containsKey(terrUser.HSFE_Territory__c)){
                        tempMap = territoryToRoleToUserMapMap.get(terrUser.HSFE_Territory__c);
                        tempMap.put(terrUser.HSFE_User_Role__c,terrUser);
                    }else{
                        tempMap = new Map<String,HSFE_Territory_To_User__c>();
                        tempMap.put(terrUser.HSFE_User_Role__c,terrUser);
                    }
                    territoryToRoleToUserMapMap.put(terrUser.HSFE_Territory__c,tempMap);
                }
            }
            Id terrId;
            Map<String,HSFE_Territory_To_User__c> territoryUserMap;
            Boolean checkRole;
            for(Lead l : leadList){              
                terrId = null;
                if(exepCombKeyToTerrIdMap.containsKey(l.HSFE_Exception_Combination_Key__c)){
                    terrId = exepCombKeyToTerrIdMap.get(l.HSFE_Exception_Combination_Key__c);
                }else if(terrCombKeyToTerrIdMap.containsKey(l.HSFE_Combination_Key__c)){
                    terrId = terrCombKeyToTerrIdMap.get(l.HSFE_Combination_Key__c);
                }
                l.HSFE_Territory__c = terrId; 
                if(groupList.size()>0){
                	l.OwnerId = groupList[0].id;
                }             
                if(terrId != null && territoryToRoleToUserMapMap.containsKey(terrId)){            
                    territoryUserMap = territoryToRoleToUserMapMap.get(terrId);  // Get the territory and its related user based on the combination key.    
                    if(territoryUserMap.size()>0 && territoryUserMap!= null){                
                        terrToUserList = new List<HSFE_Territory_To_User__c>(); 
                        l.HSFE_Territory_User__c = ''; //Clear a value before assigning a user.                                                 
                        terrToUserList = territoryUserMap.values();                   
                        system.debug('Map Values'+ terrToUserList); 
                        for(HSFE_Territory_To_User__c userTerr : terrToUserList){
                            l.HSFE_Territory__c = userTerr.HSFE_Territory__c; // Assign territory
                            l.HSFE_Territory_User__c =  l.HSFE_Territory_User__c != ''?l.HSFE_Territory_User__c+';'+userTerr.HSFE_User__c:userTerr.HSFE_User__c;// For My territory.
                        }                  
                        checkRole = false;
                        if(territoryUserMap.containsKey(HSFE_Constant.TM) && l.HSFE_Specialty__c == HSFE_Constant.SURGICAL && checkRole == false){                            
                            l.ownerid = territoryUserMap.get(HSFE_Constant.TM).HSFE_User__c; //Assign the lead owner                       
                            checkRole = true;
                        }
                        else if(territoryUserMap.containsKey(HSFE_Constant.RVP) && l.HSFE_Specialty__c == HSFE_Constant.SURGICAL && checkRole == false){
                             l.ownerid = territoryUserMap.get(HSFE_Constant.RVP).HSFE_User__c;  //Assign the lead owner
                             checkRole = true;
                        }
                        else if(territoryUserMap.containsKey(HSFE_Constant.INSIDESALES) && l.HSFE_Specialty__c == HSFE_Constant.SURGICAL && checkRole == false){
                             l.ownerid = territoryUserMap.get(HSFE_Constant.INSIDESALES).HSFE_User__c;  //Assign the lead owner
                             checkRole = true;
                        }
                        else if(territoryUserMap.containsKey( HSFE_Constant.INSIDESALES) && l.HSFE_Specialty__c == HSFE_Constant.MEDICAL && checkRole == false){
                             l.ownerid = territoryUserMap.get(HSFE_Constant.INSIDESALES).HSFE_User__c;  //Assign the lead owner
                             checkRole = true;
                        }
                        else if(groupList.size()>0 && checkRole == false){
                            l.ownerid = groupList[0].id;
                        } 
                    }                               
                }
                finalUpdateLead.add(l);
           }
                    
           List<Database.Saveresult> sr = Database.update(finalUpdateLead, false); //Update lead.
           System.debug('**** save result : '+sr);            
            for(Database.SaveResult res:sr){
            	if(!res.isSuccess()){
            		 System.debug('**** save result : '+res);
            	}
            }
        }catch(Exception e){
          HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception. 
        }
    }
    public void finish(Database.BatchableContext ctx){
        Id batjobId = Database.executeBatch(new HSFE_ClearZipTempData_BatchClass(), 200);
    }

}