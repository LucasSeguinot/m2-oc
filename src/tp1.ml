open Types

let task filename =
    let jobs = Job.parse filename in

    let rand1 = (Heuristics.random jobs).cost in
    let rand2 = (Heuristics.random jobs).cost in
    let rand3 = (Heuristics.random jobs).cost in

    let rand_ave = (rand1 + rand2 + rand3)/3 in
    let rand_min = min (min rand1 rand2) rand3 in

    let eed = (Heuristics.eed jobs).cost in

    let mdd = (Heuristics.mdd jobs).cost in

    Printf.printf "%s,%d,%d,%d,%d\n" filename rand_ave rand_min eed mdd
;;

let main argv =
    print_endline "Filename,Rand (average of 3),Rand (min of 3),EED,MDD";
    Array.iteri (fun i filename -> if i > 0 then task filename) argv
;;

main Sys.argv
