public class TaskController {
    public List<SelectOption> consultantLst {get;set;}
    public String selectedConsultant {get;set;}
    
    @AuraEnabled
    public static TimeEntryModel initData() {
        Id defaultConsultantId = [SELECT Primary_Contact__c FROM Project__c WHERE Primary_Contact__c != null][0].Primary_Contact__c;
        TimeEntryModel tem = new TimeEntryModel(defaultConsultantId);
        System.debug(tem.tasks);
        System.debug(tem.consultantNames);
        System.debug(tem);
        return tem;
        
    }
    @AuraEnabled
    public static TimeEntryModel buildModel(Id consultantId) {
        TimeEntryModel tem = new TimeEntryModel(consultantId);
        return tem;
    } 
   

}