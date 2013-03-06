class Qemu::Image

  # Absolute Pathname instance pointing to the image file.
  attr_reader :path
  # The image size in bytes.
  attr_reader :size

  def initialize(path, size)
    @path = Pathname.new(path).expand_path
    @size = size.to_i
  end

end
