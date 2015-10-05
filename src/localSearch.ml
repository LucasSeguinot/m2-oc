let rec hill_climbing_aux neighborhood select jobs schedule temp =
    if select neighborhood jobs schedule temp then
        hill_climbing_aux neighborhood select jobs schedule temp
    else
        schedule

let hill_climbing neighborhood select jobs schedule =
    let temp = Schedule.create jobs in
    hill_climbing_aux neighborhood select jobs schedule temp

let rec vnd_aux neighborhoods select jobs schedule temp i =
    if i < Array.length neighborhoods then
        if select neighborhoods.(i) jobs schedule temp then
            vnd_aux neighborhoods select jobs schedule temp 0
        else
            vnd_aux neighborhoods select jobs schedule temp (i+1)
    else
        schedule

let vnd neighborhoods select jobs schedule =
    let temp = Schedule.create jobs in
    vnd_aux neighborhoods select jobs schedule temp 0

let rec piped_vnd_aux neighborhoods select jobs schedule temp i started =
    if i < Array.length neighborhoods then
        if select neighborhoods.(i) jobs schedule temp then
            piped_vnd_aux neighborhoods select jobs schedule temp i true
        else
            if started then
                piped_vnd_aux neighborhoods select jobs schedule temp 0 false
            else
                piped_vnd_aux neighborhoods select jobs schedule temp (i+1) false
    else
        schedule

let piped_vnd neighborhoods select jobs schedule =
    let temp = Schedule.create jobs in
    piped_vnd_aux neighborhoods select jobs schedule temp 0 false
