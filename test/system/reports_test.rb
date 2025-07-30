# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:alice_report)
    sign_in users(:alice)
  end

  test '日報一覧ページにアクセスする' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on 'New report'

    fill_in 'Content', with: @report.content
    fill_in 'Title', with: @report.title
    fill_in 'User', with: @report.user_id
    click_on 'Create Report'

    assert_text 'Report was successfully created'
    click_on 'Back'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'Edit this report', match: :first

    fill_in 'Content', with: @report.content
    fill_in 'Title', with: @report.title
    fill_in 'User', with: @report.user_id
    click_on 'Update Report'

    assert_text 'Report was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'Destroy this report', match: :first

    assert_text 'Report was successfully destroyed'
  end
end
