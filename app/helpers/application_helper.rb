module ApplicationHelper
  def display_month_with_increment(inc=nil)
    month = sanitize_month(inc)
    Date::MONTHNAMES[month]
  end

  def sanitize_month(inc=nil)
    month = Date.current.month
    if inc.present?
      month += inc
      month = (month+1)%13 if month > 12
    end
    month
  end
end
