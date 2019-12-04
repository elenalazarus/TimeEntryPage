({
    init : function(component) {
    
        var action = component.get('c.initModel');
        
       	action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var consultantOptions = []
                var model = response.getReturnValue();
                var listLength = model.consultants.length;
                for (var i = 0; i < listLength; i++) {
                    consultantOptions.push({'label' : model.consultants[i].Name, 'value' : model.consultants[i].Id});
                }
                component.set('v.objTimeEntryModel', model);
                component.set('v.consultants', consultantOptions);
                component.set('v.currentConsultant', model.currentConsultant.Id);
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
        
    }
        
})