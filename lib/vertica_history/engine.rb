module VerticaHistory
  class Engine < ::Rails::Engine
    isolate_namespace VerticaHistory

    config.autoload_paths << File.expand_path("/liib", __FILE__)
  end
end
