module CPRClient

  class ClientError < StandardError; end

  class LoginError < ClientError

    attr_reader :code

    # Returns a new instance of LoginError.
    #
    # @param code login error code
    def initialize(code)
      @code = code
      super("CPRClient login failed [#{code}]")
    end

  end

end