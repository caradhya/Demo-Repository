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
global class HSFE_OpportunityCloseDateReminder implements Schedulable {
    global void execute(SchedulableContext SC){
        Date TodayDate = Date.today();
        Date fiveDayDate = TodayDate.addDays(HSFE_Constant.NUMBER_OF_DAYS);
        List<ConnectApi.BatchInput> batchInputList = new List<ConnectApi.BatchInput>();
        List<Opportunity> reminderOpptyList = new List<Opportunity>([SELECT Id, OwnerId, Name FROM Opportunity WHERE CloseDate = :fiveDayDate AND HSFE_Sales_Stage__c NOT IN :HSFE_Constant.OPPTY_REMINDER_STAGE_SET AND HSFE_Probability__c  < .75]);
        for(Opportunity oppty: reminderOpptyList){
            String PostText = oppty.Name + ' has close date less than 5 days away. Please update the opportunity status.';
            
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            //User Id
            mentionSegmentInput.id = oppty.OwnerId;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            textSegmentInput.text = PostText;
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            //Id of Object being tagged
            feedItemInput.subjectId = oppty.Id;
            
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
            batchInputList.add(batchInput);
        }
        ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputList);
    }
    
}