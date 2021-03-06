(*
 * Copyright (C) 2006-2009 Citrix Systems Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *)
(** Represents the current "lock" *)
type token 

(** Calls a provided function with the VM locked. The abstract locking token is provided
    so the caller can call 'assert_locked' to make sure they don't perform side-effects outside
    the locked region. *)
val with_lock : API.ref_VM -> (token -> 'a -> 'b) -> 'a -> 'b

(** Raised by a call to 'assert_locked' if the VM is not locked by the provided token *)
exception Lock_not_held

(** Can be called to ensure we are still in the region protected by the lock and haven't accidentally
    dropped outside, eg by an accidental partial function application. *)
val assert_locked : API.ref_VM -> token -> unit


module Per_VM_Qs : sig

  (** Attempt to push the work item to the per-VM queue if it exists. If successful, return true.
      If unsuccessful i.e. the per-VM queue doesn't exist then return false *)
  val maybe_push: API.ref_VM -> string -> (token -> unit) -> bool
end

