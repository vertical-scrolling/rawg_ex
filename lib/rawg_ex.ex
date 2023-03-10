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
  @type id() :: String.t()

  @type achievement() :: %{
          id: integer(),
          name: String.t(),
          description: String.t(),
          image: String.t(),
          percent: String.t()
        }
  @type position() :: %{id: integer(), name: String.t(), slug: String.t()}
  @type creator() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          image: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer()
        }
  @type creator_details() :: %{
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
          image: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer()
        }
  @type game() :: %{
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
        }
  @type game_details() :: %{
          id: integer(),
          slug: String.t(),
          name: String.t(),
          name_original: String.t(),
          description: String.t(),
          released: String.t(),
          tba: boolean(),
          updated: String.t(),
          background_image: String.t(),
          background_image_additional: String.t(),
          website: String.t(),
          rating: number(),
          rating_top: non_neg_integer(),
          ratings: map(),
          ratings_count: non_neg_integer(),
          reactions: map(),
          added: non_neg_integer(),
          added_by_status: map(),
          metacritic: non_neg_integer(),
          metacritic_platforms: [%{metascore: non_neg_integer(), url: String.t()}],
          playtime: non_neg_integer(),
          screenshots_count: non_neg_integer(),
          movies_count: non_neg_integer(),
          creators_count: non_neg_integer(),
          achievements_count: non_neg_integer(),
          parent_achievements_count: non_neg_integer(),
          suggestions_count: non_neg_integer(),
          reddit_url: String.t(),
          reddit_name: String.t(),
          reddit_description: String.t(),
          reddit_logo: String.t(),
          reddit_count: non_neg_integer(),
          twitch_count: non_neg_integer(),
          youtube_count: non_neg_integer(),
          reviews_text_count: String.t(),
          alternative_names: [String.t()],
          metacritic_url: String.t(),
          parents_count: non_neg_integer(),
          additions_count: non_neg_integer(),
          game_series_count: non_neg_integer(),
          esrb_rating: opt(%{id: integer(), slug: String.t(), name: String.t()}),
          platforms: [
            %{
              platform: platform(),
              released_at: opt(String.t()),
              requirements: opt(%{minimum: String.t(), recommended: String.t()})
            }
          ]
        }
  @type genre() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer()
        }
  @type genre_details() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer(),
          description: String.t()
        }
  @type platform() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          games_count: non_neg_integer(),
          image_background: String.t(),
          image: String.t(),
          year_start: 0..32767,
          year_end: 0..32767
        }
  @type platform_details() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          games_count: non_neg_integer(),
          image_background: String.t(),
          description: String.t(),
          image: String.t(),
          year_start: 0..32767,
          year_end: 0..32767
        }
  @type publisher() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer()
        }
  @type publisher_details() :: %{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer(),
          description: String.t()
        }
  @type reddit_post() :: %{
          id: integer(),
          name: String.t(),
          text: String.t(),
          image: String.t(),
          url: String.t(),
          username: String.t(),
          username_url: String.t(),
          created: String.t()
        }
  @type screenshot() :: %{
          id: integer(),
          image: String.t(),
          hidden: boolean(),
          width: non_neg_integer(),
          height: non_neg_integer()
        }
  @type store() :: %{
          id: integer(),
          name: String.t(),
          domain: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer()
        }
  @type store_details() :: %{
          id: integer(),
          name: String.t(),
          domain: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer(),
          description: String.t()
        }
  @type store_link() :: %{
          id: integer(),
          game_id: String.t(),
          store_id: String.t(),
          url: String.t()
        }
  @type tag() :: %{
          id: integer(),
          name: String.t(),
          language: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer()
        }
  @type tag_details() :: %{
          id: integer(),
          name: String.t(),
          language: String.t(),
          slug: String.t(),
          image_background: String.t(),
          games_count: non_neg_integer(),
          description: String.t()
        }
  @type trailer() :: %{
          id: integer(),
          name: String.t(),
          preview: String.t(),
          data: map()
        }
  @type twitch_stream() :: %{
          id: integer(),
          external_id: integer(),
          name: String.t(),
          description: String.t(),
          created: String.t(),
          published: String.t(),
          thumbnail: String.t(),
          view_count: non_neg_integer(),
          language: String.t()
        }
  @type youtube_video() :: %{
          id: integer(),
          external_id: String.t(),
          channel_id: String.t(),
          channel_title: String.t(),
          name: String.t(),
          description: String.t(),
          created: String.t(),
          view_count: non_neg_integer(),
          comments_count: non_neg_integer(),
          like_count: non_neg_integer(),
          dislike_count: non_neg_integer(),
          favorite_count: non_neg_integer(),
          thumbnails: %{}
        }

  @type page_opts() :: [{:page, non_neg_integer()}, {:page_size, non_neg_integer()}]
  @type order_and_page_opts() :: [
          {:ordering, atom()},
          {:page, non_neg_integer()},
          {:page_size, non_neg_integer()}
        ]
  @type start_link_opts() :: [{:pools, map()}]
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
  @spec start_link(name :: name(), api_key :: String.t(), opts :: start_link_opts()) ::
          Supervisor.on_start()
  def start_link(name, api_key, opts \\ []) do
    :persistent_term.put({:rawg_ex, name}, api_key)
    Finch.start_link([{:name, name} | opts])
  end

  @spec get_creator_roles(name :: name(), opts :: page_opts()) :: result(page(position()))
  def get_creator_roles(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/creator-roles?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_creators(name :: name(), opts :: page_opts()) :: result(page(creator()))
  def get_creators(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/creators?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_creator(name :: name(), id :: id()) :: result(creator_details())
  def get_creator(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/creators/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_developers(name :: name(), opts :: page_opts()) :: result(page(developer()))
  def get_developers(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/developers?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_developer(name :: name(), id :: id()) :: result(developer())
  def get_developer(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/developers/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_games(name :: name(), opts :: get_games_opts()) :: result(page(game()))
  def get_games(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/games?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_additions(name :: name(), id :: id(), opts :: page_opts()) ::
          result(page(game()))
  def get_game_additions(name, id, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/games/#{id}/additions?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_development_team(name :: name(), id :: id(), opts :: order_and_page_opts()) ::
          result(page(developer()))
  def get_game_development_team(name, id, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/games/#{id}/development-team?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_series_games(name :: name(), id :: id(), opts :: page_opts()) ::
          result(page(game()))
  def get_game_series_games(name, id, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/games/#{id}/game-series?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_parents(name :: name(), id :: id(), opts :: page_opts()) :: result(page(game()))
  def get_game_parents(name, id, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/games/#{id}/parent-games?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_screenshots(name :: name(), id :: id(), opts :: order_and_page_opts()) ::
          result(page(screenshot()))
  def get_game_screenshots(name, id, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/games/#{id}/screenshots?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_stores(name :: name(), id :: id(), opts :: order_and_page_opts()) ::
          result(page(store_link()))
  def get_game_stores(name, id, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/games/#{id}/stores?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game(name :: name(), id :: id()) :: result(game_details())
  def get_game(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/games/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_achievements(name :: name(), id :: id()) :: result([achievement()])
  def get_game_achievements(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/games/#{id}/achievements?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_trailers(name :: name(), id :: id()) :: result([trailer()])
  def get_game_trailers(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/games/#{id}/movies?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_reddit_posts(name :: name(), id :: id()) :: result([reddit_post()])
  def get_game_reddit_posts(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/games/#{id}/reddit?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_similars(name :: name(), id :: id()) :: result([game_details()])
  def get_game_similars(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/games/#{id}/suggested?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_twitch_streams(name :: name(), id :: id()) :: result([twitch_stream()])
  def get_game_twitch_streams(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/games/#{id}/twitch?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_game_youtube_videos(name :: name(), id :: id()) :: result([youtube_video()])
  def get_game_youtube_videos(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/games/#{id}/youtube?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_genres(name :: name(), opts :: order_and_page_opts()) :: result(page(genre()))
  def get_genres(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/genres?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_genre(name :: name(), id :: id()) :: result(genre_details())
  def get_genre(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/genres/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_platforms(name :: name(), opts :: order_and_page_opts()) :: result(page(platform()))
  def get_platforms(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/platforms?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_platforms_parents(name :: name(), opts :: order_and_page_opts()) ::
          result(
            page(%{id: integer(), name: String.t(), slug: String.t(), platforms: [platform()]})
          )
  def get_platforms_parents(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/platforms/list/parents?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_platform(name :: name(), id :: id()) :: result(platform_details())
  def get_platform(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/platforms/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_publishers(name :: name(), opts :: page_opts()) :: result(page(publisher()))
  def get_publishers(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/publishers?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_publisher(name :: name(), id :: id()) :: result(publisher_details())
  def get_publisher(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/publishers/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_stores(name :: name(), opts :: order_and_page_opts()) :: result(page(store()))
  def get_stores(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/stores?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_store(name :: name(), id :: id()) :: result(store_details())
  def get_store(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/stores/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_tags(name :: name(), opts :: page_opts()) :: result(page(tag()))
  def get_tags(name, opts \\ []) do
    query_string = query_string(name, opts)
    url = "#{@url_prefix}/tags?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  @spec get_tag(name :: name(), id :: id()) :: result(tag_details())
  def get_tag(name, id) do
    query_string = query_string(name, [])
    url = "#{@url_prefix}/tags/#{id}?#{query_string}"

    Finch.build(:get, url)
    |> Finch.request(name)
    |> parse_response()
  end

  # -------------------------------------------------------------------------------
  # Child spec
  # -------------------------------------------------------------------------------
  def child_spec([name: name, api_key: api_key] = params) do
    opts = params |> Keyword.get(:opts, [])

    %{
      id: name,
      start: {__MODULE__, :start_link, [name, api_key, opts]}
    }
  end

  # -------------------------------------------------------------------------------
  # Private functions
  # -------------------------------------------------------------------------------
  defp query_string(name, opts) do
    api_key = :persistent_term.get({:rawg_ex, name})
    URI.encode_query([{:key, api_key} | opts])
  end

  defp parse_response({:ok, %Finch.Response{status: 200, body: body}}),
    do: {:ok, Jason.decode!(body, keys: :atoms)}

  defp parse_response({:ok, %Finch.Response{status: status}}), do: {:error, Error.decode(status)}
end
