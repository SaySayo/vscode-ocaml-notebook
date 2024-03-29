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

  include
    [%js:
    val subscriptions : t -> Disposable.t list [@@js.get]
    val extensionPath : t -> string [@@js.get]

    [@@@js.stop]

    val subscribe : t -> disposable:Disposable.t -> unit

    [@@@js.start]

    [@@@js.implem
    let subscribe this ~disposable =
      let subscriptions =
        Ojs.get_prop_ascii ([%js.of: t] this) "subscriptions"
      in
      let (_ : Ojs.t) =
        Ojs.call subscriptions "push" [| [%js.of: Disposable.t] disposable |]
      in
      ()]]
end

module TextEditor = struct
  type t = Ojs.t [@@js]
end

module TextEditorEdit = struct
  type t = Ojs.t [@@js]
end

module Commands = struct
  include
    [%js:
    val registerCommand :
      command:string ->
      callback:(args:(Ojs.t list[@js.variadic]) -> unit) ->
      Disposable.t
      [@@js.global "vscode.commands.registerCommand"]

    val registerTextEditorCommand :
      command:string ->
      callback:
        (textEditor:TextEditor.t ->
        edit:TextEditorEdit.t ->
        args:(Ojs.t list[@js.variadic]) ->
        unit) ->
      Disposable.t
      [@@js.global "vscode.commands.registerTextEditorCommand"]]
end

module Window = struct
  include
    [%js:
    val showInformationMessage : message:string -> unit
      [@@js.global "vscode.window.showInformationMessage"]]
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

  include
    [%js:
    val executionOrder : t -> int option [@@js.get]
    val success : t -> bool option [@@js.get]

    (* val timing : t -> endTime:int -> startTime:int option [@@js.get] *)]
end

module CancellationToken = struct
  type t = Ojs.t [@@js]
end

module Buffer = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val alloc : size:int -> t [@@js.new "Buffer.alloc"]
    val from : string -> t [@@js.global "Buffer.from"]
    val length : t -> int [@@js.global "Buf.length"]
    val to_string : t -> string [@@js.call]]
end

module NotebookDocumentContentOptions = struct
  type t = Ojs.t [@@js]
end

module Range = struct
  type t = Ojs.t [@@js]
end

module TextDocument = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val fileName : t -> string [@@js.get]
    val getText : t -> ?range:Range.t -> unit -> string [@@js.call]]
end

module NotebookCellOutputItem = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val make : data:Buffer.t -> mime:string -> t
      [@@js.new "vscode.NotebookCellOutputItem"]

    val data : t -> Buffer.t [@@js.get]
    val mime : t -> string [@@js.get]

    val error : value:Promise.error -> t
      [@@js.global "vscode.NotebookCellOutputItem.error"]

    val text : value:string -> ?mime:string -> unit -> t
      [@@js.global "vscode.NotebookCellOutputItem.text"]]
end

module NotebookCellOutput = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val make :
      items:NotebookCellOutputItem.t list -> ?metadata:unit -> unit -> t
      [@@js.new "vscode.NotebookCellOutput"]

    val items : t -> NotebookCellOutputItem.t list [@@js.get]]
end

module NotebookCell = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val document : t -> TextDocument.t [@@js.get]
    val executionSummary : t -> NotebookCellExecutionSummary.t [@@js.get]

    (* val index : t -> int [@@js.get] *)

    val kind : t -> NotebookCellKind.t [@@js.get]

    (* val metadata : t [@@js.get "vscode.NotebookCell.metadata"] *)
    val notebook : t -> NotebookDocument.t [@@js.get]
    val outputs : t -> NotebookCellOutput.t list [@@js.get]]
end

module NotebookCellExecution = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val replaceOutput :
      t ->
      out:NotebookCellOutput.t ->
      ?cell:NotebookCell.t ->
      unit ->
      unit Promise.t
      [@@js.call]

    val executionOrder : t -> int [@@js.get "executionOrder"]
    val set_executionOrder : t -> int -> unit [@@js.set "executionOrder"]
    val start : t -> ?startTime:float -> unit -> unit [@@js.call "start"]

    val end_ : t -> success:bool -> ?endTime:float -> unit -> unit
      [@@js.call "end"]]
end

module NotebookCellData = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val make : kind:NotebookCellKind.t -> value:string -> languageId:string -> t
      [@@js.new "vscode.NotebookCellData"]

    val kind : t -> NotebookCellKind.t [@@js.get]
    val languageId : t -> string [@@js.get]
    val value : t -> string [@@js.get]
    val get_outputs : t -> NotebookCellOutput.t list option [@@js.get "outputs"]

    val set_outputs : t -> NotebookCellOutput.t list -> unit
      [@@js.set "outputs"]

    val executionSummary : t -> NotebookCellExecutionSummary.t [@@js.get]]
end

module NotebookData = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val make : cells:NotebookCellData.t list -> t
      [@@js.new "vscode.NotebookData"]

    val cells : t -> NotebookCellData.t list [@@js.get]]
end

module NotebookSerializer = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val deserializeNotebook :
      t -> content:Buffer.t -> token:CancellationToken.t -> NotebookData.t
      [@@js.call]

    val serializeNotebook :
      t -> data:NotebookData.t -> token:CancellationToken.t -> Buffer.t
      [@@js.call]

    val create :
      deserializeNotebook:
        (content:Buffer.t -> token:CancellationToken.t -> NotebookData.t) ->
      serializeNotebook:
        (data:NotebookData.t -> token:CancellationToken.t -> Buffer.t) ->
      t
      [@@js.builder]]
end

module NotebookController = struct
  type t = Ojs.t [@@js]

  include
    [%js:
    val createNotebookCellExecution :
      t -> cell:NotebookCell.t -> NotebookCellExecution.t
      [@@js.call]

    val notebookType : t -> string [@@js.get]

    val executeHandler :
      t ->
      cells:NotebookCell.t list ->
      notebook:NotebookDocument.t ->
      controller:t ->
      unit Promise.t
      [@@js.call]

    val supportedLanguages : t -> string list option [@@js.get]

    val set_supportedLanguages : t -> string list -> unit
      [@@js.set "supportedLanguages"]

    val supportsExecutionOrder : t -> bool option [@@js.get]

    val set_supportsExecutionOrder : t -> bool option -> unit
      [@@js.set "supportsExecutionOrder"]]
end

module Notebooks = struct
  include
    [%js:
    val createNotebookController :
      id:string ->
      notebookType:string ->
      label:string ->
      ?handler:
        (cells:NotebookCell.t list ->
        notebook:NotebookDocument.t ->
        controller:NotebookController.t ->
        unit Promise.t) ->
      unit ->
      NotebookController.t
      [@@js.global "vscode.notebooks.createNotebookController"]]
end

module Workspace = struct
  include
    [%js:
    val registerNotebookSerializer :
      notebookType:string ->
      serializer:NotebookSerializer.t ->
      ?option:NotebookDocumentContentOptions.t ->
      unit ->
      Disposable.t
      [@@js.global "vscode.workspace.registerNotebookSerializer"]]
end
