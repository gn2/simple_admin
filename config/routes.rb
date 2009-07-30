ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.resources :settings
  end
  
  map.admin '/admin', :controller => 'admin/dashboard'
  map.admin_dashboard '/admin/dashboard', :controller => 'admin/dashboard'
end
