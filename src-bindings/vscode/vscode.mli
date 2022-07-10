module Disposable : sig
  type t

end

module ExtensionContext : sig
  type t

  val t_to_js : t -> Ojs.t

  val t_of_js : Ojs.t -> t

  val subscriptions : t -> Disposable.t list 

  val subscribe : t -> disposable:Disposable.t -> unit

  [@@@js.implem
  let subscribe this ~disposable =
    let subscriptions = Ojs.get_prop_ascii ([%js.of: t] this) "subscriptions" in
    let (_ : Ojs.t) =
      Ojs.call subscriptions "push" [| [%js.of: Disposable.t] disposable |]
    in
    ()
  ]
end

module NotebookCellKind : sig 
  type t = Code | Markup 
end 

module NotebookDocument : sig
  type t = Ojs.t

  val cellCount : t -> int 

   val isClosed : t -> bool 

  val isDirty : t -> bool 

  val isUntitled : t -> bool 

  (* val metadata : t  *)

  val notebookType : t -> string 

  (* val uri : t -> Uri.t  *)

  val version : t -> int 
  (*
  val cellAt : t -> index:int -> NotebookCell.t

  val getCells : ?range:NotebookRange.t -> NotebookCell.t

  val save : t -> Thenable -> bool *)
end

module NotebookCellExecutionSummary : sig

  type t 

  val executionOrder : t -> int option

  val success : t -> bool option

  (* val timing : t -> endTime:int -> startTime:int option *)

end


module NotebookCellData : sig 
  type t = Ojs.t 
  val make : kind:NotebookCellKind.t  -> value:string -> languageId:string -> t [@@js.new "vscode.NotebookCellData"]
  val kind : t -> NotebookCellKind.t 
  val languageId : t -> string 
  val value : t -> string
end

module NotebookData : sig 
  type t = Ojs.t 
val make : cells:(NotebookCellData.t list [@js.variadic]) -> t [@@js.new "vscode.NotebookData"]
val cells : t -> NotebookCellData.t list 
end

module CancellationToken : sig 
  type t 
end 

module Buffer : sig 
  type t 
    val alloc : size:int -> t 
end 

module NotebookSerializer : sig 
  type t 

    val deserializeNotebook :
        t -> content:Buffer.t -> token:CancellationToken.t -> NotebookData.t 
  
    val serializeNotebook :
        t -> data:NotebookData.t -> token:CancellationToken.t -> Buffer.t 
    
    val create : deserializeNotebook:(content:Buffer.t -> token:CancellationToken.t -> NotebookData.t)
        -> serializeNotebook:(data:NotebookData.t -> token:CancellationToken.t -> Buffer.t) -> t 
  
end

module Commands : sig
  val registerCommand :
    command:string
    -> callback:(args:(Ojs.t list) -> unit)
    -> Disposable.t
end

module Window : sig
  val showInformationMessage : message:string -> unit
end

module NotebookDocumentContentOptions : sig
  type t 
end

module TextDocument : sig
  type t
(* 
  val uri : t -> Uri.t

  val fileName : t -> string

  val isUntitled : t -> bool

  val languageId : t -> string

  val version : t -> int

  val isDirty : t -> bool

  val isClosed : t -> bool

  val save : t -> bool Promise.t

  val eol : t -> EndOfLine.t

  val lineCount : t -> int

  val lineAt : t -> line:int -> TextLine.t

  val lineAtPosition : t -> position:Position.t -> TextLine.t

  val offsetAt : t -> position:Position.t -> int

  val positionAt : t -> offset:int -> Position.t

  val getText : t -> ?range:Range.t -> unit -> string

  val getWordRangeAtPosition :
       t
    -> position:Position.t
    -> ?regex:Js_of_ocaml.Regexp.regexp
    -> unit
    -> Range.t option

  val validateRange : t -> range:Range.t -> Range.t

  val validatePosition : t -> position:Position.t -> Position.t *)
end

module NotebookCellOutputItem : sig
  type t 
  
  val make : data:Buffer.t -> mime:string -> t 

  val data : t -> Buffer.t

  val mime : t -> string

  val error : value:Promise.error -> t

  val text : value:string -> ?mime:string -> unit -> t

end

module NotebookCellOutput : sig
  type t 
val make : items:(NotebookCellOutputItem.t list) -> ?metadata:unit -> unit -> t
end

module NotebookCell : sig
  type t

  val kind : t -> NotebookCellKind.t 

  val metadata : t 

  val notebook : t -> NotebookDocument.t 

   val document : t -> TextDocument.t
  (*
  val executionSummary : t -> unit -> NotebookCellExecutionSummary.t

  val index : t -> int *)

  val outputs : t -> NotebookCellOutput.t list 
end 

module NotebookCellExecution : sig
  type t = Ojs.t [@@js]
val replaceOutput : t -> out:NotebookCellOutput.t -> ?cell:NotebookCell.t -> unit -> unit Promise.t
end

module NotebookController : sig
  type t 
    val createNotebookCellExecution : t -> cell:NotebookCell.t -> NotebookCellExecution.t

    val notebookType : t -> string 
end

module Notebooks : sig 
  val createNotebookController : id:string 
  -> notebookType:string 
  -> label:string -> ?handler:(cell:NotebookCellData.t list
  -> notebook:NotebookDocument.t 
  -> controller:NotebookController.t 
  -> unit Promise.t) 
  -> unit 
  -> NotebookController.t
  end

module Workspace : sig
  val registerNotebookSerializer : notebookType:string -> serializer:NotebookSerializer.t 
  -> ?option:NotebookDocumentContentOptions.t -> unit -> Disposable.t
end

(*
module NotebookRange : sig

  type t 

  val start : t -> int

  val end : t -> int 

  val isEmpty : t -> bool 

  val with : (change:end:int) -> (*TODO*) 
end *)

