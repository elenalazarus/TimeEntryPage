public class TaskController {
    public String selectedConsultant {get; set;}
    
    public List<Task__c> getTasks() {
        List<Task__c> selectedTasks = [SELECT Name, Consultant__r.Name, Project__r.Name, Billing_Rule__r.Non_billable__c  FROM Task__c WHERE Consultant__c != null];
        return selectedTasks;
    }
    
    
    public List<SelectOption> getConsultants() {
        List<SelectOption> selectedConsultants = new List<SelectOption>();
        Set<Id> consultantIds = new Set<Id>();
        for (Task__c task : getTasks()) {
            consultantIds.add(task.Consultant__c);
        }
        
        for (Contact contact: [SELECT Id, Name FROM Contact WHERE Id IN :consultantIds]) {
            selectedConsultants.add(new SelectOption(contact.Id, contact.Name));
        }
        return selectedConsultants;
    }
    
    public void getTasksforConsultant() {
        List<Task__c> tasksForConsultant = new List<Task__c>();
        for (Task__c task : getTasks()) {
            if (task.Consultant__c == selectedConsultant.Id) {
                tasksForConsultant.add(task);
            }
        }
    }
    
    public List<Time__c> getTime() {
		List<Project__c> projects = [SELECT Id FROM Project__c];        
        List<Time__c> times = [SELECT Name, Time_spend__c FROM Time__c WHERE Task__c IN :getTasks()];
        return times;
    }

}