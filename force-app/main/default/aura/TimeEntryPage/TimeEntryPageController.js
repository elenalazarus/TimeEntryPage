({
    doInit : function(component, event, helper) {
        helper.init(component);
    },

    onConsultantChange : function(component, event, helper) {
        helper.getNeededTasks(component);
    },

    onWeekDateChange : function(component, event, helper) {
        helper.getNeededTasks(component);
    },

    handleModalAddRowOpen: function(component, event, helper) {
        component.set('v.showModalAddRow', true);
    },

    handleModalEditLeadSave: function(component, event, helper) {
        /* Handle the Lead here */
        component.set('v.showModalAddRow', false);
    },

    handleModalAddRowCancel: function(component) {
        component.set('v.showModalAddRow', false);
    },

})