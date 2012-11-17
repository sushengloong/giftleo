module ApplicationHelper
  def display_month_with_increment(inc=nil)
    month = Date.current.month
    if inc.present?
      month += inc
      month = (month+1)%13 if month > 12
    end
    Date::MONTHNAMES[month]
  end
end
