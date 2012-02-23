class FaradayBase
  @@conn = nil
  def initialize(url)
    @conn = Faraday.new(:url => url) do |builder|
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Response::Logger,   Rails.logger
      builder.use Faraday::Adapter::NetHttp
      builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      faraday_use(builder)
    end
  end
  #override this function for custom builders
  def faraday_use(builder)

  end

  def conn
    @conn
  end

  def self.conn(url)
    @@conn ||= self.new(url).conn
  end
end


