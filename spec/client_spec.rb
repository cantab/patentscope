require 'spec_helper'

module Patentscope

  describe Client, :core, :vcr do

    before { Patentscope.configure_from_env}

    let(:client) { Client.new(username: Patentscope.configuration.username, password: Patentscope.configuration.password) }

    it "exists" do
      expect(client).to_not be_nil
    end

    describe "methods" do

      it "has its own attribute reader methods" do
        expect(client).to respond_to(:username)
        expect(client).to respond_to(:password)
      end

      it "has other methods" do
        expect(client).to respond_to(:get_url)
        expect(client).to respond_to(:post_url)
      end
    end

    describe "attribute reader methods" do

      describe "username method" do
        it "returns the right username" do
          expect(client.username).to eq(Patentscope.configuration.username)
        end
      end

      describe "password method" do
        it "returns the right password" do
          expect(client.password).to eq(Patentscope.configuration.password)
        end
      end
    end

    describe "attribute writer methods" do

      it "is not possible to set username" do
        expect { client.username = 'foo' }.to raise_error(NoMethodError)
      end

      it "is not possible to set password" do
        expect { client.password = 'foo' }.to raise_error(NoMethodError)
      end
    end

    describe "get_url method" do
      it "fetches the Example.org website by GET" do
        site = client.get_url('https://www.google.com')
        expect(site).to include('<html')
      end

      it "fetches the Patentscope WSDL by GET" do
        site = client.get_url(Patentscope::Webservice::PATENTSCOPE_WEBSERVICE_LOCATION + '?wsdl')
        expect(site).to include('<?xml')
      end
    end

    describe "post_url method" do
      it "fetches a URL by POST" do
        soap_envelope_xml = '<?xml version="1.0"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><getIASR xmlns="http://www.wipo.org/wsdl/ps"><iaNumber>SG2009000062</iaNumber></getIASR></S:Body></S:Envelope>'
        site = client.post_url(Patentscope::Webservice::PATENTSCOPE_WEBSERVICE_LOCATION, 'text/xml', soap_envelope_xml)
        expect(site).to include('<getIASRResponse')
      end
    end
  end
end
