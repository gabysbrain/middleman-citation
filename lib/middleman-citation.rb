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
      app.config[:bibtex] = BibTeX.open(options.bibtex)
      app.config[:bibtex].replace
      app.config[:bibtex].convert(:latex)
      app.config[:cite_style] = options.style
      app.config[:cite_format] = options.format
    end
  
    helpers do
      # Given a BibTeX citation return a formatted string according to
      # how the setting of the style option
      # Params:
      # +key+:: bibtex key located in the BibTeX file defined in the config
      def cite_full(key,link=false)
        Citations::cite_full(key, config.bibtex, config.cite_style, config.cite_format,link)
      end

      # Given a BibTeX citation return a block containing the citation
      # that we can embed in a webpage inline
      # Params:
      # +key+:: bibtex key located in the BibTeX file defined in the config
      def cite_inline(key)
        Citations::cite_inline(key, config.bibtex, config.cite_style)
      end

      def citations_search(search_key, author = nil)
        if author then
            entries = search_by_author(entries_matching_key, author)
        else
            entries_matching_key = config.bibtex.query(search_key)
            entries ||= []

            entries_matching_key.each do |entry|
                next if entry.type == :string
                entries << entry
            end
        end

        entries.sort { |x, y| y.year.to_i <=> x.year.to_i }.map(&:key)
      end

      # Loads a bibtex file, given as parameter.
      # Same functionality as initialize function, but allows to open
      # multiple files sequentially.
      def citations_load_bibtex_file(file)
        app.config[:bibtex] = BibTeX.open(file)
        app.config[:bibtex].replace
        app.config[:bibtex].convert(:latex)
      end

      # Returns an array containing the years of the current
      # bibtex file. e.g. useful to generate menu items.
      def citations_list_years(search_key)
        entries = config.bibtex.query(search_key)

        years ||= []

        entries.each do |entry|
            next if entry.type == :string
            years |= [entry.year.to_i]
        end

        years.sort { |x, y| x.to_i <=> y.to_i}.reverse
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

