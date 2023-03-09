# frozen_string_literal: true

class CompletionCallback
  attr_accessor :url, :version, :skip_server_certificate_validation

  def initialize(url, version = nil, skip_server_certificate_validation = false)
    @url = url
    @version = version
    @skip_server_certificate_validation = skip_server_certificate_validation
  end
end
