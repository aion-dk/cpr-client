require 'httpclient'
require 'nokogiri'
require 'cpr_client/record'
require 'cpr_client/errors'

module CPRClient

  class Client

    # Returns a new Client.
    #
    # @param user your cpr username
    # @param pass your current cpr password
    # @param endpoint the full URI to the cpr gctp service
    def initialize(user, pass, endpoint)
      @user, @pass, @endpoint = user, pass, endpoint
      @http = HTTPClient.new(
          agent_name: 'CPRClient/0.1',
          default_header: { 'Content-Type' => 'text/xml' }
      )
    end

    # Returns a Record object or nil if the record could not be found.
    # If the client is not logged in, a login is performed before a retry.
    #
    # The cpr parameter is stripped of any non-digits.
    #
    # @param cpr a string
    # @return a #Record or nil if no record was found
    def lookup(cpr)
      xml_doc = post_auto_login(stamp_body(digits(cpr)))
      case receipt_code(xml_doc)
        when 0
          Record.new(xml_doc)
        when 172, 52
          nil
        else
          raise ClientError, "Unexpected STAMP resp: #{xml_doc}"
      end
    end

    alias_method :stamp, :lookup

    # Performs login for client.
    #
    # @return true
    # @raise LoginError if login failed
    def login
      code = receipt_code(post(login_body))
      code == 900 or raise LoginError, code
    end

    protected

    # Returns the gctp status code of the given xml_doc.
    #
    # If a receipt is not preset then -1 is returned.
    #
    # @param xml_doc a Nokogiri::XML object
    # @return a Fixnum gctp status code
    def receipt_code(xml_doc)
      node = xml_doc && xml_doc.at_css('Kvit')
      node && node['v'] ? node['v'].to_i : -1
    end

    # Removes all non digit characters from string
    def digits(arg)
      arg.to_s.gsub(/\D+/,'')
    end

    # Posts xml to the server.
    #
    # A login is performed if the client is not logged in,
    # or if the login is expired.
    #
    # @param body a string of xml
    # @return a Nokogiri::XML object
    # @raise ClientError if the response status was not 200
    # @raise LoginError if login failed
    def post_auto_login(body)
      xml_doc = post(body)
      xml_doc = login && post(body) if receipt_code(xml_doc) == 901
      xml_doc
    end

    # Posts a request to the service with xml as content type.
    #
    # @param body a string of xml
    # @return a Nokogiri::XML object
    # @raise ClientError if the response status was not 200
    def post(body)
      resp = @http.post(@endpoint, body)
      raise ClientError, 'Bad response' if resp.status != 200
      Nokogiri::XML(resp.body)
    end

    private

    def login_body
      <<-DATA
      <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
      <root xmlns="http://www.cpr.dk">
        <Gctp v=”1.0”>
          <Sik function="signon" userid="#{@user}"  password="#{@pass}"/>
        </Gctp>
      </root>
      DATA
    end

    def stamp_body(cpr)
      <<-DATA
      <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
      <root xmlns="http://www.cpr.dk">
        <Gctp v="1.0">
          <System r="CprSoeg">
            <Service r="STAMP">
              <CprServiceHeader r="STAMP">
                <Key>
                  <Field r="PNR" v="#{cpr}"/>
                </Key>
              </CprServiceHeader>
            </Service>
          </System>
        </Gctp>
      </root>
      DATA
    end

  end
end