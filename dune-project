(lang dune 2.8)

(name jsoo-yaml)

(generate_opam_files true)

(source
 (github patricoferris/jsoo-yaml))

(license ISC)

(authors "Patrick Ferris")

(maintainers "pf341@patricoferris.com")

(package
 (name yml)
 (synopsis "A thin wrapper over ocaml-yaml and jsoo-yaml")
 (description
  "Yml provides a thin wrapper over a C and JS backend for parsing Yaml and to share types")
 (depends
  (yaml
   (>= 2.1.0))
  (js_of_ocaml
   (>= 3.9.0))
  brr))

(package
 (name jsoo-yaml)
 (synopsis "Js_of_ocaml bindings for js-yaml")
 (description
  "This library uses Brr to produce js_of_ocaml bindings for the popular js-yaml")
 (depends
  (js_of_ocaml
   (>= 3.9.0))
  brr))
