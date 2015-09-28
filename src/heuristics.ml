open Job
open Schedule

let random jobs =
    let schedule = create_schedule jobs in
    Array.iteri (fun i _ -> schedule.jobs.(i) <- i) schedule.jobs;
    Util.shuffle schedule.jobs;
    set_cost jobs schedule;
    schedule

let eed jobs =
    let schedule = create_schedule jobs in
    Array.iteri (fun i _ -> schedule.jobs.(i) <- i) schedule.jobs;
    Array.sort (fun i j -> jobs.(i).deadline - jobs.(j).deadline) schedule.jobs;
    set_cost jobs schedule;
    schedule

let mdd jobs =
    let schedule = create_schedule jobs in
    Array.iteri (fun i _ -> schedule.jobs.(i) <- i) schedule.jobs;

    let start = ref 0 in

    Array.iteri (fun i j ->
        let minvalue = ref (max (!start + jobs.(j).duration) jobs.(j).deadline) in
        let minindex = ref i in

        for k = i+1 to Array.length schedule.jobs - 1 do
            let job = jobs.(schedule.jobs.(k)) in
            let value = max (!start + job.duration) job.deadline in

            if value < !minvalue then
            begin
                minvalue := value;
                minindex := k
            end
        done;

        Util.swap schedule.jobs i !minindex;
        start := !start + jobs.(schedule.jobs.(i)).duration)
        schedule.jobs;
    
    set_cost jobs schedule;
    schedule
