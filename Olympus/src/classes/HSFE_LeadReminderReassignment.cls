/* 
*Class Name :HSFE_LeadReminderReassignment
*Description :This class for re-assignment and reminder functionality.
*Created By  :Sourav Datta
*Created On  :02/26/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sourav             2/26/2015                      Created                          
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
global class HSFE_LeadReminderReassignment implements Schedulable {
    global void execute(SchedulableContext SC){
        Date TodayDate = Date.today();
        List<ConnectApi.BatchInput> batchInputList = new List<ConnectApi.BatchInput>();
        List<Lead> reminderLeadList = new List<Lead>([SELECT Id,OwnerId,Name,HSFE_Reminder_Date__c FROM LEAD WHERE HSFE_Reminder_Date__c = :TodayDate]);
        List<Lead> reassignmentLeadList = new List<Lead>([SELECT Id,OwnerId,Name FROM LEAD WHERE HSFE_Reassignment_Date__c = :TodayDate]);
        for(Lead ld: reminderLeadList){
            String PostText = 'Please take action on ' + ld.Name + ' or the lead will be re-assigned to your RVP';
            
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            //User Id
            mentionSegmentInput.id = ld.OwnerId;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            textSegmentInput.text = PostText;
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            //Id of Object being tagged
            feedItemInput.subjectId = ld.Id;
            
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
            batchInputList.add(batchInput);
            ld.HSFE_Reminder_Date__c = null;
        }
        ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputList);
        
        if(reminderLeadList.size()>0){
            Update reminderLeadList;
        }
        
        List<Id> LeadOwnerIdList = new List<Id>();
        for(Lead ld: reassignmentLeadList){
            LeadOwnerIdList.add(ld.OwnerId);
        }
        Map<Id,User> OwnerManagerMap = new Map<Id,User>([SELECT Id,ManagerId FROM User WHERE Id IN :LeadOwnerIdList]);
        for(Lead ld: reassignmentLeadList){
            if(OwnerManagerMap.containsKey(ld.OwnerId) && OwnerManagerMap.get(ld.OwnerId).ManagerId <> null){
                ld.OwnerId = OwnerManagerMap.get(ld.OwnerId).ManagerId;
                ld.HSFE_Override_Assignment_Reminder__c = true;
                ld.HSFE_Reassignment_Date__c = null;
            }
        }
        if(reassignmentLeadList.size()>0){
            Update reassignmentLeadList;
        }
        for(Lead ld: reassignmentLeadList){
            ld.HSFE_Override_Assignment_Reminder__c = false;
        }
        if(reassignmentLeadList.size()>0){
            Update reassignmentLeadList;
        }
    }
    
}