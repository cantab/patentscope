require 'spec_helper'

module Patentscope

  describe Patentscope, :core, :vcr do

    before { Patentscope.configure_from_env }

    let(:patentscope) { Patentscope }

    it "exists" do
      expect(patentscope).to_not be_nil
    end

    it "has the right methods" do
      expect(patentscope).to respond_to(:wsdl)
      expect(patentscope).to respond_to(:get_available_documents)
      expect(patentscope).to respond_to(:get_document_content)
      expect(patentscope).to respond_to(:get_document_ocr_content)
      expect(patentscope).to respond_to(:get_iasr)
      expect(patentscope).to respond_to(:get_document_table_of_contents)
      expect(patentscope).to respond_to(:get_document_content_page)
    end

    describe "wsdl method" do
      it "returns a wsdl document" do
        response = patentscope.wsdl
        expect(response).to include('<?xml')
        expect(response).to include('<wsdl:definitions')
      end
    end

    describe "get_available_documents method" do
      it 'returns an appropriate XML document for the get_available_documents operation' do
        response = patentscope.get_available_documents('SG2009000062')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<doc ocrPresence="no" docType="RO101" docId="id00000008679651"/>')
        expect(response).to_not include('<getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_content method" do
      it 'returns an appropriate XML document for the get_document_content operation' do
        response = patentscope.get_document_content('090063618004ca88')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<documentContent>')
        expect(response).to include('nRpZsy7ezxU2/8/fk5JM6HIXReMWymXUCmhYcRgUIjjNk2pDAkdlxox7xiSLm')
        expect(response).to_not include('<getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_ocr_content method" do
      it 'returns an appropriate XML document for the get_document_ocr_content operation' do
        response = patentscope.get_document_ocr_content('id00000015801579')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<documentContent>')
        expect(response).to include('XdDb9Ain4kev61wgZc36X022QPCEZZASS2Rwpcy4Hx7I5GYHhriRwpsDwoX9tgjgZwcEGGEksgthsHsNtkFmyGZYQIGGCCX3dhggRDTgEEDNgVgkvuw2ECDDSYMEF')
        expect(response).to_not include('<getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_iasr method" do
      it 'returns an appropriate XML document for the get_iasr operation' do
        response = patentscope.get_iasr('SG2009000062')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<wo-international-application-status>')
        expect(response).to include('MESENCHYMAL STEM CELL PARTICLES')
        expect(response).to_not include('<getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_table_of_contents method" do
      it 'returns an appropriate XML document for the get_document_table_of_contents operation' do
        response = patentscope.get_document_table_of_contents('090063618004ca88')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('<content>')
        expect(response).to include('<content>000001.tif</content>')
        expect(response).to_not include('<getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end

    describe "get_document_content_page method" do
      it 'returns an appropriate XML document for the get_document_content_page operation' do
        response = patentscope.get_document_content_page('090063618004ca88', '000001.tif')
        expect(response).to include('<?xml version="1.0"?>')
        expect(response).to include('+GP0kv9dhgiY7Rb5h2q4RN6Jj9NpDCJjuMImO0l0TfLe7QRO2yFceTvvTu6C6qTH')
        expect(response).to_not include('<getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">')
      end
    end
  end
end
