# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @bob = users(:bob)
    @carol = users(:carol)
    @dave = users(:dave)
    @ellen = users(:ellen)

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

  test 'レポートURLを含む内容でメンションが作成される' do
    # メンションされる側の日報
    report1 = Report.create!(
      user: @bob,
      title: 'Rubyについて',
      content: 'Rubyまとめチートシート・・・'
    )

    # メンションする側の日報
    report2 = Report.create!(
      user: @alice,
      title: 'Rubyについて学習した',
      content: "参考にした日報はこちら\nhttp://localhost:3000/reports/#{report1.id}"
    )

    # メンション確認
    assert_equal 1, report2.mentioning_reports.count
    assert_includes report2.mentioning_reports, report1
  end

  test '複数のメンションが作成される' do
    report1 = Report.create!(
      user: @carol,
      title: '課題終わった',
      content: "課題が一つ終わりました\n参考にした日報はこちらです\nhttp://localhost:3000/reports/#{@alice_report.id}\nhttp://localhost:3000/reports/#{@bob_report.id}"
    )

    report2 = Report.create!(
      user: @dave,
      title: '参考になった日報',
      content: "参考：\nhttp://localhost:3000/reports/#{@alice_report.id}"
    )

    # それぞれのメンション数を確認
    assert_equal 2, @alice_report.mentioned_reports.count
    assert_equal 1, @bob_report.mentioned_reports.count

    # report1のメンション確認
    assert_includes report1.mentioning_reports, @alice_report
    assert_includes report1.mentioning_reports, @bob_report

    # report2のメンション確認
    assert_includes report2.mentioning_reports, @alice_report
    # bobの日報はreport2ではメンションされていない
    assert_not_includes report2.mentioning_reports, @bob_report
  end

  test 'メンションは非伝播性である' do
    report1 = Report.create!(
      user: @carol,
      title: '課題終わった',
      content: "課題が一つ終わりました\n参考にした日報はこちらです\nhttp://localhost:3000/reports/#{@alice_report.id}\nhttp://localhost:3000/reports/#{@bob_report.id}"
    )
    report2 = Report.create!(
      user: @dave,
      title: '参考になった日報',
      content: "参考：\nhttp://localhost:3000/reports/#{report1.id}"
    )
    # 親日報がメンションされても、子日報のメンションはカウントされない
    assert_equal 1, @alice_report.mentioned_reports.count
    assert_not_equal 2, @alice_report.mentioned_reports.count
    assert_equal 1, report1.mentioned_reports.count

    # 親日報をメンションしたときに子日報の内容は含まれない
    assert_includes report2.mentioning_reports, report1
    assert_not_includes report2.mentioning_reports, @alice_report
  end
end
