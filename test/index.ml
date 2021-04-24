let () =
  let s = "hello: [ world, 1 ]" in
  match Jsyaml.of_string s with
  | Ok (`O [ ("hello", `A [ `String "world"; `Float 1. ]) ]) ->
      Brr.Console.log [ Jstr.of_string "Woohoo :)" ]
  | _ -> failwith "Not woohoo"

let () =
  let src = {|`
foo: {
    bar: true
} |} in
  match Jsyaml.of_string src with
  | Ok _ -> assert false
  | Error (`YAMLException yaml) -> Brr.Console.log [ Jstr.of_string yaml ]
  | _ -> failwith "hmmm"

let () =
  let obj =
    Jsyaml.to_jv (`O [ ("hello", `O [ ("hello", `String "world") ]) ])
  in
  Brr.Console.log [ Jsyaml.dump obj ];
  Brr.Console.log [ Jsyaml.(dump ~opts:(dump_opts ~indent:10 ())) obj ]
