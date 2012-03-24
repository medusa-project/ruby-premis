require "active-fedora"
module Medusa
module Premis
class PremisAgent < ActiveFedora::NokogiriDatastream       
  
  set_terminology do |t|
    t.root(:path=>"agent", :xmlns=>"info:lc/xmlns/premis-v2", :schema=>"http://www.loc.gov/standards/premis/v2/premis-v2-1.xsd") 
    t.agentIdentifier {
      t.agentIdentifierType
      t.agentIdentifierValue
    }
    t.agentName
    t.agentType
    t.agentNote
    t.linkingEventIdentifier {
      t.linkingEventIdentifierType
      t.linkingEventIdentifierValue
    }
  end
  
  
  # Cannot generate an empty PREMIS Agent (when you call PremisAgent.new without args)
  def self.xml_template
    Nokogiri::XML::Document.parse("<xml/>")
  end
  
  # Instead, call new with identifier type and identifier value
  def self.xml_template(id_type, id_value)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.mods(:version=>"2.1", "xmlns:xlink"=>"http://www.w3.org/1999/xlink",
               "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
               "xmlns"=>"info:lc/xmlns/premis-v2",
               "xsi:schemaLocation"=>"info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/v2/premis-v2-1.xsd") {
        xml.agentIdentifier {
          xml.agentIdentifierType => id_type
          xml.agentIdentifierValue => id_value
        }
        xml.agentName
        xml.agentType
        xml.agentNote
      }
  end
  
  
end
end
end

