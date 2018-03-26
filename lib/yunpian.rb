require 'yunpian/version'
require 'yunpian/request'

module Yunpian
  SEND_GATEWAY    = 'http://yunpian.com/v1/sms/send.json'
  ACCOUNT_GATEWAY = 'http://yunpian.com/v1/user/get.json'
  SHORTEN_URL_GATEWAY = 'http://yunpian.com/v2/short_url/shorten.json'

  @timeout = 5

  class << self
    attr_accessor :apikey, :signature, :timeout

    def send_to(recipients, content, signature = nil)
      params = {
        apikey: Yunpian.apikey,
        mobile: Array(recipients).join(','),
        text:   "#{signature || Yunpian.signature}#{content}"
      }
      Request.new(SEND_GATEWAY, params).perform
    end

    def send_to!(recipients, content, signature = nil)
      params = {
        apikey: Yunpian.apikey,
        mobile: Array(recipients).join(','),
        text:   "#{signature || Yunpian.signature}#{content}"
      }
      Request.new(SEND_GATEWAY, params).perform!
    end

    def account_info
      Request.new(ACCOUNT_GATEWAY, apikey: Yunpian.apikey).perform
    end

    def shorten_url(url)
      Request.new(SHORTEN_URL_GATEWAY, long_url: url, apikey: Yunpian.apikey).perform
    end
  end

  class RequestException < StandardError; end
end
