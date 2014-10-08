module Fortune
  class Api < Sinatra::Base
    get '/daily_rates/:symbol' do
      Fortune::DailyRate.asc(:date).where(currency: params[:symbol].upcase).to_json
    end

    get '/currencies' do
      Fortune::Currency.all.asc(:name).to_json
    end
  end
end
