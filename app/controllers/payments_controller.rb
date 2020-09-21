class PaymentsController < ApplicationController
   
  #creating new wallet for each user and storing it.
  def create_crypto_wallets

    if !Payment.find_by(user_id: current_user.id)

      currency = ["btc", "ltc", "doge", "eth"]
      wallets = []

      currency.map do |i|
        block_cypher = BlockCypher::Api.new(currency: i)
        address = block_cypher.address_generate
       #wallets.push(
       #  currency: i, 
       #  wallet: address
       #  )
        db_entry = Payment.new 
        db_entry.user_id = current_user.id
        db_entry.currency = i
        db_entry.wallet_addr = address["address"]
        db_entry.wallet_priv = address["private"]
        db_entry.wallet_pub = address["public"]
        db_entry.wallet_wif = address["wif"]
        db_entry.save 
      end
    end
  end
  
  #get users public wallet address and create qr code.
  #users is currently calling this endpoint from javascript.
  #using this gem https://github.com/whomwah/rqrcode
  def create_crypto_qrcodes
    
    wallet_addr = Payment.where(user_id: current_user.id, 
                        currency: params["currency"])
                        .pluck(:wallet_addr)
  

    qrcode = RQRCode::QRCode.new("#{wallet_addr}")

    @svg = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 5,
      standalone: true
    )
      

    render :inline => @svg

  end

  #get current price from public api of luno exchange.
  #users is currently calling this endpoint from javascript.
  #using luno gem
  def crypto_price
    eth = BitX.ticker('ETHZAR')
    render :inline => (1/eth[:ask]*149).round(7)
  end
end
