defmodule RawgEx do
  alias RawgEx.Error

  @moduledoc """
  Documentation for `RawgEx`.
  """

  # -------------------------------------------------------------------------------
  # Constants
  # -------------------------------------------------------------------------------
  @url_prefix "https://api.rawg.io/api/"

  # -------------------------------------------------------------------------------
  # Types
  # -------------------------------------------------------------------------------
  @type name() :: atom()

  @type position() :: %{id: integer(), name: String.t(), slug: String.t()}

  @type opt(t) :: nil | t
  @type start_link_opts() :: [{:name, name()}, {:pools, map()}]
  @type get_creator_roles_opts() :: [{:page, non_neg_integer()}, {:page_size, non_neg_integer()}]

  # -------------------------------------------------------------------------------
  # External API
  # -------------------------------------------------------------------------------
  @spec start_link(opts :: start_link_opts()) :: Supervisor.on_start()
  def start_link(opts) do
    Finch.start_link(opts)
  end

  @spec get_creator_roles(name :: name(), opts :: get_creator_roles_opts()) ::
          {:ok,
           %{
             count: non_neg_integer(),
             next: opt(String.t()),
             previous: opt(String.t()),
             results: [position()]
           }}
          | {:error, RawgEx.Error.t()}
  def get_creator_roles(name, opts \\ []) do
    api_key = Application.get_env(__MODULE__, :api_key)
    query_string = URI.encode_query([{:key, api_key} | opts])
    url = "#{@url_prefix}creator-roles?#{query_string}"
    response = Finch.build(:get, url) |> Finch.request(name)

    case response do
      {:ok,
       %Finch.Response{
         body: body,
         status: 200
       }} ->
        {:ok, Jason.decode!(body, keys: :atoms)}

      {:ok,
       %Finch.Response{
         status: status
       }} ->
        {:error, Error.decode(status)}
    end
  end
end
