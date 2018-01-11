module ApplicationHelper

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end  

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "active-column" : nil
    direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    title = raw("<span class='caret #{direction}'></span> #{title}")
    link_to title, params.merge({:sort => column, :direction => direction}), { class: css_class }
  end

end
