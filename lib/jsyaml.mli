(** {1 Bindings for js-yaml}

    Using Brr, this library contains js_of_ocaml bindings for js-yaml. The
    bindings aim to be as compatible as possible with
    {{:https://github.com/avsm/ocaml-yaml} ocaml-yaml} as possible. This should
    make it somehow possible to share the same data structure across your server
    and client. *)

type 'a res = ('a, [ `Msg of string | `YAMLException of string ]) result

type t =
  [ `Null
  | `Bool of bool
  | `Float of float
  | `String of string
  | `A of t list
  | `O of (string * t) list ]

val to_jv : t -> Jv.t
(** [to_jv t] conerts [t] to a Javascript value in probably the obvious way from
    the type definition *)

val of_jv : Jv.t -> t res
(** [of_jv t] converts a Javascript value to a {!t} but returns a result as it
    might fail *)

val yaml : Jv.t
(** Global jsyaml object *)

(** {2 Loading YAML} *)

module Schema : sig
  type t

  val default : t
  (** The default schema, all of the wonderfully weird yaml types... *)

  val failsafe : t
  (** Strings, arrays and plain objects --
      {{:http://www.yaml.org/spec/1.2/spec.html#id2802346} see the spec}*)

  val json : t
  (** JSON support types, probably the same as [t] so it might be wise to use
      this -- {{:http://www.yaml.org/spec/1.2/spec.html#id2803231} see the spec}*)

  val core : t
  (** Same as [json] *)
end

type load_opts

val load_opts :
  ?filename:string -> ?schema:Schema.t -> ?json:bool -> unit -> load_opts
(** Options for the load function. [filename] is used in error warnings. Note
    these bindings don't add the [onWarning] function because they capture it in
    the result type. [schema] is the schema to be used for parsing, defaulting
    to [{!Schema.default}]. [json] tells the parser if it should behave like
    [JSON.parse]. *)

val load_jv : ?opts:load_opts -> Jstr.t -> Jv.t res
(** [load_jv s] calls the
    {{:https://github.com/nodeca/js-yaml#load-string---options-} load} function
    and just returns whatever that is *)

val load : ?opts:load_opts -> Jstr.t -> t res
(** [load s] is the typed equivalent of {!load_jv} *)

val of_string : ?opts:load_opts -> string -> t res
(** [of_string s] is [load (Jstr.to_string jstr)] *)

(** {2 Dumping YAML}*)

type dump_opts

val dump_opts :
  ?indent:int ->
  ?no_array_indent:bool ->
  ?skip_invalid:bool ->
  ?flow_level:int ->
  ?styles:Jv.t ->
  ?schema:Schema.t ->
  ?sort_keys:[ `Bool of bool | `Fun of string -> int ] ->
  ?line_width:int ->
  ?no_refs:bool ->
  ?no_compat_mode:bool ->
  ?condense_flow:bool ->
  ?quoting_type:char ->
  ?force_quote:bool ->
  ?replacer:(string * string -> Jv.t) ->
  unit ->
  dump_opts
(** See {{:https://github.com/nodeca/js-yaml#dump-object---options-} the
    js-yaml} README for the details *)

val dump : ?opts:dump_opts -> Jv.t -> Jstr.t
(** [dump obj] serialises an object to YAML. *)

val dump_string : ?opts:dump_opts -> Jv.t -> string
(** [dump_string obj] is [Jstr.to_string @@ dump obj] *)

val to_string : ?opts:dump_opts -> t -> string
