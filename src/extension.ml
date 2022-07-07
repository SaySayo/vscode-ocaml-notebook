  let deserializeNotebook ~content:_ ~token:_ = 
    let kind = Vscode.NotebookCellKind.Markup in
    let value = "This is a proof concept of a notebook cell :)" in 
    let languageId = "OCaml" in
    let cell = Vscode.NotebookCellData.make ~kind ~value ~languageId in
    let cells = [cell] in 
    Vscode.NotebookData.make ~cells

  let serializeNotebook ~data:_ ~token:_ = Vscode.Buffer.alloc ~size:16

  let notebookSerializer = Vscode.NotebookSerializer.create ~serializeNotebook ~deserializeNotebook 
  
  let activate (context : Vscode.ExtensionContext.t) =
  let disposable =
    Vscode.Workspace.registerNotebookSerializer ~notebookType:"ocamlnotebook" ~serializer:notebookSerializer ()
  in
  Vscode.ExtensionContext.subscribe ~disposable context

(* see {{:https://code.visualstudio.com/api/references/vscode-api#Extension}
   activate() *)
let () =
  let open Js_of_ocaml.Js in
  export "activate" (wrap_callback activate)

(* let notebookData = 
  let kind = Vscode.NotebookCellKind.Markup in
  let value = "Html markup" in 
  let languageId = "OCaml" in
  let cell = Vscode.NotebookCellData.make ~kind ~value ~languageId in
  let cells = [cell] in 
  Vscode.NotebookData.make ~cells *)

(* let _ = 
  let content = Vscode.Uint8Array in 
  let token = Vscode.CancellationToken in
  let serializeNotebook = Vscode.NotebookSerializer.serializeNotebook ~data ~token in
  let deserializeNotebook = Vscode.NotebookSerializer.deserializeNotebook ~content ~token in
  let notebookSerializer = Vscode.NotebookSerializer.create ~deserializeNotebook ~serializeNotebook  *)

