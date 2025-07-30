# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @bob = users(:bob)
    @alice_report = reports(:alice_report)
    @bob_report = reports(:bob_report)
  end

  test '日報の編集は作成者のみ可能' do
    # aliceの日報の編集機能について
    assert @alice_report.editable?(@alice)
    assert_not @alice_report.editable?(@bob)

    # bobの日報の編集機能について
    assert @bob_report.editable?(@bob)
    assert_not @bob_report.editable?(@alice)
  end

  test 'created_onで作成日を取得できる' do
    expected_date = @alice_report.created_at.to_date
    assert_equal expected_date, @alice_report.created_on

    # 特定の日時の場合
    travel_to Time.zone.parse('1995-12-21 12:00:00') do
      report = Report.create!(
        user: @alice,
        title: 'Rubyに初めて触った日',
        content: 'これからが楽しみ'
      )

      assert_equal Date.new(1995, 12, 21), report.created_on
      assert_instance_of Date, report.created_on
    end
  end
end
