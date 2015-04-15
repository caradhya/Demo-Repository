<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HSFE_Combination_Key</fullName>
        <field>HSFE_Combination_Key__c</field>
        <formula>Name+ Text(HSFE_Specialty__c)+ Text(HSFE_Sub_Specialty__c)</formula>
        <name>Combination Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Combination Key</fullName>
        <actions>
            <name>HSFE_Combination_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is used to update the combination key.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
