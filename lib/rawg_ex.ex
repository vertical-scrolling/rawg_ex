defmodule RawgEx do
  alias RawgEx.Error

  @moduledoc """
  Documentation for `RawgEx`.
  """

  # -------------------------------------------------------------------------------
  # Constants
  # -------------------------------------------------------------------------------
  @url_prefix "https://api.rawg.io/api"

  # -------------------------------------------------------------------------------
  # Types
  # -------------------------------------------------------------------------------
  @type name() :: atom()

  @type position() :: %{id: integer(), name: String.t(), slug: String.t()}
  @type creator() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          image: String.t(),
          image_background: String.t(),
          description: String.t(),
          games_count: non_neg_integer(),
          reviews_count: non_neg_integer(),
          rating: String.t(),
          rating_top: non_neg_integer(),
          updated: String.t()
        }

  @type start_link_opts() :: [{:name, name()}, {:pools, map()}]
  @type get_creator_roles_opts() :: [{:page, non_neg_integer()}, {:page_size, non_neg_integer()}]
  @type get_creators_opts() :: [{:page, non_neg_integer()}, {:page_size, non_neg_integer()}]

  @type opt(t) :: nil | t
  @type page(t) :: %{
          count: non_neg_integer(),
          next: opt(String.t()),
          previous: opt(String.t()),
          results: [t]
        }
  @type result(t) :: {:ok, t} | {:error, RawgEx.Error.t()}

  # -------------------------------------------------------------------------------
  # External API
  # -------------------------------------------------------------------------------
  @spec start_link(opts :: start_link_opts()) :: Supervisor.on_start()
  def start_link(opts) do
    Finch.start_link(opts)
  end

  @spec get_creator_roles(name :: name(), opts :: get_creator_roles_opts()) ::
          result(page(position()))
  def get_creator_roles(name, opts \\ []) do
    api_key = Application.get_env(__MODULE__, :api_key)
    query_string = URI.encode_query([{:key, api_key} | opts])
    url = "#{@url_prefix}/creator-roles?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_creators(name :: name(), opts :: get_creators_opts()) ::
          result(
            page(%{
              id: integer(),
              name: String.t(),
              slug: String.t(),
              image: String.t(),
              image_background: String.t(),
              games_count: non_neg_integer()
            })
          )
  def get_creators(name, opts \\ []) do
    query_string = query_string(opts)
    url = "#{@url_prefix}/creators?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_creator(name :: name(), id :: String.t()) :: result(creator())
  def get_creator(name, id) do
    url = "#{@url_prefix}/creator/#{id}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  # -------------------------------------------------------------------------------
  # Private functions
  # -------------------------------------------------------------------------------
  defp query_string(opts) do
    api_key = Application.get_env(__MODULE__, :api_key)
    URI.encode_query([{:key, api_key} | opts])
  end

  defp parse_response({:ok, %Finch.Response{status: 200, body: body}}),
    do: {:ok, Jason.decode!(body, keys: :atoms)}

  defp parse_response({:ok, %Finch.Response{status: status}}), do: {:error, Error.decode(status)}
end
