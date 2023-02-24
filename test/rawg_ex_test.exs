defmodule RawgExTest do
  use ExUnit.Case
  import Mock
  doctest RawgEx

  @test_name :rawg_ex_test

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
    creator_roles = [%{id: 1, name: "test", slug: "test"}] |> page()

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
      [
        %{
          id: 1,
          name: "creator1",
          slug: "slug",
          image: "image",
          image_background: "image_background",
          games_count: 1
        }
      ]
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
    creator = %{
      id: 1,
      name: "creator1",
      slug: "slug",
      image: "image",
      image_background: "image_background",
      description: "description",
      games_count: 1,
      reviews_count: 1,
      rating: "5.6",
      rating_top: 3,
      updated: "updated"
    }

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
      [
        %{
          id: 1,
          name: "developer1",
          slug: "slug",
          image_background: "image_background",
          games_count: 1
        }
      ]
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
    developer = %{
      id: 1,
      name: "developer1",
      slug: "slug",
      image_background: "image_background",
      games_count: 1,
      description: "description"
    }

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
      [
        %{
          id: 1,
          slug: "slug",
          name: "name",
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
      ]
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
      [
        %{
          id: 1,
          slug: "slug",
          name: "name",
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
      ]
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

  defp page(elements),
    do: %{count: Enum.count(elements), results: elements, next: nil, previous: nil}
end
