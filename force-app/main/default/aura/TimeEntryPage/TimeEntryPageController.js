({
    doInit : function(component, event, helper) {
        helper.init(component);
    },

    onConsultantChange : function(component, event, helper) {
        helper.getTasksByConsultant(component);
    },

    onWeekDateChange : function(component, event, helper) {
        helper.getTasksByConsultant(component);
    },

    onAddRowClick : function(component, event, helper) {
        component.set('v.showModalAddRow', true);
        component.set('v.currentProject', null);
        component.set('v.currentTask', null);
        console.log('Add Row clicked');
        helper.showAllProjects(component);
    },

    onAddRowSaveClick : function(component, event, helper) {
        component.set('v.showModalAddRow', false);
        helper.addTaskToUI(component);
    },

    onAddRowCancelClick : function(component) {
        component.set('v.showModalAddRow', false);
    },

    getNotReportedProjectTaskOptions : function(component, event, helper) {
        helper.showNotReportedTasks(component);
    },

    onProjectChange : function(component, event, helper) {
        helper.showNotReportedTasks(component);
    },

    onSaveClick : function(component, event, helper) {
        helper.saveReportedHours(component);
    },

    onDeleteClick : function(component, event, helper) {
        helper.deleteReportedHours(event, component);
    },

})