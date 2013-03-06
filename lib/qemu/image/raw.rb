# The raw disk format, i.e., a simple plain blob of bytes
# without any fancy features. For a more versatile format,
# see Qemu::Image::QCow2.
class Qemu::Image::Raw < Qemu::Image

  # Loads an existing image without modifying it.
  # == Parameter
  # [path]
  #   The path to the image file.
  # == Raises
  # [RuntimeError]
  #   The image file was not in the +raw+ image format.
  # == Return value
  # The newly created instance.
  def self.from_image(path)
    path = Pathname.new(path).expand_path
    obj  = allocate
    info = JSON.parse(Qemu.execute_qemu_img("info", "--output=json", path))

    raise("Image not in 'raw' format: #{path}") unless info["format"] == "raw"

    obj.instance_eval do
      @path = path
      @size = info["virtual-size"]
    end

    obj
  end

  # Create a new raw image.
  # == Parameters
  # [path]
  #   The path to the file. This will not create parent
  #   directories. I recommend the <tt>.img</tt> file
  #   extension for raw images.
  # [size]
  #   The size of the image file, in bytes. Ensure you have
  #   this much space on your disk, otherwise this will fail
  #   badly.
  # == Return value
  # The newly created instance.
  # == Remarks
  # Depending on the specified size, this may take some time.
  def initialize(path, size)
    super(path, size)
    format!
  end

  private

  def format!
    Qemu.execute_qemu_img("create", "-f", "raw", path, size)
  end

end
