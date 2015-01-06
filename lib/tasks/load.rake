namespace :load do
  task :latest do
    rates = api.latest["rates"]
    rates.each { |currency, price| Fortune::DailyRate.load_today(currency, price) }
    rates.each { |currency, price| Fortune::HourlyRate.load(currency, price) }
  end

  task :currencies do
    currencies = api.currencies
    currencies.each { |symbol, name| Fortune::Currency.load(name, symbol) }
  end

  task :history do
    start_date = Date.strptime(ask("Start? (YYYY-mm-dd)"), "%Y-%m-%d")
    num_days   = ask("# of days? ").to_i
    dates      = start_date..(start_date + (num_days-1).days)

    dates.each do |date|
      rates = api.historical(date)["rates"]
      rates.each { |currency, price| Fortune::DailyRate.load(currency, price, date) }
    end
  end

  task :investment do
    capital  = ask("Capital (3000 for $3000)? ")
    currency = ask("Currency (EUR)? ")
    price    = ask("Buy in price? The actual converted price from the bank. (0.8 for $0.8)? ")
    date     = ask("Buy in date? (2014-10-14) ")

    Fortune::Investment.load(capital, currency, price, Date.parse(date))
  end

  task :bank_rate do
    base = ask("Base Currency (USD)? ")
    to   = ask("To Currency (BRL)? ")
    fee  = ask("Conversion fee (0.08 for 8%)? ")

    Fortune::BankRate.load(base, to, fee)
  end

  task :interest do
    id       = ask("Investment ID (i.e. 4d3ed089fb60ab534684b7e9)? ")
    rate     = ask("Interest (0.08 for 8%)? ")
    maturity = ask("Maturity Length (12 for 12 months)? ")
    start    = ask("Start Date (2014-10-14)? ")

    Fortune::BankInterest.load(id, rate, maturity, start)
  end
end
