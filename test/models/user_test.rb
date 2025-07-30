# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '表示名' do
    user = User.new(email: 'bob@example.com', name: '')
    assert_equal 'bob@example.com', user.name_or_email

    user.name = 'ボブ'
    assert_equal 'ボブ', user.name_or_email
  end
end
