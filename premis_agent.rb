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
  
  
  # Generates an empty PREMIS Agent (used when you call PremisAgent.new without passing in existing xml))
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.agent(:version=>"2.1", "xmlns:xlink"=>"http://www.w3.org/1999/xlink",
               "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
               "xmlns"=>"info:lc/xmlns/premis-v2",
               "xsi:schemaLocation"=>"info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/v2/premis-v2-1.xsd") {
        xml.agentIdentifier {
          xml.agentIdentifierType
          xml.agentIdentifierValue
        }
        xml.agentName
        xml.agentType
        xml.agentNote
      }
    end  
      return builder.doc
    end
  end
  
  def self.identifier_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.agentIdentifier {
        xml.agentIdentifierType
        xml.agentIdentifierValue
      }
    end
    return builder.doc.root
  end
  
  def self.linking_identifier_template
    builder = Nokogiri::XML::Builder.new do |xml|
      t.linkingEventIdentifier {
        t.linkingEventIdentifierType
        t.linkingEventIdentifierValue
      }
    end
    return builder.doc.root
  end
    
  # Inserts a new identifer into the agent document
  def insert_identifier(opts={})
    node = Medusa::Premis::Agent.identifier_template
    nodeset = self.find_by_terms(:agentIdentifier)
    
    unless nodeset.nil?
      if nodeset.empty?
        self.ng_xml.root.add_child(node)
        index = 0
      else
        nodeset.after(node)
        index = nodeset.length
      end
      self.dirty = true
    end
    
    return node, index
  end

    # Inserts a new linking identifer into the agent document
    def insert_linking_identifier(opts={})
      node = Medusa::Premis::Agent.linking_identifier_template
      nodeset = self.find_by_terms(:linkingIdentifier)

      unless nodeset.nil?
        if nodeset.empty?
          self.ng_xml.root.add_child(node)
          index = 0
        else
          nodeset.after(node)
          index = nodeset.length
        end
        self.dirty = true
      end

      return node, index
    end
  
end
end
end

