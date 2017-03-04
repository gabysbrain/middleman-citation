
require "bibtex"
require "citeproc"
require "csl/styles"

module Citations
  class InvalidKeyError < StandardError
  end

  class InvalidStyleError < StandardError
  end

  # Returns a link to directly access scientific articles
  # on the internet according to their digital object identifier (DOI).
  def self.doi_link(doi)
    "http://dx.doi.org/#{doi}"
  end

  def self.cite_full(key, bib, style, format='text', link=false)
    cp = CiteProc::Processor.new style: style, format: format
    cp.import bib.to_citeproc

    citation = ""

    # need to convert latex special characters, like {\"o} to unicode
    #bib[key].convert_latex
    #puts bib[key]
    #CiteProc.process(bib[key].to_citeproc, :style => style)
    begin
        citation = cp.render(:bibliography, id: key).join("\n")

        # Add optional link to reference.
        if link == true
            if !bib[key][:doi].nil? && !bib[key][:doi].empty?
                citation << "&nbsp;<a href=\"#{doi_link(bib[key][:doi])}\">link</a>"
            end
        end
    rescue TypeError => e
      raise InvalidKeyError, "citation key '#{key}' not found"
    rescue CSL::ParseError => e
      raise InvalidStyleError, "citation style '#{style}' not found"
    end

    return citation
  end

  def self.cite_inline(key, bib, style, link=false)
    "&nbsp;<span class='inline-citation'><span class='citation'>#{cite_full(key, bib, style,'html',link)}</span></span>"
  end

end
