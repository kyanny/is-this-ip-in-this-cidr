require 'sinatra'
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
    erb :index, locals: { ip: ip, cidr: cidr, result: result, error: error }
end
