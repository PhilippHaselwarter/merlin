(*
 * uTop_complete.ml
 * ----------------
 * Copyright : (c) 2011, Jeremie Dimino <jeremie@dimino.org>
 * Licence   : BSD3
 *
 * This file is a part of utop.
 *)

open Types

let lookup_env f x env =
  try
    Some (f x env)
  with Not_found | Env.Error _ ->
    None

(* +-----------------------------------------------------------------+
   | Listing methods                                                 |
   +-----------------------------------------------------------------+ *)

let rec find_method env meth type_expr =
  match type_expr.desc with
    | Tlink type_expr ->
        find_method env meth type_expr
    | Tobject (type_expr, _) ->
        find_method env meth type_expr
    | Tfield (name, _, type_expr, rest) ->
        if name = meth then
          Some type_expr
        else
          find_method env meth rest
    | Tpoly (type_expr, _) ->
        find_method env meth type_expr
    | Tconstr (path, _, _) -> begin
        match lookup_env Env.find_type path env with
          | None
          | Some { type_manifest = None } ->
              None
          | Some { type_manifest = Some type_expr } ->
              find_method env meth type_expr
      end
    | _ ->
        None

let rec methods_of_type env acc type_expr =
  match type_expr.desc with
    | Tlink type_expr ->
        methods_of_type env acc type_expr
    | Tobject (type_expr, _) ->
        methods_of_type env acc type_expr
    | Tfield (name, _, ty, rest) ->
        methods_of_type env ((name,ty) :: acc) rest
    | Tpoly (type_expr, _) ->
        methods_of_type env acc type_expr
    | Tconstr (path, _, _) -> begin
        match lookup_env Env.find_type path env with
          | None
          | Some { type_manifest = None } ->
              acc
          | Some { type_manifest = Some type_expr } ->
              methods_of_type env acc type_expr
      end
    | _ -> acc

let rec find_object env meths type_expr =
  match meths with
    | [] ->
        Some type_expr
    | meth :: meths ->
        match find_method env meth type_expr with
          | Some type_expr ->
              find_object env meths type_expr
          | None ->
              None

let methods_of_object env longident meths =
  match lookup_env Env.lookup_value longident env with
    | None ->
        []
    | Some (path, { val_type = type_expr }) ->
        match find_object env meths type_expr with
          | None ->
              []
          | Some type_expr -> methods_of_type env [] type_expr

