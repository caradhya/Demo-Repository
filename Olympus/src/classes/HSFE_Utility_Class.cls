/* Class Name :HSFE_Utitlity_Class
*Description : Utility class for all the reusable functionality.
*Created By :Chiranth Aradhya
*Created On :03/10/2015
* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*Kumar Gaurav               03/23/2015                                                          Added method to stop recursive calls while Apttus Callback
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public with sharing class HSFE_Utility_Class {

    /************VARIABLE Declaration**************************************/

    private static boolean run = true;
    public static boolean stopUpdateLeadTerritory = false;
    public static boolean stopUpdateOpptyTerritory = false;
    public static boolean stopUpdateAccountTerritory = false;
    private Static Boolean alreadyExecuted = false;
    //Variable
    public static Map<String, String> constantCategoryMap = assignConstant();
   
    /************VARIABLE Declaration**************************************/
     
    /*********************************************************************************
     * Method Name:handleTerritoryMapping
     * Description:This method is to map the territories
     * Return Type: Territory Map.
     *********************************************************************************/
     
    public static  Map<String, Map<String,HSFE_Territory_To_User__c >> handleTerritoryMapping(Set<String>combinationKey) {
        
        Map<String, Map<String,HSFE_Territory_To_User__c >> terrFinalMap = new Map<String, Map<String,HSFE_Territory_To_User__c >>();
        Map<Id, Map<String,HSFE_Territory_To_User__c >> territoryUserMap = new Map<Id, Map<String,HSFE_Territory_To_User__c >>();
       
        system.debug('*****************combinationKey********************'+combinationKey);
        //Get the map of Territory Id's 
        for(HSFE_Zip_To_Territory__c zipte:[Select Id,HSFE_Territory__c from HSFE_Zip_To_Territory__c where HSFE_Combination_Key__c IN:combinationKey]){
            territoryUserMap.put(zipte.HSFE_Territory__c, null);
            system.debug('*****************territoryUserMap********************'+territoryUserMap); 
        }
        system.debug('*****************territoryUserMap********************'+territoryUserMap); 
        Map<String,HSFE_Territory_To_User__c> tempMap;
        for(HSFE_Territory_To_User__c terrUser:[Select Id, HSFE_User_Role__c,HSFE_Territory__c, HSFE_User__c from HSFE_Territory_To_User__c where HSFE_Territory__c IN: territoryUserMap.Keyset()]){
           if(terrUser.HSFE_User_Role__c != null){
               if(territoryUserMap.get(terrUser.HSFE_Territory__c) == null){
                    tempMap = new Map<String,HSFE_Territory_To_User__c>();
                    tempMap.put(terrUser.HSFE_User_Role__c,terrUser);
                }else{  
                   tempMap = territoryUserMap.get(terrUser.HSFE_Territory__c);
                   tempMap.put(terrUser.HSFE_User_Role__c,terrUser);
                }
                territoryUserMap.put(terrUser.HSFE_Territory__c,tempMap);
            }
        }
        
        //Pass the CombinationKey and User record 
        for(HSFE_Zip_To_Territory__c zipte:[Select Id,HSFE_Combination_Key__c,HSFE_Territory__c from HSFE_Zip_To_Territory__c where HSFE_Combination_Key__c IN:combinationKey]){
            terrFinalMap.put(zipte.HSFE_Combination_Key__c,territoryUserMap.get(zipte.HSFE_Territory__c));
        }   
        return terrFinalMap;
    }
    
    public static Map<String,ID> territoryHelper(Set<String>combinationKey){
    
        Map<String,ID> territoryMap = new Map<String,ID>();
        //Get the map of Territory Id's 
        for(HSFE_Zip_To_Territory__c zipte:[Select Id,HSFE_Territory__c,HSFE_Combination_Key__c from HSFE_Zip_To_Territory__c where HSFE_Combination_Key__c IN:combinationKey]){
            territoryMap.put(zipte.HSFE_Combination_Key__c,zipte.HSFE_Territory__c);
        }
         return territoryMap;
    }
    
     /*********************************************************************************
     * Method Name:runOnce
     * Description:This method is to control the recursive triggers
     * Return Type: boolean.
     ********************************************************************************/
    public static boolean runOnce(){
        if(run){
             run=false;
             return true;
        }else{
            return run;
        }
    }
    //Methods added by Kumar Gaurav for Apttus Callback
    /*
     * Method name  : hasAlreadyExecuted
     * Description  : This method is to prevent recurssive call in callback methods
     * Return Type  : Boolean
     * Parameter    : None
     */
     public static boolean hasAlreadyExecuted() {
        return alreadyExecuted ;
     }
     
     /*
     * Method name  : setAlreadyExecuted
     * Description  : This method will force callback flag to set as its already executed
     * Return Type  : Boolean
     * Parameter    : None
     */
     public static void setAlreadyExecuted() {
        alreadyExecuted = true;
     }  
     
     /*
     * Method name  : setAlreadyExecutedFalse
     * Description  : This method will force callback flag to re-set
     * Return Type  : Boolean
     * Parameter    : None
     */
     public static void setAlreadyExecutedFalse() {
        alreadyExecuted = false;
     }
     
    // Method which stores the value from Custom Setting - HSFE_Product_Attribute_Charge_Types__c into constantCategoryMap
    public static Map<String, String> assignConstant () {
        
        // Return Value
        Map<String, String> tempMap = new Map<String, String>(); 
        String tempVal = null;
        // Fetch values from Custom Setting - HSFE_Product_Attribute_Charge_Types__c
        for (HSFE_Product_Attribute_Charge_Types__c consObj : HSFE_Product_Attribute_Charge_Types__c.getAll().values()) {
            tempVal = consObj.HSFE_Name_Long__c;
            Integer Position = tempVal.indexOf(HSFE_Constant.COUSTOM_NEW, 0);            
            if(Position > 0){
                tempVal = HSFE_Constant.COUSTOM_NEW;
            }else{
                tempVal = tempVal.split(';')[0];
            }           
            
            tempMap.put(consObj.Name, tempVal);
        }
        system.debug('-----tempMap----->'+tempMap);
        return tempMap;
    } 
}