({
    doInit : function(component, event, helper) {
        helper.init(component);
    },

    onProjectChange : function(component, event, helper) {
        helper.getNotReportedTasks(component);
    }
})
