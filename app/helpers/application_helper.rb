module ApplicationHelper

  # Set page title
  def page_title(page_title)
    content_for(:page_title) { page_title }
  end

  def nice_page_title(page_title)
    page_title.blank? ? 'Admin' : page_title.gsub(/<\/?[^>]*>/, "")
  end

  def breadcrumbs(request)
    path =  request.env['REQUEST_PATH'] || request.env["PATH_INFO"] || ""
    breadcrumbs_string = path.split('/').compact.each do |p|
      unless p.empty? || (p.to_i.to_s == p.strip) || (p.strip =~ /edit|new/)
        #TODO Create links instead
        "#{p.titlecase} >"
      end
    end
    "#{breadcrumbs_string} #{@controller.action_name.titlecase}"
  end

end
