({
    init : function(component) {
        var cons = component.find("consultant");
		var picklistValue = cons.get("v.value");
        var action = component.get('c.initClass');
        action.setParams({
            consultantId: picklistValue,
        });
        
       	action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                component.set('v.objTimeEntryModel', response.getReturnValue());
                component.set('v.defaultConsultant', response.getReturnValue().defaultConsultant);
                component.set('v.defaultWeekDate', response.getReturnValue().defaultWeekDate);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
       

        $A.enqueueAction(action);

    },
    
    getNeededTasks: function(component, event){
        var cons = component.find("consultant");
		var picklistValue = cons.get("v.value");
        var weekD = component.find("weekDate");
		var picklistWeekD = weekD.get("v.value");
        var action = component.get("c.initClassWithNeededTasks");
        action.setParams({
            consultantId: picklistValue,
            weekDate: picklistWeekD
        });
        
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                console.log('hello');
                component.set('v.objTimeEntryModel', response.getReturnValue());
                component.set('v.defaultConsultant', response.getReturnValue().defaultConsultant);
                component.set('v.defaultWeekDate', response.getReturnValue().defaultWeekDate);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
       

        $A.enqueueAction(action);
	},
        
})