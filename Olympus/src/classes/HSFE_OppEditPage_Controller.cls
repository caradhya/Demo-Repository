public with sharing class HSFE_OppEditPage_Controller{

    public HSFE_OppEditPage_Controller(ApexPages.StandardController controller) {
    
    Opportunity opp = (Opportunity)controller.getRecord();
    opp.HSFE_Sales_Stage__c='Closed Lost';

    }

}