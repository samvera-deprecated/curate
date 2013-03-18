class AddRailsBestPracticeRecommendations < ActiveRecord::Migration
  def change
    add_index :bookmarks, [:user_id,:user_type]
    add_index :notifications, [:sender_id,:sender_type]
    add_index :notifications, [:notified_object_id,:notified_object_type], name: :notifications_notified_object
    add_index :receipts, [:receiver_id,:receiver_type]
    add_index :searches, [:user_id,:user_type]
    add_index :trophies, [:user_id]
  end
end
