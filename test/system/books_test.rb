# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @book = books(:cherry_book)
    sign_in users(:alice)
  end

  test '本一覧ページにアクセスする' do
    visit books_url
    assert_selector 'h1', text: '本の一覧'
  end

  test 'should create book' do
    visit books_url
    click_on 'New book'

    fill_in 'Memo', with: @book.memo
    fill_in 'Title', with: @book.title
    click_on 'Create Book'

    assert_text 'Book was successfully created'
    click_on 'Back'
  end

  test 'should update Book' do
    visit book_url(@book)
    click_on 'Edit this book', match: :first

    fill_in 'Memo', with: @book.memo
    fill_in 'Title', with: @book.title
    click_on 'Update Book'

    assert_text 'Book was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Book' do
    visit book_url(@book)
    click_on 'Destroy this book', match: :first

    assert_text 'Book was successfully destroyed'
  end
end
