public with sharing class HSFE_NewOpportunityOverriddenExt  {
private ApexPages.StandardController controller = null;
public HSFE_NewOpportunityOverriddenExt  (ApexPages.StandardController controller){
    this.controller = controller;
}


public PageReference onLoad(){
    User currentuser=[Select Id,Name,HSFE_Specialty__c,HSFE_Sub_Specialty__c from User where Id=:userinfo.getuserId()];
    String prefix = Opportunity.SObjectType.getDescribe().getKeyPrefix();
    String param = getParameters();
    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    PageReference pg = new PageReference('/'+prefix+'/e?nooverride=1&'+param); 
    pg.getParameters().put(System.Label.HSFE_Specialty,currentuser.HSFE_Specialty__c);
    pg.getParameters().put(System.Label.HSFE_Sub_Specialty,currentuser.HSFE_Sub_Specialty__c );
    pg.getParameters().put('opp11','Pipeline');
    pg.getParameters().put(System.Label.HSFE_Sales_Stage,'Universe');
    return pg;
    
}

// Inherit previous parameters, more imporatntly, RecordType parameter!
private String getParameters(){
    string param = '';
    Map<String, String> strMap = ApexPages.currentPage().getParameters();
    String[] keys = new String[]{'RecordType', 'retURL', 'cancelURL','opp4_lkid'};
    for(String s : keys){
    if(strMap.containsKey(S)) param += s + '=' + strMap.get(s) + '&';
    }
    if(param.length() > 0) param = param.substring(0, param.length()-1);
    return param;
    }

}