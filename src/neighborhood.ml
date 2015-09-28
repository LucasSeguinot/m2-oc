open Job
open Schedule

type 'a neighborhood = {
    iterator : ('a -> unit) -> job array -> schedule -> schedule -> unit;
    neighbor : 'a -> job array -> schedule -> unit;
    null_index : 'a
}

let exchange_neighbor i jobs schedule =
    let t = schedule.jobs.(i) in
    schedule.jobs.(i) <- schedule.jobs.(i+1);
    schedule.jobs.(i+1) <- t;
    set_cost jobs schedule

let exchange_iterator f jobs src dst =
    let n = Array.length jobs in

    Array.iteri (fun i j -> dst.jobs.(i) <- j) src.jobs;

    let t = dst.jobs.(0) in
    dst.jobs.(0) <- dst.jobs.(1);
    dst.jobs.(1) <- t;
    set_cost jobs dst;
    f 0;
    for i = 1 to n-2 do
        let t = dst.jobs.(i-1) in
        dst.jobs.(i-1) <- dst.jobs.(i);
        dst.jobs.(i) <- dst.jobs.(i+1);
        dst.jobs.(i+1) <- t;
        set_cost jobs dst;
        f i
    done

let exchange = {
    iterator = exchange_iterator;
    neighbor = exchange_neighbor;
    null_index = -1
}

let swap_neighbor (i,j) jobs schedule =
    let t = schedule.jobs.(i) in
    schedule.jobs.(i) <- schedule.jobs.(j);
    schedule.jobs.(j) <- t;
    set_cost jobs schedule

let swap_iterator f jobs src dst =
    let n = Array.length jobs in

    Array.iteri (fun i j -> dst.jobs.(i) <- j) src.jobs;

    for i = 0 to n-2 do
        let t = dst.jobs.(i) in
        dst.jobs.(i) <- dst.jobs.(i+1);
        dst.jobs.(i+1) <- t;
        set_cost jobs dst;
        f (i,i+1);
        for j = i+2 to n-1 do
            let t = dst.jobs.(i) in
            dst.jobs.(i) <- dst.jobs.(j);
            dst.jobs.(j) <- dst.jobs.(j-1);
            dst.jobs.(j-1) <- t;
            set_cost jobs dst;
            f (i,j)
        done;
        let t = dst.jobs.(i) in
        dst.jobs.(i) <- dst.jobs.(n-1);
        dst.jobs.(n-1) <- t;
    done

let swap = {
    iterator = swap_iterator;
    neighbor = swap_neighbor;
    null_index = (-1, -1)
}
