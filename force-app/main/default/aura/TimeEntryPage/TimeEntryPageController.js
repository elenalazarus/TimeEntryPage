({
    doInit : function(component, event, helper) {
        helper.doInit(component);
        helper.getConsultants(component);
        
    },
    
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        alert(event.getSource().get("v.value"));
    },
})