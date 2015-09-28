let rec hill_climbing neighborhood select jobs schedule temp =
    if select neighborhood jobs schedule temp then
        hill_climbing neighborhood select jobs schedule temp
    else
        schedule
