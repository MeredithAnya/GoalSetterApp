module ApplicationHelper
  def auth_token
    html = <<-meredith
      <input type="hidden" name="authenticity_token" value="#{form_authenticity_token}">
    meredith
    html.html_safe
  end
end
