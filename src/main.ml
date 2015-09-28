type job = {
    duration : int;
    weight : int;
    deadline : int
};;

let create_job () =
    {duration = -1; weight = -1; deadline = -1}
;;

type jobs = job array;;

type schedule = {
    job : int array;
    mutable cost : int
};;

let set_cost jobs schedule =
    let start = ref 0 in
    schedule.cost <- 0;

    Array.iter (fun i ->
        start := !start + jobs.(i).duration;
        schedule.cost <- schedule.cost + jobs.(i).weight * (max (!start - jobs.(i).deadline)0))
        schedule.job
;;

let rec _parse_line file acc =
    try
        let job = match List.map int_of_string (Str.split (Str.regexp ",") (input_line file)) with
            | [a;b;c] -> {duration=a;weight=b;deadline=c}
            | _ -> failwith "Invalid file"
        in
        _parse_line file (job::acc)
    with
    | End_of_file -> acc

let rec input_lines file =
    try
        let line = input_line file in
        line::(input_lines file)
    with
        | End_of_file -> []

let job_of_string line = match List.map int_of_string (Str.split (Str.regexp ",") line) with
    | [a;b;c] -> {duration=a; weight=b; deadline=c}
    | _ -> failwith "Invalid file"
;;

let parse filename =
    let file = open_in filename in
    Array.map job_of_string (Array.of_list (input_lines file))
;;

let jobs = parse "tests/orlib/wt_40_001.txt";;
print_int jobs.(0).duration
