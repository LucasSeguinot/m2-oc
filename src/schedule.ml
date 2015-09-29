open Types

let set_cost jobs schedule =
    let start = ref 0 in
    schedule.cost <- 0;

    Array.iter (fun i ->
        start := !start + jobs.(i).duration;
        schedule.cost <- schedule.cost + jobs.(i).weight * (max (!start - jobs.(i).deadline)0))
        schedule.jobs

let create jobs = {
    jobs = Array.make (Array.length jobs) (-1);
    cost = -1
}
