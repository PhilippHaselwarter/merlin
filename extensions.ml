let ext_lwt = "lwt",
  ["module Lwt : sig
    val un_lwt : 'a Lwt.t -> 'a
    val in_lwt : 'a Lwt.t -> 'a Lwt.t
    val to_lwt : 'a -> 'a Lwt.t
    val finally' : 'a Lwt.t -> unit Lwt.t -> 'a Lwt.t
    val un_stream : 'a Lwt_stream.t -> 'a
    val unit_lwt : unit Lwt.t -> unit Lwt.t
   end"],
  ["val (>>) : unit Lwt.t -> 'a Lwt.t -> 'a Lwt.t
   val raise_lwt : exn -> 'a Lwt.t"]

let ext_any = "any",
  ["module Any : sig
    val val' : 'a
  end"],
  []

let ext_js = "js",
  ["module Js : sig
    val un_js : 'a Js.t -> 'a
    val un_meth : 'a Js.meth -> 'a
  end"],
  []

(* a##m         | (un_js a)#m#get
   a##m <- e    | (un_js a)#m#set e
   a##m (a,b,c) | un_meth ((un_js a)#m a b c …)
   Js constructors : todo *)

let registry = [ext_lwt;ext_any]

