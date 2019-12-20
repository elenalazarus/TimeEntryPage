({
    init : function(component) {
        var currentConsultant = component.get("v.currentConsultant");
        var action = component.get('c.getNotReportedTasks');
        action.setParams({
            currentConsultant : currentConsultant
        });
        
        console.log(currentConsultant);

        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var projectOptions = []
                console.log('hello');
                var projects = response.getReturnValue();
                for (var i = 0; i < projects.length; i++) {
                    projectOptions.push({'label' : projects[i].Name, 'value' : projects[i].Id});
                }
                component.set('v.projects', projectOptions);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },
})
