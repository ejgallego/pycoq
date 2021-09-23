open Base
open Python_lib

module SP = Serapi.Serapi_protocol
module SY = Sertop.Sertop_pyser
module D = Defunc

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

let wrap f =
  try f ()
  with exn ->
    let str = Caml.Printexc.to_string exn in
    Python_lib.python_of_string str

let exec_cmd =
  let st_ref = ref (SP.State.make ()) in
  fun cmd ->
    let ans, st = SP.exec_cmd !st_ref cmd in
    st_ref := st;
    ans

(* XXX: use applicative syntax *)
let coq_add : pyobject D.t =
  let open D.Param in
  let open CParam in
  let code = positional "code" string ~docstring:"Coq code to parse" in
  let opts = positional "opts" add_opts ~docstring:"add options" in
  Defunc.map2 code opts ~f:(fun code opts ->
      wrap @@ fun () ->
      let cmd = SP.Add (opts, code) in
      let ans = exec_cmd cmd in
      Python_lib.python_of_list SY.python_of_answer_kind ans
    )

let coq_exec : pyobject D.t =
  let open D.Param in
  let open CParam in
  let sid = positional "sid" sid ~docstring:"sid to reach" in
  Defunc.map sid ~f:(fun sid ->
      wrap @@ fun () ->
      let cmd = SP.Exec sid in
      let ans = exec_cmd cmd in
      Python_lib.python_of_list SY.python_of_answer_kind ans
    )

let coq_query : pyobject D.t =
  let open D.Param in
  let open CParam in
  let cmd = positional "cmd" query_cmd ~docstring:"query command" in
  let opts = positional "opts" query_opt ~docstring:"query options" in
  Defunc.map2 opts cmd ~f:(fun opts cmd ->
      wrap @@ fun () ->
      let cmd = SP.Query(opts,cmd) in
      Caml.Format.eprintf "going to call query@\n%!";
      let ans = exec_cmd cmd in
      Python_lib.python_of_list SY.python_of_answer_kind ans
    )

let coq_print : pyobject D.t =
  let open D.Param in
  let open CParam in
  let obj = positional "obj" coq_object ~docstring:"Coq object to print" in
  let opts = positional "opts" print_opt ~docstring:"print options" in
  Defunc.map2 obj opts ~f:(fun obj opts ->
      wrap @@ fun () ->
      let cmd = SP.Print(opts,obj) in
      Caml.Format.eprintf "going to call print@\n%!";
      let ans = exec_cmd cmd in
      Python_lib.python_of_list SY.python_of_answer_kind ans
    )

let coq_init () =
  let open Sertop.Sertop_init in

  let fb_handler fmt (fb : Feedback.feedback) =
    let open Feedback in
    let open Caml.Format in
    let pp_lvl fmt lvl = match lvl with
      | Error   -> fprintf fmt "Error: "
      | Info    -> fprintf fmt "Info: "
      | Debug   -> fprintf fmt "Debug: "
      | Warning -> fprintf fmt "Warning: "
      | Notice  -> fprintf fmt ""
    in
    let pp_loc fmt loc = let open Loc in match loc with
      | None     -> fprintf fmt ""
      | Some loc ->
        let where =
          match loc.fname with InFile f -> f | ToplevelInput -> "Toplevel input" in
        fprintf fmt "\"%s\", line %d, characters %d-%d:@\n"
          where loc.line_nb (loc.bp-loc.bol_pos) (loc.ep-loc.bol_pos) in
    match fb.contents with
    | Processed ->
      fprintf fmt "Processed@\n%!"
    | ProcessingIn s ->
      fprintf fmt "Processing in %s@\n%!" s
    | FileLoaded (m,n) ->
      fprintf fmt "file_loaded: %s, %s@\n%!" m n
    | Message (lvl,loc,msg) ->
      fprintf fmt "@[%a@]%a@[%a@]\n%!" pp_loc loc pp_lvl lvl Pp.pp_with msg
    | _ -> ()
  in

  (* coq initialization *)
  coq_init
    { fb_handler
    ; ml_load    = None
    ; debug = true
    ; allow_sprop = true
    ; indices_matter = false
    } Caml.Format.err_formatter;

  (* document initialization *)

  let stm_options = Stm.AsyncOpts.default_opts in

  (* Disable due to https://github.com/ejgallego/coq-serapi/pull/94 *)
  let stm_options =
    { stm_options with
      async_proofs_tac_error_resilience = `None
    ; async_proofs_cmd_error_resilience = false
    } in

  let injections = [Stm.RequireInjection ("Coq.Init.Prelude", None, Some false)] in

  let dft_ml_path, vo_path =
    Serapi.Serapi_paths.coq_loadpath_default ~implicit:true ~coq_path:Coq_config.coqlib in
  let ml_load_path = dft_ml_path in
  let vo_load_path = vo_path in

  let sertop_dp = Names.(DirPath.make [Id.of_string "PyTop"]) in
  let doc_type = Stm.Interactive (TopLogical sertop_dp) in

  let ndoc = { Stm.doc_type
             ; injections
             ; ml_load_path
             ; vo_load_path
             ; stm_options
             } in

  let _ = Stm.new_doc ndoc in
  Caml.Format.eprintf "🐓🐓 Coq's initialization complete 🐓🐓@\n%!"

let () =
  if not (Py.is_initialized ())
  then Py.initialize ();
  let () = coq_init () in
  let mod_ = Py_module.create "coq" in
  Py_module.set mod_ "add" coq_add;
  Py_module.set mod_ "exec" coq_exec;
  Py_module.set mod_ "query" coq_query;
  Py_module.set mod_ "print" coq_print;
  ()
