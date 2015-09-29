type job = {
    duration : int;
    weight : int;
    deadline : int
}

type schedule = {
    jobs : int array;
    start : int array;
    mutable cost : int
}

type 'a neighborhood = {
    iterator : ('a -> unit) -> job array -> schedule -> schedule -> unit;
    neighbor : 'a -> job array -> schedule -> unit;
    null_index : 'a
}
