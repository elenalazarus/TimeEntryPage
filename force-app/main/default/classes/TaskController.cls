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
    public static List<Consultant__c> getConsultants() {
        List<Id> selectedConsultantIds = new List<Id>();
        Set<Id> consultantIds = new Set<Id>();
        for (Task__c task : getTasks()) {
            selectedConsultantIds.add(task.Consultant__c);
        }
        List<Consultant__c> selectedConsultants = [SELECT Id FROM Consultant__c WHERE Id IN :selectedConsultantIds];
       
        return selectedConsultants;
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