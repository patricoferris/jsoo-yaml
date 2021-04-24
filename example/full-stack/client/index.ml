open Brr

let () =
  let yaml = `O [ ("hello", `String "world") ] in
  let doc_body = Document.body G.document in
  let text = match Yml.to_string yaml with Ok s -> s | _ -> "Yikes!" in
  El.(append_children doc_body [ p [ txt @@ Jstr.of_string "Client says: "; code [txt @@ Jstr.of_string text] ] ])
