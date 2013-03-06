class Qemu::Image::QCow2 < Qemu::Image

  def initialize(path, size, opts = {})
    super(path, size)

    if opts[:cluster_size] and (opts[:clust_size] < 512 or opts[:cluster_size] > 2097152) # 2MiB
      raise(ArgumentError, "Cluster size must be between 512 byte and 2 Mebibyte")
    end

    if opts[:preallocation] and opts[:preallocation] != :metadata
      raise(ArgumentError, "Invalid value for :preallocation: #{opts[:preallocation]}")
    end

    if opts[:lazy_refcounts] and opts[:compat] != "1.1"
      raise(ArgumentError, "Lazy refcounts can only be enabled if :compat is set to 1.1.")
    end

    @compat         = opts[:compat]
    @backing_file   = opts[:backing_file]
    @backing_fmt    = opts[:backing_fmt]
    @encryption     = opts[:encryption]
    @cluster_size   = opts[:cluster_size]
    @preallocation  = opts[:preallocation]
    @lazy_refcounts = opts[:lazy_refcounts]

    format!
  end

  def encrypted?
    @encryption
  end

  private

  def format!
    cmd = ["-f", "qcow2"]

    cmd << "-o" if @compat || @backing_file || @backing_fmt || @encryption || @cluster_size || @preallocation || @lazy_refcounts
    cmd << "compat=#@compat" if @compat
    cmd << "backing_file=#@backing_file" if @backing_file
    cmd << "backing_fmt=#@backing_fmt" if @backing_fmt
    cmd << "encryption=on" if @encryption
    cmd << "cluster_size=#@cluster_size" if @cluster_size
    cmd << "preallocation=#@preallocation" if @preallocation
    cmd << "lazy_refcounts=#@lazy_refcounts" if @lazy_refcounts

    cmd << path << size

    Qemu.execute_qemu_img(cmd)
  end

end
