(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *   INRIA, CNRS and contributors - Copyright 1999-2018       *)
(* <O___,, *       (see CREDITS file for the list of authors)           *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(************************************************************************)
(* Coq Python interface                                                 *)
(* Copyright 2021 Inria Paris -- Dual License LGPL 2.1 / GPL3+          *)
(* Written by: Emilio J. Gallego Arias                                  *)
(************************************************************************)
(* Status: Very Experimental                                            *)
(************************************************************************)

open Base
open Python_lib

module SP = Serapi.Serapi_protocol
module SY = Sertop.Sertop_pyser
module D = Defunc

(* Eventually set from Python *)
let _debug = ref false

module CParam : sig
  val sid : Stateid.t D.Of_python.t
  val coq_object : SP.coq_object D.Of_python.t
  val add_opts : SP.add_opts D.Of_python.t
  val query_opt : SP.query_opt D.Of_python.t
  val query_cmd : SP.query_cmd D.Of_python.t
  val print_opt : SP.print_opt D.Of_python.t
end = struct
  let sid = D.Of_python.create ~type_name:"sid" ~conv:SY.Stateid.t_of_python
  let coq_object = D.Of_python.create ~type_name:"coq_object" ~conv:SY.coq_object_of_python
  let add_opts = D.Of_python.create ~type_name:"add_opts" ~conv:SY.add_opts_of_python
  let query_opt = D.Of_python.create ~type_name:"query_opt" ~conv:SY.query_opt_of_python
  let query_cmd = D.Of_python.create ~type_name:"query_cmd" ~conv:SY.query_cmd_of_python
  let print_opt = D.Of_python.create ~type_name:"print_opt" ~conv:SY.print_opt_of_python
end

let _ppd = Caml.Format.eprintf "===> %s@\n%!"

let exec_cmd =
  let st_ref = ref (SP.State.make ()) in
  fun cmd ->
    try
      let ans, st = SP.exec_cmd !st_ref cmd in
      st_ref := st;
      ans
    with exn ->
      let msg = Caml.Printexc.to_string exn in
      [SP.ObjList [ SP.CoqString ("Exception raised in Coq: " ^ msg) ]]

let ap = Python_lib.python_of_list SY.python_of_answer_kind
let exec_cmd cmd = exec_cmd cmd |> ap

(* XXX: use applicative syntax *)
let coq_add : pyobject D.t =
  let open D.Param in
  let open CParam in
  let code = positional "code" string ~docstring:"Coq code to parse" in
  let opts = positional "opts" add_opts ~docstring:"add options" in
  Defunc.map2 code opts
    ~f:(fun code opts -> SP.Add (opts, code) |> exec_cmd)

let coq_exec : pyobject D.t =
  let open D.Param in
  let open CParam in
  let sid = positional "sid" sid ~docstring:"sid to reach" in
  Defunc.map sid ~f:(fun sid -> SP.Exec sid |> exec_cmd)

let coq_query : pyobject D.t =
  let open D.Param in
  let open CParam in
  let cmd = positional "cmd" query_cmd ~docstring:"query command" in
  let opts = positional "opts" query_opt ~docstring:"query options" in
  Defunc.map2 opts cmd
    ~f:(fun opts cmd -> SP.Query(opts,cmd) |> exec_cmd)

let coq_print : pyobject D.t =
  let open D.Param in
  let open CParam in
  let obj = positional "obj" coq_object ~docstring:"Coq object to print" in
  let opts = positional "opts" print_opt ~docstring:"print options" in
  Defunc.map2 obj opts
    ~f:(fun obj opts -> SP.Print(opts,obj) |> exec_cmd)

let () =
  if not (Py.is_initialized ())
  then Py.initialize ();
  let () = Coq_init.init () in
  Caml.Format.eprintf "🐓🐍🐓🐍 Coq's initialization complete 🐍🐓🐍🐓@\n%!";
  let mod_ = Py_module.create "coq" in
  Py_module.set mod_ "add" coq_add;
  Py_module.set mod_ "exec" coq_exec;
  Py_module.set mod_ "query" coq_query;
  Py_module.set mod_ "print" coq_print;
  ()
