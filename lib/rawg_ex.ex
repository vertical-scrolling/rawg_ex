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
  @type developer() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer(),
          description: String.t()
        }
  @type platform() :: %{}

  @type page_opts() :: [{:page, non_neg_integer()}, {:page_size, non_neg_integer()}]
  @type start_link_opts() :: [{:name, name()}, {:pools, map()}]
  @type get_games_opts() :: [
          {:page, non_neg_integer()},
          {:page_size, non_neg_integer()},
          {:search, String.t()},
          {:search_precise, boolean()},
          {:search_exact, boolean()},
          {:parent_platforms, String.t()},
          {:platforms, String.t()},
          {:stores, String.t()},
          {:developers, String.t()},
          {:publishers, String.t()},
          {:genres, String.t()},
          {:tags, String.t()},
          {:creators, String.t()},
          {:dates, String.t()},
          {:updated, String.t()},
          {:platforms_count, non_neg_integer()},
          {:metacritic, String.t()},
          {:exclude_collection, non_neg_integer()},
          {:exclude_additions, boolean()},
          {:exclude_patterns, boolean()},
          {:exclude_game_series, boolean()},
          {:exclude_stores, String.t()},
          {:ordering,
           :name
           | :"-name"
           | :released
           | :"-released"
           | :added
           | :"-added"
           | :created
           | :"-created"
           | :updated
           | :"-updated"
           | :rating
           | :"-rating"
           | :metacritic
           | :"-metacritic"}
        ]

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

  @spec get_creator_roles(name :: name(), opts :: page_opts()) :: result(page(position()))
  def get_creator_roles(name, opts \\ []) do
    api_key = Application.get_env(__MODULE__, :api_key)
    query_string = URI.encode_query([{:key, api_key} | opts])
    url = "#{@url_prefix}/creator-roles?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_creators(name :: name(), opts :: page_opts()) ::
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
    url = "#{@url_prefix}/creators/#{id}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_developers(name :: name(), opts :: page_opts()) ::
          result(
            page(%{
              id: integer(),
              name: String.t(),
              slug: String.t(),
              image_background: String.t(),
              games_count: non_neg_integer()
            })
          )
  def get_developers(name, opts \\ []) do
    query_string = query_string(opts)
    url = "#{@url_prefix}/developers?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_developer(name :: name(), id :: String.t()) :: result(developer())
  def get_developer(name, id) do
    url = "#{@url_prefix}/developers/#{id}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_games(name :: name(), opts :: get_games_opts()) ::
          result(
            page(%{
              id: integer(),
              slug: String.t(),
              name: String.t(),
              released: String.t(),
              tba: boolean(),
              background_image: String.t(),
              rating: number(),
              rating_top: non_neg_integer(),
              ratings: map(),
              ratings_count: non_neg_integer(),
              reviews_text_count: String.t(),
              added: non_neg_integer(),
              added_by_status: map(),
              metacritic: non_neg_integer(),
              playtime: non_neg_integer(),
              suggestions_count: non_neg_integer(),
              updated: String.t(),
              esrb_rating: opt(%{id: integer(), slug: String.t(), name: String.t()}),
              platforms: [
                %{
                  platform: platform(),
                  released_at: opt(String.t()),
                  requirements: opt(%{minimum: String.t(), recommended: String.t()})
                }
              ]
            })
          )
  def get_games(name, opts \\ []) do
    query_string = query_string(opts)
    url = "#{@url_prefix}/games?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_additions(name :: name(), id :: String.t()) ::
          result(
            page(%{
              id: integer(),
              slug: String.t(),
              name: String.t(),
              released: String.t(),
              tba: boolean(),
              background_image: String.t(),
              rating: number(),
              rating_top: non_neg_integer(),
              ratings: map(),
              ratings_count: non_neg_integer(),
              reviews_text_count: String.t(),
              added: non_neg_integer(),
              added_by_status: map(),
              metacritic: non_neg_integer(),
              playtime: non_neg_integer(),
              suggestions_count: non_neg_integer(),
              updated: String.t(),
              esrb_rating: opt(%{id: integer(), slug: String.t(), name: String.t()}),
              platforms: [
                %{
                  platform: platform(),
                  released_at: opt(String.t()),
                  requirements: opt(%{minimum: String.t(), recommended: String.t()})
                }
              ]
            })
          )
  def get_game_additions(name, id) do
    url = "#{@url_prefix}/games/#{id}/additions"

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
