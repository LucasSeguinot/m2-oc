open Job
open Schedule

let task filename =
    let jobs = Job.parse filename in

    let temp = create_schedule jobs in
    let exchbest = (LocalSearch.hill_climbing Neighborhood.exchange Selection.best jobs (Heuristics.mdd jobs) temp).cost in
    let exchfirst = (LocalSearch.hill_climbing Neighborhood.exchange Selection.first jobs (Heuristics.mdd jobs) temp).cost in
    let swapbest = (LocalSearch.hill_climbing Neighborhood.swap Selection.best jobs (Heuristics.mdd jobs) temp).cost in
    let swapfirst = (LocalSearch.hill_climbing Neighborhood.swap Selection.first jobs (Heuristics.mdd jobs) temp).cost in

    Printf.printf "%s,%d,%d,%d,%d" filename exchbest exchfirst swapbest swapfirst;
    print_newline ()
;;

let main argv =
    print_endline "Filename,exchbest,exchfirst,swapbest,swapfirst";
    Array.iteri (fun i filename -> if i > 0 then task filename) argv
;;

if true then
    main Sys.argv
else
    begin
        let jobs = Array.make 4 {duration=0; weight=0; deadline=0} in
        let schedule = create_schedule jobs in
        let temp = create_schedule jobs in
        let callback i =
            Array.iter (fun i -> print_int i; print_string " ") temp.jobs;
            print_newline () in
        let neighborhood = Neighborhood.swap in

        Array.iteri (fun i _ -> schedule.jobs.(i) <- i) schedule.jobs;
        neighborhood.iterator callback jobs schedule temp
    end
