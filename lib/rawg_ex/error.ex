defmodule RawgEx.Error do
  # -------------------------------------------------------------------------------
  # Types
  # -------------------------------------------------------------------------------
  @type t() ::
          :bad_request
          | :unauthorized
          | :forbidden
          | :not_found
          | :proxy_authentication_required
          | :request_timeout
          | :conflict
          | :gone
          | :too_many_requests
          | :internal_server_error
          | :bad_gateway
          | :service_unavailable
          | :network_authentication_required
          | {:unexpected_error, non_neg_integer()}

  # -------------------------------------------------------------------------------
  # External API
  # -------------------------------------------------------------------------------
  @spec decode(code :: non_neg_integer()) :: __MODULE__.t()
  def decode(400), do: :bad_request
  def decode(401), do: :unauthorized
  def decode(403), do: :forbidden
  def decode(408), do: :request_timeout
  def decode(409), do: :conflict
  def decode(410), do: :gone
  def decode(429), do: :too_many_requests
  def decode(500), do: :internal_server_error
  def decode(502), do: :bad_gateway
  def decode(503), do: :service_unavailable
  def decode(511), do: :network_authentication_required
  def decode(code), do: {:unexpected_error, code}
end
