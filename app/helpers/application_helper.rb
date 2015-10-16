module ApplicationHelper
  def is_apply_event(user_id,event_id)
    if TeamUserShip.is_join(user_id,event_id)
      TRUE
    else
      FALSE
    end
  end
end
