type 'a res = ('a, [ `Msg of string | `YAMLException of string ]) result

type t =
  [ `Null
  | `Bool of bool
  | `Float of float
  | `String of string
  | `A of t list
  | `O of (string * t) list ]

let yaml = G.yml

let obj = Jv.get Jv.global "Object"

let rec to_jv : t -> Jv.t = function
  | `Null -> Jv.null
  | `Bool b -> Jv.of_bool b
  | `Float f -> Jv.of_float f
  | `String s -> Jv.of_string s
  | `A lst -> Jv.of_list to_jv lst
  | `O map ->
      let obj = Jv.obj [||] in
      List.iter (fun (k, v) -> Jv.set obj k (to_jv v)) map;
      obj

let keys jv =
  let keys_method = Jv.get obj "keys" in
  Jv.apply keys_method [| jv |] |> Jv.to_jstr_list |> List.map Jstr.to_string

let of_jv jv =
  let rec fn jv =
    if Jv.is_none jv then `Null
    else
      match Jv.typeof jv |> Jstr.to_string with
      | "string" -> `String (Jv.to_string jv)
      | "number" -> `Float (Jv.to_float jv)
      | "boolean" -> `Bool (Jv.to_bool jv)
      | "object" -> (
          match Jv.instanceof jv ~cons:(Jv.get Jv.global "Array") with
          | true -> `A (List.map fn (Jv.to_jv_list jv))
          | false ->
              let keys = keys jv in
              `O (List.map (fun key -> (key, fn (Jv.get jv key))) keys) )
      | _ -> raise (Failure "load returned something I can't convert")
  in
  try Ok (fn jv) with Failure msg -> Error (`Msg msg)

module Schema = struct
  type t = Jv.t

  let default = Jv.get yaml "DEFAULT_SCHEMA"

  let failsafe = Jv.get yaml "FAILSAFE_SCHEMA"

  let json = Jv.get yaml "JSON_SCHEMA"

  let core = Jv.get yaml "CORE_SCHEMA"
end

type load_opts = Jv.t

let load_opts ?filename ?schema ?json () =
  let str = Option.map Jstr.of_string in
  let o = Jv.obj [||] in
  Jv.Jstr.set_if_some o "filename" (str filename);
  Jv.set_if_some o "schema" schema;
  Jv.Bool.set_if_some o "json" json;
  o

let load_jv ?opts str =
  let args =
    match opts with
    | None -> [| Jv.of_jstr str |]
    | Some load_opts -> [| Jv.of_jstr str; load_opts |]
  in
  match Jv.call yaml "load" args with
  | exception Jv.Error e ->
      if Jstr.to_string (Jv.Error.name e) = "YAMLException" then
        Error (`YAMLException (Jv.Error.message e |> Jstr.to_string))
      else Error (`Msg (Jv.Error.message e |> Jstr.to_string))
  | v -> Ok v

let load ?opts str =
  match load_jv ?opts str with Error _ as e -> e | Ok v -> of_jv v

let of_string ?opts s = load ?opts (Jstr.of_string s)

type dump_opts = Jv.t

let dump_opts ?indent ?no_array_indent ?skip_invalid ?flow_level ?styles ?schema
    ?sort_keys ?line_width ?no_refs ?no_compat_mode ?condense_flow ?quoting_type
    ?force_quote ?replacer () =
  let o = Jv.obj [||] in
  Jv.Int.set_if_some o "indent" indent;
  Jv.Bool.set_if_some o "noArrayIndent" no_array_indent;
  Jv.Bool.set_if_some o "skipInvalid" skip_invalid;
  Jv.Int.set_if_some o "flowLevel" flow_level;
  Jv.set_if_some o "styles" styles;
  Jv.set_if_some o "schema" schema;
  ( match sort_keys with
  | Some (`Bool b) -> Jv.Bool.set o "sortKeys" b
  | Some (`Fun f) ->
      Jv.set o "sortKeys"
        (Jv.repr (fun jstr -> Jv.of_int (f (Jstr.to_string jstr))))
  | _ -> () );
  Jv.Int.set_if_some o "lineWidth" line_width;
  Jv.Bool.set_if_some o "noRefs" no_refs;
  Jv.Bool.set_if_some o "noCompatMode" no_compat_mode;
  Jv.Bool.set_if_some o "condenseFlow" condense_flow;
  ( match quoting_type with
  | Some '\'' -> Jv.Jstr.set o "quotingType" (Jstr.of_string "'")
  | Some '"' -> Jv.Jstr.set o "quotingType" (Jstr.of_string "'")
  | _ -> () );
  Jv.Bool.set_if_some o "forceQuotes" force_quote;
  ( match replacer with
  | Some f ->
      Jv.set o "replacer"
        (Jv.repr (fun (k', v') -> f (Jstr.to_string k', Jstr.to_string v')))
  | _ -> () );
  o

let dump ?opts jv =
  let args =
    match opts with None -> [| jv |] | Some load_opts -> [| jv; load_opts |]
  in
  Jv.call yaml "dump" args |> Jv.to_jstr

let dump_string ?opts jv = dump ?opts jv |> Jstr.to_string

let to_string ?opts t = dump ?opts (to_jv t) |> Jstr.to_string
