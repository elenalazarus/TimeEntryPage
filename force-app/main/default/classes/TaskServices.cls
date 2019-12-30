public with sharing class TaskServices {

    public static List<Contact> getConsultants() {
        List<Id> consultantIds = new List<Id>();
        List<Project__c> projects = [SELECT Primary_Contact__c FROM Project__c WHERE Primary_Contact__c != null];
        
        for (Project__c project : projects) {
            consultantIds.add(project.Primary_Contact__c);
        }
        List<Contact> allConsultants = [SELECT Name FROM Contact WHERE Id IN :consultantIds];
        return allConsultants;
    }

    public static List<Task__c> getTasks(Id consultantId, Date currentWeekDate) {
        Set<Id> selectedTasksId = new Set<Id>();

        List<Time__c> times = [
            SELECT Task__c
            FROM Time__c
            WHERE Date__c >= :currentWeekDate 
                AND Date__c <= :currentWeekDate.addDays(6)
        ];

        for (Time__c workTime : times) {
            selectedTasksId.add(workTime.Task__c);
        }

        List<Task__c> selectedTasks = [
            SELECT Name, 
                (SELECT Time_spend__c, Date__c FROM Times__r), 
                Consultant__r.Name, 
                Project__r.Name, 
                Billing_Rule__r.Non_billable__c  
            FROM Task__c 
            WHERE Consultant__c = :consultantId
                AND ID IN :selectedTasksId];

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
        return previousWeekDates;
    }

    public static List<Time__c> getTimesByTask(Date currentWeekDate, Task__c task) {
        Integer numberOfWorkDays = 7;
        List<Time__c> times = [
            SELECT Time_spend__c, Date__c, Task__c, Task__r.Billing_Rule__c, Task__r.Project__c 
            FROM Time__c 
            WHERE Task__c = :task.Id 
                AND Date__c >= :currentWeekDate
                AND Date__c <= :currentWeekDate.addDays(6)
        ];
        Map<Date, Time__c> existedWorkDateToTime = new Map<Date, Time__c>();
        Map<Date, Time__c> allWorkDateToTime = new Map<Date, Time__c>();
        for (Integer i = 0; i < times.size(); i++) {
            existedWorkDateToTime.put(times[i].Date__c, times[i]);
        }
        
        for (Integer i = 0; i < numberOfWorkDays; i++) {
            if (!existedWorkDateToTime.containsKey(currentWeekDate.addDays(i))) {
                Time__c emptyTime = new Time__c(
                        Name=currentWeekDate.addDays(i).format() + ' ' + task.Name,
                        Billing_Rule__c=task.Billing_Rule__c,
                        Task__c=task.Id,
                        Project__c=task.Project__c,
                        Date__c=currentWeekDate.addDays(i),
                        Time_spend__c=0);
                AllWorkDateToTime.put(currentWeekDate.addDays(i), emptyTime);
            }
            else {
                AllWorkDateToTime.put(
                    currentWeekDate.addDays(i), existedWorkDateToTime.get(currentWeekDate.addDays(i))
                );
            }
        }
        return AllWorkDateToTime.values();
    }
}
