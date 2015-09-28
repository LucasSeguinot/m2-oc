let swap a i j =
    let t = a.(i) in
    a.(i) <- a.(j);
    a.(j) <- t

let shuffle a =
    Array.iteri (fun i _ -> swap a i (Random.int (i+1))) a
