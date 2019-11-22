({
    doInit : function(component) {

        var action = component.get("c.getTasks");
        
       	action.setCallback(this, function(response){
            
            var data = response.getReturnValue();
            console.log(data);
            component.set("v.taskList", data);
        });
       

        $A.enqueueAction(action);

    },
    
    getNeededTasks: function(component){
        var action = component.get("c.getNeededTasks");
        action.setParams({
            recordId: recID
        });
        
        action.setCallback(this, function(response){
            
            var data = response.getReturnValue();
            console.log(data);
            console.log("Hello");
            var options = []; 
		        
            for(var i = 0; i < data.length; i++){
                options.push({selected: false, label: data[i].Consultant__r.Name, value: data[i].Consultant__c});
            } 
        	component.set("v.options", options);
        	$A.enqueueAction(action);
        });
	},
        
})