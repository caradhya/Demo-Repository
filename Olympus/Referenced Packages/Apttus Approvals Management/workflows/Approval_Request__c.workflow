<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ApprovalRequestCommentsEntered</fullName>
        <description>Approval Request Comments Entered</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/Approval_Request_Comments_Entered2</template>
    </alerts>
    <alerts>
        <fullName>ApprovalRequestEscalationReminder</fullName>
        <description>Approval Request Escalation Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/ApprovalRequestEscalationReminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>Resettrigger</fullName>
        <description>Reset trigger flag when comments have been entered for an approval request without actually approving or rejecting the request.</description>
        <field>Workflow_Trigger_Added_Comments__c</field>
        <literalValue>0</literalValue>
        <name>Reset trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetCanEscalateToFalse</fullName>
        <description>Set the can escalate flag to true when the request has a valid escalation assignee</description>
        <field>CanEscalate__c</field>
        <literalValue>0</literalValue>
        <name>Set Can Escalate To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetDateEscalatedToNull</fullName>
        <description>Clears the date escalated field when the request is escalated</description>
        <field>DateEscalated__c</field>
        <name>Set Date Escalated To Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetInEscalationToTrue</fullName>
        <description>Sets the InEscalation field to true when the request is escalated</description>
        <field>InEscalation__c</field>
        <literalValue>1</literalValue>
        <name>Set In Escalation To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approval Request Comments Modified</fullName>
        <actions>
            <name>ApprovalRequestCommentsEntered</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Resettrigger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Approval_Request__c.Workflow_Trigger_Added_Comments__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Workflow rule that fires when an approval request has had comments added without actually approving or rejecting the request.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
