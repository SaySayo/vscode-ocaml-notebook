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

(* module NotebookCellExecutionSummary : sig

  type t 

  val executionOrder : t -> int option

  val success : t -> bool option

  val timing : t -> endTime:int -> startTime:int option

end *)

module NotebookCellData = struct 
  type t = Ojs.t [@@js]
  include [%js: val make : kind:NotebookCellKind.t  -> value:string -> languageId:string -> t [@@js.new "vscode.NotebookCellData"]]
end

module NotebookData = struct 
  type t = Ojs.t [@@js]
include [%js: val make : cells:(NotebookCellData.t list [@js.variadic]) -> t [@@js.new "vscode.NotebookData"]]
end

module CancellationToken = struct 
  type t = Ojs.t [@@js]
end 

module Buffer = struct 
  type t = Ojs.t [@@js]
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