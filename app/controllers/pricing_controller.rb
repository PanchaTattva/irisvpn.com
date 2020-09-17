class PricingController < ApplicationController
  def index
    #block_cypher = BlockCypher::Api.new(currency: "doge")
    #render :json => block_cypher.address_generate

    qrcode = RQRCode::QRCode.new("qpt5mjldn2kzfdqg9r7sxqkv2f6u6ftu3sdznxjrep")

    @svg = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 5,
      standalone: true
    )
  end
end
