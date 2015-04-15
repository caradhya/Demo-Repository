/* Class Name : HSFE_Constant
*Description :  It contains all the global constant variables.
*Created By :   Sunil Kumar
*Created On :   03/10/2015
* Modification log:
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                  Date                           Modification Id                       Description
* Deloitte/Sunil              2/10/2015                     Created 
* Deloitte/Yunus              4/1/2015                      Modified v2       
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public class HSFE_Constant {
    
    // Territory User's Role
    public static string AVP = 'AVP';
    public static string RVP = 'RSD/RVP';
    public static string SALESREP = 'Sales Rep';
    public static string TEAMLEAD = 'Team Lead';
    public static string VP = 'VP';
    public static string TM = 'EAM/TM';
    public static string INSIDESALES = 'Inside Sales';
    
    //Lead Speciality
    public static string SURGICAL = 'Surgical';
    public static string MEDICAL = 'Medical';
    
    //Group Name
    public static string QUEUENAME = 'Inside Sales Team';  
    
    //Contact 
    public static string YES = 'Yes';
    public static string NO = 'No';
    
    //Custom Pricing
    public static string LINE_TYPE_PRODUCT_SERVICE = 'Product/Service';
    public static string CHARGE_TYPE_KIT_OP = 'Charge Type Kit Op';
    public static string NA_STOCKING_KIT = 'Same as kit';
    public static string COUSTOM_NEW = 'New';
    public static string COUSTOM_TRADE_COMPETITOR = 'Trade-In - Competitor';
    public static string COUSTOM_TRADE_OLYMPUS = 'Trade-In - Olympus';
    public static string COUSTOM_USED = 'Used';
    public static string COUSTOM_RECOMMENDED = 'Recommended Products';
    public static string COUSTOM_OPTIONAL = 'Optional Accessories';
    public static string COUSTOM_MANDATORY = 'Mandatory Accessories';
    public static string COUSTOM_FREE_GOODS = 'Free Goods';
    public static set<string> CUSTOM_SKIP_ADJUSTMENT = new set<string>{'Trade-In - Competitor','Trade-In - Olympus','Used'};
    
    // Inactive Account Name
    public static string ACCOUNTNAME = 'Inactive Contacts';

    //Opportunity Details
    public static string CUSTOM_ClOSED_WON = 'Closed Won';    
    
    // Quote Details
    public static string CUSTOM_QUOTE_ACCEPTED = 'Closed';  
    public static string CUSTOM_DEFAULT_PRICELIST = 'Olympus_MSG_NA';
    
    //Opprtunity Sales Stage for Reminder
    public static set<String> OPPTY_REMINDER_STAGE_SET = new set<String>{'Verbally Accepted','Closed Won','Closed Lost'};
    public static integer NUMBER_OF_DAYS = 4;
    
    //Lead immport default contact name functionality
    public static string LEAD_TBD_NAME = 'TBD';
    
    //Lotus Event Type Meeting
    public static string MEETING = 'Meeting';
    public static Id MULE_INTEGRATION_USER = '00511000002Ol7f';
}