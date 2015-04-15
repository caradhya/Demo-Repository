public with sharing class CalAppointmentTest {

	public void callAppointmentService(){
		CalAppointment.Domino cappDm = new CalAppointment.Domino();
		cappDm.endpoint_x = 'http://dev:1024/apps/dale/calendarservice.nsf/CalAppointment?OpenWebService';
		String SALESFORCE_ID = 'XXXG';
		String SUSER = 'Test User';
		String MAILDB = 'Mail/tuser.nsf';
		String SSUBJECT = 'POC 001';
		String VCALSTARTDATE = String.valueof(DateTime.Now());
		String VCALSTARTTIME = String.valueof(DateTime.Now());
		String VCALENDDATE = String.valueof(DateTime.Now());
		String VCALENDTIME = String.valueof(DateTime.Now());
		String DESCRIPTION = 'POC';
		String LOCATION = 'POC';
		cappDm.CREATECALENTRYAPPOINTMENT(SUSER, MAILDB, SSUBJECT, VCALSTARTDATE, VCALSTARTTIME, VCALENDDATE, VCALENDTIME, DESCRIPTION, LOCATION, SALESFORCE_ID);
	}
}