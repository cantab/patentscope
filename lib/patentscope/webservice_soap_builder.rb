module Patentscope

  class WebserviceSoapBuilder

    def build_envelope(operation, options_hash)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.Envelope do
          ns = xml.doc.root.add_namespace_definition('S', 'http://schemas.xmlsoap.org/soap/envelope/')
          xml.doc.root.namespace = ns
          xml.Body do
            xml.send(operation, :'xmlns' => 'http://www.wipo.org/wsdl/ps') do
              options_hash.each do |key, value|
                xml.send(key, value)
              end
            end
          end
        end
      end.to_xml
    end
  end
end
