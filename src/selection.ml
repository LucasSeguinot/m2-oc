open Types
open Schedule
open Neighborhood

exception FoundSchedule

let first neighborhood jobs schedule temp =
    let cost = schedule.cost in
    let index = ref [] in

    let callback i =
        if temp.cost < cost then
            begin
                index := i;
                raise FoundSchedule
            end
    in
    try
        neighborhood.iterator callback jobs schedule temp;
        false
    with
        | FoundSchedule ->
            neighborhood.neighbor !index jobs schedule;
            true

let best neighborhood jobs schedule temp =
    let best_cost = ref schedule.cost in
    let best_index = ref [] in

    let callback i =
        if temp.cost < !best_cost then
            begin
                best_cost := temp.cost;
                best_index := i
            end
    in
    neighborhood.iterator callback jobs schedule temp;

    if !best_index != [] then
        begin
            neighborhood.neighbor !best_index jobs schedule;
            true
        end
    else
        false
