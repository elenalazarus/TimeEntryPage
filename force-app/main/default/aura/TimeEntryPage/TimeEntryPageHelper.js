({
    doInit : function(component) {
        var recID = component.get("v.recordId");
        var action = component.get("c.getTasks");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            component.set("v.taskList", data);
        });
        $A.enqueueAction(action);
    },
    getConsultants : function(component) {
        var action = component.get("c.getConsultants");
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            component.set("v.consultants", data);
        });
        $A.enqueueAction(action);
    },
        
})