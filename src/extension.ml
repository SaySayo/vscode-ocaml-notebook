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
let _ = 
  let kind = Vscode.NotebookCellKind.Markup in
  let value = "Html markup" in 
  let languageId = "OCaml" in
  let cell = Vscode.NotebookCellData.make ~kind ~value ~languageId in
  let cells = [cell] in 
  Vscode.NotebookData.make ~cells