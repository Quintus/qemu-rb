class Qemu::VM

  attr_reader :image
  attr_reader :architecture
  attr_reader :pid
  attr_accessor :options
  attr_accessor :drives

  def initialize(image, architecture = "x86_64")
    @image        = image
    @architecture = architecture
    @pid          = nil
    @options      = []
    @last_index   = -1
    @drives       = []
  end

  def boot
    Dir.mktmpdir("qemu-rb") do |tmpdir|
      # TODO: Add drives!
      Qemu.execute_qemu_system(@architecture,
                               "-daemonize",
                               "-pidfile",
                               File.join(tmpdir, "qemu.pid"),
                               *@options)

      @pid = File.read(File.join(tmpdir, "qemu.pid")).to_i
    end
  end

  def enable_kvm
    @options << "-enable-kvm"
  end

  def kvm_enabled?
    @options.include?("-enable-kvm")
  end

  def add_drive(args)
    @drives << args.kind_of?(Qemu::VM::Drive) ? args << Qemu::VM::Drive.new(args)
  end

  def add_cdrom(path)
    @drives << Qemu::VM::Drive.new(file: Pathname.new(path).expand_path,
                                   index: next_index,
                                   media: :cdrom)

    def add_disk(path)
      @drives << Qemu::VM::Drive.new(file: Pathname.new(path).expand_path,
                                     index: next_index,
                                     media: :disk)

  def cdrom_drives
    @drives.select{|drive| drive.media == :cdrom}
  end

  def disk_drives
    @drives.select{|drive| drive.media == :disk}
  end

  private

  def next_index
    @last_index += 1
  end

end
