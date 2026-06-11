module Patentscope

  class Webservice

    PATENTSCOPE_WEBSERVICE_LOCATION = "https://patentscope.wipo.int/patentscope-webservice/servicesPatentScope"

    def wsdl
      send_wsdl_request
    end

    def get_available_documents(args = {})
      ia_number = normalized_ia_number(args[:ia_number])
      perform_operation(:getAvailableDocuments, { iaNumber: ia_number })
    end

    def get_document_content(args = {})
      doc_id = required_value(args[:doc_id], NoDocIDError, "Document id was not entered")
      perform_operation(:getDocumentContent, { docId: doc_id })
    end

    def get_document_ocr_content(args = {})
      doc_id = required_value(args[:doc_id], NoDocIDError, "Document id was not entered")
      perform_operation(:getDocumentOcrContent, { docId: doc_id })
    end

    def get_iasr(args = {})
      ia_number = normalized_ia_number(args[:ia_number])
      perform_operation(:getIASR, { iaNumber: ia_number })
    end

    def get_document_table_of_contents(args = {})
      doc_id = required_value(args[:doc_id], NoDocIDError, "Document id was not entered")
      perform_operation(:getDocumentTableOfContents, { docId: doc_id })
    end

    def get_document_content_page(args = {})
      doc_id  = required_value(args[:doc_id], NoDocIDError, "Document id was not entered")
      page_id = required_value(args[:page_id], NoPageIDError, "Page id was not entered")
      perform_operation(:getDocumentContentPage, { docId: doc_id, pageId: page_id })
    end

    private

    def perform_operation(operation, options_hash)
      soap_envelope = soapbuilder.build_envelope(operation, options_hash)
      response = send_soap_request(soap_envelope).to_s
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

    def normalized_ia_number(number)
      PctAppNumber.new(number).to_ia_number
    end

    def required_value(value, error_class, message)
      value = value.to_s.strip
      raise error_class, message if value.empty?
      value
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
