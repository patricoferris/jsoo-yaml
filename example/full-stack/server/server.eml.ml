let yaml () = 
  let y = `O [ ("hello", `String "world") ] in 
  match Yml.to_string y with Ok s -> s | _ -> "Yikes!" 

let home =
  <html>
    <head>
      <title>jsoo-yaml</title>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/js-yaml/4.1.0/js-yaml.min.js"
        integrity="sha512-CSBhVREyzHAjAFfBlIBakjoRUKp5h7VSweP0InR/pAJyptH7peuhCsqAI/snV+TwZmXZqoUklpXp6R6wMnYf5Q=="
        crossorigin="anonymous"></script>
    </head>
    <body id="body">
      <p>Server says: <code><%s yaml () %></code></p>
      <script src="/static/index.js"></script>
    </body>
  </html>

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [

    Dream.get "/"
      (fun _ -> Dream.html home);

    Dream.get "/static/**"
      (Dream.static "./static");

  ]
  @@ Dream.not_found