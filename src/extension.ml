let deserializeNotebook ~content:_ ~token:_ =
  let kind = Vscode.NotebookCellKind.Markup in
  let value = "This is a proof concept of a notebook cell :)" in
  let languageId = "OCaml" in
  let cell = Vscode.NotebookCellData.make ~kind ~value ~languageId in
  let cells = [ cell ] in
  Vscode.NotebookData.make ~cells

let serializeNotebook ~data:_ ~token:_ = Vscode.Buffer.alloc ~size:16

let notebookSerializer =
  Vscode.NotebookSerializer.create ~serializeNotebook ~deserializeNotebook

let notebook_controller =
  let id = "ocamlnotebook" in
  let notebookType = "markup" in
  let label = "ocamlnotebook" in
  let handler ~cells ~notebook:_ ~controller =
    (* Create the handler *)
    let () =
      (* TODO: Run these in parallel *)
      List.iter
        (fun cell ->
          let open Promise.Syntax in
          let execution =
            Vscode.NotebookController.createNotebookCellExecution controller
              ~cell
          in
          let () =
            Vscode.NotebookCellExecution.set_executionOrder execution 0
          in
          let now = Js.Date.make () |> Js.Date.getTime in
          (* Call execution starts *)
          let () = Vscode.NotebookCellExecution.start ~startTime:now () in
          (* Create CellOutputItem with the content of the cell *)
          let notebook_cell_output_item =
            (* We don't have a buffer in the VSCode API, this is a UInt8Array, which is part of the escript API, should be binded. *)
            let data = Vscode.Buffer.alloc ~size:16 in
            let mime = "ocaml-notebook-cell-output-item" in
            Vscode.NotebookCellOutputItem.make ~data ~mime
          in
          (* Create CellOutput *)
          let notebook_cell_output =
            NotebookCellOutput.make ~items:[ notebook_cell_output_item ] ()
          in
          (* Assign the cell output to the execution (replaceOutput) *)
          let* () =
            NotebookCellExecution.replaceOutput ~out:notebook_cell_output ~cell
              ()
          in
          (* Call execution.end *)
          let now = Js.Date.make () |> Js.Date.getTime in
          let () =
            Vscode.NotebookCellExecution.end_ ~success:true ~endTime:now ()
          in
          ())
        cells
    in
    Promise.return ()
  in
  Vscode.Notebooks.createNotebookController ~id ~notebookType ~label ~handler ()

let activate (context : Vscode.ExtensionContext.t) =
  let disposable =
    Vscode.Workspace.registerNotebookSerializer ~notebookType:"ocamlnotebook"
      ~serializer:notebookSerializer ()
  in
  Vscode.ExtensionContext.subscribe ~disposable context

(* see {{:https://code.visualstudio.com/api/references/vscode-api#Extension}
   activate() *)
let () =
  let open Js_of_ocaml.Js in
  export "activate" (wrap_callback activate)

(* let notebookController =
   let createNotebookCellExecution ~cell:cell = *)

(* let _notebookCell =
   (* let kind = Vscode.NotebookCellKind.Markup in
   let document = Vscode.TextDocument in
   let outputs = Vscode.NotebookCellOutput.make ~items ()  *)
   let kind = Vscode.NotebookCellKind.Markup in
     let value = "This is a proof concept of a notebook cell :)" in
     let languageId = "OCaml" in
     let cell = Vscode.NotebookCellData.make ~kind ~value ~languageId in
     let cells = [cell] in
     Vscode.NotebookData.make ~cells *)
