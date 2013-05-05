module Async = struct
  module Http = Cohttp_protocol
  include Cohttp_async
end
module Lwt = struct
  module Http = Cohttp_protocol
  include Cohttp_lwt_unix
end
