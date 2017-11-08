module Patentscope

  class WebserviceSoapStripper

    def strip_envelope(response, operation)
      case operation
      when :getAvailableDocuments
        result_tag = 'doc'
      when :getDocumentContent
        result_tag = 'documentContent'
      when :getDocumentOcrContent
        result_tag = 'documentContent'
      when :getIASR
        result_tag = 'wo-international-application-status'
      when :getDocumentTableOfContents
        result_tag = 'content'
      when :getDocumentContentPage
        result_tag = 'pageContent'
      end
      doc = Nokogiri::XML(response)
      stripped_response = doc.xpath("//iasr:#{result_tag}", 'iasr' => "http://www.wipo.org/wsdl/ps").to_xml
      # this seems to be the only way to add back the XML declaration to the XML!
      stripped_response_with_declaration = Nokogiri::XML(stripped_response).to_s
      stripped_response_with_declaration
    end
  end
end
