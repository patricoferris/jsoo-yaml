type 'a res = ('a, [ `Msg of string ]) result

type t =
  [ `Null
  | `Bool of bool
  | `Float of float
  | `String of string
  | `A of t list
  | `O of (string * t) list ]
(** Note these type are compatible with the
    {{:https://github.com/avsm/ocaml-yaml/blob/master/lib/types.ml#L44-L51}
    Yaml.value} and therefore also the [Ezjsonm.value] *)

val of_string : string -> t res

val to_string : t -> string res
