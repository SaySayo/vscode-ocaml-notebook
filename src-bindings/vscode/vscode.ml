module Disposable = struct
   type t = Ojs.t [@@js]

include
[%js:
val from : (t list[@js.variadic]) -> t
  [@@js.global "vscode.Disposable.from"]

val make : dispose:(unit -> unit) -> t [@@js.new "vscode.Disposable"]

val dispose : t -> unit [@@js.call]]
end

module ExtensionContext = struct
  type t = Ojs.t [@@js]
  include [%js: 
  val subscriptions : t -> Disposable.t list [@@js.get]

  val extensionPath : t -> string [@@js.get]

  [@@@js.stop]
  val subscribe : t -> disposable:Disposable.t -> unit
  [@@@js.start]

  [@@@js.implem
  let subscribe this ~disposable =
    let subscriptions = Ojs.get_prop_ascii ([%js.of: t] this) "subscriptions" in
    let (_ : Ojs.t) =
      Ojs.call subscriptions "push" [| [%js.of: Disposable.t] disposable |]
    in
    ()
  ]]
end

module Commands = struct
  include [%js: val registerCommand :
    command:string
    -> callback:(args:(Ojs.t list[@js.variadic]) -> unit)
    -> Disposable.t
    [@@js.global "vscode.commands.registerCommand"]]
end

module Window = struct
  include [%js: val showInformationMessage : message:string -> unit [@@js.global "vscode.window.showInformationMessage"]]
end

module NotebookCellKind = struct 
  type t = Code [@js 2] | Markup [@js 1] [@@js.enum] [@@js]
end 

module NotebookDocument = struct
  type t = Ojs.t [@@js]
include 
[%js:
  val cellCount : t -> int [@@js.get]

   val isClosed : t -> bool [@@js.get]

  val isDirty : t -> bool [@@js.get]

  val isUntitled : t -> bool [@@js.get]

  (* val metadata : t  *)

  val notebookType : t -> string [@@js.get]

  (* val uri : t -> Uri.t [@@js.get] *)

  val version : t -> int [@@js.get]
  (*
  val cellAt : t -> index:int -> NotebookCell.t

  val getCells : ?range:NotebookRange.t -> NotebookCell.t

  val save : t -> Thenable -> bool *)]
end

module NotebookCellExecutionSummary = struct
  type t = Ojs.t [@@js]
include [%js:
  val executionOrder : t -> int option [@@js.get]

  val success : t -> bool option [@@js.get]

  (* val timing : t -> endTime:int -> startTime:int option [@@js.get] *)]

end

module NotebookCellData = struct 
  type t = Ojs.t [@@js]
  include [%js: val make : kind:NotebookCellKind.t  -> value:string -> languageId:string -> t [@@js.new "vscode.NotebookCellData"]
                val kind : t -> NotebookCellKind.t [@@js.get]
                val languageId : t -> string [@@js.get]
                val value : t -> string [@@js.get]]
end

module NotebookData = struct 
  type t = Ojs.t [@@js]
include [%js: val make : cells:(NotebookCellData.t list) -> t [@@js.new "vscode.NotebookData"]
              val cells : t -> NotebookCellData.t list [@@js.global "NotebookCellData"]]
end

module CancellationToken = struct 
  type t = Ojs.t [@@js]
end 

module Buffer = struct 
  type t = Ojs.t [@@js]
  include
    [%js:
    val alloc : size:int -> t [@@js.new "Buffer.alloc"]]
end 

module NotebookSerializer = struct 
  type t = Ojs.t [@@js]

  include [%js:
    val deserializeNotebook :
        t -> content:Buffer.t -> token:CancellationToken.t -> NotebookData.t 
        [@@js.call]
    val serializeNotebook :
        t -> data:NotebookData.t -> token:CancellationToken.t -> Buffer.t 
        [@@js.call]
    val create : deserializeNotebook:(content:Buffer.t -> token:CancellationToken.t -> NotebookData.t)
        -> serializeNotebook:(data:NotebookData.t -> token:CancellationToken.t -> Buffer.t)
         -> t [@@js.builder]]
end

module NotebookDocumentContentOptions = struct
  type t = Ojs.t [@@js]
end

module TextDocument = struct
  type t = Ojs.t [@@js]
end

module NotebookCellOutputItem = struct
  type t = Ojs.t [@@js]
include [%js:
  val make : data:Buffer.t -> mime:string -> t [@@js.new "vscode.NotebookCellOutputItem"]

  val data : t -> Buffer.t [@@js.get]
  
  val mime : t -> string [@@js.get]

  val error : value:Promise.error -> t
  [@@js.global "vscode.NotebookCellOutputItem.error"]
  
  val text : value:string -> ?mime:string -> unit -> t
  [@@js.global "vscode.NotebookCellOutputItem.text"]]
end

module NotebookCellOutput = struct

  type t = Ojs.t [@@js]

include [%js:
val make : items:(NotebookCellOutputItem.t list) -> ?metadata:unit -> unit -> t [@@js.new "vscode.NotebookCellOutput"]]
end

module NotebookCell = struct
  type t = Ojs.t [@@js]
(* include [%js:
  val document : t -> TextDocument.t [@@js.get]

  val executionSummary : t -> unit -> NotebookCellExecutionSummary.t [@@js.get]

  val index : t -> int [@@js.get]

  val kind : t -> NotebookCellKind.t [@@js.get]

  val metadata : t [@@js.get]

  val notebook : t -> NotebookDocument.t [@@js.get]

  val outputs : t -> NotebookCellOutput [@@js.get]] *)
end 

module NotebookCellExecution = struct 
  type t = Ojs.t [@@js]
include [%js:
val replaceOutput : t -> out:NotebookCellOutput.t -> ?cell:NotebookCell.t -> unit -> unit Promise.t [@@js.call]]
end

module NotebookController = struct
  type t = Ojs.t [@@js]
include [%js:
val createNotebookCellExecution : t -> cell:NotebookCell.t -> NotebookCellExecution.t [@@js.call]]
end

module Notebooks = struct 
include [%js: val createNotebookController : id:string 
-> notebookType:string 
-> label:string 
-> ?handler:(cell:NotebookCellData.t list
-> notebook:NotebookDocument.t -> controller:NotebookController.t -> unit Promise.t)
-> unit 
-> NotebookController.t [@@js.global "vscode.notebook.createNotebookController"]]
end

module Workspace = struct
include [%js: val registerNotebookSerializer : notebookType:string -> serializer:NotebookSerializer.t 
  -> ?option:NotebookDocumentContentOptions.t -> unit -> Disposable.t [@@js.global "vscode.workspace.registerNotebookSerializer"] ]
end