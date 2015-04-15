public with sharing class PopUpExtension{
    
    public PopUpExtension(ApexPages.StandardController controller) {
        Opportunity opp = (Opportunity)controller.getRecord();
        opp.StageName='Closed Lost';
    }
     
    
}