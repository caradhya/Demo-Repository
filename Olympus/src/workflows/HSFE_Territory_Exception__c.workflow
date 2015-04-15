<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HSFE_Update_Combination_Key</fullName>
        <field>HSFE_Combination_Key__c</field>
        <formula>Name+ HSFE_Zip_Code__c + Text(HSFE_Specialty__c)+ Text(HSFE_Sub_Specialty__c)</formula>
        <name>Update Combination Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>HSFE Update Exception Combination key</fullName>
        <actions>
            <name>HSFE_Update_Combination_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
