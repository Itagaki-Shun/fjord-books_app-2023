# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :icon
  validate :icon_type

  private

  def icon_type
    return unless icon.attached?
    return if icon.content_type.in?(%w[image/jpg image/jpeg image/png image/gif])

    errors.add(:icon, 'はjpg、png、gif形式のみ対応しています')
  end
end
