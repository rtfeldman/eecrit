defmodule RoundingPegs.ExUnit.PhoenixView.AssertTest do
  use RoundingPegs.ExUnit.Case
  alias RoundingPegs.ExUnit.PhoenixView.Assert, as: S
  require Eecrit.Router.Helpers

  @model Eecrit.OldAnimal

  describe "allows_anchor!" do 
    test "the simple success case" do
      html = "<a class='irrelevant' href='/animals'>Animals</a>"
      assert S.allows_anchor!(html, :index, @model) =~ html
    end

    test "failure case: no anchor" do
      html = ""
      assert_exception [ExUnit.AssertionError, "No <a> matching /animals"],
        do: S.allows_anchor!(html, :index, @model)
    end

    test "failure case: anchor with bad string" do
      html = "<a class='irrelevant' href='/animals'>Animals</a>"
      assert_exception ["No :index <a> to /animals", ~r/Animals/],
        do: S.allows_anchor!(html, :index, @model, "Manimals")
    end

    test "success case for action, path, and string" do
      html = "<a class='irrelevant' href='/animals'>Animals</a>"
      assert S.allows_anchor!(html, :index, @model, "Animals") =~ html
    end

    test "note that the match must be exact" do
      html = "<a class='irrelevant' href='/animals'>Animals</a>"
      assert_exception ["No :index <a> to /animals", "Animals"],
        do: S.allows_anchor!(html, :index, @model, "Animal")
      html = "<a class='irrelevant' href='/animals'> Animals</a>"
      assert_exception ["No :index <a> to /animals", "Animals"],
        do: S.allows_anchor!(html, :index, @model, "Animals")
    end
  end

  describe "disallows_anchor!" do
    test "a simple success case: no anchor with that path" do
      html = "<a href='/NOT_animals'>Animals</a>"
      assert S.disallows_anchor!(html, :index, @model) =~ html
    end

    test "a simple success case: different path index" do
      html = "<a href='/animals/new'>Animals</a>"
      assert S.disallows_anchor!(html, :index, @model) =~ html
    end

    test "the failue case" do
      assert_exception "Disallowed :new <a> to /animals/new" do 
        html = "<a href='/animals/new'>Animals</a>"
        assert S.disallows_anchor!(html, :new, @model) =~ html
      end

      assert_exception "Disallowed :edit <a> to /animals/1/edit" do 
        html = "<a href='/animals/1/edit'>Animals</a>"
        assert S.disallows_anchor!(html, :edit, [@model, 1]) =~ html
      end
    end
  end

  describe "allows_form!" do
    test "the simple success case" do
      html = "<a class='irrelevant' href='/animals'>Animals</a>"
      assert S.allows_anchor!(html, :index, @model) =~ html
    end
  end



  test "querying a form for the rest verb - allowing standard kludge" do
    just_post = "<form accept-charset='UTF-8' action='/foo' method='post'>
                    stuff
                 </form>"
    assert S.true_rest_verb(just_post) == "post"
    
    has_fake = "<form action='/foo' method='post'>
                  <input name='_method' type='hidden' value='put'>
                  stuff
                </form>"
    assert S.true_rest_verb(has_fake) == "put"

    no_method = "<form action='/foo' method='post'>
                   <input name='fred' type='hidden' value='put'>
                     stuff
                 </form>"
    assert S.true_rest_verb(no_method) == "post"
  end

end
