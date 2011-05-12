module Bookie
  module Emitters
    class MOBI < HTML
      OPF_TEMPLATE = %{

      }

      def self.extension
        ".mobi"
      end

      def initialize
        @chapters = []
      end

      def start_new_chapter(params)
        @body =  ""

        @chapters << [params[:title], @body]
        @body << "<h1>#{params[:header]}: #{params[:title]}</h1>"
      end

      def render(params)
        Dir.mktmpdir("bookie-mobi") do |dir|
          @chapters.each_with_index do |(title, content),index|
            File.open("#{dir}/#{index}.html", "w") do |f|
              template = File.read("#{Bookie::TEMPLATES_DIR}/html_chapter.erb")
              f << ERB.new(template).result(binding)
            end
          end

          File.open("#{dir}/book.opf", "w") do |f|
            template = File.read("#{Bookie::TEMPLATES_DIR}/opf.erb")
            f << ERB.new(template).result(binding)
          end

          `kindlegen #{dir}/book.opf -o #{params[:file]}`
          FileUtils.mv("#{dir}/#{params[:file]}", ".")
        end
      end
    end
  end
end
