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

  class NewPasswordError < ClientError

    attr_reader :code

    # Returns a new instance of NewPasswordError.
    #
    # @param code new password error code
    def initialize(code)
      @code = code
      super("CPRClient failed to update password [#{code}]")
    end

  end

end


# Possible error codes
#
# 900 Signon successful
# 901 Token kendes ikke
# 902 Bruger-id er ikke defineret i sikkerhedssystemet
# 903 Bruger-id er inaktivt i sikkerhedssystemet
# 904 Ugyldig Bruger-id indtastet
# 905 Ugyldig kodeord indtastet
# 906 Dit kodeord er udløbet
# 907 Begge kodeord skal være ens
# 908 Det nye kodeord er ikke gyldigt