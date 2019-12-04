public with sharing class TimeEntryModel {
    @AuraEnabled
    public List<Task__c> tasks {get;set;}
    @AuraEnabled
    public List<Contact> consultants{get; set;}
    @AuraEnabled
    public Contact currentConsultant{get; set;}
    @AuraEnabled
    public List<Time__c> times{get; set;}
    @AuraEnabled
    public Date currentWeekDate{get; set;}
    @AuraEnabled
    public List<Date> weekDates {get; set;}    
    
}