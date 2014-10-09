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
      it "returns a wsdl document" do
        response = webservice.wsdl
        expect(response).to include('<?xml')
        expect(response).to include('<wsdl:definitions')
      end
    end

    describe "get_available_documents method" do
      it 'returns an appropriate XML document for the get_available_documents operation' do
        response = webservice.get_available_documents(ia_number: 'SG2009000062')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<doc ocrPresence="yes" gazette="35/2009" docType="PAMPH" docId="id00000008693323"/>')
        expect(response).to_not include('<getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_content method" do
      it 'returns an appropriate XML document for the get_document_content operation' do
        response = webservice.get_document_content(doc_id: '090063618004ca88')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<documentContent>')
        expect(response).to include('nRpZsy7ezxU2/8/fk5JM6HIXReMWymXUCmhYcRgUIjjNk2pDAkdlxox7xiSLm')
        expect(response).to_not include('<getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_ocr_content method" do
      it 'returns an appropriate XML document for the get_document_ocr_content operation' do
        response = webservice.get_document_ocr_content(doc_id: 'id00000015801579')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<documentContent>')
        expect(response).to include('XdDb9Ain4kev61wgZc36X022QPCEZZASS2Rwpcy4Hx7I5GYHhriRwpsDwoX9tgjgZwcEGGEksgthsHsNtkFmyGZYQIGGCCX3dhggRDTgEEDNgVgkvuw2ECDDSYMEF')
        expect(response).to_not include('<getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_iasr method" do
      it 'returns an appropriate XML document for the get_iasr operation' do
        response = webservice.get_iasr(ia_number: 'SG2009000062')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<wo-international-application-status>')
        expect(response).to include('MESENCHYMAL STEM CELL PARTICLES')
        expect(response).to_not include('<getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_table_of_contents method" do
      it 'returns an appropriate XML document for the get_document_table_of_contents operation' do
        response = webservice.get_document_table_of_contents(doc_id: '090063618004ca88')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<content>')
        expect(response).to include('<content>000001.tif</content>')
        expect(response).to_not include('<getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_content_page method" do
      it 'returns an appropriate XML document for the get_document_content_page operation' do
        response = webservice.get_document_content_page(doc_id: '090063618004ca88', page_id: '000001.tif')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('+GP0kv9dhgiY7Rb5h2q4RN6Jj9NpDCJjuMImO0l0TfLe7QRO2yFceTvvTu6C6qTH')
        expect(response).to_not include('<getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end
  end
end
