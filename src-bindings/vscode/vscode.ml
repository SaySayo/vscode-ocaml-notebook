module NotebookCellKind = struct 
  type t = Code [@js 2] | Markup [@js 1] [@@js.enum] [@@js]
end 

module NotebookDocument : sig
  type t

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

  val save : t -> Thenable -> bool *)

end