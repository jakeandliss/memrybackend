class Resource < ActiveRecord::Base
  belongs_to :entry
  after_create :reprocess_without_delay



  # Apply styling appropriate for this file
  has_attached_file :attachment,
                    styles: lambda { |a| a.instance.check_file_type},
                    default_url: "no_image.png",
                    processors: lambda { |a| a.processors},
                    only_process: [:thumb]

  # # Don't forget to add name of the image that will be shown while the file is loading
  #process_in_background :attachment, {
  #                                 only_process: [:original],
  #                                 processing_image_url: lambda { |a| a.instance.processing_image_path("vid-processing.jpg")}
  #                             }



  def reprocess_without_delay
    unless is_video_type?
      attachment.reprocess_without_delay!
      #update(avatar_processing: false)
    end
  end



  validates_attachment_content_type :attachment, :content_type => [
                                               /\Aaudio\/.*\Z/,
                                               /\Avideo\/.*\Z/,
                                               /\Aimage\/.*\Z/,
                                               "application/pdf"
                                           ] #See paperclip.rb initializer for other formats


  def processors
    if is_image_type?
      [:thumbnail, :compression]
    elsif is_video_type?
      [:transcoder]
    elsif is_audio_type?
      [:transcoder]
    end
  end

  # IMPORTANT! The ffmpeg library has to added to the server machine. 
  # It can be uploaded from the official website https://www.ffmpeg.org/
  def check_file_type
    if is_image_type?
      {
          :thumb => "300x300#",
          :original => "750x750>"
      }
    elsif is_video_type?
      {
          :thumb => { :format => 'jpg', :time => 5,
                      convert_options: {
                          output: {
                              vf: "crop=300:300"
                              # :output => {'c:v' => 'libx264', vprofile: 'high', preset: 'medium', 'b:v' => '750k', maxrate: '750k', bufsize: '1500k', pix_fmt: 'yuv420p', flags: '+mv4+aic', threads: 'auto', 'b:a' => '128k', strict: '-2'}
                          }
                      }
          },
          :original => {:geometry => "1024x576>", :format => 'mp4',
                        convert_options: {
                            output: {
                                'b:v' => "1000k",
                                'b:a' => '128k'
                                # :output => {'c:v' => 'libx264', vprofile: 'high', preset: 'medium', 'b:v' => '750k', maxrate: '750k', bufsize: '1500k', pix_fmt: 'yuv420p', flags: '+mv4+aic', threads: 'auto', 'b:a' => '128k', strict: '-2'}
                            }
                        }
          }
      }
    elsif is_audio_type?
      {
          :original => { :format => 'aac',
                         convert_options: {
                             output: {
                                 'b:a' => '128k'
                             }
                         }
          }
      }
    elsif is_doc_type?
      {}
    else
      {}
    end
  end

  # The path of the image that will be shown while the file is loading
  def processing_image_path(image_name)
    "/assets/" + Rails.application.assets.find_asset(image_name).digest_path
  end




  # Method returns true if file's content type contains word 'image', overwise false
  def is_image_type?
    attachment_content_type ? attachment_content_type =~ %r(image) : false
  end

  # Method returns true if file's content type contains word 'video', overwise false
  def is_video_type?
    attachment_content_type ? attachment_content_type =~ %r(video) : false
  end

  # Method returns true if file's content type contains word 'audio', overwise false
  def is_audio_type?
    attachment_content_type ? attachment_content_type =~ /\Aaudio\/.*\Z/ : false
  end

  def is_doc_type?
    attachment_content_type = ["application/pdf", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"]
  end
end
