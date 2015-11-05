
require "bibtex"
require "citeproc"
require "csl/styles"

module Citations
  def self.cite_full(key, bib, style, format='text')
    cp = CiteProc::Processor.new style: style, format: format
    cp.import bib.to_citeproc
    # need to convert latex special characters, like {\"o} to unicode
    #bib[key].convert_latex
    #puts bib[key]
    #CiteProc.process(bib[key].to_citeproc, :style => style)
    cp.render(:bibliography, id: key).join("\n")
  end

  def self.cite_inline(key, bib, style)
    "&nbsp;<span class='inline-citation'><span class='citation'>#{cite_full(key, bib, style,'html')}</span></span>"
  end

end
