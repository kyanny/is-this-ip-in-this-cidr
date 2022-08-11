require 'sinatra'
require 'sinatra/json'
require 'ipaddr'

helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end

    def message(ip, cidr, result)
        if result
            "✅ #{ip} is in #{cidr}."
        else
            "❌ #{ip} is not in #{cidr}."
        end
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
        message = message(ip, cidr, result)
        erb :index, locals: { ip: ip, cidr: cidr, message: message, error: error }
    when 'json'
        json result
    when /te?xt/
        content_type 'text/plain'
        message(ip, cidr, result)
    end
end
