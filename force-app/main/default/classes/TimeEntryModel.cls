public with sharing class TimeEntryModel {
    @AuraEnabled
    public List<Task__c> tasks {get;set;}
    @AuraEnabled
    public List<Contact> consultants{get; set;}
    @AuraEnabled
    public Contact defaultConsultant{get; set;}
    @AuraEnabled
    public List<Time__c> times{get; set;}
    @AuraEnabled
    public Date defaultWeekDate{get; set;}
    @AuraEnabled
    public List<Date> weekDates {get; set;}
    
    
    public static List<Task__c> getTasks(Id consultantId) {
        List<Task__c> selectedTasks = [SELECT 
                                              Name, 
                                              (SELECT Time_spend__c, Date__c FROM Times__r), 
                                              Consultant__r.Name, 
                                              Project__r.Name, 
                                              Billing_Rule__r.Non_billable__c  
                                          FROM Task__c 
                                          WHERE Consultant__c = :consultantId];
        return selectedTasks;
    }

    public static List<Contact> getConsultants(Id defaultConsultant) {
        List<Id> consultantIds = new List<Id>();
        List<Project__c> projects = [SELECT Primary_Contact__c FROM Project__c WHERE Primary_Contact__c != null];
        
        for (Project__c project : projects) {
            if (project.Primary_Contact__c != defaultConsultant) {
                consultantIds.add(project.Primary_Contact__c);
            }
        }
        List<Contact> allConsultants = [SELECT Name FROM Contact WHERE Id IN :consultantIds];
        return allConsultants;
    }
    
    public static List<Time__c> getTimes(List<Task__c> tasks) {
        List<Time__c> times = [SELECT Time_spend__c, Date__c FROM Time__c WHERE Task__c IN :tasks];
        return times;
    }
    

    public static List<Date> getWeekDates(Date weekDate) {
        Date currentWeekDate = Date.today().toStartofWeek();
        List<Date> previousWeekDates = new List<Date>{currentWeekDate};
        Integer numberOfpreviousWeeks = 5;
        
        
        for (Integer i = 0; i < numberOfpreviousWeeks; i ++) {
            currentWeekDate = currentWeekDate.addDays(-7);
            if (currentWeekDate != weekDate) {
                previousWeekDates.add(currentWeekDate);
            }
        }
        System.debug(previousWeekDates);
        return previousWeekDates;
    } 
    
    @AuraEnabled
    public static TimeEntryModel initClass() {
        Id defaultConsultantId = [SELECT Primary_Contact__c FROM Project__c WHERE Primary_Contact__c != null][0].Primary_Contact__c;
        Contact defaultConsultant = [SELECT Id, Name FROM Contact WHERE Id = :defaultConsultantId];
        TimeEntryModel tem = new TimeEntryModel();
        tem.consultants = getConsultants(defaultConsultant.Id);
        tem.defaultWeekDate = Date.today().toStartofWeek();
        tem.defaultConsultant = defaultConsultant;
        tem.tasks = getTasks(defaultConsultant.Id);
        tem.weekDates = getWeekDates(tem.defaultWeekDate);
        tem.times = getTimes(tem.tasks);
        return tem;
    }
    
   
    
    @AuraEnabled
    public static TimeEntryModel initClassWithNeededTasks(Id consultantId, Date weekDate) {
        TimeEntryModel tem = new TimeEntryModel();
        tem.consultants = getConsultants(consultantId);
        tem.defaultConsultant = [SELECT Id, Name FROM Contact WHERE Id = :consultantId][0];
        tem.tasks = getTasks(consultantId);
        tem.defaultWeekDate = weekDate;
        tem.weekDates = getWeekDates(weekDate);
        return tem;
        
    }
    
}