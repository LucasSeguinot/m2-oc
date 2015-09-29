open Types

let exchange_neighbor i jobs schedule =
    Schedule.swap schedule i (i+1);
    Schedule.update_cost jobs schedule i (i+1)

let exchange_iterator f jobs src dst =
    let n = Array.length jobs in

    Schedule.copy src dst;

    Schedule.swap dst 0 1;
    Schedule.update_cost jobs dst 0 1;
    f 0;
    for i = 1 to n-2 do
        Schedule.swap dst (i-1) i;
        Schedule.swap dst i (i+1);
        Schedule.update_cost jobs dst (i-1) (i+1);
        f i
    done

let exchange = {
    iterator = exchange_iterator;
    neighbor = exchange_neighbor;
    null_index = -1
}

let swap_neighbor (i,j) jobs schedule =
    Schedule.swap schedule i j;
    Schedule.update_cost jobs schedule i j

let swap_iterator f jobs src dst =
    let n = Array.length jobs in

    Schedule.copy src dst;

    for i = 0 to n-2 do
        Schedule.swap dst i (i+1);
        Schedule.update_cost jobs dst i (i+1);
        f (i,i+1);
        for j = i+2 to n-1 do
            Schedule.swap dst i j;
            Schedule.swap dst j (j-1);
            Schedule.update_cost jobs dst i j;
            f (i,j)
        done;
        Schedule.swap dst i (n-1);
        Schedule.update_cost jobs dst i (n-1);
    done

let swap = {
    iterator = swap_iterator;
    neighbor = swap_neighbor;
    null_index = (-1, -1)
}

let insertion_neighbor (i,j) jobs schedule =
    for k = j-1 downto i do
        Schedule.swap schedule k (k+1);
    done;
    Schedule.update_cost jobs schedule i j

let insertion_iterator f jobs src dst =
    let n = Array.length jobs in

    for j = 1 to n-1 do
        Schedule.copy src dst;

        for i = j-1 downto 0 do
            Schedule.swap dst i (i+1);
            Schedule.update_cost jobs dst i (i+1);
            f (i,j)
        done
    done

let insertion = {
    iterator = insertion_iterator;
    neighbor = insertion_neighbor;
    null_index = (-1, -1)
}
