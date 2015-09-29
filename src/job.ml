open Types

exception ParsingError

let rec input_lines file =
    try
        let line = input_line file in
        line::(input_lines file)
    with
        | End_of_file -> []

let read_header file = match List.map int_of_string (Str.split (Str.regexp ",") (input_line file)) with
    | [s; b] -> s, b
    | _ -> raise ParsingError

let read_job file = match List.map int_of_string (Str.split (Str.regexp ",") (input_line file)) with
    | [p; w; d] -> {duration=p; weight=w; deadline=d}
    | _ -> raise ParsingError

let parse filename =
    let file = open_in filename in
    let size, best = read_header file in
    let jobs = Array.make size {duration=0; weight=0; deadline=0} in
    Array.iteri (fun i _ -> jobs.(i) <- read_job file) jobs;
    jobs, best
