defmodule Retrospectivex.Retrospectives.Schemas.Board do
  use Ecto.Schema

  import Ecto.Changeset

  alias Retrospectivex.Retrospectives.Schemas.Card

  schema "boards" do
    field(:description, :string)
    field(:slug, :string)
    field(:status, BoardStatusEnum)
    field(:title, :string)
    field(:uuid, :binary_id)

    timestamps()

    has_many(:what_went_well, Card, on_delete: :delete_all)
    has_many(:what_can_be_improved, Card, on_delete: :delete_all)
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
    |> generate_slug()
  end

  defp generate_slug(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{title: title}} ->
        slug =
          title
          |> String.downcase()
          |> String.replace(" ", "-")

        put_change(current_changeset, :slug, slug)

      _ ->
        current_changeset
    end
  end
end
