/* Class Name :HSFE_AccountTriggerHandler_Class
*Description :Trigger Handler class for the Account SObject, which implements all the logic of Account trigger.
            1. Update the primary text field on contact based on Is primary checkbox, Primary text field is used in duplicate rules.
*Created By :Sourav Datta
*Created On :04/08/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public with sharing class HSFE_TerritoryObjsTriggerHandler_Class {
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Zip To Terriotry Start*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
   /*********************************************************************************
     * Method Name:handleZipToTerrAfterUpdate
     * Description:Handle After Update keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleZipToTerrAfterUpdate(map<Id, HSFE_Zip_To_Territory__c> newObjMap, map<Id, HSFE_Zip_To_Territory__c> oldObjMap) {
    	try{
    		set<String> zipCodeUpdatedSet = new set<String>();
    		for(Id idVal:newObjMap.keySet()){
                HSFE_Zip_To_Territory__c newObj = newObjMap.get(idVal);
				HSFE_Zip_To_Territory__c oldObj = oldObjMap.get(idVal);
				if(newObj.HSFE_Combination_Key__c ==  oldObj.HSFE_Combination_Key__c && newObj.HSFE_Territory__c != oldObj.HSFE_Territory__c){
					zipCodeUpdatedSet.add(newObj.Name);
				}
            }
            insertZipCodeSet(zipCodeUpdatedSet);
    	}catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    /*********************************************************************************
     * Method Name:handleZipToTerrBeforeUpdate
     * Description:Handle After Update keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleZipToTerrBeforeUpdate(map<Id, HSFE_Zip_To_Territory__c> newObjMap, map<Id, HSFE_Zip_To_Territory__c> oldObjMap) {
    	try{
    		set<String> zipCodeUpdatedSet = new set<String>();
    		for(Id idVal:newObjMap.keySet()){
                HSFE_Zip_To_Territory__c newObj = newObjMap.get(idVal);
				HSFE_Zip_To_Territory__c oldObj = oldObjMap.get(idVal);
				if(newObj.HSFE_Combination_Key__c !=  oldObj.HSFE_Combination_Key__c){
					newObj.addError('Zip Code, Specialty or Sub Specialty cannnot be changed for an existing record');	
				}
            }
    	}catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    /*********************************************************************************
     * Method Name:handleZipToTerrAfterUpdate
     * Description:Handle After Update keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleZipToTerrAfterInsertDelete(list<HSFE_Zip_To_Territory__c> objList) {
    	try{
    		set<String> zipCodeUpdatedSet = new set<String>();
    		for(HSFE_Zip_To_Territory__c obj : objList){
				if(obj.Name != null && obj.Name != ''){
					zipCodeUpdatedSet.add(obj.Name);
				}
            }
            insertZipCodeSet(zipCodeUpdatedSet);
    	}catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Zip To Terriotry End*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

    /*********************************************************************************
     * Method Name:insertZipCodeSet
     * Description: Insert unique zip code sets to the temporary table
     * Return Type: None.
     ********************************************************************************/
    public static void insertZipCodeSet(set<String> zipCodeSet) {
    	
    }
}