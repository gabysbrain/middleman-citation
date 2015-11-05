require "middleman-citation/version"
require "middleman-citation/citations"
require "middleman-core"
require "bibtex"

module Middleman

  class CitationExtension < Middleman::Extension

    option :bibtex, nil,                   'Path to the bibtex file'
    option :style,  'chicago-author-date', 'Citation style'
    option :format, 'html',                'Citation format'

    def initialize(app, options_hash={}, &block)
      super
      app.set(:bibtex,      BibTeX.open(options.bibtex, :filter => 'latex'))
      app.set(:cite_style,  options.style)
      app.set(:cite_format, options.format)
    end
  
    helpers do
      # Given a BibTeX citation return a formatted string according to
      # how the setting of the style option
      # Params:
      # +key+:: bibtex key located in the BibTeX file defined in the config
      def cite_full(key)
        Citations::cite_full(key, bibtex, cite_style, cite_format)
      end

      # Given a BibTeX citation return a block containing the citation
      # that we can embed in a webpage inline
      # Params:
      # +key+:: bibtex key located in the BibTeX file defined in the config
      def cite_inline(key)
        Citations::cite_inline(key, bibtex, cite_style)
      end

      def citations_search(search_key, author = nil)
        entries_matching_key = bibtex.query(search_key)
        entries = 
          if author then
            search_by_author(entries_matching_key, author)
          else
            entries_matching_key
          end
        entries.sort { |x, y| y.year.to_i <=> x.year.to_i }.map(&:key)
      end

      def citation_entry(key)
        bibtex[key].convert_latex.to_citeproc
      end

      def citation_formatted(entry)
        CiteProc.process(entry, :style => cite_style, :format => cite_format)
      end

      def citation(key)
        entry = citation_entry(key)
        citation_formatted(entry)
      end

      private

      def search_by_author(entries, author)
        bib_author = BibTeX::Name.parse(author)
        entries.select do |e|
          e.respond_to?(:author) && 
            e.author && 
            e.author.include?(bib_author)
        end
      end

    end
  end
end

::Middleman::Extensions.register(:citation, Middleman::CitationExtension)

