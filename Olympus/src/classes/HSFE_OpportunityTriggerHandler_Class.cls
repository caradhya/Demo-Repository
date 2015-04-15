/* Class Name :HSFE_OpportunityTriggerHandler_Class 
*Description :Trigger Handler for the Opportunity SObject, which implements all the logic of Opportunity trigger.
              1. Update the standard pricebook on opportunity before insert
              2. Update the Opportunity record type based on opportunity type picklist on creation of opportunity
*Created By :Chiranth Aradhya
*Created On :02/24/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public with sharing class HSFE_OpportunityTriggerHandler_Class {
    
    /*********************************************************************************
     * Method Name:handleBeforeInsert
     * Description:Update the standard pricebook Id on opportunity and record type based on Opportunity type.
     * Return Type: None.
     ********************************************************************************/
    public static void handleBeforeInsert(List<Opportunity> oppList) {
        try{
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
            Schema.SObjectType s = sObjectMap.get('Opportunity') ; // getting Sobject Type
            Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
            
            //get the standard pricebook        
            List<Pricebook2> stdPBL =  [select id from Pricebook2 where IsStandard = TRUE];

            for(Opportunity opp:oppList){
                if(opp.HSFE_Opportunity_Type__c!= ''  && opp.HSFE_Opportunity_Type__c != null){
                //get the record type based on picklist from the custom setting
                HSFE_Opportunity_Record_Type_Mapping__c recordTypeIds = new HSFE_Opportunity_Record_Type_Mapping__c ();
                recordTypeIds = HSFE_Opportunity_Record_Type_Mapping__c.getInstance(opp.HSFE_Opportunity_Type__c);
                    if(recordTypeIds.HSFE_Record_Type_Ids__c != '' && recordTypeIds.HSFE_Record_Type_Ids__c != null){
                       //update the opprotuntiy record type
                       if(recordTypeInfo.ContainsKey(recordTypeIds.HSFE_Record_Type_Ids__c)){ 
                           opp.RecordTypeId=recordTypeInfo.get(recordTypeIds.HSFE_Record_Type_Ids__c).getRecordTypeId();
                           
                       }
                    }
                }
               //update the pricebook on opportunity before insert
               if(!stdPBL.isEmpty()){
                   opp.PriceBook2Id = stdPBL[0].id;
               }
            }
        }catch(Exception e){ 
            system.debug('Exception********************************************* '+e);
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.  
            
        }
    }
    
    /*********************************************************************************
     * Method Name:handleBeforeUpdate
     * Description:Update the standard pricebook Id on opportunity and record type based on Opportunity type.
     * Return Type: None.
     ********************************************************************************/
    public static void handleBeforeUpdate(List<Opportunity> oppList, Map<Id,Opportunity> oldOpportunityMap) {
        try{
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
            Schema.SObjectType s = sObjectMap.get('Opportunity') ; // getting Sobject Type
            Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
            
            //get the standard pricebook        
            List<Pricebook2> stdPBL =  [select id from Pricebook2 where IsStandard = TRUE];

            for(Opportunity opp:oppList){
                 if (opp.HSFE_Opportunity_Type__c != oldOpportunityMap.get(opp.Id).HSFE_Opportunity_Type__c   && opp.HSFE_Opportunity_Type__c!= ''  && opp.HSFE_Opportunity_Type__c != null ){ 
                    //get the record type based on picklist from the custom setting
                    HSFE_Opportunity_Record_Type_Mapping__c recordTypeIds = new HSFE_Opportunity_Record_Type_Mapping__c ();
                    recordTypeIds = HSFE_Opportunity_Record_Type_Mapping__c.getInstance(opp.HSFE_Opportunity_Type__c);
                    if(recordTypeIds.HSFE_Record_Type_Ids__c != '' && recordTypeIds.HSFE_Record_Type_Ids__c != null){
                       //update the opprotuntiy record type
                       if(recordTypeInfo.ContainsKey(recordTypeIds.HSFE_Record_Type_Ids__c)){ 
                           opp.RecordTypeId=recordTypeInfo.get(recordTypeIds.HSFE_Record_Type_Ids__c).getRecordTypeId();
                           
                       }
                    }
                }
               //update the pricebook on opportunity before insert
               if(!stdPBL.isEmpty()){
                   opp.PriceBook2Id = stdPBL[0].id;
               }
            }
        }catch(Exception e){ 
            system.debug('Exception********************************************* '+e);
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.  
            
        }
    }
    
    
    /*********************************************************************************
     * Method Name:handleAfterUpdate
     * Description:Update Territory on Opportunity
     * Return Type: None.
     ********************************************************************************/
    public static void handleAfterUpdate(Map<Id, Opportunity> oldOpptyMap,Map<Id, Opportunity> newOpptyMap) {
        try{
            
            Map<Id, Opportunity> opptyToUpdateMap = new Map<Id, Opportunity>();
            Map<Id, Opportunity> opptyToDeleteMap = new Map<Id, Opportunity>();
            Map<Id, Opportunity> veryNewOpptyMap = new Map<Id, Opportunity>([SELECT Id, OwnerId, HSFE_Territory__c,HSFE_Combination_Key__c,CreatedById FROM Opportunity WHERE Id IN : newOpptyMap.keySet()]);
            Set<String> accountQuerySet = new Set<String>();
            for(Id idVal:newOpptyMap.keySet()){
                Opportunity newOppty = newOpptyMap.get(idVal);
                Opportunity oldOppty = oldOpptyMap.get(idVal);
                Opportunity veryNewOppty = veryNewOpptyMap.get(idVal);
                if(HSFE_Utility_Class.stopUpdateOpptyTerritory == false){ // Stop the logic to excute when a batch class run.
                    if((newOppty.HSFE_Specialty__c != oldOppty.HSFE_Specialty__c) || (newOppty.HSFE_Sub_Specialty__c != oldOppty.HSFE_Sub_Specialty__c) || (newOppty.AccountId != oldOppty.AccountId)){
                        opptyToDeleteMap.put(veryNewOppty.Id, veryNewOppty);
                        veryNewOppty.HSFE_Territory__c = null;
                        veryNewOppty.OwnerId = veryNewOppty.CreatedById;
                        if(newOppty.HSFE_Specialty__c != null && newOppty.HSFE_Sub_Specialty__c!= null && newOppty.AccountId !=null){
                            opptyToUpdateMap.put(veryNewOppty.Id, veryNewOppty);
                            accountQuerySet.add(newOppty.HSFE_Combination_Key__c);
                        }
                    }
                }
            }
            System.debug('*********************opptyToUpdateMap' + opptyToUpdateMap);
            assignTerritory(opptyToUpdateMap, opptyToDeleteMap, accountQuerySet);
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    /*********************************************************************************
     * Method Name:handleAfterUpdate
     * Description:Update Territory on Opportunity
     * Return Type: None.
     ********************************************************************************/
    public static void handleAfterInsert(Map<Id, Opportunity> newOpptyMap) {
        try{
            Map<Id, Opportunity> opptyToUpdateMap = new Map<Id, Opportunity>();
            Map<Id, Opportunity> opptyToDeleteMap = new Map<Id, Opportunity>();
            Map<Id, Opportunity> veryNewOpptyMap = new Map<Id, Opportunity>([SELECT Id, OwnerId, HSFE_Territory__c,HSFE_Combination_Key__c,CreatedById FROM Opportunity WHERE Id IN : newOpptyMap.keySet()]);
            Set<String> accountQuerySet = new Set<String>();
            for(Id idVal:newOpptyMap.keySet()){
                Opportunity newOppty = newOpptyMap.get(idVal);
                Opportunity veryNewOppty = veryNewOpptyMap.get(idVal);
                if(HSFE_Utility_Class.stopUpdateOpptyTerritory == false){ // Stop the logic to excute when a batch class run.
                    if(newOppty.HSFE_Specialty__c != null && newOppty.HSFE_Sub_Specialty__c!= null && newOppty.AccountId !=null){
                        opptyToUpdateMap.put(veryNewOppty.Id, veryNewOppty);
                        accountQuerySet.add(veryNewOppty.HSFE_Combination_Key__c);
                    }
                }
            }
            assignTerritory(opptyToUpdateMap, opptyToDeleteMap, accountQuerySet);
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    /*********************************************************************************
     * Method Name:assignTerritory
     * Description:Update Territory on Opportunity
     * Return Type: None.
     ********************************************************************************/
    public static void assignTerritory(Map<Id, Opportunity> opptyToUpdateMap,Map<Id, Opportunity> opptyToDeleteMap, Set<String> accountQuerySet) {
        Map<String, Id> combKeytoTerrMap = new Map<String, Id>();
        Set<Id> terrIdSet = new Set<Id>();
        Id userId;
        Boolean creatorPresent;
        Opportunity tempOppty;
        List<OpportunityTeamMember> teamToCreateList = new List<OpportunityTeamMember>();
        OpportunityTeamMember tempTeam;
        if(opptyToUpdateMap.size() > 0){
            List<HSFE_Account_Territory__c> accTerrList = new List<HSFE_Account_Territory__c>([SELECT Id, Account__c, Territory__c, HSFE_Combination_Key__c FROM HSFE_Account_Territory__c WHERE HSFE_Combination_Key__c IN :accountQuerySet]);
            for(HSFE_Account_Territory__c accTerr: accTerrList){
                combKeytoTerrMap.put(accTerr.HSFE_Combination_Key__c, accTerr.Territory__c);
                terrIdSet.add(accTerr.Territory__c);
            }
            System.debug('*********************combKeytoTerrMap' + combKeytoTerrMap);
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
            
            System.debug('*********************opptyToUpdateMap' + opptyToUpdateMap);
            for(Id idVal : opptyToUpdateMap.keySet()){
                tempOppty = opptyToUpdateMap.get(idVal);
                creatorPresent = false;
                userId = tempOppty.CreatedById;
                System.debug('*********************tempOppty.HSFE_Combination_Key__c' + tempOppty.HSFE_Combination_Key__c);
                if(combKeytoTerrMap.containsKey(tempOppty.HSFE_Combination_Key__c)){
                    Id terrId = combKeytoTerrMap.get(tempOppty.HSFE_Combination_Key__c);
                    tempOppty.HSFE_Territory__c = terrId;
                    if(territoryToRoleToUserMapMap.containsKey(terrId)){
                        tempMap = territoryToRoleToUserMapMap.get(terrId);
                        System.debug('*********************tempMap' + tempMap);
                        if(tempMap.containsKey(HSFE_Constant.TM)){
                            tempOppty.OwnerId = tempMap.get(HSFE_Constant.TM).HSFE_User__c;
                        }
                    }
                    for(String role : tempMap.keySet()){
                    	if(userId == tempMap.get(role).HSFE_User__c){
                    		creatorPresent = true;
                    	}
                        tempTeam = new OpportunityTeamMember(OpportunityId = idVal, UserId = tempMap.get(role).HSFE_User__c, TeamMemberRole = role);
                        teamToCreateList.add(tempTeam);
                    }
                    if(!creatorPresent){
                    	tempTeam = new OpportunityTeamMember(OpportunityId = idVal, UserId = userId, TeamMemberRole = 'Creator');
                        teamToCreateList.add(tempTeam);
                    }
                }
            }
        }
        if(opptyToDeleteMap.size() > 0){
            List<OpportunityTeamMember> teamToDeleteList = new List<OpportunityTeamMember>([SELECT Id from OpportunityTeamMember WHERE OpportunityId IN :opptyToDeleteMap.keySet() AND OpportunityAccessLevel != 'All']);
            if(teamToDeleteList.size() > 0){
                Delete teamToDeleteList;
            }
        }
        if(teamToCreateList.size() > 0){
        	System.debug('*************************teamToCreateList' + teamToCreateList);
            Insert teamToCreateList;
            List<OpportunityShare > updateOpptyShareList = new List<OpportunityShare>();
            List<OpportunityShare > shares = [select Id, OpportunityAccessLevel, OpportunityId from OpportunityShare where OpportunityId IN :opptyToUpdateMap.keySet() 
                                        and OpportunityAccessLevel != 'All' and OpportunityAccessLevel !='Edit' and RowCause= 'Team'];
            if(shares.size()>0){
                for(OpportunityShare oppShare:shares ){
                    oppShare.OpportunityAccessLevel='Edit';
                    updateOpptyShareList.add(oppShare);
                }
            }
            if(updateOpptyShareList.size()>0){
                update updateOpptyShareList;
            }
        }
        if(opptyToDeleteMap.size()> 0){
            Update opptyToDeleteMap.values();
        }else if(opptyToUpdateMap.size()> 0){
            Update opptyToUpdateMap.values();
        }
    }
}