require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class VerticaHistory < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option(:member) { true }
        register_instance_option(:pjax) { false }

        register_instance_option :controller do
          Proc.new do
            redirect_to "/admin/vertica_history/#{params['model_name'].underscore.downcase.to_param}/#{params['id']}"
          end
        end

        register_instance_option :link_icon do
          'icon-time'
        end
      end
    end
  end
end