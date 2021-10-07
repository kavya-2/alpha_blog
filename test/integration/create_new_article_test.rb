require "test_helper"
 
class CreateArticleTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: "sam", email: "sam@email.com", 
                              password: "password", admin: false)
    @category = Category.create(name: "Sports")
  end
 
  test "get new article form and create article" do
    sign_in_as(@user) 
    get "/articles/new"
    assert_response :success 
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "test title", description: "test description", category: "Sports" } }
      assert_response :redirect 
    end
    follow_redirect!
    assert_response :success
    assert_match "test title", response.body 
  end
 
  test "get new article form and reject invalid article submission" do
    sign_in_as(@user) 
    get "/articles/new"
    assert_response :success 
    assert_no_difference "Article.count" do
      post categories_path, params: { article: { title: " ", description: " ", category: " " } }
    end
    assert_match "redirected", response.body
  end
end