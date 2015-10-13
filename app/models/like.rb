class Like < ActiveRecord::Base
  belongs_to :creative_activity, counter_cache: true
  belongs_to :user

  def self.toggle(user_id, creative_activity_id)
    fav = Like.where(user_id: user_id, creative_activity_id: creative_activity_id).take
    if fav.present?
      fav.destroy
      is_present = FALSE
    else
      fav = Like.new(user_id: user_id, creative_activity_id: creative_activity_id)
      is_present = TRUE
    end
    [fav.save, is_present]
  end


  def self.check(user_id, creative_activity_id)
    fav = Like.where(user_id: user_id, creative_activity_id: creative_activity_id).take
    fav.present?
  end

end
