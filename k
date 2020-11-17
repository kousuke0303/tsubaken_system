
[1mFrom:[0m /home/ec2-user/environment/tsubaken_system/app/controllers/employees/tasks_controller.rb:10 Employees::TasksController#move_task:

     [1;34m3[0m: [32mdef[0m [1;34mmove_task[0m
     [1;34m4[0m:   task = [1;34;4mTask[0m.find(remove_str(params[[33m:task[0m]))
     [1;34m5[0m:   before_status = task.status
     [1;34m6[0m:   move_date = [1;34;4mTime[0m.current
     [1;34m7[0m:   [1;34m# default_tasksから移動した場合は、コピー作成[0m
     [1;34m8[0m:   [32mif[0m default_tasks.where([35mid[0m: task.id).exists?
     [1;34m9[0m:     copy_task = task.deep_dup
 => [1;34m10[0m:     binding.pry
    [1;34m11[0m:     copy_task.save
    [1;34m12[0m:     [1;34m# copy_task.default_tasks.create(matter_id: current_matter.id)[0m
    [1;34m13[0m:     copy_task.update([35mstatus[0m: params[[33m:status[0m], [35mrow_order[0m: roworder_params)
    [1;34m14[0m:   [32melse[0m
    [1;34m15[0m:     task.update([35mstatus[0m: params[[33m:status[0m],
    [1;34m16[0m:                 [35mbefore_status[0m: before_status,
    [1;34m17[0m:                 [35mmove_date[0m: move_date,
    [1;34m18[0m:                 [35mrow_order[0m: roworder_params)
    [1;34m19[0m:     create_started_at_or_finished_at
    [1;34m20[0m:   [32mend[0m
    [1;34m21[0m:   matter_task_type
    [1;34m22[0m:   respond_to [32mdo[0m |format|
    [1;34m23[0m:     format.js
    [1;34m24[0m:   [32mend[0m
    [1;34m25[0m: [32mend[0m

