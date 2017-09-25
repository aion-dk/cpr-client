module CPRClient
  class Record

    attr_reader :timestamp, :fields

    # Returns a new Response.
    #
    # @param xml_doc a Nokogiri::XML object
    def initialize(xml_doc)
      @timestamp = xml_doc.at_css("CprServiceHeader[r='STAMP']")['ts']
      @fields    = extract_fields(xml_doc)
    end

    # Gets the value of a field with the given name.
    #
    # @param name the name of the target field.
    # @param value the name of the value attribute
    def get(name, value = 'v')
      field = @fields[name.to_s.upcase]
      field[value.to_s.downcase] if field
    end

    alias_method :[], :get

    # Returns true if the person has name/address protection.
    #
    # @return true if protected, false otherwise
    def protected?
      get(:beskyt) == '1'
    end

    # Returns the birthday as Date.
    #
    # @return Date with date of birth
    def birthday
      Date.parse(get(:foeddato))
    end

    # Returns the record's address if present.
    #
    # The address will be a string of the fields
    # STADR, POSTNR and POSTNR's t attribute.
    #
    # Fx. Boulevarden 101, 1. mf, 6800 Varde
    #
    # @return string with address or nil
    def address
      street_and_number = "#{get(:vejkod, :t)} #{get_clean(:husnr)}"
      postal_district   = "#{get(:postnr)} #{get(:postnr, :t)}"
      door  = get_clean(:sidedoer)
      floor = get_clean(:etage)

      if floor and door
        "#{street_and_number}, #{floor}. #{door}, #{postal_district}"
      elsif floor
        "#{street_and_number}, #{floor}., #{postal_district}"
      else
        "#{street_and_number}, #{postal_district}"
      end
    end

    private

    def get_clean(name, value = 'v')
      value = get(name, value)
      value.sub(/^[ 0\-]*(.*?)\s*/, '\1') if value
    end

    def extract_fields(xml_doc)
      Hash[xml_doc.css("Praes[r='STAMPNR'] Field").reduce([]) { |a, f|
        attrs = Hash[f.keys.zip(f.values)]
        key = attrs.delete('r')
        attrs.empty? ? a : a << [key, attrs]
      }]
    end

  end
end