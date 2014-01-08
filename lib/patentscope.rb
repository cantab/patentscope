module Patentscope

  require 'patentscope/version'
  require 'patentscope/client'
  require 'patentscope/configuration'
  require 'patentscope/webservice'
  require 'patentscope/webservice_soap_builder'
  require 'patentscope/pct_doc_number'

  class NoCredentialsError < StandardError; end
  class WrongCredentialsError < StandardError; end
  class BusinessError < StandardError; end
  class WrongNumberFormatError < StandardError; end

  class << self

    def wsdl
      webservice.wsdl
    end

    def get_available_documents(ia_number)
      webservice.get_available_documents(ia_number: ia_number)
    end

    def get_document_content(doc_id)
      webservice.get_document_content(doc_id: doc_id)
    end

    def get_document_ocr_content(doc_id)
      webservice.get_document_ocr_content(doc_id: doc_id)
    end

    def get_iasr(ia_number)
      webservice.get_iasr(ia_number: ia_number)
    end

    def get_document_table_of_contents(doc_id)
      webservice.get_document_table_of_contents(doc_id: doc_id)
    end

    def get_document_content_page(doc_id, page_id)
      webservice.get_document_content_page(doc_id: doc_id, page_id: page_id)
    end

    private

    def webservice
      Webservice.new
    end
  end
end

