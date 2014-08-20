module Dropbox
  class DropboxClient
    def metadata(path, file_limit=25000, list=true, hash=nil, rev=nil, include_deleted=false)
      binding.pry
      params = {
        "file_limit" => file_limit.to_s,
        "list" => list.to_s,
        "include_deleted" => include_deleted.to_s,
        "hash" => hash,
        "rev" => rev,
        "include_media_info" => true
      }

      response = @session.do_get "/metadata/#{@root}#{format_path(path)}", params
      if response.kind_of? Net::HTTPRedirection
        raise DropboxNotModified.new("metadata not modified")
      end
      Dropbox::parse_response(response)
    end
  end

end
