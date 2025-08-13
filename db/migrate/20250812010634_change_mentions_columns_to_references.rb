class ChangeMentionsColumnsToReferences < ActiveRecord::Migration[7.0]
  def change
    remove_column :mentions, :mentioning_id, :integer
    remove_column :mentions, :mentioned_id, :integer

    add_reference :mentions, :mentioning, null: false, foreign_key: { to_table: :reports }
    add_reference :mentions, :mentioned, null: false, foreign_key: { to_table: :reports }

    add_index :mentions, %i[mentioning_id mentioned_id], unique: true
  end
end
