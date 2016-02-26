module CPRClient
  class Record

    attr_reader :xml_doc

    # Returns a new Response.
    #
    # @param xml_doc a Nokogiri::XML object
    def initialize(xml_doc)
      @xml_doc = xml_doc
    end

    # Gets the value of a field with the given name.
    #
    # @param name the name of the target field.
    # @param value the name of the value attribute
    def get(name, value = 'v')
      field = xml_doc.at_css("Praes[r='STAMPNR'] Field[r='#{name.to_s.upcase}']")
      field && field[value.to_s.downcase]
    end

    alias_method :[], :get

    # Returns true if the person has name/address protection.
    #
    # @return true if protected, false otherwise
    def protected?
      get('BESKYT') == '1'
    end

    # Returns the birthday as Date.
    #
    # @return Date with date of birth
    def birthday
      Date.parse(get('FOEDDATO'))
    end

    # Returns a Hash with all values of all fields.
    #
    # The default value attribute is stored with field name as key.
    # If any other attribute is found, it will have a key name of
    # #{field_name}_#{attribute_name}.
    #
    # @return a Hash with string values
    def values
      fields = {}
      xml_doc.css("Praes[r='STAMPNR'] Field").each do |field|
        attrs = Hash[field.keys.zip(field.values)]
        key = attrs.delete('r')
        fields[key] = attrs.delete('v')
        attrs.each do |name, value|
          fields["#{key}_#{name}"] = value
        end
      end
      fields
    end

  end
end