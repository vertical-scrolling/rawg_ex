defmodule RawgExTest do
  use ExUnit.Case
  import Mock
  doctest RawgEx

  @test_name :rawg_ex_test

  setup_all do
    RawgEx.start_link(name: @test_name)
    :ok
  end

  describe "creator roles" do
    test "correctly gets creator roles" do
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
  end

  describe "creators" do
    test "correctly gets creators" do
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
        assert {:error, :unauthorized} == RawgEx.get_creators(@test_name)
      end
    end
  end

  defp page(elements),
    do: %{count: Enum.count(elements), results: elements, next: nil, previous: nil}
end
