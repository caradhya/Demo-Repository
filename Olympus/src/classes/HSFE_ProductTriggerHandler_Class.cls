/* 
* Class Name  : HSFE_ProductTriggerHandler_Class 
* Description : Trigger Handler for the Product SObject, which implements all the logic.
* Created By  : Yunus H Navalur
* Created On  : 02/20/2015
*
* Modification log:
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                  Date                             Description
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Yunus                    3/23/2015
*
*
*/

public with sharing class HSFE_ProductTriggerHandler_Class{
    
    public void ProductConditionPopulateLogic_Update(map<id,Product2> NewTriggerRecords,Map<id,Product2> OldTriggerRecords){

        //Declarations Section
        map<string,String> ProdAttrConditionMap = new map<string,String>();
        
        
        //Logic Section
        for(product2 LoopProdRec: NewTriggerRecords.values()){
            if(LoopProdRec.HSFE_Product_Conditions_Multi__c != null){
                List<String> Values = LoopProdRec.HSFE_Product_Conditions_Multi__c.Split(';',5);
                Values.sort();
                String strSobjects = null;                 
                for(integer i=0;i<Values.size();i++){
                    if(strSobjects == null){
                        strSobjects = Values[i];
                    }Else{
                        strSobjects = strSobjects+';'+Values[i];
                    }               
                }
                LoopProdRec.HSFE_Product_Conditions_Multi__c = strSobjects;
                ProdAttrConditionMap.put(strSobjects,'');
            }                     
        }
        for(HSFE_Product_Attribute_Charge_Types__c CustomSetgRec : [select name,HSFE_Name_Long__c,HSFE_Description__c from HSFE_Product_Attribute_Charge_Types__c where HSFE_Name_Long__c in: ProdAttrConditionMap.KeySet()]){
            if(ProdAttrConditionMap.ContainsKey(CustomSetgRec.HSFE_Name_Long__c)) 
                ProdAttrConditionMap.put(CustomSetgRec.HSFE_Name_Long__c,CustomSetgRec.Name);      
        }
        for(product2 LoopProdRec: NewTriggerRecords.values()){
            if(ProdAttrConditionMap.ContainsKey(LoopProdRec.HSFE_Product_Conditions_Multi__c)){
                LoopProdRec.HSFE_Charge_Type__c = ProdAttrConditionMap.get(LoopProdRec.HSFE_Product_Conditions_Multi__c);
            }else if(LoopProdRec.HSFE_Product_Conditions_Multi__c != null && !ProdAttrConditionMap.ContainsKey(LoopProdRec.HSFE_Product_Conditions_Multi__c)){
                LoopProdRec.HSFE_Charge_Type__c = 'N/A - Stocking Kit';
            }else{
                LoopProdRec.HSFE_Charge_Type__c = '';
            }   
        }                          
    }
    
    public void ProductConditionPopulateLogic_Insert(List<Product2> NewTriggerRecords){

        //Declarations Section
        map<string,String> ProdAttrConditionMap = new map<string,String>();
        
        
        //Logic Section
        for(product2 LoopProdRec: NewTriggerRecords){
            if(LoopProdRec.HSFE_Product_Conditions_Multi__c != null){
                List<String> Values = LoopProdRec.HSFE_Product_Conditions_Multi__c.Split(';',5);
                Values.sort();
                String strSobjects = null;                 
                for(integer i=0;i<Values.size();i++){
                    if(strSobjects == null){
                        strSobjects = Values[i];
                    }Else{
                        strSobjects = strSobjects  +';'+Values[i];
                    }               
                }
                LoopProdRec.HSFE_Product_Conditions_Multi__c = strSobjects;
                ProdAttrConditionMap.put(strSobjects,'');                
            }                     
        }
        for(HSFE_Product_Attribute_Charge_Types__c CustomSetgRec : [select name,HSFE_Name_Long__c,HSFE_Description__c from HSFE_Product_Attribute_Charge_Types__c where HSFE_Name_Long__c in: ProdAttrConditionMap.KeySet()]){
            if(ProdAttrConditionMap.ContainsKey(CustomSetgRec.HSFE_Name_Long__c)) 
                ProdAttrConditionMap.put(CustomSetgRec.HSFE_Name_Long__c,CustomSetgRec.Name);      
        }
        for(product2 LoopProdRec: NewTriggerRecords){
            if(ProdAttrConditionMap.ContainsKey(LoopProdRec.HSFE_Product_Conditions_Multi__c)){
                LoopProdRec.HSFE_Charge_Type__c = ProdAttrConditionMap.get(LoopProdRec.HSFE_Product_Conditions_Multi__c);
            }else if(LoopProdRec.HSFE_Product_Conditions_Multi__c != null && !ProdAttrConditionMap.ContainsKey(LoopProdRec.HSFE_Product_Conditions_Multi__c)){
                LoopProdRec.HSFE_Charge_Type__c = 'N/A - Stocking Kit';
            }else{
                LoopProdRec.HSFE_Charge_Type__c = '';
            }   
        }                          
    }    
}