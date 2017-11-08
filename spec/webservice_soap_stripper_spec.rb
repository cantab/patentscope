require 'spec_helper'

module Patentscope

  describe WebserviceSoapStripper, :core do

    before { Patentscope.configure_from_env}

    let(:ws_soap_stripper) { WebserviceSoapStripper.new }

    it "exists" do
      expect(ws_soap_stripper).to_not be_nil
    end

    it "has the right methods" do
      expect(ws_soap_stripper).to respond_to(:strip_envelope)
    end

    describe "strip_envelope method" do

      context "getAvailableDocuments operation" do
        let(:envelope) { '<?xml version="1.0" ?>
                            <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                              <S:Body>
                                <getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">
                                  <doc gazette="35/2006" docType="PAMPH" docId="id50000000162179"></doc>
                                  <doc docType="WOSA" docId="id50000000125420"></doc>
                                  <doc docType="ETIP1" docId="id50000000329130"></doc>
                                  <doc priorityNumber="10 2005 008 395.1" docType="PDOC" docId="id50000000116310"></doc> <doc docType="IB304" docId="id50000000116985"></doc>
                                  <doc docType="ETWOS" docId="id50000000325635">
                                </doc>
                              </getAvailableDocumentsResponse>
                          </S:Body></S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getAvailableDocuments) }

        it "retains the xml declaration" do
          expect(stripped).to include('<?xml')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
        end

        it "strips the getAvailableDocumentsResponse element" do
          expect(stripped).to_not include('<getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<doc gazette="35/2006" docType="PAMPH" docId="id50000000162179"/>')
        end
      end

      context "getDocumentContent operation" do
        let(:envelope) { '<?xml version="1.0" encoding="utf-8"?>
                            <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                              <S:Body>
                                <getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">
                                  <documentContent>UEsDBBQACAAIAIyMOy0AAAAAAAAAAAAAAAAKAAAAMDAwMDA...AAAAAA=</documentContent>
                                </getDocumentContentResponse>
                              </S:Body>
                            </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentContent) }

        it "retains the xml declaration" do
          expect(stripped).to include('<?xml')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
        end

        it "strips the getDocumentContentResponse element" do
          expect(stripped).to_not include('<getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<documentContent>UEsDBBQACAAIAIyMOy0AAAAAAAAAAAAAAAAKAAAAMDAwMDA...AAAAAA=</documentContent>')
        end
      end

      context "getDocumentOcrContent operation" do
        let(:envelope) { '<?xml version="1.0" encoding="utf-8"?>
                            <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                              <S:Body>
                                <getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps">
                                  <documentContent>JVBERi0xLjQKJeLjz9MKOCAwIG9iago8P...DUKJSVFT0YK</documentContent>
                                </getDocumentOcrContentResponse>
                              </S:Body>
                            </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentOcrContent) }

        it "retains the xml declaration" do
          expect(stripped).to include('<?xml')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
        end

        it "strips the getDocumentOcrContentResponse element" do
          expect(stripped).to_not include('<getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<documentContent>JVBERi0xLjQKJeLjz9MKOCAwIG9iago8P...DUKJSVFT0YK</documentContent>')
        end
      end

      context "getIASR operation" do
         let(:envelope) { '<?xml version="1.0" encoding="utf-8"?>
                          <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                            <S:Body>
                              <getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">
                                <wo-international-application-status>baz</wo-international-application-status>
                              </getIASRResponse>
                            </S:Body>
                          </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getIASR) }

        it "retains the xml declaration" do
          expect(stripped).to include('<?xml')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
        end

        it "strips the getIASRResponse element" do
          expect(stripped).to_not include('<getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<wo-international-application-status>baz</wo-international-application-status>')
        end
      end

      context "getDocumentTableOfContents operation" do
        let(:envelope) { '<?xml version=\'1.0\' encoding=\'UTF-8\'?>
                            <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                              <S:Body>
                                <getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">
                                  <content>000001.tif</content>
                                </getDocumentTableOfContentsResponse>
                              </S:Body>
                            </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentTableOfContents) }

        it "retains the xml declaration" do
          expect(stripped).to include('<?xml')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
        end

        it "strips the getDocumentTableOfContentsResponse element" do
          expect(stripped).to_not include('<getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<content>000001.tif</content>')
        end
      end

      context "getDocumentContentPage operation" do
        let(:envelope) { '<?xml version="1.0" encoding="utf-8"?>
                            <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                              <S:Body>
                                <getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">
                                  <pageContent>SUkqAAgAAAASAP4ABAABAAAAAAAAAAABAwABAAAAqwk...//wAQAQAQAQ==</pageContent>
                                </getDocumentContentPageResponse>
                              </S:Body>
                            </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentContentPage) }

        it "retains the xml declaration" do
          expect(stripped).to include('<?xml')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
        end

        it "strips the getDocumentContentPageResponse element" do
          expect(stripped).to_not include('<getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<pageContent>SUkqAAgAAAASAP4ABAABAAAAAAAAAAABAwABAAAAqwk...//wAQAQAQAQ==</pageContent>')
        end
      end
    end
  end
end
