public class ProspectSapForm2ExtController {
    public Account account;
    
    public ProspectSapForm2ExtController(ApexPages.StandardController stdCont){
        account = (Account) stdCont.getRecord();
        System.debug('Prateek IN Second Page : ' + account);
    }
    
    /*
    public void sendEmailwithAttachment(){
        
        List<String> recipientList = new List<String>();
         try {
            
           // if (null != inputEmail)
            	recipientList.add('pratsaxena@deloitte.com');
            System.debug('String Body is : ' + curPage.getContent().toString());
            Blob emailBody = curPage.getContent();
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('CreateSoldToPayerForm.xdp');
            efa.setContentType('txt/xml');
            efa.setInline(true);
            efa.setBody(emailBody);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(recipientList);
            email.setSubject('Account XDP File Attachment');
            email.setHtmlBody('Body');
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

        }
        catch (Exception ex){
            System.debug('Error : ' + ex.getLineNumber() + ' Cause :' + ex.getMessage());
        }
        
    }*/
    
}