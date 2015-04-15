trigger HSFE_UpdateLineItemsToComplete on Apttus_Config2__ProductConfiguration__c (before Update) {
    
    set<id> ConfigIds = new set<id>();
    list<Apttus_Config2__LineItem__c> UpdateLineItemRec = new list<Apttus_Config2__LineItem__c>();
    for(Apttus_Config2__ProductConfiguration__c Config : Trigger.new){           
        if(Config.Apttus_Config2__Status__c == 'Ready For Finalization'){ 
            Config.Apttus_Config2__IsPricePending__c = false;     
            ConfigIds.add(Config.id);
        }    
    }
    for(Apttus_Config2__LineItem__c LineItemRec : [Select id, Apttus_Config2__PricingStatus__c, Apttus_Config2__ConfigurationId__c 
                                                    from Apttus_Config2__LineItem__c 
                                                    where Apttus_Config2__ConfigurationId__c in: ConfigIds]){
                                                    
        LineItemRec.Apttus_Config2__PricingStatus__c = 'Complete';
        UpdateLineItemRec.add(LineItemRec);
    }
    update UpdateLineItemRec;
}