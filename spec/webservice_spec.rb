require 'spec_helper'

module Patentscope

  describe Webservice, :core, :vcr do

    before { Patentscope.configure_from_env}

    let(:webservice) { Webservice.new }

    it "exists" do
      expect(webservice).to_not be_nil
    end

    it "has the right methods" do
      expect(webservice).to respond_to(:wsdl)
      expect(webservice).to respond_to(:get_available_documents)
      expect(webservice).to respond_to(:get_document_content)
      expect(webservice).to respond_to(:get_document_ocr_content)
      expect(webservice).to respond_to(:get_iasr)
      expect(webservice).to respond_to(:get_document_table_of_contents)
      expect(webservice).to respond_to(:get_document_content_page)
    end

    describe "constants" do
      it "has a webservice location constant" do
        expect(Webservice::PATENTSCOPE_WEBSERVICE_LOCATION).to_not be_nil
      end
    end

    describe "wsdl method" do
      it "returns a wsdl document", :more do
        response = webservice.wsdl
        expect(response).to include('<?xml')
        expect(response).to include('<wsdl:definitions')
      end
    end

    describe "get_available_documents method" do
      it 'raises for an invalid application number before making a request' do
        expect(webservice).to_not receive(:perform_operation)

        expect do
          webservice.get_available_documents(ia_number: 'SG201200001')
        end.to raise_error(Patentscope::WrongNumberFormatError)
      end

      it 'returns an appropriate XML document for the get_available_documents operation', :more do
        response = webservice.get_available_documents(ia_number: 'SG2009000062')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<doc docId="id00000008693323" docType="PAMPH" gazette="35/2009" ocrPresence="no"/>')
        expect(response).to include('<getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_content method" do
      it 'raises for a blank document id before making a request' do
        expect(webservice).to_not receive(:perform_operation)

        expect do
          webservice.get_document_content(doc_id: ' ')
        end.to raise_error(Patentscope::NoDocIDError)
      end

      it 'returns an appropriate XML document for the get_document_content operation', :more do
        response = webservice.get_document_content(doc_id: '090063618004ca88')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<documentContent>')
        expect(response).to include('<xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include"')
        expect(response).to include('<getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_ocr_content method" do
      it 'returns an appropriate XML document for the get_document_ocr_content operation', :more do
        response = webservice.get_document_ocr_content(doc_id: 'id00000015801579')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps"/>')
      end
    end

    describe "get_iasr method" do
      it 'raises for an invalid application number before making a request' do
        expect(webservice).to_not receive(:perform_operation)

        expect do
          webservice.get_iasr(ia_number: 'SG201200001')
        end.to raise_error(Patentscope::WrongNumberFormatError)
      end

      it 'returns an appropriate XML document for the get_iasr operation', :more do
        response = webservice.get_iasr(ia_number: 'SG2009000062')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<wo-international-application-status>')
        expect(response).to include('MESENCHYMAL STEM CELL PARTICLES')
        expect(response).to include('<getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_table_of_contents method" do
      it 'returns an appropriate XML document for the get_document_table_of_contents operation', :more do
        response = webservice.get_document_table_of_contents(doc_id: '090063618004ca88')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<content>000001.tif</content>')
        expect(response).to include('<getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_content_page method" do
      it 'raises for a blank page id before making a request' do
        expect(webservice).to_not receive(:perform_operation)

        expect do
          webservice.get_document_content_page(doc_id: '090063618004ca88', page_id: '')
        end.to raise_error(Patentscope::NoPageIDError)
      end

      it 'returns an appropriate XML document for the get_document_content_page operation', :more do
        response = webservice.get_document_content_page(doc_id: '090063618004ca88', page_id: '000001.tif')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<pageContent>')
        expect(response).to include('<xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include"')
        expect(response).to include('<getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end
  end
end
