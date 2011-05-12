module Bookie
  module Emitters
    class EPUB < HTML
      def self.extension
        ".epub"
      end

     def initialize
       @chapters = []
     end

     def start_new_chapter(params)
        @body =  ""

        @chapters << [params[:title], @body]
        @body << "<h1>#{params[:title]}</h1>"
      end

      def render(params)
        Dir.mktmpdir("bookie-epub") do |dir|
          @chapters.each_with_index do |(title, content),index|
            File.open("#{dir}/#{index}.html", "w") do |f|
              template = File.read("#{Bookie::TEMPLATES_DIR}/epub_chapter.erb")
              f << ERB.new(template).result(binding)
            end
          end

          chapter_filenames = @chapters.length.times.map do |i|
            File.expand_path("#{dir}/#{i}.html")
          end

          chapter_outline = @chapters.map.with_index do |(title,_), i| 
            { :label => title, :content => "#{i}.html" }
          end

          epub = EeePub.make do
            title       params[:title]
            identifier  '', :scheme => 'URL'
            uid         ''
            files chapter_filenames
            nav chapter_outline
          end

          epub.save(params[:file])
        end
      end
    end
  end
end
