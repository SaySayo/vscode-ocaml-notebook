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