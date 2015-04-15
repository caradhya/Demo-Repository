<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HSFE_Update_Material_Group_on_Opportunit</fullName>
        <field>HSFE_Material_Group__c</field>
        <formula>Text(Product2.HSFE_Material_Group__c)</formula>
        <name>HSFE Update Material Group on Opportunit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>HSFE Update Material Group on Opportunity Product</fullName>
        <actions>
            <name>HSFE_Update_Material_Group_on_Opportunit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.HSFE_Material_Group__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow to update the Material group on opportunity product from product object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
