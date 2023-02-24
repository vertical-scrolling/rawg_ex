defmodule RawgExTest do
  use ExUnit.Case
  import Mock
  doctest RawgEx

  @test_name :rawg_ex_test

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
  @example_screenshot %{
    id: 1,
    image: "image",
    hidden: false,
    width: 1920,
    height: 1080
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
      assert {:ok, screenshots} == RawgEx.get_game_parents(@test_name, "1")
    end
  end

  # -------------------------------------------------------------------------------
  # Private functions
  # -------------------------------------------------------------------------------
  defp page(elements),
    do: %{count: Enum.count(elements), results: elements, next: nil, previous: nil}
end
