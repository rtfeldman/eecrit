defmodule Eecrit.OrganizationControllerTest do
  use Eecrit.ConnCase

  alias Eecrit.Organization
  @valid_attrs %{full_name: "some content", short_name: "sn"}
  @invalid_attrs %{}

  setup %{conn: conn} = config do
    if Map.has_key?(config, :accessed_by) do
      user = make_user(ability_group: make_ability_group(config.accessed_by))
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn}
    else
      {:ok, conn: conn}
    end
  end

  ### Authorization 

  @tag accessed_by: "admin"
  test "anyone less than superuser does not have access", %{conn: conn} do
    conn = get conn, organization_path(conn, :index)
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "that includes someone not logged in", %{conn: conn} do
    conn = get conn, organization_path(conn, :index)
    assert redirected_to(conn) == page_path(conn, :index)
  end

  # @tag accessed_by: "superuser"
  # test "anyone less than superuser does not have access", %{conn: conn} do
  #   conn = get conn, organization_path(conn, :index)
  #   assert redirected_to(conn) == page_path(conn, :index)
  # end


  #### 


  @tag :skip
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, organization_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing organizations"
  end

  @tag :skip
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, organization_path(conn, :new)
    assert html_response(conn, 200) =~ "New organization"
  end

  @tag :skip
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), organization: @valid_attrs
    assert redirected_to(conn) == organization_path(conn, :index)
    assert Repo.get_by(Organization, @valid_attrs)
  end

  @tag :skip
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), organization: @invalid_attrs
    assert html_response(conn, 200) =~ "New organization"
  end

  @tag :skip
  test "shows chosen resource", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = get conn, organization_path(conn, :show, organization)
    assert html_response(conn, 200) =~ "Show organization"
  end

  @tag :skip
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, organization_path(conn, :show, -1)
    end
  end

  @tag :skip
  test "renders form for editing chosen resource", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = get conn, organization_path(conn, :edit, organization)
    assert html_response(conn, 200) =~ "Edit organization"
  end

  @tag :skip
  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = put conn, organization_path(conn, :update, organization), organization: @valid_attrs
    assert redirected_to(conn) == organization_path(conn, :show, organization)
    assert Repo.get_by(Organization, @valid_attrs)
  end

  @tag :skip
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = put conn, organization_path(conn, :update, organization), organization: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit organization"
  end

  @tag :skip
  test "deletes chosen resource", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = delete conn, organization_path(conn, :delete, organization)
    assert redirected_to(conn) == organization_path(conn, :index)
    refute Repo.get(Organization, organization.id)
  end
end
