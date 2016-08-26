module VerticaHistory
  class VerticaHistoryController < ApplicationController
    # before_filter { |c| c.authorize_ability :can_edit }
    # before_filter :fetch_columns, only: [:index, :view_history]

    def index
      fetch_columns
    end

    def view_history
      fetch_columns
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

      schema = Rails.configuration.vertica_schema
      id = params['id']
      history = []

      if (@column_filter.nil? && @value_filter.nil?)
        @value_filter = [params['filter_column']]
        @column_filter = [params['filter_field']]
      else
        @column_filter += [params['filter_field']]
        @value_filter += [params['filter_column']]
      end

      order_by = params['order_by'] || 'vertica_updated_at'
      @columns = params['columns'] || params['attribute-keys'] || @all_columns
      table_name = params['class_name']


      connection = Vertica.connect(connection_configurations)
      @columns = @columns + ['vertica_updated_at'] unless @columns.include?('vertica_updated_at')

      if @columns == ["*", "vertica_updated_at"]
        unless (@column_filter.compact.empty? && @value_filter.compact.empty?)
          sub_query = ""

          @query_hash = Hash[@column_filter.zip(@value_filter)]
          @query_hash.delete_if { |key, value| value.to_s.strip == '' }
          @query_hash.each do |col, val|
            next if col.nil? || val.nil?
            sub_query = sub_query + "AND #{col}='#{val}' "
          end

          result = connection.query("SELECT * from #{schema}.#{table_name.pluralize} where id=#{id} #{sub_query} order by #{order_by};")
        else
          result = connection.query("SELECT * from #{schema}.#{table_name.pluralize} where id=#{id} order by #{order_by};")
        end
        @columns = ['vertica_updated_at'] + @model.columns.map { |c| c.name }

      elsif @columns.include?("*")
        unless (@column_filter.compact.empty? && @value_filter.compact.empty?)
          sub_query = ""

          @query_hash = Hash[@column_filter.zip(@value_filter)]
          @query_hash.delete_if { |key, value| value.to_s.strip == '' }

          @query_hash.each do |col, val|
            next if col.nil? || val.nil?
            sub_query = sub_query + "AND #{col}='#{val}' "
          end

          result = connection.query("SELECT * from #{schema}.#{table_name.pluralize} where id=#{id} #{sub_query} order by #{order_by};")
        else
          result = connection.query("SELECT * from #{schema}.#{table_name.pluralize} where id=#{id} order by #{order_by};")
        end
        @columns = ['vertica_updated_at'] + @model.columns.map { |c| c.name }


      else
        query_columns = ""
        @columns.each { |c| query_columns = query_columns + c + "," }
        query_columns = query_columns[0..-2]
        unless (@column_filter.compact.empty? && @value_filter.compact.empty?)
          sub_query = ""


          @query_hash = Hash[@column_filter.zip(@value_filter)]
          @query_hash.delete_if { |key, value| value.to_s.strip == '' }
          @query_hash.each do |col, val|
            next if col.nil? || val.nil?
            sub_query = sub_query + "AND #{col}='#{val}' "
          end

          result = connection.query("SELECT #{query_columns} from #{schema}.#{table_name.pluralize} where id=#{id} #{sub_query} order by #{order_by};")
        else
          result = connection.query("SELECT #{query_columns} from #{schema}.#{table_name.pluralize} where id=#{id} order by #{order_by};")
        end
      end

      @total_records = result.count

      result.each do |row|
        history << row
      end

      @history = Kaminari.paginate_array(history, total_count: history.count).page(params[:page]).per(20)
      connection.close

    rescue => e
      Rails.logger.info("Unable to submit query to Vertica: #{e}")
      flash[:error] = "Unable to submit query to Vertica: #{e.message}"
      redirect_to "/rails_admin/#{@model}/#{id}"
    end


    def make_query
      @other_schemas = Rails.configuration.other_vertica_schemas || nil
    end

    def query_results
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
      result = connection.query("#{params[:q]}")
      @q = params[:q]
      @columns = result.columns.map { |x| x.name }
      @rows = result.rows
      connection.close
    end

    def fetch_columns
      @id = params['id']
      @model ||= params['class_name'].camelize.constantize
      @columns = @model.columns.map { |c| c.name }
      @all_columns = @model.columns.map { |c| c.name }
    end
  end
end