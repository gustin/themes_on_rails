module ThemesOnRails
  class Railtie < ::Rails::Railtie

    initializer "themes_on_rails.action_controller" do |app|
      ActiveSupport.on_load :action_controller do
        include ThemesOnRails::ControllerAdditions
      end
    end

    initializer "themes_on_rails.assets_path" do |app|
      Dir.glob("#{Rails.root}/app/themes/*/assets/*").each do |dir|
        app.config.assets.paths << dir
      end
    end

    if !Rails.env.development? && !Rails.env.test?
      initializer "themes_on_rails.precompile" do |app|
        app.config.assets.precompile += [ Proc.new { |path, fn| fn =~ /app\/themes/ && !%w(.js .css .css.scss).include?(File.extname(path)) } ]
        app.config.assets.precompile += Dir["app/themes/*"].map { |path| "#{path.split('/').last}/all.js" }
        app.config.assets.precompile += Dir["app/themes/*"].map { |path| "#{path.split('/').last}/all.css.scss" }
      end
    end

  end
end
