(* let activate (context : Vscode.ExtensionContext.t) =
  let disposable =
    Vscode.Commands.registerCommand ~command:"extension.helloWorld" ~callback:(fun ~args:_ ->
        Vscode.Window.showInformationMessage ~message:"Hello World!")
  in
  Vscode.ExtensionContext.subscribe ~disposable context

(* see {{:https://code.visualstudio.com/api/references/vscode-api#Extension}
   activate() *)
let () =
  let open Js_of_ocaml.Js in
  export "activate" (wrap_callback activate)
*)