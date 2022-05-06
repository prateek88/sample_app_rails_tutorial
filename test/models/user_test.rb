require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be tool long" do
    @user.email = "a" * 244  + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid email" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email" do
    invalid_addresses = %w[user@example,com USER_at_foo.com A_US-ER@foo_bar.org
      first.last@foo. foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  # This test is not needed, as we are converting all emails to downcase before
  # saving
  # test "email addresses should be case insensitive" do
  #   user1 = User.new(name: "Example User", email: "USER@example.com")
  #   @user.save
  #   assert_not user1.valid?
  # end

  test "email should be saved in downcase" do
    mixed_case_email = "Foo@ExaMpLe.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be non blank" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password should be minimum 6 characters" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end
end
