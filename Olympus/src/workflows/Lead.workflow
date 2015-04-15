<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_on_lead_assignment</fullName>
        <description>Email alert on lead assignment</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_on_lead_assignment1</fullName>
        <description>Email alert on lead assignment</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <fieldUpdates>
        <fullName>HSFE_Nullify_Reassignment_Date</fullName>
        <field>HSFE_Reassignment_Date__c</field>
        <name>HSFE Nullify Reassignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HSFE_Nullify_Reminder_Date</fullName>
        <field>HSFE_Reminder_Date__c</field>
        <name>HSFE Nullify Reminder Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HSFE_Update_Reassignment_Date</fullName>
        <field>HSFE_Reassignment_Date__c</field>
        <formula>TODAY() + HSFE_Reassignment__c + 1</formula>
        <name>HSFE Update Reassignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HSFE_Update_Reminder_Date</fullName>
        <field>HSFE_Reminder_Date__c</field>
        <formula>TODAY() +  HSFE_Reminder__c + 1</formula>
        <name>HSFE Update Reminder Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>HSFE Nullify Reminder and Reassignment Date on Lead Update</fullName>
        <actions>
            <name>HSFE_Nullify_Reassignment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HSFE_Nullify_Reminder_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( LastModifiedDate ),NOT(ISCHANGED(OwnerId)), NOT(ISCHANGED( HSFE_Reassignment_Date__c )),NOT(ISCHANGED( HSFE_Reminder__c )),NOT(ISCHANGED( HSFE_Reassignment_Date__c )),NOT(ISCHANGED( HSFE_Reminder_Date__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HSFE Update Reminder and Reassignment Date on Owner Update</fullName>
        <actions>
            <name>HSFE_Update_Reassignment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HSFE_Update_Reminder_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED(OwnerId) ||  ISNEW()) &amp;&amp; (NOT (ISNULL( HSFE_Reassignment__c )) || NOT(ISNULL( HSFE_Reminder__c ))) &amp;&amp; ( HSFE_Override_Assignment_Reminder__c  = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
