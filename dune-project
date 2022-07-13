(lang dune 3.0)

(name vscode-ocaml-notebook)

(generate_opam_files true)

(package
 (name vscode-ocaml-notebook)
 (synopsis "HelloWorld example for VS Code")
 (allow_empty)
 (depends
  (ocaml
   (>= 4.11))
  (promise_jsoo
   (>= 0.3.1))
  (gen_js_api
   (and
    (= 1.1.1)
    :build))
  ojs
  js_of_ocaml))
