require 'mini_magick'

module Sufia
  module GenericFile
    module Thumbnail
      # Create thumbnail requires that the characterization has already been run (so mime_type, width and height is available)
      # and that the object is already has a pid set
      def create_thumbnail
        return if self.content.content.nil?
        if pdf?
          create_pdf_thumbnail
        elsif image?
          create_image_thumbnail
        # elsif video?
        #   create_video_thumbnail
        end
      end

      def create_pdf_thumbnail
        retryCnt = 0
        stat = false;
        for retryCnt in 1..3
          begin
            pdf = MiniMagick::Image.read(content.content, "pdf")
            pdf.format("png", 1)
            pdf.resize("200x>")
            pdf.write("thumb.png")
            f = File.open("thumb.png")
            add_file_datastream(f, :dsid=>"thumbnail", :dsLabel => "File Datastream", :mime_type => "image/png", :label =>"File Datastream")
            File.delete("thumb.png")
            stat = self.save
            break
          rescue => e
            logger.warn "Rescued an error #{e.inspect} retry count = #{retryCnt}"
            sleep 1
          end
        end
        return stat
      end

      def create_image_thumbnail
        img=MiniMagick::Image.read(content.content, "jpg")
        img.resize "200x>"
        img.write  "thumb.jpg"
        f = File.open("thumb.jpg")
        add_file_datastream(f, :dsid=>"thumbnail", :dsLabel => "File Datastream", :mime_type => "image/jpeg", :label =>"File Datastream")
        File.delete("thumb.jpg")
        self.save
      end
    end
  end
end
