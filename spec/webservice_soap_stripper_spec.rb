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
        let(:envelope) { '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                            <S:Body>
                              <getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">
                                <doc docId="id00000008684397" docType="DECLA" ocrPresence="no"/>
                                <doc docId="id00000008684400" docType="PDOC" ocrPresence="no" priorityNumber="61/066,671"/>
                                <doc docId="id00000008684501" docType="IB304" ocrPresence="no"/>
                                <doc docId="id00000008688844" docType="ISR" ocrPresence="no"/>
                                <doc docId="id00000008679650" docType="RO146" ocrPresence="no"/>
                                <doc docId="id00000008679648" docType="RO102" ocrPresence="no"/>
                                <doc docId="id00000008679649" docType="RO105" ocrPresence="no"/>
                                <doc docId="id00000008692319" docType="IB311" ocrPresence="no"/>
                                <doc docId="id00000008684398" docType="RO135" ocrPresence="no"/>
                                <doc docId="id00000011435292" docType="IPRP2" ocrPresence="no"/>
                                <doc docId="id00000008684396" docType="IB371" ocrPresence="no"/>
                                <doc docId="id00000008679647" docType="APBDY" ocrPresence="no"/>
                                <doc docId="id00000008679673" docType="IB301" ocrPresence="no"/>
                                <doc docId="id00000011434982" docType="WOSA" ocrPresence="no"/>
                                <doc docId="id00000010873927" docType="IB308" ocrPresence="no"/>
                                <doc docId="id00000008814497" docType="IB308" ocrPresence="no"/>
                                <doc docId="id00000008693323" docType="PAMPH" gazette="35/2009" ocrPresence="yes"/>
                                <doc docId="id00000008679651" docType="RO101" ocrPresence="no"/>
                              </getAvailableDocumentsResponse>
                            </S:Body>
                          </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getAvailableDocuments) }

        it "adds an xml declaration" do
          expect(stripped).to include('<?xml version="1.0" encoding="UTF-8"?>')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
          expect(stripped).to_not include('</S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
          expect(stripped).to_not include('</S:Body>')
        end

        it "retains the getAvailableDocumentsResponse element" do
          expect(stripped).to include('<getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
          expect(stripped).to include('</getAvailableDocumentsResponse>')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<doc docId="id00000008693323" docType="PAMPH" gazette="35/2009" ocrPresence="yes"/>')
          expect(stripped).to include('<doc docId="id00000008684397" docType="DECLA" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008684400" docType="PDOC" ocrPresence="no" priorityNumber="61/066,671"/>')
          expect(stripped).to include('<doc docId="id00000008684501" docType="IB304" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008688844" docType="ISR" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008679650" docType="RO146" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008679648" docType="RO102" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008679649" docType="RO105" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008692319" docType="IB311" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008684398" docType="RO135" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000011435292" docType="IPRP2" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008684396" docType="IB371" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008679647" docType="APBDY" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008679673" docType="IB301" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000011434982" docType="WOSA" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000010873927" docType="IB308" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008814497" docType="IB308" ocrPresence="no"/>')
          expect(stripped).to include('<doc docId="id00000008693323" docType="PAMPH" gazette="35/2009" ocrPresence="yes"/>')
          expect(stripped).to include('<doc docId="id00000008679651" docType="RO101" ocrPresence="no"/>')
        end
      end

      context "getDocumentContent operation" do
        let(:envelope) { '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                            <S:Body>
                                <getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">
                                    <documentContent>
                                        <xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include" href="cid:1afdf9a2-eeb8-416c-bb13-35e28fbe10fc-292470@www.wipo.org"/>
                                    </documentContent>
                                </getDocumentContentResponse>
                            </S:Body>
                          </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentContent) }

        it "adds an xml declaration" do
          expect(stripped).to include('<?xml version="1.0" encoding="UTF-8"?>')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
          expect(stripped).to_not include('</S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
          expect(stripped).to_not include('</S:Body>')
        end

        it "retains the getDocumentContentResponse element" do
          expect(stripped).to include('<getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
          expect(stripped).to include('</getDocumentContentResponse>')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<documentContent>')
          expect(stripped).to include('<xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include" href="cid:')
          expect(stripped).to include('<documentContent>')
        end
      end

      context "getDocumentOcrContent operation" do
        let(:envelope) { '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                            <S:Body>
                              <getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps">
                                <documentContent>
                                  <xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include" href="cid:1afdf9a2-eeb8-416c-bb13-35e28fbe10fc-292537@www.wipo.org"/>
                                </documentContent>
                              </getDocumentOcrContentResponse>
                            </S:Body>
                          </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentOcrContent) }

        it "adds an xml declaration" do
          expect(stripped).to include('<?xml version="1.0" encoding="UTF-8"?>')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
          expect(stripped).to_not include('</S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
          expect(stripped).to_not include('</S:Body>')
        end

        it "retains the getDocumentOcrContentResponse element" do
          expect(stripped).to include('<getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
          expect(stripped).to include('</getDocumentOcrContentResponse>')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include" href="cid:')
        end
      end

      context "getIASR operation" do
         let(:envelope) { '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                             <S:Body>
                               <getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">
                                 <wo-international-application-status>baz</wo-international-application-status>
                               </getIASRResponse>
                             </S:Body>
                           </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getIASR) }

        it "adds an xml declaration" do
          expect(stripped).to include('<?xml version="1.0" encoding="UTF-8"?>')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
          expect(stripped).to_not include('</S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
          expect(stripped).to_not include('</S:Body>')
        end

        it "retains the getIASRResponse element" do
          expect(stripped).to include('<getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">')
          expect(stripped).to include('</getIASRResponse')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<wo-international-application-status>baz</wo-international-application-status>')
        end
      end

      context "getDocumentTableOfContents operation" do
        let(:envelope) { '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                            <S:Body>
                              <getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">
                                <content>000001.tif</content>
                              </getDocumentTableOfContentsResponse>
                            </S:Body>
                          </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentTableOfContents) }

        it "adds an xml declaration" do
          expect(stripped).to include('<?xml version="1.0" encoding="UTF-8"?>')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
          expect(stripped).to_not include('</S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
          expect(stripped).to_not include('</S:Body>')
        end

        it "retains the getDocumentTableOfContentsResponse element" do
          expect(stripped).to include('<getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
          expect(stripped).to include('</getDocumentTableOfContentsResponse')
        end

        it "retains the inner elements" do
          expect(stripped).to include('<content>000001.tif</content>')
        end
      end

      context "getDocumentContentPage operation" do
        let(:envelope) { '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
                            <S:Body>
                              <getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">
                                <pageContent>
                                  <Include xmlns="http://www.w3.org/2004/08/xop/include" href="cid:e4c25938-e5a2-4159-996f-3165f8992e34@example.jaxws.sun.com"/>
                                </pageContent>
                              </getDocumentContentPageResponse>
                            </S:Body>
                          </S:Envelope>' }
        let(:stripped) { ws_soap_stripper.strip_envelope(envelope, :getDocumentContentPage) }

        it "adds an xml declaration" do
          expect(stripped).to include('<?xml version="1.0" encoding="UTF-8"?>')
        end

        it "strips the Envelope element" do
          expect(stripped).to_not include('<S:Envelope')
          expect(stripped).to_not include('</S:Envelope')
        end

        it "strips the Body element" do
          expect(stripped).to_not include('<S:Body>')
          expect(stripped).to_not include('</S:Body>')
        end

        it "retains the getDocumentContentPageResponse element" do
          expect(stripped).to include('<getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">')
          expect(stripped).to include('</getDocumentContentPageResponse')
        end

        it "retains the inner elements" do
          expect(stripped).to include('Include xmlns="http://www.w3.org/2004/08/xop/include" href="cid:')
        end
      end
    end
  end
end
