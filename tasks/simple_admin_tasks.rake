namespace :simple_admin do

  desc "Sync extra files from simple_admin plugin"
  task :sync do
    system "rsync -ruv vendor/plugins/simple_admin/public ."
  end
  
end