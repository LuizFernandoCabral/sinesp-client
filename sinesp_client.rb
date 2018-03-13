require 'nokogiri'
require 'openssl'
require 'httparty'

class SinespClient
  include HTTParty

  URL = 'cidadao.sinesp.gov.br'
  SECRET = '#8.1.0#Mw6HqdLgQsX41xAGZgsF'

  def initialize(proxy_address=nil, proxy_port=nil)
    # TODO use A Proxy if provided
    # # SINESP only accepts national web requests. If you don't have a valid
    # # Brazilian IP address you could use a web proxy (SOCKS5).
    # @proxies = nil
    # if proxy_address && proxy_port
    #   @proxies = {"https": "https://#{proxy_address}:#{proxy_port}"}
    # end

    # Read and store XML template for our HTTP request body.
    body_file = File.open('body.xml')
    @body_template = Nokogiri::XML(body_file.read())
    body_file.close()
  end

  def search(plate)
    # Searchs for vehicle plate.
    # If a vehicle with the specified plate was found, the server returns the
    # followign information which we'll repass in a dictionary format:
    # - return_code
    # - return_message
    # - status_code
    # - status_message
    # - chassis
    # - model
    # - brand
    # - color
    # - year
    # - model_year
    # - plate
    # - date
    # - city
    # - state
    response = self.request(plate)
    # if not response:
    #   return dict()

    self.parse(response)
  end

  def request(plate)
    # Performs an HTTP request with a given content.
    url = 'https://cidadao.sinesp.gov.br/sinesp-cidadao/mobile/consultar-placa/v3'
    data = self.body(plate).to_s
    # p data['g']
    cookies = self.captcha_cookie
    headers = {
      'Accept' => 'text/plain, */*; q=0.01',
      'Cache-Control' => 'no-cache',
      'Content-Length' => '661',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'Host' => 'sinespcidadao.sinesp.gov.br',
      'User-Agent' => 'SinespCidadao / 3.0.2.1 CFNetwork / 758.2.8 Darwin / 15.0.0',
      'Connection' => 'close'
    }
    return HTTParty.post(url, {
        body: data,
        headers: headers,
        cookies: cookies,
        verify: false
      })
    data
  end

  def body(plate)
    # Populate XML request body with specific data.
    xml = @body_template.dup

    xml.xpath("//g")[0].content = self.token(plate)
    xml.xpath("//i")[0].content = self.rand_latitude
    xml.xpath("//h")[0].content = self.rand_longitude
    xml.xpath("//l")[0].content = self.date
    xml.xpath("//a")[0].content = plate

    xml
  end

  def token(plate)
    # Generates SHA1 token as HEX based on specified and secret key.
    plate_and_secret = "#{plate}#{SECRET}"
    # plate_and_secret = bytes(plate_and_secret.encode!(Encoding::UTF_8))
    plate_and_secret = plate_and_secret.encode!(Encoding::UTF_8)
    plate = plate.encode!(Encoding::UTF_8)

    digest = OpenSSL::Digest.new('sha1')
    OpenSSL::HMAC.hexdigest(digest, plate_and_secret, plate)
  end

  def rand_latitude
    # Generates random latitude.
    sprintf('%.7f', self.rand_coordinate - 38.5290245 )
  end

  def rand_longitude
    # Generates random longitude.
    sprintf('%.7f', self.rand_coordinate - 3.7506985 )
  end

  def rand_coordinate(radius=2000)
    # Generates random seed for latitude and longitude coordinates.
    seed = radius/111000.0 * Math.sqrt(Random.new.rand)
    seed * Math.sin(2 * 3.141592654 * Random.new.rand)
  end

  def date
    # Returns the current date formatted as yyyy-MM-dd HH:mm:ss
    Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end

  def captcha_cookie
    # Performs a captcha request and return the cookie.
    cookies_request = HTTParty.get('https://sinespcidadao.sinesp.gov.br/sinesp-cidadao/captchaMobile.png', :verify => false)
    cookies_str = cookies_request.headers['set-cookie']
    cookies_hsh = Hash[cookies_str.split(';').map {|elem| elem.split '='}]

    { 'JSESSIONID' => cookies_hsh['JSESSIONID'] }
  end


  def parse(response)
    # Parses result from HTTP response.
    {
      'data'=> response.dig("Envelope", "Body", "getStatusResponse", "return"),
      'plain_response' => response
    }
  end

end
