open Js_of_ocaml
open Vscode
open Yojson

(* type t = [ 
| `Null
| `Bool of bool
| `Int of int
| `Intlit of string
| `Float of float
| `Floatlit of string
| `String of string
| `Stringlit of string
| `Assoc of (string * t) list
| `List of t list
| `Tuple of t list
| `Variant of string * t option
 ]

type _toplevel_struct = {
  metadata : t;
  nbformat : int;
  nbformat_minor : int;
  cells : int list
} *)

(* let example = "\"field\": 23"
let _ = print_endline Yojson.from_string example; *)

let deserializeNotebook ~content:_ ~token:_ =
  let kind = NotebookCellKind.Code in
  let value = "let x = 5;;" in
  let languageId = "OCaml" in
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
                let document = NotebookCell.document cell in 
                let content = TextDocument.getText document () in
                let lb = Lexing.from_string content in
                let len = lb.lex_buffer_len in 
                let _ = Printf.printf "length of lexbuf: %i\n" len in
                let b = lb.lex_buffer in 
                let _ = print_endline (Bytes.to_string b) in
                let toplevel_phrase = Parse.toplevel_phrase lb in
                let ()  = Toploop.initialize_toplevel_env () in
             (* FIXME: We should do error handling using the return bool instead *)
                let () = Js_of_ocaml_toplevel.JsooTop.initialize () in
               let _ = try Toploop.execute_phrase true Format.str_formatter toplevel_phrase with err -> let _ = print_endline (Printexc.to_string err) in true in
              let output = Format.flush_str_formatter () in
               let data = Buffer.from output in 
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
