module Patentscope

  class WebserviceSoapStripper

    def strip_envelope(response, operation)
      case operation
      when :getAvailableDocuments
        result_tag = 'getAvailableDocumentsResponse'
      when :getDocumentContent
        result_tag = 'getDocumentContentResponse'
      when :getDocumentOcrContent
        result_tag = 'getDocumentOcrContentResponse'
      when :getIASR
        result_tag = 'getIASRResponse'
      when :getDocumentTableOfContents
        result_tag = 'getDocumentTableOfContentsResponse'
      when :getDocumentContentPage
        result_tag = 'getDocumentContentPageResponse'
      end

      doc = Nokogiri::XML(response)
      stripped_response = doc.xpath("//iasr:#{result_tag}", 'iasr' => "http://www.wipo.org/wsdl/ps").children

      # add back the XML declaration to the XML with a namespace
      stripped_response_with_declaration = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.send(result_tag, "xmlns" => "http://www.wipo.org/wsdl/ps") do
          xml.parent << stripped_response
        end
      end.to_xml

      stripped_response_with_declaration
    end
  end
end
