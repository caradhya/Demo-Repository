<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Amount_Field</fullName>
        <field>Amount</field>
        <formula>If ((HSFE_Service_Amount__c &gt; 0),HSFE_Service_Amount__c, 0)+ 
If ((HSFE_Disposable_Amount__c &gt;0 ), HSFE_Disposable_Amount__c, 0 )+ 
If ((HSFE_Capital_Amount__c &gt; 0), HSFE_Capital_Amount__c, 0)</formula>
        <name>Update Amount Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Forecast_Amount_Field</fullName>
        <field>Forecast_Amount__c</field>
        <formula>If(ISPICKVAL(HSFE_Purchase_Type__c,&apos;Run Rate&apos; ),
	(if(HSFE_Service_Amount__c &gt;0,HSFE_Service_Amount__c ,0) + 
	if((HSFE_Run_Rate_Term_Months__c &gt; 0 &amp;&amp; HSFE_Disposable_Amount__c &gt; 0),(HSFE_Disposable_Amount__c/HSFE_Run_Rate_Term_Months__c),0) +
	if(HSFE_Capital_Amount__c&gt;0,HSFE_Capital_Amount__c,0)),
	if(ISPICKVAL(HSFE_Purchase_Type__c,&apos;Bulk&apos;),
	(if(HSFE_Service_Amount__c &gt;0,HSFE_Service_Amount__c ,0) + 
	if(HSFE_Disposable_Amount__c&gt;0,HSFE_Disposable_Amount__c,0) + 
	if(HSFE_Capital_Amount__c&gt;0,HSFE_Capital_Amount__c,0)) ,0 ))</formula>
        <name>Update Forecast Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_type_to_Read_only</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Customer_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record type to Read only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Run_Rate_terms_to_blank</fullName>
        <field>HSFE_Run_Rate_Term_Months__c</field>
        <name>Update Run Rate terms to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Lock_Checkbox_on_Opporutnity</fullName>
        <field>HSFE_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Update the Lock Checkbox on Opporutnity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>HSFE Update Amount%2FForecast Amount Field on Opportunity</fullName>
        <actions>
            <name>Update_Amount_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Forecast_Amount_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow to updateAMount/Forecast Amount, Amount is sum of disposable, capital and service totals and Forecast Amount is ??</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HSFE Update Run Rate Term %28Months%29 to Blank</fullName>
        <actions>
            <name>Update_Run_Rate_terms_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.HSFE_Purchase_Type__c</field>
            <operation>equals</operation>
            <value>Bulk</value>
        </criteriaItems>
        <description>Workflow to update Run Rate Term (Months) to blank when purchase type is Bulk.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HSFE Update lock checkbox</fullName>
        <actions>
            <name>Update_Record_type_to_Read_only</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_the_Lock_Checkbox_on_Opporutnity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.HSFE_Sales_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won,Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>Whenever the opportunity is Closed Won or Lost update locked checkbox to true and change the record type to customer read only.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
