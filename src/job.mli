open Types

exception ParsingError

val parse : string -> job array * int
