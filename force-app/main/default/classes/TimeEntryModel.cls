public with sharing class TimeEntryModel {
    public Time__c record;
    
    public TimeEntryModel(Time__c record){
        this.record = record;
    }
    
    @AuraEnabled
    public String project {
        get {
            return record.Task__r.Project__r.Name;
        }
        set;
    } 
    
    @AuraEnabled
    public String projectTaskName {
        get {
            return project + ' - ' + record.Task__r.Name;
        }
        set;
    }
    
    @AuraEnabled
    public Id taskId {
        get {
            return record.Task__c;
        }
    }
    
    @AuraEnabled
    public Boolean nonBilliable {
        get {
            return record.Task__r.Billing_rule__r.Non_billable__c;
        }
        set;
    }
    
    @AuraEnabled
    public String consultant {
        get {
            return record.Task__r.Consultant__c;
        }
        set;
    }
    
    @AuraEnabled
    public Date workDate {
        get {
            return record.Date__c;
        }
        set;
    }
    
    @AuraEnabled
    public Id recordId {
        get {
            return record.Id;
        }
    }
}