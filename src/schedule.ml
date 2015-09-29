open Types

let swap schedule i j =
    let t = schedule.jobs.(i) in
    schedule.jobs.(i) <- schedule.jobs.(j);
    schedule.jobs.(j) <- t;
    let t = schedule.start.(i) in
    schedule.start.(i) <- schedule.start.(j);
    schedule.start.(j) <- t

let copy src dst =
    Array.iteri (fun i j -> dst.jobs.(i) <- j) src.jobs;
    Array.iteri (fun i j -> dst.start.(i) <- j) src.start;
    dst.cost <- src.cost

let set_cost jobs schedule =
    let start = ref 0 in
    schedule.cost <- 0;

    Array.iteri (fun i j ->
        schedule.start.(i) <- !start;
        start := !start + jobs.(j).duration;
        schedule.cost <- schedule.cost + jobs.(j).weight * (max (!start - jobs.(j).deadline) 0))
        schedule.jobs

let update_cost jobs schedule k l =
    let start =
        if k == 0 then
            0
        else
            schedule.start.(k-1) + jobs.(schedule.jobs.(k-1)).duration
    in
    let start = ref start in

    for i = k to l do
        let j = schedule.jobs.(i) in
        schedule.cost <- schedule.cost - jobs.(j).weight * ((max (schedule.start.(i) + jobs.(j).duration - jobs.(j).deadline) 0) -
                                                            (max (!start + jobs.(j).duration - jobs.(j).deadline) 0));
        schedule.start.(i) <- !start;
        start := !start + jobs.(j).duration
    done

let create jobs = {
    jobs = Array.make (Array.length jobs) (-1);
    start = Array.make (Array.length jobs) (-1);
    cost = -1
}
