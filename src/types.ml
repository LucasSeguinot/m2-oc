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

type neighborhood = {
    iterator : (int list -> unit) -> job array -> schedule -> schedule -> unit;
    neighbor : int list -> job array -> schedule -> unit
}
