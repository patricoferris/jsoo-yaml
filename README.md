jsoo-yaml
---------

Js_of_ocaml bindings for [js-yaml](https://github.com/nodeca/js-yaml).

There's also `Yml`, which provides a unified interface to parsing the subset of Yaml that is compatible with JSON with a Javascript backend thanks to bindings to [js-yaml](https://github.com/nodeca/js-yaml) and a non-JS backend thanks to [ocaml-yaml](https://github.com/avsm/ocaml-yaml) which binds `libyaml`. 

*If useful, desirable or doable this could be upstreamed to ocaml-yaml instead, but I need this functionality now!*

The `example/full-stack` shows the sharing of code by being able to specify. It's not exactly sharing the code because you still have to specify the `.js` implementation, but at least the interface (although small) is the same. You can always eject to `jsoo-yaml` and `yaml` if you want more options. 

