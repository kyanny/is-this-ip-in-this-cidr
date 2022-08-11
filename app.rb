require 'sinatra'
require 'sinatra/json'
require 'ipaddr'

helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
end

get '/' do
    ip = params['ip'] || '192.168.0.1'
    cidr = params['cidr'] || '192.168.0.0/24'
    begin
        result = IPAddr.new(cidr).include?(IPAddr.new(ip))
    rescue IPAddr::InvalidAddressError => error
        p error.inspect
    end

    format = params['format'] || 'html'
    case format
    when 'html'
        erb :index, locals: { ip: ip, cidr: cidr, result: result, error: error }
    when 'json'
        json result
    when /te?xt/
        content_type 'text/plain'
        result ? "✅ #{ip} is in #{cidr}." : "❌ #{ip} is not in #{cidr}."
    end
end
