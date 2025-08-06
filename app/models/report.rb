# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentions, class_name: 'Mention', foreign_key: 'mentioning_id', dependent: :destroy, inverse_of: :mentioning
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned
  has_many :passive_mentions, class_name: 'Mention', foreign_key: 'mentioned_id', dependent: :destroy, inverse_of: :mentioned
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  after_save :update_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def update_mentions
    active_mentions.destroy_all
    report_ids = content.scan(%r{http://127\.0\.0\.1:3000/reports/(\d+)}).flatten.map(&:to_i).uniq

    Report.where(id: report_ids).where.not(id:).find_each do |report|
      active_mentions.create!(mentioned_id: report.id)
    end
  end
end
