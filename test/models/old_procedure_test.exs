defmodule Eecrit.OldProcedureTest do
  use Eecrit.ModelCase
  alias Eecrit.OldProcedure

  @valid_attrs %{days_delay: 42, name: "procedure name"}
  @invalid_attrs %{}

  test "a starting changeset" do
    changeset = OldProcedure.new_action_changeset()
    refute changeset.valid?
  end

  # Creation

  test "changeset with all required attributes" do
    changeset = OldProcedure.create_action_changeset(@valid_attrs)
    assert changeset.valid?
    assert changeset.changes == @valid_attrs
  end

  test "an invalid changeset" do
    changeset = OldProcedure.create_action_changeset(@invalid_attrs)
    refute changeset.valid?
  end

  ### Utilities

  test "sorting a list of procedures in a pleasing way" do
    procedures = [make_old_procedure(name: "AM"),
                  make_old_procedure(name: "aa"),
                  make_old_procedure(name: "K"),
                  make_old_procedure(name: "m"),
                  make_old_procedure(name: "1")]
    assert OldProcedure.alphabetical_names(procedures) == ["1", "aa", "AM", "K", "m"]
  end
  
end
