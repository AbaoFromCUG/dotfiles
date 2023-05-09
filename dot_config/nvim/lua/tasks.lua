local M = {
    presave_tasks = {},
    register_presave_task = function(self, id, task)
        self.presave_tasks[id] = task
    end,
    saveextra_tasks = {},
    register_saveextra_task = function(self, id, task)
        self.saveextra_tasks[id] = task
    end,
    postsave_tasks = {},
    register_postsave_task = function(self, id, task)
        self.postsave_tasks[id] = task
    end,
    prerestore_tasks = {},
    register_prerestore_task = function(self, id, task)
        self.prerestore_tasks[id] = task
    end,
    postrestore_tasks = {},
    register_postrestore_task = function(self, id, task)
        self.postrestore_tasks[id] = task
    end,
    predelete_tasks = {},
    register_predelete_task = function(self, id, task)
        self.predelete_tasks[id] = task
    end,
    postdelete_tasks = {},
    register_postdelete_task = function(self, id, task)
        self.postdelete_tasks[id] = task
    end
}

return M
