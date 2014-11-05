module Sinatra
  module LinkHelper

    def link_to(url_or_record, body, css_class=nil)
      return "<a class=#{css_class}, href='#{url_or_record}'>#{body}</a>" if url_or_record.is_a? String
      link_to(record_path(url_or_record), body, css_class)
    end

    def record_path(record)
      table_name = record.class.table_name
      record_id = record.id
      "/#{table_name}/#{record_id}"
    end

    def new_resource_path(resource)
      "/#{pluralize(resource)}/new"
    end

    def resource_index_path(resource)
      "/#{pluralize(resource)}"
    end

    def constant_defined?(resource)
      resource = singularize(resource).capitalize
      Module.const_defined?(resource)
    end

  end
  helpers LinkHelper
end