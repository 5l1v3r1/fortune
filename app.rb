module Fortune
  class App < Sinatra::Base
    register Sinatra::JstPages
    serve_jst '/jst.js'

    get '/' do
      'This is Fortune home page'
    end

    get '/currency-graph' do
      haml :'currency-graph'
    end
  end
end
