let yml =
  let v = Jv.get Jv.global "jsyaml" in
  match Jv.is_some v with
  | true -> v
  | false ->
      failwith
        "No global jsyaml object found -- are you sure you have correctly \
         required jsyaml for this project?"