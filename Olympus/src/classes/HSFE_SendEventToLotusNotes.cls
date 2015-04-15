/************************************************************************************** 
 Apex Class  Name    : HSFE_SendEventToLotusNotes
 Version             : 1.0 
 Created Date        : 12 April 2015
 Function            : This class will invoke the service to mule
 Modification Log    :
 * Developer                      Date                                    Description
 * ----------------------------------------------------------------------------                 
 * Kumar Gaurav                04/12/2014                              Original Version
 *************************************************************************************/
public  class HSFE_SendEventToLotusNotes {
	/*
     * Method name  : createOrUpdateCalendarInNotes
     * Description  : This method is called when the salesrep creates an event in salesforce
     * Return Type  : None
     * Parameter    : None
     */ 
    @future (callout=true) 
	public static void createOrUpdateCalendarInNotes(List<Id> evdIds){
		String username = 'Test User';
		String endpoint = 'http://12.189.73.247:8888/esb/sfdc/updateSFDCEventInNotes?Id=';
		HTTP h = new HTTP();
		HTTPRequest req = new HTTPRequest();
		req.setEndpoint(endpoint+evdIds.get(0));
		req.setMethod('POST');
		req.setTimeOut(120000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setBody(createRequestXML());
		HTTPResponse resp = h.send(req);
		system.debug('Res----------------------->'+resp);
		system.debug('Res----------------------->'+resp.getBody());
	}
	
	/*
     * Method name  : createRequestXML
     * Description  : This method is called to create empty request XML
     * Return Type  : String
     * Parameter    : None
     */ 
	public static String createRequestXML(){
		String xmlReq = '';  
        xmlReq += '<soap:Envelope xmlns:soap = "http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:DefaultNamespace">';
        xmlReq +=   '<soap:Body>';
        xmlReq +=   '</soap:Body>';
        xmlReq += '</soap:Envelope>';
        return xmlReq;
	}
}