class Message < ActiveRecord::Base
  belongs_to :card
  after_save :enqueue_image 
  after_save :enqueue_audio 
  mount_uploader :audio, AudioUploader
  mount_uploader :photo, PhotoUploader

  def enqueue_image
    ImageWorker.perform_async(id, key) if key.present?
  end

  def enqueue_audio
    AudioWorker.perform_async(id, key) if key.present?
  end

  def image_name
    File.basename(image.path || image.filename) if image
  end

  validates_presence_of :audio, :image

  class ImageWorker
    include Sidekiq::Worker
    
    def perform(id, key)
      photo = Photo.find(id)
      painting.key = key
      painting.remote_image_url = painting.image.direct_fog_url(with_path: true)
      painting.save!
      painting.update_column(:image_processed, true)
    end
  end

  class AudioWorker
    include Sidekiq::Worker
    
    def perform(id, key)
      audio = Audio.find(id)
      audio.key = key
      audio.remote_image_url = audio.image.direct_fog_url(with_path: true)
      audio.save!
      audio.update_column(:image_processed, true)
    end
  end

end
