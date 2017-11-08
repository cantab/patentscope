require 'spec_helper'

module Patentscope

  describe WebserviceSoapBuilder, :core do

    before { Patentscope.configure_from_env}

    let(:ws_soap_builder) { WebserviceSoapBuilder.new }

    it "exists" do
      expect(ws_soap_builder).to_not be_nil
    end

    it "has the right methods" do
      expect(ws_soap_builder).to respond_to(:build_envelope)
    end

    describe "build_envelope method" do
      let(:envelope) { ws_soap_builder.build_envelope('foo', {bar: 'baz'}) }

      it "returns an XML document" do
        expect(envelope).to include('<?xml')
      end

      it "has an envelope element" do
        expect(envelope).to include('<S:Envelope')
      end

      it "has a namespace definition for the envelope" do
        expect(envelope).to include('xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"')
      end

      it "has a body element" do
        expect(envelope).to include('<S:Body>')
      end

      it "has an operation element" do
        expect(envelope).to include('<foo ')
      end

      it "has a namespace definition for the operation" do
        expect(envelope).to include('xmlns="http://www.wipo.org/wsdl/ps"')
      end

      it "has a option key element" do
        expect(envelope).to include('<bar>')
      end

      it "has an option value element" do
        expect(envelope).to include('baz')
      end

      describe "specific operations" do

        context "get_available_documents" do

          it 'generates an appropriate soap envelope' do
            envelope = ws_soap_builder.build_envelope(:getAvailableDocuments, { iaNumber: 'SG2009000062' })
            expect(envelope).to include('<?xml version="1.0"')
            expect(envelope).to include('<getAvailableDocuments ')
            expect(envelope).to include('<iaNumber>SG2009000062</iaNumber')
          end
        end

        context "get_document_content" do

          it 'generates an appropriate soap envelope' do
            envelope = ws_soap_builder.build_envelope(:getDocumentContent, { docId: 'id50000000125222' })
            expect(envelope).to include('<?xml version="1.0"')
            expect(envelope).to include('<getDocumentContent ')
            expect(envelope).to include('<docId>id50000000125222</docId>')
          end
        end

        context "get_document_ocr_content" do

          it 'generates an appropriate soap envelope' do
            envelope = ws_soap_builder.build_envelope(:getDocumentOcrContent, { docId: 'id50000000125222' })
            expect(envelope).to include('<?xml version="1.0"')
            expect(envelope).to include('<getDocumentOcrContent ')
            expect(envelope).to include('<docId>id50000000125222</docId>')
          end
        end

        context "get_iasr" do

          it 'generates an appropriate soap envelope' do
            envelope = ws_soap_builder.build_envelope(:getIASR, { iaNumber: 'SG2009000062' })
            expect(envelope).to include('<?xml version="1.0"')
            expect(envelope).to include('<getIASR ')
            expect(envelope).to include('<iaNumber>SG2009000062</iaNumber')
          end
        end

        context "get_document_table_of_contents" do

          it 'generates an appropriate soap envelope' do
            envelope = ws_soap_builder.build_envelope(:getDocumentTableOfContents, { docId: 'id50000000125222' })
            expect(envelope).to include('<?xml version="1.0"')
            expect(envelope).to include('<getDocumentTableOfContents ')
            expect(envelope).to include('<docId>id50000000125222</docId>')
          end
        end

        context "get_document_content_page" do

          it 'generates an appropriate soap envelope' do
            envelope = ws_soap_builder.build_envelope(:getDocumentContentPage, { docId: 'id50000000125222', pageId: '000031.tif' })
            expect(envelope).to include('<?xml version="1.0"')
            expect(envelope).to include('<getDocumentContentPage ')
            expect(envelope).to include('<docId>id50000000125222</docId>')
            expect(envelope).to include('<pageId>000031.tif</pageId>')
          end
        end
      end
    end
  end
end
