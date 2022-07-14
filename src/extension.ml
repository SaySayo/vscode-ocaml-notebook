open Js_of_ocaml
open Vscode

let deserializeNotebook ~content:_ ~token:_ =
  let kind = NotebookCellKind.Markup in
  let value = "This is a proof concept of a notebook cell :)" in
  let languageId = "ocaml" in
  let cell = NotebookCellData.make ~kind ~value ~languageId in
  let cells = [ cell ] in
  NotebookData.make ~cells

let serializeNotebook ~data:_ ~token:_ = Buffer.alloc ~size:16

let notebookSerializer =
  NotebookSerializer.create ~serializeNotebook ~deserializeNotebook

let _notebook_controller =
  let id = "ocamlnotebook" in
  let notebookType = "ocamlnotebook" in
  let label = "ocamlnotebook" in
  let handler ~(cells : NotebookCell.t list) ~notebook:_ ~controller =
    (* Create the handler *)
    let () =
      (* TODO: Run these in parallel *)
      cells
      |> List.map (fun (cell : NotebookCell.t) ->
             let open Promise.Syntax in
             let execution =
               NotebookController.createNotebookCellExecution controller ~cell
             in
             let () = NotebookCellExecution.set_executionOrder execution 0 in
             let now = (new%js Js.date_now)##getTime in
             (* Call execution starts *)
             let () = NotebookCellExecution.start execution ~startTime:now () in
             (* Create CellOutputItem with the content of the cell *)
             let notebook_cell_output_item =
               (* We don't have a buffer in the VSCode API, this is a UInt8Array, which is part of the escript API, should be binded. *)
               let data = Buffer.from "ocamlnotebook" in
               let mime = "text/plain" in
               NotebookCellOutputItem.make ~data ~mime
             in
             (* Create CellOutput *)
             let notebook_cell_output =
               NotebookCellOutput.make ~items:[ notebook_cell_output_item ] ()
             in
             (* Assign the cell output to the execution (replaceOutput) *)
             let* () =
               NotebookCellExecution.replaceOutput execution
                 ~out:notebook_cell_output ~cell ()
             in
             (* Call execution.end *)
             let now = (new%js Js.date_now)##getTime in
             let () =
               NotebookCellExecution.end_ execution ~success:true ~endTime:now
                 ()
             in
             Promise.return ())
      |> Promise.all_list |> ignore
    in
    Promise.return ()
  in
  Notebooks.createNotebookController ~id ~notebookType ~label ~handler ()

let activate (context : ExtensionContext.t) =
  let disposable =
    Workspace.registerNotebookSerializer ~notebookType:"ocamlnotebook"
      ~serializer:notebookSerializer ()
  in
  ExtensionContext.subscribe ~disposable context

(* see {{:https://code.visualstudio.com/api/references/vscode-api#Extension}
   activate() *)
let () =
  let open Js_of_ocaml.Js in
  export "activate" (wrap_callback activate)

(* let notebookController =
   let createNotebookCellExecution ~cell:cell = *)

(* let _notebookCell =
   (* let kind = NotebookCellKind.Markup in
   let document = TextDocument in
   let outputs = NotebookCellOutput.make ~items ()  *)
   let kind = NotebookCellKind.Markup in
     let value = "This is a proof concept of a notebook cell :)" in
     let languageId = "OCaml" in
     let cell = NotebookCellData.make ~kind ~value ~languageId in
     let cells = [cell] in
     NotebookData.make ~cells *)
