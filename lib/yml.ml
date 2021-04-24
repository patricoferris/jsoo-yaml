type 'a res = ('a, [ `Msg of string ]) result

type t =
  [ `Null
  | `Bool of bool
  | `Float of float
  | `String of string
  | `A of t list
  | `O of (string * t) list ]

let of_string s : t res =
  match Jsyaml.of_string s with
  | Error (`YAMLException msg) -> Error (`Msg msg)
  | Error (`Msg _) as e -> e
  | Ok _ as ok -> ok

let to_string (t : t) = Ok (Jsyaml.to_string t)
