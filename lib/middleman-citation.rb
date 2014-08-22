require "middleman-citation/version"
require "middleman-core"
require "bibtex"
require "citeproc"

module Middleman
  class CitationExtension < Middleman::Extension
    option :bibtex, "", "The path to the bibtex file to use"
    option :style, "chicago-author-date", "The citation style to use"
  
    def initialize(app, options_hash={}, &block)
      super
  
      @@bibtex = BibTeX.open(options.bibtex)
      # for some reason the options function is the one from 
      # middleman-deploy in the helper methods below...
      @@cite_style = options.style
    end
  
    helpers do
      # Given a BibTeX citation return a formatted string according to
      # how the setting of the style option
      # Params:
      # +key+:: bibtex key located in the BibTeX file defined in the config
      def cite_full(key)
        # need to convert latex special characters, like {\"o} to unicode
        @@bibtex[key].convert_latex
        CiteProc.process(@@bibtex[key].to_citeproc, :style => @@cite_style)
      end
  
      # Search the BibTeX file for all citations of a certain type for a 
      # certain author.  Returns a list of citation keys you can send to
      # +cite_full+.
      # Params:
      # +search_key+:: filter keys for the BibTeX file, e.g. @book, @article,
      #                etc.
      # +author+:: The full author name to search for
      def find_pubs(search_key, author)
        bib_name = BibTeX::Name.parse(author)
        results = @@bibtex.query(search_key) do |e|
          e.respond_to?(:author) and e.author and e.author.include? bib_name
        end
        results.sort! {|x,y| y.year.to_i-x.year.to_i}
        results.map {|x| x.key}
      end
    end
  end
end

::Middleman::Extensions.register(:citation, Middleman::CitationExtension)

