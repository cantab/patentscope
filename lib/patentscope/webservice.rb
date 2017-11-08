module Patentscope

  class Webservice

    PATENTSCOPE_WEBSERVICE_LOCATION = "https://patentscope.wipo.int/patentscope-webservice/servicesPatentScope"

    def wsdl
      send_wsdl_request
    end

    def get_available_documents(args = {})
      ia_number = PctAppNumber.new(args[:ia_number]).to_ia_number
      perform_operation(:getAvailableDocuments, { iaNumber: ia_number })
    end

    def get_document_content(args = {})
      doc_id = args[:doc_id]
      perform_operation(:getDocumentContent, { docId: doc_id })
    end

    def get_document_ocr_content(args = {})
      doc_id = args[:doc_id]
      perform_operation(:getDocumentOcrContent, { docId: doc_id })
    end

    def get_iasr(args = {})
      ia_number = PctAppNumber.new(args[:ia_number]).to_ia_number
      perform_operation(:getIASR, { iaNumber: ia_number })
    end

    def get_document_table_of_contents(args = {})
      doc_id = args[:doc_id]
      perform_operation(:getDocumentTableOfContents, { docId: doc_id })
    end

    def get_document_content_page(args = {})
      doc_id  = args[:doc_id]
      page_id = args[:page_id]
      perform_operation(:getDocumentContentPage, { docId: doc_id, pageId: page_id })
    end

    private

    def perform_operation(operation, options_hash)
      soap_envelope = soapbuilder.build_envelope(operation, options_hash)
      response = send_soap_request(soap_envelope)
      if response.include?('Error') && response.include?('Unauthorized')
        raise WrongCredentialsError
      elsif response.include?('Business error during the execution of service')
        raise BusinessError
      else
        soapstripper.strip_envelope(response, operation)
      end
    end

    def send_soap_request(soap_envelope_xml)
      client.post_url(PATENTSCOPE_WEBSERVICE_LOCATION, "text/xml", soap_envelope_xml)
    end

    def send_wsdl_request
      client.get_url(PATENTSCOPE_WEBSERVICE_LOCATION + '?wsdl')
    end

    def client
      raise NoCredentialsError unless Patentscope.configured?
      Client.new(username: Patentscope.configuration.username,
                 password: Patentscope.configuration.password)
    end

    def soapbuilder
      WebserviceSoapBuilder.new
    end

    def soapstripper
      WebserviceSoapStripper.new
    end
  end
end
