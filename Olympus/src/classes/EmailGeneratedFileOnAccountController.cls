public class EmailGeneratedFileOnAccountController {
    
    private String accountId; 
    public Account account;
    private Map<String, String> PageParameter;
    private String xdpTemplateBody;
    public String selectOption {get; set;}
    public String inputEmail{get; set;}
    public String xdpFormData{get; set;}
    PageReference curPage;
    PageReference returnPage;
    
    
    public EmailGeneratedFileOnAccountController(ApexPages.StandardController stdCont) {
        PageParameter = ApexPages.currentPage().getParameters();
        if (null != PageParameter){
            returnPage = new PageReference('/' + PageParameter.get('retUrl'));
            accountId = PageParameter.get('retUrl');
        }
        //curPage = Page.ProspectSapForm2;
        //Changes Prateek
        	curPage = new PageReference('/apex/ProspectSapForm2?Id='+accountId);
			curPage.setRedirect(false);
        
        selectOption = 'Email';
        System.debug('Prateek : ' + xdpFormData);
    }
    
    public PageReference sendEmailwithAttachment(){
        
        List<String> recipientList = new List<String>();
        System.debug('Prateek : ' + xdpFormData);
        try {
            if (null != inputEmail)
            	recipientList.add(inputEmail);
            
            Blob emailBody = curPage.getContent();
            System.debug('String Body is : ' + emailBody.toString());
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
        return returnPage;
    }
    
    public PageReference attachAtachmentToAccount(){
        Attachment atch = new Attachment();
        try {
            atch.Body = curPage.getContent();
            atch.ParentId = accountId;
            atch.Name = 'CreateSoldToPayerForm.xdp';
            atch.ContentType = 'txt/xml';
            Insert atch;
        }
        catch (Exception ex) {
            System.debug('Error : ' + ex.getLineNumber() + ' Cause :' + ex.getMessage());
        }
        return returnPage;
    }
    
    public String getXdpFormData(){
        String data = '';
        return data;
    }
}