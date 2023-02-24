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
      creator_roles = %{
        count: 1,
        next: nil,
        previous: nil,
        results: [%{id: 1, name: "test", slug: "test"}]
      }

      with_mock Finch, [:passthrough],
        request: fn _request, _name ->
          body = Jason.encode!(creator_roles)

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
end
