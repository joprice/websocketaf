open Websocketaf

module Server : sig

  val create_connection_handler
    :  ?config : Httpaf.Config.t
    -> websocket_handler : (Eio.Net.Sockaddr.stream -> Wsd.t -> Websocket_connection.input_handlers)
    -> error_handler : (Eio.Net.Sockaddr.stream -> Server_connection.error_handler)
    -> sw:Eio.Switch.t
    -> (Eio.Net.Sockaddr.stream -> _ Eio.Net.stream_socket -> unit)
end

module Client : sig
  type t

  (* Perform HTTP/1.1 handshake and upgrade to WS. *)
  val connect
    :  ?config : Httpaf.Config.t
    -> sw             : Eio.Switch.t
    -> nonce          : string
    -> host           : string
    -> port           : int
    -> resource       : string
    -> error_handler : (Client_connection.error -> unit)
    -> websocket_handler : (Wsd.t -> Websocket_connection.input_handlers)
    -> Eio_unix.Net.stream_socket_ty Eio.Net.stream_socket
    -> t

  val is_closed : t -> bool

  val shutdown : t -> unit Eio.Promise.t
end
