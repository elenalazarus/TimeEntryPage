public class TaskController {
    public List<SelectOption> consultantLst {get;set;}
    public String selectedConsultant {get;set;}
    @AuraEnabled
    public static List<Task__c> getTasks() {
        List<Task__c> selectedTasks = [SELECT Name, Consultant__r.Name, Project__r.Name, Billing_Rule__r.Non_billable__c  FROM Task__c WHERE Consultant__c != null];
        return selectedTasks;
    }
    
    public static Set<Id> getTaskIds() {
        Set<Id> taskIds = new Set<Id>();
        List<Task__c> selectedTasks = [SELECT Id  FROM Task__c WHERE Consultant__c != null];
        for (Task__c task : selectedTasks) {
            taskIds.add(task.Id);
        }
        return taskIds;
    }
    
    @AuraEnabled
    public static List<Task__c> getNeededTasks(Consultant__c consultant) {
        List<Task__c> selectedTasks = [
            SELECT Name, Consultant__r.Name, Project__r.Name, Billing_Rule__r.Non_billable__c 
            FROM Task__c
            WHERE Consultant__c = :consultant.Id
       ];
        return selectedTasks;
    }

    
    @AuraEnabled
    public static List<Consultant__c> getConsultants() {
        Set<Id> consultantIds = new Set<Id>();
        for (Task__c task : getTasks()) {
            consultantIds.add(task.Consultant__c);
        }
        List<Consultant__c> options = [SELECT Name FROM Consultant__c WHERE Id IN :consultantIds];
       
        return options;
    }
    
    @AuraEnabled
    public static List<Time__c> getTimes(List<Task__c> tasks) {
        
        List<Time__c> selectedTimes = [SELECT Time_spend__c, Date__c, Task__c FROM Time__c WHERE Task__c IN :tasks];
        return selectedTimes;
        
    }
    
    // public void getTasksforConsultant() {
        // List<Task__c> tasksForConsultant = new List<Task__c>();
        // for (Task__c task : getTasks()) {
            // if (task.Consultant__c == selectedConsultant.Id) {
                // tasksForConsultant.add(task);
            // }
        // }
    // }
    
    public List<Time__c> getTime() {
		List<Project__c> projects = [SELECT Id FROM Project__c];        
        List<Time__c> times = [SELECT Name, Time_spend__c FROM Time__c WHERE Task__c IN :getTasks()];
        return times;
    }

}