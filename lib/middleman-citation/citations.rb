
require "bibtex"
require "citeproc"
require "csl/styles"

module Citations
  class InvalidKeyError < StandardError
  end

  class InvalidStyleError < StandardError
  end

  def self.cite_full(key, bib, style, format='text')
    cp = CiteProc::Processor.new style: style, format: format
    cp.import bib.to_citeproc
    # need to convert latex special characters, like {\"o} to unicode
    #bib[key].convert_latex
    #puts bib[key]
    #CiteProc.process(bib[key].to_citeproc, :style => style)
    begin
      cp.render(:bibliography, id: key).join("\n")
    rescue TypeError => e
      raise InvalidKeyError, "citation key '#{key}' not found"
    rescue CSL::ParseError => e
      raise InvalidStyleError, "citation style '#{style}' not found"
    end
  end

  def self.cite_inline(key, bib, style)
    "&nbsp;<span class='inline-citation'><span class='citation'>#{cite_full(key, bib, style,'html')}</span></span>"
  end

end
