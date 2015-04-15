/* 
* Class Name  : HSFE_Proposal_TriggerHandler_Class
* Description : Trigger Handler for the Proposal SObject, which implements all the logic.
* Created By  : Yunus H Navalur
* Created On  : 4/3/2015
*
* Modification log:
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                  Date                             Description
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Yunus                      4/3/2015
*
*
*/

public with sharing class HSFE_Proposal_TriggerHandler_Class{
    
    public void UpdatePriceListOnProposal_BeforeInsert(List<Apttus_Proposal__Proposal__c> NewRecords_List, List<Apttus_Proposal__Proposal__c> OldRecords_List, map<id,Apttus_Proposal__Proposal__c> NewProposalRecords, map<id,Apttus_Proposal__Proposal__c> OldProposalRecords){
    
        Apttus_Config2__PriceList__c PricelistRec = [select id,Name from Apttus_Config2__PriceList__c where Name =: HSFE_Constant.CUSTOM_DEFAULT_PRICELIST limit 1];
        if(NewRecords_List != null)
            for(Apttus_Proposal__Proposal__c ProposalRecord : NewRecords_List){
                ProposalRecord.Apttus_QPConfig__PriceListId__c = PricelistRec.id;
            }        
    }
    
    public void PrimaryQuoteLogic_BeforeInsert(List<Apttus_Proposal__Proposal__c> NewRecords_List, List<Apttus_Proposal__Proposal__c> OldRecords_List, map<id,Apttus_Proposal__Proposal__c> NewProposalRecords, map<id,Apttus_Proposal__Proposal__c> OldProposalRecords){
        
        map<id,id> Oppr_PrimaryQuoteIds = new map<id,id>();
        map<id,boolean> Oppr_PrimaryQuoteReady = new map<id,boolean>();
        list<Apttus_Proposal__Proposal__c> UpdateProposal = new list<Apttus_Proposal__Proposal__c>();
        
        for(Apttus_Proposal__Proposal__c ProposalRecord : NewRecords_List){
            Oppr_PrimaryQuoteIds.put(ProposalRecord.Apttus_Proposal__Opportunity__c,null);
        }
        
        for(Apttus_Proposal__Proposal__c ProposalRec: [select id, Apttus_Proposal__Approval_Stage__c, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Primary__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in: Oppr_PrimaryQuoteIds.KeySet() and Apttus_Proposal__Primary__c =: True ]){
            if(ProposalRec.Apttus_Proposal__Approval_Stage__c != HSFE_Constant.CUSTOM_QUOTE_ACCEPTED){
                if(Oppr_PrimaryQuoteIds.ContainsKey(ProposalRec.Apttus_Proposal__Opportunity__c)){
                    Oppr_PrimaryQuoteIds.put(ProposalRec.Apttus_Proposal__Opportunity__c,ProposalRec.id);
                    Oppr_PrimaryQuoteReady.put(ProposalRec.id,true);
                    ProposalRec.Apttus_Proposal__Primary__c = false; 
                    UpdateProposal.add(ProposalRec);                    
                }
            }else{
                Oppr_PrimaryQuoteIds.put(ProposalRec.Apttus_Proposal__Opportunity__c,ProposalRec.id);
                Oppr_PrimaryQuoteReady.put(ProposalRec.id,false);
            }    
        }
        
        if(UpdateProposal != null)
            Update UpdateProposal;
            
        for(Apttus_Proposal__Proposal__c ProposalRecord : NewRecords_List){
            if(Oppr_PrimaryQuoteIds.containsKey(ProposalRecord.Apttus_Proposal__Opportunity__c)){
                if(Oppr_PrimaryQuoteReady.ContainsKey(Oppr_PrimaryQuoteIds.get(ProposalRecord.Apttus_Proposal__Opportunity__c))){
                    if(Oppr_PrimaryQuoteReady.get(Oppr_PrimaryQuoteIds.get(ProposalRecord.Apttus_Proposal__Opportunity__c))){
                        ProposalRecord.Apttus_Proposal__Primary__c = true;
                    }else{
                        ProposalRecord.Apttus_Proposal__Primary__c = false;
                    }
                }else{
                    ProposalRecord.Apttus_Proposal__Primary__c = true;
                }
            }
        }          
    }    
    
    public void UpdateOpportunityOnProposalChange_AfterUpdate(List<Apttus_Proposal__Proposal__c> NewRecords_List, List<Apttus_Proposal__Proposal__c> OldRecords_List, map<id,Apttus_Proposal__Proposal__c> NewProposalRecords, map<id,Apttus_Proposal__Proposal__c> OldProposalRecords){
        Map<id,boolean> OpportunityIdsWithCondition = new map<id,boolean>();
        List<Opportunity> UpdateOpp_Records = new List<Opportunity>();
        for(Apttus_Proposal__Proposal__c PropRec: NewProposalRecords.Values()){
            if(NewProposalRecords.get(PropRec.id).HSFE_Quote_Status__c!= OldProposalRecords.get(PropRec.id).HSFE_Quote_Status__c&& PropRec.HSFE_Quote_Status__c== HSFE_Constant.CUSTOM_QUOTE_ACCEPTED && PropRec.Apttus_Proposal__Primary__c == true){
                OpportunityIdsWithCondition.put(PropRec.Apttus_Proposal__Opportunity__c,true);
            }
        }
        if(OpportunityIdsWithCondition != null){
            for(Opportunity OppRec: [Select id,HSFE_Quote_Accepted__c,HSFE_Sales_Stage__c from Opportunity where id in: OpportunityIdsWithCondition.KeySet() ]){
                OppRec.HSFE_Quote_Accepted__c = OpportunityIdsWithCondition.get(OppRec.id);
                OppRec.HSFE_Sales_Stage__c = HSFE_Constant.Custom_CLOSED_WON;
                UpdateOpp_Records.add(OppRec);
            }
            
            if(UpdateOpp_Records != null)
            Update UpdateOpp_Records;
        }
    }
    
}