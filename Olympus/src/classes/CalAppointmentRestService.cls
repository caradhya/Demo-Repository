/************************************************************************************** 
 Apex Class Name     : CalAppointmentRestService
 Version             : 1.0 
 Created Date        : 03 Mar 2015
 Function            : This class tracks the constants and provides actions
 Modification Log    :
 * Developer                      Date                                    Description
 * ----------------------------------------------------------------------------                 
 * Kumar Gaurav                03/04/2014                              Original Version
 *************************************************************************************/
public class CalAppointmentRestService {
	
	/*
     * Method name  : createCalendarInNotes
     * Description  : This method is called when the salesrep creates an event in salesforce
     * Return Type  : None
     * Parameter    : None
     */ 
	public void createCalendarInNotes(){
		String username = 'Test User';
		String password = 'Olympus1';
		HTTP h = new HTTP();
		HTTPRequest req = new HTTPRequest();
		req.setEndpoint('http://12.189.73.186/apps/dale/calendarservice.nsf/CalAppointmentv2');
		Blob headerValue = Blob.valueOf(username + ':' + password);
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
		req.setHeader('Authorization', authorizationHeader);
		req.setMethod('POST');
		req.setTimeOut(120000);
        //req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setBody(createRequestXML2());
		HTTPResponse resp = h.send(req);
		system.debug('Res----------------------->'+resp);
		system.debug('Res----------------------->'+resp.getBody());
	}
	
	
	/*
     * Method name  : createRequestXML
     * Description  : This method is called to create request XML
     * Return Type  : String
     * Parameter    : None
     */ 
	public String createRequestXML(){
		String xmlReq = '';  
        xmlReq += '<soap:Envelope xmlns:soap = "http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:DefaultNamespace">';
        xmlReq +=   '<soap:Body>';
        xmlReq +=       '<urn:CREATECALENTRYAPPOINTMENT>';//CREATECALENTRYAPPOINTMENT
        xmlReq +=           '<SUSER>Test User</SUSER>';
        xmlReq +=           '<MAILDB>Mail/tuser.nsf</MAILDB>';
        xmlReq +=           '<SSUBJECT>POC Kumar Gaurav 001 - </SSUBJECT>';
        xmlReq +=           '<VCALSTARTDATE>3/10/2015</VCALSTARTDATE>';
        xmlReq +=       	'<VCALSTARTTIME>17:00:00</VCALSTARTTIME>';
        xmlReq +=   		'<VCALENDDATE>3/10/2015</VCALENDDATE>';
        xmlReq +=   		'<VCALENDTIME>17:10:00</VCALENDTIME>';
        xmlReq +=   		'<DESCRIPTION>POC</DESCRIPTION>';
        xmlReq +=   		'<LOCATION>OLYMPUS</LOCATION>';
        xmlReq +=   		'<SALESFORCE_ID>001</SALESFORCE_ID>';
        xmlReq +=       '</urn:CREATECALENTRYAPPOINTMENT>';
        xmlReq +=   '</soap:Body>';
        xmlReq += '</soap:Envelope>';
        return xmlReq;
	}
	
	/*
     * Method name  : createRequestXML2
     * Description  : This method is called to create request XML
     * Return Type  : String
     * Parameter    : None
     */ 
	public String createRequestXML2(){
		String xmlReq = '';  
        xmlReq += '<soap:Envelope xmlns:soap = "http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:DefaultNamespace">';
        xmlReq +=   '<soap:Body>';
        xmlReq +=       '<urn:CREATECALENTRYAPPOINTMENT>';
        xmlReq +=           '<SUSER>Dale Lin </SUSER>';
        xmlReq +=           '<EMAILADD>dale.lin@olympus.com</EMAILADD>';
        xmlReq +=           '<SSUBJECT>POC Kumar Gaurav 001 - </SSUBJECT>';
        xmlReq +=           '<VCALSTARTDATE>3/10/2015</VCALSTARTDATE>';
        xmlReq +=       	'<VCALSTARTTIME>17:00:00</VCALSTARTTIME>';
        xmlReq +=   		'<VCALENDDATE>3/10/2015</VCALENDDATE>';
        xmlReq +=   		'<VCALENDTIME>17:10:00</VCALENDTIME>';
        xmlReq +=   		'<DESCRIPTION>POC</DESCRIPTION>';
        xmlReq +=   		'<LOCATION>OLYMPUS Desk</LOCATION>';
        xmlReq +=   		'<SALESFORCE_ID>001</SALESFORCE_ID>';
        xmlReq +=   		'<CATEGORIES>001</CATEGORIES>';
        xmlReq +=   		'<INVITEES>kumgaurav@deloitte.com, sandy.strouse@olympus.com</INVITEES>';
        xmlReq +=       '</urn:CREATECALENTRYAPPOINTMENT>';
        xmlReq +=   '</soap:Body>';
        xmlReq += '</soap:Envelope>';
        return xmlReq;
	}
	
	/*
     * Method name  : computePrice
     * Description  : This method is test only
     * Return Type  : String
     * Parameter    : None
     */ 
	public boolean computePrice(String cartId, Integer lineNumber){
        //RE-PRICE 
        Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO netRequest = null;
        Apttus_CPQApi.CPQ.ComputeNetPriceResponseDO res = null;
        boolean isSuccess = false;
        system.debug('Method computePrice Input  Line number - > '+lineNumber+ '  CartId - >'+ cartId);
        try{
            netRequest = new Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO();
            netRequest.CartId = cartId;
            netRequest.LineNumber = Integer.valueof(lineNumber);
            res = Apttus_CPQApi.CPQWebService.computeNetPriceForBundle(netRequest);
            isSuccess = res.IsSuccess;
        }catch(Exception e){
            system.debug('Method computePrice   Line number - > '+e.getLineNumber()+ '  Message - >'+ e.getMessage());
        }
        return isSuccess;
    }
}