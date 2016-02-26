require 'minitest/autorun'
require 'nokogiri'
require 'cpr_client/record'

class RecordTest < Minitest::Test

  def setup
    @record = init_protected_record
  end

  def test_protected_address
    record = init_protected_record
    assert_equal '1', record[:beskyt]
    assert record.protected?
    assert_nil record.address
  end

  def test_birthday
    record = init_protected_record
    assert_equal Date.new(1961, 1, 7), record.birthday
  end

  def init_protected_record
    CPRClient::Record.new Nokogiri::XML <<-DATA
      <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
      <root xmlns="http://www.cpr.dk">
        <Gctp v="1.0" env="Demo">
          <System r="CprSoeg">
            <Service r="STAMP">
              <CprServiceHeader r="STAMP" ts="20160224235714648938"/>
              <CprData u="O">
                <Rolle r="HovedRolle">
                  <Praes r="STAMPNR">
                    <Field r="PNR" v="0701614011"/>
                    <Field r="I_VENT_MRK"/>
                    <Field r="ADRNVN"/>
                    <Field r="KOEN" v="M"/>
                    <Field r="STATUS" v="01"/>
                    <Field r="STARTDATOSTATUS"/>
                    <Field r="PNRGAELD"/>
                    <Field r="FOEDDATO" v="19610107"/>
                    <Field r="FOEDDATOUSM"/>
                    <Field r="BESKYT" v="1" t="Navne- og adresse beskyttelse" ts="Beskyt"/>
                    <Field r="CONVN"/>
                    <Field r="ETAGE"/>
                    <Field r="HUSNR"/>
                    <Field r="SIDEDOER"/>
                    <Field r="BNR"/>
                    <Field r="KOMKOD"/>
                    <Field r="VEJKOD"/>
                    <Field r="BYNVN"/>
                    <Field r="LOKALITET"/>
                    <Field r="POSTNR"/>
                    <Field r="UDR_LANDEKOD"/>
                    <Field r="UDLANDSADR1"/>
                    <Field r="UDLANDSADR2"/>
                    <Field r="UDLANDSADR3"/>
                    <Field r="UDLANDSADR4"/>
                    <Field r="UDLANDSADR5"/>
                    <Field r="STADR"/>
                  </Praes>
                </Rolle>
              </CprData>
              <Kvit r="Ok" t="" v="0"/>
            </Service>
          </System>
        </Gctp>
      </root>
    DATA
  end



end