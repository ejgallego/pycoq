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

let init () =
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

  let dft_ml_path, vo_path =
    Serapi.Serapi_paths.coq_loadpath_default ~implicit:true ~coq_path:Coq_config.coqlib in
  let ml_path = dft_ml_path in
  let vo_path = vo_path in

  (* coq initialization *)
  coq_init
    { fb_handler
    ; ml_load = None
    ; debug = true
    ; allow_sprop = true
    ; indices_matter = false
    ; ml_path
    ; vo_path
    } Caml.Format.err_formatter;

  (* document initialization *)

  let stm_options = Stm.AsyncOpts.default_opts in

  (* Disable due to https://github.com/ejgallego/coq-serapi/pull/94 *)
  let stm_options =
    { stm_options with
      async_proofs_tac_error_resilience = `None
    ; async_proofs_cmd_error_resilience = false
    } in

  let injections = [Coqargs.RequireInjection ("Coq.Init.Prelude", None, Some false)] in

  let sertop_dp = Names.(DirPath.make [Id.of_string "PyTop"]) in
  let doc_type = Stm.Interactive (TopLogical sertop_dp) in

  let ndoc = { Stm.doc_type
             ; injections
             ; stm_options
             } in

  let _ = Stm.new_doc ndoc in
  ()
