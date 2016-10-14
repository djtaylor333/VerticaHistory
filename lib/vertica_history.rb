require "vertica_history/engine"
require 'rails_admin/config/actions/vertica_history'

module VerticaHistory
  PROJECT_CONFIG = File.join(__dir__, '..', 'config')

  class Interface
    def self.make_query(query)
      connection_configurations = {
          host: Rails.configuration.vertica_host,
          user: Rails.configuration.vertica_user,
          password: Rails.configuration.vertica_password,
          ssl: Rails.configuration.vertica_ssl || true,
          port: Rails.configuration.vertica_port || 5433,
          database: Rails.configuration.vertica_database,
          role: Rails.configuration.vertica_role,
          search_path: Rails.configuration.vertica_search_path || nil,
          row_style: Rails.configuration.vertica_row_style || :hash
      }

      connection = Vertica.connect(connection_configurations)
      result = connection.query("#{query}")
      @q = query
      @columns = result.columns.map { |x| x.name }
      @rows = result.rows
      connection.close
      {columns: @columns, rows: @rows}
    end
  end
end

