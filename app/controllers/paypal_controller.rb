class PaypalController < ApplicationController

  def index
    # Creating Access Token for Sandbox
    client_id = "AVm16FFwezt03m7PB-a1Jav93krEpF4sGktXjPUiCgUAAqd52QmkPpvCwRjkbYfx1x6DfO7Yt0fOLLrW"
    client_secret = "EAQ5avARyptECHrH0MUz_zWCmTo51kntU4g97zaoprdn_pA_4PIShU2crl1miFDB6S72zollIVnpnbus"
    # Creating an environment
    environment = PayPal::SandboxEnvironment.new(client_id, client_secret)
    client = PayPal::PayPalHttpClient.new(environment)

    # Construct a request object and set desired parameters
    # Here, OrdersCreateRequest::new creates a POST request to /v2/checkout/orders
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
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

        # If call returns body in response, you can get the deserialized version from the result attribute of the response
        @order = response.result
        #puts order
    rescue PayPalHttp::HttpError => ioe
        # Something went wrong server-side
        puts ioe.status_code
        puts ioe.headers["debug_id"]
    end
  end

  def capture
    # Creating Access Token for Sandbox
    client_id = "AVm16FFwezt03m7PB-a1Jav93krEpF4sGktXjPUiCgUAAqd52QmkPpvCwRjkbYfx1x6DfO7Yt0fOLLrW"
    client_secret = "EAQ5avARyptECHrH0MUz_zWCmTo51kntU4g97zaoprdn_pA_4PIShU2crl1miFDB6S72zollIVnpnbus"
    # Creating an environment
    environment = PayPal::SandboxEnvironment.new(client_id, client_secret)
    client = PayPal::PayPalHttpClient.new(environment)
    # Here, OrdersCaptureRequest::new() creates a POST request to /v2/checkout/orders
    # order.id gives the orderId of the order created above
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new("1FS30591MM301181S")
    request.prefer("return=representation")

    begin
        # Call API with your client and get a response for your call
        response = client.execute(request)

        # If call returns body in response, you can get the deserialized version from the result attribute of the response
        @order = response.result
        puts @order
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
