defmodule RawgEx do
  @moduledoc """
  Documentation for `RawgEx`.
  """

  # -------------------------------------------------------------------------------
  # Types
  # -------------------------------------------------------------------------------
  @type opt(t) :: nil | t

  @type position() :: %{id: integer(), name: String.t(), slug: String.t()}

  @type start_link_opts() :: [{:name, atom()}]
  @type get_creator_roles_opts() :: [{:page, non_neg_integer()}, {:page_size, non_neg_integer()}]

  # -------------------------------------------------------------------------------
  # External API
  # -------------------------------------------------------------------------------
  @spec start_link(opts :: start_link_opts()) :: Supervisor.on_start()
  def start_link(opts) do
    name = Keyword.get(opts, :name) || raise(ArgumentError, "must supply a name")
    Finch.start_link(name: name)
  end

  @spec get_creator_roles(opts :: get_creator_roles_opts()) :: %{
          count: integer(),
          next: opt(String.t()),
          previous: opt(String.t()),
          results: [position()]
        }
  def get_creator_roles(_opts), do: raise("not implemented")
end
