# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'レポート編集は作成者のみ可能' do
    alice = users(:alice)
    bob = users(:bob)

    # aliceの日報の編集機能について
    alice_report = reports(:alice_report)
    assert alice_report.editable?(alice)
    refute alice_report.editable?(bob)

    # bobの日報の編集機能について
    bob_report = reports(:bob_report)
    assert bob_report.editable?(bob)
    refute bob_report.editable?(alice)
  end
end
