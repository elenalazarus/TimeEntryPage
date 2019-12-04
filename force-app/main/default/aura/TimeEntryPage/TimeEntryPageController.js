({
    doInit : function(component, event, helper) {
        helper.init(component);
        
        
    },
    
    onConsultantChange: function(component, event, helper) {
        helper.getNeededTasks(component);
    },
    
    onWeekDateChange: function(component, event, helper) {
        helper.getNeededTimes(component, event);
    },
})