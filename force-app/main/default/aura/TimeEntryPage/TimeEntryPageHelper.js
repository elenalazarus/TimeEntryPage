({
    init : function(component) {
        var action = component.get('c.getModelOfTasksForCurrentConsultant');
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var consultantOptions = [];
                var weekDateOptions = [];
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
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    getTasksByConsultant : function(component) {
        var currentConsultant = component.get("v.currentConsultant");
        var currentWeekDate = component.get("v.currentWeekDate");
        var action = component.get("c.getModelOfTasksWithTimesForConsultantAndForSpecificWeek");
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

    showNotReportedTasks : function(component) {
        var model = component.get("v.objTimeEntryModel");
        var currentConsultant = component.get("v.currentConsultant");
        var currentProject = component.get("v.currentProject");
        var action = component.get("c.getNotReportedTasks");
        var taskIds = [];
        for (var i = 0; i < model.taskWrappers.length; i++) {
            taskIds.push(model.taskWrappers[i].task.Id);
        }
        action.setParams({
            reportedTaskIds : taskIds,
            currentConsultantId : currentConsultant,
            currentProjectId : currentProject
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var notReportedTasks = response.getReturnValue();
                var notReportedTaskOptions = []
                for (var i = 0; i < notReportedTasks.length; i++) {
                    notReportedTaskOptions.push({'label' : notReportedTasks[i].Name, 'value' : notReportedTasks[i].Id});
                }
                component.set('v.notReportedTaskOptions', notReportedTaskOptions);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    showAllProjects : function(component) {
        var currentConsultant = component.get("v.currentConsultant");
        var action = component.get("c.getAllProjects");
        action.setParams({
            currentConsultantId : currentConsultant
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var allProjects = response.getReturnValue();
                var projectOptions = []
                for (var i = 0; i < allProjects.length; i++) {
                    projectOptions.push({'label' : allProjects[i].Name, 'value' : allProjects[i].Id});
                }
                component.set('v.allProjectOptions', projectOptions);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    addTaskToUI : function(component) {
        var currentWeekDate = component.get("v.currentWeekDate");
        var currentTaskId = component.get("v.currentTask");
        var taskWrappers = component.get("v.objTimeEntryModel.taskWrappers");
        var action = component.get("c.addTaskToUI");
        action.setParams({
            taskId : currentTaskId,
            currentWeekDate : currentWeekDate
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var addedTaskByUser = response.getReturnValue();
                taskWrappers.push(addedTaskByUser);
                component.set('v.objTimeEntryModel.taskWrappers', taskWrappers);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    saveReportedHours : function(component) {
        var taskWrappers = component.get("v.objTimeEntryModel.taskWrappers");
        var timesToInsert = [];
        for (var i = 0; i < taskWrappers.length; i++) {
            for (var k = 0; k < taskWrappers[i].times.length; k++)
                timesToInsert.push(taskWrappers[i].times[k]);
        }
        var action = component.get("c.insertNewReportedHours");
        action.setParams({
            timesToInsert : timesToInsert
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set('v.objTimeEntryModel.taskWrappers', taskWrappers);
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    deleteReportedHours : function(component) {
        
    }
})