type 'a res = ('a, [ `Msg of string ]) result

type t =
  [ `Null
  | `Bool of bool
  | `Float of float
  | `String of string
  | `A of t list
  | `O of (string * t) list ]

let of_string = Yaml.of_string

let to_string t = Yaml.to_string t
