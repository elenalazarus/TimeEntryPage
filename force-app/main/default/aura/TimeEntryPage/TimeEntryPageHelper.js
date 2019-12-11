({
    init : function(component) {
        var action = component.get('c.initModel');
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var consultantOptions = []
                var weekDateOptions = []
                var model = response.getReturnValue();
                console.log(model);
                for (var i = 0; i < model.consultants.length; i++) {
                    consultantOptions.push({'label' : model.consultants[i].Name, 'value' : model.consultants[i].Id});
                }
                for (var j = 0; j < model.weekDates.length; j++) {
                    weekDateOptions.push({'label' : model.weekDates[j], 'value' : model.weekDates[j]});
                }
                component.set('v.objTimeEntryModel', model);
                component.set('v.consultants', consultantOptions);
                component.set('v.currentConsultant', model.currentConsultant.Id);
                component.set('v.currentWeekDate', model.currentWeekDate);
                component.set('v.weekDates', weekDateOptions);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    getNeededTasks : function(component) {
        var currentConsultant = component.get("v.currentConsultant");
        var currentWeekDate = component.get("v.currentWeekDate");
        var action = component.get("c.initClassWithNeededTasks");
        action.setParams({
            consultantId : currentConsultant,
            currentWeekDate : currentWeekDate
        });

        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var updatedData = response.getReturnValue();
                component.set('v.objTimeEntryModel.taskWrappers', updatedData.taskWrappers);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    closeModal : function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },

    openmodal : function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
})