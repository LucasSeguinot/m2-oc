let swap a i j =
    let t = a.(i) in
    a.(i) <- a.(j);
    a.(j) <- t

let shuffle a =
    Array.iteri (fun i _ -> swap a i (Random.int (i+1))) a

let print_int_array a =
    Array.iter (Printf.printf "%d ") a;
    print_newline ()

let get_time = Unix.gettimeofday

let time f x =
    let t = get_time () in
    let fx = f x in
    fx, get_time () -. t
