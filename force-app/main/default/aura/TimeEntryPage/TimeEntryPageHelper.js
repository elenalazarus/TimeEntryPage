({
    init : function(component) {
    
        var action = component.get('c.initModel');
        
       	action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var consultantOptions = []
                var weekDateOptions = []
                var taskIdToTimes = []
                var model = response.getReturnValue();
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
                for (var key in model.taskIdToTimes) {
                    taskIdToTimes.push({value:model.taskIdToTimes[key], key:key})
                }
                component.set('v.taskIdToTimes', model.taskIdToTimes);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
       

        $A.enqueueAction(action);

    },
    
    getNeededTasks : function(component) {
        var picklistValue = component.get("v.currentConsultant");
        var action = component.get("c.initClassWithNeededTasks");
        action.setParams({
            consultantId: picklistValue
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var updatedData = response.getReturnValue();
                component.set('v.objTimeEntryModel.tasks', updatedData.tasks);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
       

        $A.enqueueAction(action);
	},
    
    getNeededTimes : function(component) {
        var currentDate = component.get("c.currentDate")
        action.setCallback(this, function(response) {
            if (response.getSate() == "SUCCESS") {
                
            }
        })
        
    }
        
})