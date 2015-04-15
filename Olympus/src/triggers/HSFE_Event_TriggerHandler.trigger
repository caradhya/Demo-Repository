/************************************************************************************** 
 Trigger Name        : HSFE_Event_TriggerHandler
 Version             : 1.0 
 Created Date        : 12 April 2015
 Function            : This trigger will perform any customization on event records during any insert or update events
 Modification Log    :
 * Developer                      Date                                    Description
 * ----------------------------------------------------------------------------                 
 * Kumar Gaurav                04/12/2014                              Original Version
 *************************************************************************************/
trigger HSFE_Event_TriggerHandler on Event (before insert, before update) {
    if (Trigger.isBefore && !HSFE_Utility_Class.hasAlreadyExecuted()) { 
        HSFE_EventTriggerHandler_Class.handleLotusNotesUpdate(trigger.new);
        HSFE_Utility_Class.setAlreadyExecuted();
    }
}