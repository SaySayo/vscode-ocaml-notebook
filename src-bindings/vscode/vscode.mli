module Disposable : sig
  type t

  val t_to_js : t -> Ojs.t

  val t_of_js : Ojs.t -> t
end

module ExtensionContext : sig
  type t

  val t_to_js : t -> Ojs.t

  val t_of_js : Ojs.t -> t

  val subscriptions : t -> Disposable.t list [@@js.get]

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
  ]
end

module Commands : sig
  val registerCommand :
    command:string
    -> callback:(args:(Ojs.t list[@js.variadic]) -> unit)
    -> Disposable.t
    [@@js.global "vscode.commands.registerCommand"]
end

module Window : sig
  val showInformationMessage : message:string -> unit [@@js.global "vscode.window.showInformationMessage"]
end

module TextDocument : sig
  type t 

  val t_to_js : t -> Ojs.t

  val eol : t -> EndOfLine.t 
end

module NotebookCell : sig
  val document -> TextDocument
end 