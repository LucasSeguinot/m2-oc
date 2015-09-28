type job = {
    duration : int;
    weight : int;
    deadline : int
}

exception ParsingError

val parse : string -> job array
