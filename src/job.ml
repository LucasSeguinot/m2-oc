type job = {
    duration : int;
    weight : int;
    deadline : int
}

exception ParsingError

let rec input_lines file =
    try
        let line = input_line file in
        line::(input_lines file)
    with
        | End_of_file -> []

let job_of_string line = match List.map int_of_string (Str.split (Str.regexp ",") line) with
    | [p; w; d] -> {duration=p; weight=w; deadline=d}
    | _ -> raise ParsingError

let parse filename =
    let file = open_in filename in
    Array.map job_of_string (Array.of_list (input_lines file))
