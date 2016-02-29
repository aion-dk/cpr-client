require 'cpr_client/client'
require 'cpr_client/record'
require 'cpr_client/errors'
require 'cpr_client/version'

module CPRClient

  ENDPOINT_DEMO = 'https://gctp-demo.cpr.dk/cpr-online-gctp/gctp'
  ENDPOINT_PROD = 'https://gctp.cpr.dk/cpr-online-gctp/gctp'

  # Returns a new Client.
  #
  # @param user your cpr username
  # @param pass your current cpr password
  # @param demo use demo endpoint
  def self.new(user, pass, demo = false)
    Client.new(user, pass, demo ? ENDPOINT_DEMO : ENDPOINT_PROD)
  end

end