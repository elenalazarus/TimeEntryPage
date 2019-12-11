public class TaskController {
    public TimeEntryModel tem {get;set;}
    public updatedTimeEntryModel updatedTem {get;set;}


    @AuraEnabled
    public static TimeEntryModel initModel() {
        Id currentConsultantId = 
            [SELECT Primary_Contact__c FROM Project__c WHERE Primary_Contact__c != null][0].Primary_Contact__c;
        Contact currentConsultant = [SELECT Id, Name FROM Contact WHERE Id = :currentConsultantId];
        TimeEntryModel tem = new TimeEntryModel();
        tem.consultants = TaskServices.getConsultants();
        tem.currentWeekDate = Date.today().toStartofWeek();
        tem.currentConsultant = currentConsultant;
        tem.weekDates = TaskServices.getWeekDates(tem.currentWeekDate);
        tem.taskWrappers = getTaskWrappers(currentConsultant.Id, tem.currentWeekDate);
        return tem;
    }

    private static List<TaskWrapper> getTaskWrappers(Id currentConsultantId, Date currentWeekDate) {
        List<Task__c> tasks = TaskServices.getTasks(currentConsultantId, currentWeekDate);
        List<TaskWrapper> allWrappers = new List<TaskWrapper>();
        for (Task__c task : tasks) {
            List<Time__c> allTimesByTask = TaskServices.getTimesByTask(currentWeekDate, task);
            TaskWrapper taskWrapper = new TaskWrapper();
            taskWrapper.task = task;
            taskWrapper.times = allTimesByTask;
            allWrappers.add(taskWrapper);
        }
        return allWrappers;
    }

    @AuraEnabled
    public static updatedTimeEntryModel initClassWithNeededTasks(Id consultantId, Date currentWeekDate) {
        updatedTimeEntryModel updatedTem = new updatedTimeEntryModel();
        updatedTem.taskWrappers = getTaskWrappers(consultantId, currentWeekDate);
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
        public Date currentWeekDate{get; set;}
        @AuraEnabled
        public List<Date> weekDates {get; set;}
        @AuraEnabled
        public List<TaskWrapper> taskWrappers;
	}

    public with sharing class TaskWrapper {
        @AuraEnabled
        public Task__c task;
        @AuraEnabled
        public List<Time__c> times;
    }

    public with sharing class UpdatedTimeEntryModel {
        @AuraEnabled
        public List<TaskWrapper> taskWrappers;
    }
}