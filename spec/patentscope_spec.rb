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
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<getAvailableDocumentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
        expect(response).to include('<doc docId="id00000008693323" docType="PAMPH" gazette="35/2009" ocrPresence="yes"/>')
      end
    end

    describe "get_document_content method" do
      it 'returns an appropriate XML document for the get_document_content operation' do
        response = patentscope.get_document_content('090063618004ca88')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<getDocumentContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
        expect(response).to include('<documentContent>')
        expect(response).to include('<xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include" href="cid:')
      end
    end

    describe "get_document_ocr_content method" do
      it 'returns an appropriate XML document for the get_document_ocr_content operation' do
        response = patentscope.get_document_ocr_content('id00000015801579')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<getDocumentOcrContentResponse xmlns="http://www.wipo.org/wsdl/ps">')
        expect(response).to include('<documentContent>')
        expect(response).to include('<xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include" href="cid:')
      end
    end

    describe "get_iasr method" do
      it 'returns an appropriate XML document for the get_iasr operation' do
        response = patentscope.get_iasr('SG2009000062')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<getIASRResponse xmlns="http://www.wipo.org/wsdl/ps">')
        expect(response).to include('<wo-international-application-status>')
        expect(response).to include('MESENCHYMAL STEM CELL PARTICLES')
      end
    end

    describe "get_document_table_of_contents method" do
      it 'returns an appropriate XML document for the get_document_table_of_contents operation' do
        response = patentscope.get_document_table_of_contents('090063618004ca88')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<getDocumentTableOfContentsResponse xmlns="http://www.wipo.org/wsdl/ps">')
        expect(response).to include('<content>')
        expect(response).to include('<content>000001.tif</content>')
      end
    end

    describe "get_document_content_page method" do
      it 'returns an appropriate XML document for the get_document_content_page operation' do
        response = patentscope.get_document_content_page('090063618004ca88', '000001.tif')
        expect(response).to include('<?xml version="1.0" encoding="UTF-8"?>')
        expect(response).to include('<getDocumentContentPageResponse xmlns="http://www.wipo.org/wsdl/ps">')
        expect(response).to include('<xop:Include xmlns:xop="http://www.w3.org/2004/08/xop/include" href="cid:')
      end
    end
  end
end
