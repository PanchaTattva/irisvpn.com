class PaypalController < ApplicationController
  def index
  end
  
  #let paypal know to create invoice
  def create_order 
    # Creating Access Token for Sandbox
    client_id =  Rails.application.credentials.paypal_client
    client_secret =  Rails.application.credentials.paypal_secret

    # Creating an environment
    environment = PayPal::SandboxEnvironment.new(client_id, client_secret)
    client = PayPal::PayPalHttpClient.new(environment)

    # Construct a request object and set desired parameters
    # Here, OrdersCreateRequest::new creates a POST request to /v2/checkout/orders
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
    request.prefer("return=representation")
    request.request_body({
                            intent: "CAPTURE",
                            purchase_units: [
                                {
                                    amount: {
                                        currency_code: "USD",
                                        value: "00.01"
                                    }
                                }
                            ]
                          })

    begin
        # Call API with your client and get a response for your call
        response = client.execute(request)

        @order = helpers.openstruct_to_hash(response)

        #@order = response
        #puts @order
        puts @order.to_json 
        render :json => @order
        @order_id = JSON.parse @order.to_json
        puts @order_id["result"]["id"]
        #return @order
    rescue PayPalHttp::HttpError => ioe
        # Something went wrong server-side
        puts ioe.status_code
        puts ioe.headers["debug_id"]
    end
  end

  #verify user has paid/transaction completed 
  def capture

    data = JSON.parse request.raw_post
    puts data 
    # Creating Access Token for Sandbox
    client_id =  Rails.application.credentials.paypal_client
    client_secret =  Rails.application.credentials.paypal_secret
    # Creating an environment
    environment = PayPal::SandboxEnvironment.new(client_id, client_secret)
    client = PayPal::PayPalHttpClient.new(environment)
    # Here, OrdersCaptureRequest::new() creates a POST request to /v2/checkout/orders
    # order.id gives the orderId of the order created above
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new(data["orderID"])
    request.prefer("return=representation")

    begin
        # Call API with your client and get a response for your call
        response = client.execute(request)

        # If call returns body in response, you can get the deserialized version from the result attribute of the response
        @order = response.result

        @order = helpers.openstruct_to_hash(response)

        #@order = response
        #puts @order
        puts @order.to_json 
        render :json => @order

        #puts @order
        puts "Status Code: " + response.status_code.to_s
        puts "Status: " + response.result.status
        puts "Order ID: " + response.result.id
        puts "Intent: " + response.result.intent
        puts "Links:"
    rescue PayPalHttp::HttpError => ioe
        # Something went wrong server-side
        puts ioe.status_code
        puts ioe.headers["debug_id"]
    end
  end
end
