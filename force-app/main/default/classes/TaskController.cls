public class TaskController {
    public TimeEntryModel tem {get;set;}
    public updatedTimeEntryModel updatedTem {get;set;}


    @AuraEnabled
    public static TimeEntryModel getModelOfTasksForCurrentConsultant() {
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
    public static UpdatedTimeEntryModel getModelOfTasksWithTimesForConsultantAndForSpecificWeek(
        Id consultantId, Date currentWeekDate
    ) {
        updatedTimeEntryModel updatedTem = new updatedTimeEntryModel();
        updatedTem.taskWrappers = getTaskWrappers(consultantId, currentWeekDate);
        return updatedTem;
    }

    @AuraEnabled
    public static List<Task__c> getNotReportedTasks(
        List<Id> reportedTaskIds, Id currentConsultantId, Id currentProjectId
    ) {
        if (reportedTaskIds.size() == 0) {
            List<Task__c> unreportedTasks = [
                SELECT Name FROM Task__c WHERE Consultant__c = :currentConsultantId AND Project__c = :currentProjectId
            ];
            return unreportedTasks;
        }
        List<Task__c> unreportedTasks = [
            SELECT Name, Project__r.Name
            FROM Task__c
            WHERE Id not IN : reportedTaskIds 
                AND Consultant__c = :currentConsultantId
                AND Project__c = :currentProjectId
        ];
        return unreportedTasks;
    }

    @AuraEnabled
    public static List<Project__c> getAllProjects(Id currentConsultantId) {
        List<Project__c> allProjects = [
            SELECT Name FROM Project__c WHERE Primary_Contact__c = :currentConsultantId
        ];
        return allProjects;
    }

    @AuraEnabled
    public static TaskWrapper addTaskToUI(Id taskId, Date currentWeekDate) {
        Task__c chosenTask = [SELECT Name, Project__r.Name, Billing_Rule__c FROM Task__c WHERE Id = :taskId];
        List<Time__c> timesForChosenTask = TaskServices.getTimesByTask(currentWeekDate, chosenTask);
        TaskWrapper addedTaskByUser = new TaskWrapper();
        addedTaskByUser.task = chosenTask;
        addedTaskByUser.times = timesForChosenTask ;
        return addedTaskByUser;
    }

    @AuraEnabled
    public static void insertNewReportedHours(List<Id> taskIds, List<Time__c> reportedTimes) {
        List<Time__c> timesToUpsert = new List<Time__c>();
        Date currentWeekDate = reportedTimes[0].Date__c;
        List<Time__c> insertedTimes = [
            SELECT Id, Time_spend__c, Task__c, Date__c
            FROM Time__c
            WHERE Task__c IN :taskIds
                AND Date__c >= : currentWeekDate
                AND Date__c <= :currentWeekDate.addDays(6)];
        Map<String, Time__c> taskDateToTime = new Map<String, Time__c>();
        for (Time__c workTime : insertedTimes) {
            taskDateToTime.put(workTime.Task__c + ' ' + workTime.Date__c, workTime);
        }
        for (Time__c workTime : reportedTimes) {
            String taskDate = workTime.Task__c + ' ' + workTime.Date__c;
            if (taskDateToTime.containsKey(taskDate)) {
                Time__c insertedTime = taskDateToTime.get(taskDate);
                insertedTime.Time_spend__c = workTime.Time_spend__c;
                timesToUpsert.add(insertedTime);
            }
            else {
                timesToUpsert.add(workTime);
            }
        }
        upsert timesToUpsert;
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