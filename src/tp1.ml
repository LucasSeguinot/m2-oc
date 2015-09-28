open Job

let jobs = Job.parse "tests/orlib/wt_40_001.txt";;
print_int jobs.(0).duration
