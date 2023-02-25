defmodule RawgExTest do
  use ExUnit.Case
  import Mock
  doctest RawgEx

  @test_name :rawg_ex_test

  @example_achievement %{
    id: 1,
    name: "achievement",
    description: "description",
    image: "image",
    percent: "percent"
  }
  @example_position %{
    id: 1,
    name: "position_1",
    slug: "slug"
  }
  @example_creator %{
    id: 1,
    name: "creator1",
    slug: "slug",
    image: "image",
    image_background: "image_background",
    games_count: 1
  }
  @example_developer %{
    id: 1,
    name: "developer1",
    slug: "slug",
    image: "image",
    image_background: "image_background",
    games_count: 1,
    description: "description"
  }
  @example_game %{
    id: 1,
    slug: "slug",
    name: "game",
    released: "released",
    tba: false,
    background_image: "background_image",
    rating: 1.0,
    rating_top: 100,
    ratings: %{},
    ratings_count: 5000,
    reviews_text_count: "reviews_text_count",
    added: 3,
    added_by_status: %{},
    metacritic: 80,
    playtime: 5,
    suggestions_count: 5,
    updated: "updated",
    platforms: []
  }
  @example_game_details %{
    id: 1,
    slug: "slug",
    name: "name",
    name_original: "name_original",
    description: "description",
    released: "released",
    tba: false,
    updated: "updated",
    background_image: "background_image",
    background_image_additional: "background_image_additional",
    website: "website",
    rating: 4.47,
    rating_top: 100,
    ratings: %{},
    ratings_count: 5000,
    reactions: %{},
    added: 3,
    added_by_status: %{},
    metacritic: 70,
    metacritic_platforms: [],
    playtime: 8,
    screenshots_count: 100,
    movies_count: 2,
    creators_count: 100,
    achievements_count: 45,
    parent_achievements_count: 50,
    suggestions_count: 15,
    reddit_url: "reddit_url",
    reddit_name: "reddit_name",
    reddit_description: "reddit_description",
    reddit_logo: "reddit_logo",
    reddit_count: 500,
    twitch_count: 150,
    youtube_count: 80,
    reviews_text_count: "reviews_text_count",
    alternative_names: [],
    metacritic_url: "metacritic_url",
    parents_count: 1,
    additions_count: 3,
    game_series_count: 5,
    platforms: []
  }
  @example_screenshot %{
    id: 1,
    image: "image",
    hidden: false,
    width: 1920,
    height: 1080
  }
  @example_store_link %{
    id: 1,
    game_id: 1,
    store_id: 1,
    url: "url"
  }
  @example_trailer %{
    id: 1,
    name: "name",
    preview: "preview",
    data: %{}
  }

  setup_all do
    RawgEx.start_link(name: @test_name)
    :ok
  end

  test "properly produces errors" do
    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        {:ok,
         %Finch.Response{
           body: nil,
           headers: [],
           status: 401
         }}
      end do
      assert {:error, :unauthorized} == RawgEx.get_creator_roles(@test_name)
    end
  end

  test "get creator roles" do
    creator_roles =
      [@example_position]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = creator_roles |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, creator_roles} == RawgEx.get_creator_roles(@test_name)
    end
  end

  test "get creators" do
    creators =
      [@example_creator]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = creators |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, creators} == RawgEx.get_creators(@test_name)
    end
  end

  test "get creator" do
    creator = @example_creator

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = creator |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, creator} == RawgEx.get_creator(@test_name, "1")
    end
  end

  test "get developers" do
    developers =
      [@example_developer]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = developers |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, developers} == RawgEx.get_developers(@test_name)
    end
  end

  test "get developer" do
    developer = @example_developer

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = developer |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, developer} == RawgEx.get_developer(@test_name, "1")
    end
  end

  test "get games" do
    games =
      [@example_game]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = games |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, games} == RawgEx.get_games(@test_name)
    end
  end

  test "get game additions" do
    game_additions =
      [@example_game]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = game_additions |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, game_additions} == RawgEx.get_game_additions(@test_name, "1")
    end
  end

  test "get game development team" do
    development_team =
      [@example_developer]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = development_team |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, development_team} == RawgEx.get_game_development_team(@test_name, "1")
    end
  end

  test "get game series games" do
    series_games =
      [@example_game]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = series_games |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, series_games} == RawgEx.get_game_series_games(@test_name, "1")
    end
  end

  test "get game parents" do
    parents =
      [@example_game]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = parents |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, parents} == RawgEx.get_game_parents(@test_name, "1")
    end
  end

  test "get game screenshots" do
    screenshots =
      [@example_screenshot]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = screenshots |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, screenshots} == RawgEx.get_game_screenshots(@test_name, "1")
    end
  end

  test "get game stores" do
    stores =
      [@example_store_link]
      |> page()

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = stores |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, stores} == RawgEx.get_game_stores(@test_name, "1")
    end
  end

  test "get game" do
    game = @example_game_details

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = game |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, game} == RawgEx.get_game(@test_name, "1")
    end
  end

  test "get game achievements" do
    achievements = [@example_achievement]

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = achievements |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, achievements} == RawgEx.get_game_achievements(@test_name, "1")
    end
  end

  test "get game trailers" do
    trailers = [@example_trailer]

    with_mock Finch, [:passthrough],
      request: fn _request, _name ->
        body = trailers |> Jason.encode!()

        {:ok,
         %Finch.Response{
           body: body,
           headers: [],
           status: 200
         }}
      end do
      assert {:ok, trailers} == RawgEx.get_game_trailers(@test_name, "1")
    end
  end

  # -------------------------------------------------------------------------------
  # Private functions
  # -------------------------------------------------------------------------------
  defp page(elements),
    do: %{count: Enum.count(elements), results: elements, next: nil, previous: nil}
end
