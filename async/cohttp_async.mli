(*
 * Copyright (c) 2013 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open Core.Std
open Async.Std

module Http_response : sig
  type t
  val version : t -> Cohttp_protocol.Code.version
  val status : t -> Cohttp_protocol.Code.status_code
  val headers : t -> Cohttp_protocol.Header.t
  val make :
    ?version:Cohttp_protocol.Code.version ->
    ?status:Cohttp_protocol.Code.status_code ->
    ?encoding:Cohttp_protocol.Transfer.encoding ->
    ?headers:Cohttp_protocol.Header.t -> unit -> t
end

module Http_request : sig
  type t
  val meth : t -> Cohttp_protocol.Code.meth
  val uri : t -> Uri.t
  val version : t -> Cohttp_protocol.Code.version
  val path : t -> string
  val header : t -> string -> string option
  val headers : t -> Cohttp_protocol.Header.t
  val params : t -> (string * string list) list
  val get_param : t -> string -> string option
  val transfer_encoding : t -> string
  val make :
    ?meth:Cohttp_protocol.Code.meth ->
    ?version:Cohttp_protocol.Code.version ->
    ?encoding:Cohttp_protocol.Transfer.encoding ->
    ?headers:Cohttp_protocol.Header.t -> ?body:'a -> Uri.t -> t
end

type ret = (Http_response.t * string Pipe.Reader.t) option Deferred.t

module Http_client : sig
  val head : ?headers:Cohttp_protocol.Header.t -> Uri.t -> ret
  val get : ?headers:Cohttp_protocol.Header.t -> Uri.t -> ret
  val delete : ?headers:Cohttp_protocol.Header.t -> Uri.t -> ret
  val post :
    ?body:(unit -> string option) ->
    ?chunked:bool ->
    ?headers:Cohttp_protocol.Header.t -> Uri.t -> ret
  val put :
    ?body:(unit -> string option) ->
    ?chunked:bool ->
    ?headers:Cohttp_protocol.Header.t -> Uri.t -> ret
  val patch :
    ?body:(unit -> string option) ->
    ?chunked:bool ->
    ?headers:Cohttp_protocol.Header.t -> Uri.t -> ret
end
