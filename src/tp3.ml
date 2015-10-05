open Types

let searches = [|LocalSearch.vnd; LocalSearch.piped_vnd|];;
let searches_names = [|"v"; "p"|];;

let esi = [|Neighborhood.exchange; Neighborhood.swap; Neighborhood.insertion|];;
let eis = [|Neighborhood.exchange; Neighborhood.insertion; Neighborhood.swap|];;
let neighborhoods = [|esi;eis|];;
let neighborhoods_names = [|"esi";"eis"|];;

let heuristics = [|Heuristics.random; Heuristics.mdd|];;
let heuristics_names = [|"r"; "m"|];;

let task filename =
    let n = 1 in
    let nf = float_of_int n in

    let jobs, best = Job.parse filename in
    let bestf = float_of_int best in

    print_string (Filename.basename filename);
    for i = 0 to Array.length searches - 1 do
        for j = 0 to Array.length neighborhoods - 1 do
            for k = 0 to Array.length heuristics - 1 do
                let average_deviation = ref 0 in
                let average_time = ref 0. in
                for l = 1 to n do
                    let schedule, time = Util.time (searches.(i) neighborhoods.(j) Selection.best jobs) (heuristics.(k) jobs) in
                    average_deviation := !average_deviation + 100 * (schedule.cost - best);
                    average_time := !average_time +. time
                done;
                if best = 0 then
                    Printf.printf ",(%d),%.2f" (!average_deviation/(100*n)) ((!average_time *. 1000.) /. nf)
                else
                    Printf.printf ",%.2f,%.2f" ((float_of_int !average_deviation) /. (nf*.bestf)) ((!average_time *. 1000.)/. nf);
                flush_all ()
            done
        done
    done;
    print_newline ();
;;

let main argv =
    print_string "filename";
    for i = 0 to Array.length searches - 1 do
        for j = 0 to Array.length neighborhoods - 1 do
            for k = 0 to Array.length heuristics - 1 do
                Printf.printf ",d(%s%s%s)" searches_names.(i) heuristics_names.(k) neighborhoods_names.(j);
                Printf.printf ",t(%s%s%s)" searches_names.(i) heuristics_names.(k) neighborhoods_names.(j)
            done
        done
    done;
    print_newline ();
    Array.iteri (fun i filename -> if i > 0 then task filename) argv
;;

main Sys.argv
