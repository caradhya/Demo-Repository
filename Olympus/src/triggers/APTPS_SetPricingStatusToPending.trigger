trigger APTPS_SetPricingStatusToPending on Apttus_Config2__LineItem__c (before update) {

    for(Apttus_Config2__LineItem__c lineItemSO : trigger.New) {
        lineItemSO.Apttus_Config2__PricingStatus__c = 'Pending';
    }

}