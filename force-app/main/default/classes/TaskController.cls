public class TaskController {
    public TimeEntryModel tem {get;set;}
    public updatedTimeEntryModel updatedTem {get;set;}
    
    
    @AuraEnabled
    public static TimeEntryModel initModel() {
        Id currentConsultantId = [SELECT Primary_Contact__c FROM Project__c WHERE Primary_Contact__c != null][0].Primary_Contact__c;
        Contact currentConsultant = [SELECT Id, Name FROM Contact WHERE Id = :currentConsultantId];
        TimeEntryModel tem = new TimeEntryModel();
        tem.consultants = getConsultants();
        tem.currentWeekDate = Date.today().toStartofWeek();
        tem.currentConsultant = currentConsultant;
        tem.tasks = getTasks(currentConsultant.Id);
        tem.weekDates = getWeekDates(tem.currentWeekDate);
        tem.taskIdToTimes = getTimes(tem.tasks, tem.currentWeekDate);
        return tem;
    }
    
    public static List<Contact> getConsultants() {
        List<Id> consultantIds = new List<Id>();
        List<Project__c> projects = [SELECT Primary_Contact__c FROM Project__c WHERE Primary_Contact__c != null];
        
        for (Project__c project : projects) {
            consultantIds.add(project.Primary_Contact__c);
        }
        List<Contact> allConsultants = [SELECT Name FROM Contact WHERE Id IN :consultantIds];
        return allConsultants;
    }
    
    public static List<Task__c> getTasks(Id consultantId) {
        List<Task__c> selectedTasks = [
            SELECT Name, 
            	(SELECT Time_spend__c, Date__c FROM Times__r), 
                Consultant__r.Name, 
                Project__r.Name, 
                Billing_Rule__r.Non_billable__c  
            FROM Task__c 
            WHERE Consultant__c = :consultantId];
        return selectedTasks;
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
    
    
    public static Map<Id, List<Time__c>> getTimes(List<Task__c> tasks, Date currentWeekDate) {
        Map<Id, List<Time__c>> taskIdToTimes = new Map<Id, List<Time__c>>();
        for (Task__c task : tasks) {
            List<Time__c> allTimes = getTimesByTask(currentWeekDate, task);
            taskIdToTimes.put(task.Id, allTimes);
        }
            
        return taskIdToTimes;
    }

    public static List<Time__c> getTimesByTask(Date currentWeekDate, Task__c task) {
        Integer numberOfWorkDays = 7;
        List<Time__c> times = [SELECT Time_spend__c, Date__c, Task__c, Task__r.Billing_Rule__c, Task__r.Project__c 
                               FROM Time__c 
                               WHERE Task__c = :task.Id 
                               	   AND Date__c >= :currentWeekDate
                                   AND Date__c <= :currentWeekDate.addDays(6)
                                   
        ];
        Map<Date, Time__c> workDateToTime = new Map<Date, Time__c>();
        for (Integer i = 0; i < times.size(); i++) {
            workDateToTime.put(times[i].Date__c, times[i]);
        }
        
        for (Integer i = 0; i < numberOfWorkDays; i++) {
            if (!workDateToTime.containsKey(currentWeekDate.addDays(i))) {
                Time__c emptyTime = new Time__c(
                        Name=currentWeekDate.addDays(i) + ' ' + task.Id,
                        Billing_Rule__c=task.Billing_Rule__c,
                        Task__c=task.Id,
                        Project__c=task.Project__c,
                    	Date__c=currentWeekDate.addDays(i),
                    	Time_spend__c=0);
                workDateToTime.put(currentWeekDate.addDays(i), emptyTime);
            }
        }
        return workDateToTime.values();
    }
   
    
    @AuraEnabled
    public static updatedTimeEntryModel initClassWithNeededTasks(Id consultantId) {
        updatedTimeEntryModel updatedTem = new updatedTimeEntryModel();
        updatedTem.tasks = getTasks(consultantId);
        return updatedTem;
        
    }
    
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
    @AuraEnabled
    public Map<Id, List<Time__c>> taskIdToTimes{get; set;}
	}
    
    public with sharing class UpdatedTimeEntryModel{
    @AuraEnabled
    public List<Task__c> tasks {get;set;}
    @AuraEnabled
    public Contact currentConsultant{get; set;}
    @AuraEnabled
    public List<Time__c> times{get; set;} 
    @AuraEnabled
    public Map<Id, List<Time__c>> taskIdToTimes{get; set;}
	}
   

}