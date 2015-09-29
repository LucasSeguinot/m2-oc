open Types

let task filename =
    let jobs, best = Job.parse filename in

    let temp = Schedule.create jobs in

    let exchbest = (LocalSearch.hill_climbing Neighborhood.exchange Selection.best jobs (Heuristics.mdd jobs) temp).cost in
    let exchfirst = (LocalSearch.hill_climbing Neighborhood.exchange Selection.first jobs (Heuristics.mdd jobs) temp).cost in

    let swapbest = (LocalSearch.hill_climbing Neighborhood.swap Selection.best jobs (Heuristics.mdd jobs) temp).cost in
    let swapfirst = (LocalSearch.hill_climbing Neighborhood.swap Selection.first jobs (Heuristics.mdd jobs) temp).cost in

    let insebest = (LocalSearch.hill_climbing Neighborhood.insertion Selection.best jobs (Heuristics.mdd jobs) temp).cost in
    let insefirst = (LocalSearch.hill_climbing Neighborhood.insertion Selection.first jobs (Heuristics.mdd jobs) temp).cost in

    Printf.printf "%s,%d,%d,%d,%d,%d,%d" filename exchbest exchfirst swapbest swapfirst insebest insefirst;
    print_newline ()
;;

let main argv =
    print_endline "Filename,exchbest,exchfirst,swapbest,swapfirst,insebest,insefirst";
    Array.iteri (fun i filename -> if i > 0 then task filename) argv
;;

main Sys.argv
