/*************************************************************************************
* Name          :    HSFE_Proposal_TriggerHandler
* Description   :    Trigger used to update Proposal Pricelist
* Author        :    Deloitte/Yunus
 
Modification Log
----------------
Date             Developer       Comments
---------------------------------------------------------------------------------------
4/3/2015         Yunus           Created
               

**************************************************************************************/

trigger HSFE_Proposal_TriggerHandler on Apttus_Proposal__Proposal__c (Before insert, Before update, After insert, After update) {

    HSFE_Proposal_TriggerHandler_Class ClassInstance = new HSFE_Proposal_TriggerHandler_Class();
    
    If(Trigger.IsBefore){
        If(Trigger.IsInsert){
            ClassInstance.UpdatePriceListOnProposal_BeforeInsert(Trigger.new,null,Trigger.newmap,null);
            ClassInstance.PrimaryQuoteLogic_BeforeInsert(Trigger.new,null,Trigger.newmap,null);
        }    
    }
    
    If(trigger.IsAfter){
        If(Trigger.IsUpdate){
            ClassInstance.UpdateOpportunityOnProposalChange_AfterUpdate(Trigger.new,Trigger.old,Trigger.newmap, Trigger.oldmap);
        }
    }            
}