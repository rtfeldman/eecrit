defmodule Eecrit.OldAnimalController do
  use Eecrit.Web, :controller

  import Ecto.Query
  alias Eecrit.OldAnimal

  def index(conn, _params) do
    animals = OldRepo.all(from a in OldAnimal, where: is_nil(a.date_removed_from_service))
    render(conn, "index.html", animals: animals)
  end

  def new(conn, _params) do
    changeset = OldAnimal.changeset(%OldAnimal{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"old_animal" => old_animal_params}) do
    changeset = OldAnimal.changeset(%OldAnimal{}, old_animal_params)

    case OldRepo.insert(changeset) do
      {:ok, _old_animal} ->
        conn
        |> put_flash(:info, "Old animal created successfully.")
        |> redirect(to: old_animal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    old_animal = OldRepo.get!(OldAnimal, id)
    render(conn, "show.html", old_animal: old_animal)
  end

  def edit(conn, %{"id" => id}) do
    old_animal = OldRepo.get!(OldAnimal, id)
    changeset = OldAnimal.changeset(old_animal)
    render(conn, "edit.html", old_animal: old_animal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "old_animal" => old_animal_params}) do
    old_animal = OldRepo.get!(OldAnimal, id)
    changeset = OldAnimal.changeset(old_animal, old_animal_params)

    case OldRepo.update(changeset) do
      {:ok, old_animal} ->
        conn
        |> put_flash(:info, "Old animal updated successfully.")
        |> redirect(to: old_animal_path(conn, :show, old_animal))
      {:error, changeset} ->
        render(conn, "edit.html", old_animal: old_animal, changeset: changeset)
    end
  end
end
