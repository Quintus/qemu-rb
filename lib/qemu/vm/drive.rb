# Instances of this class represennt a virtual drive in a VM.
class Qemu::VM::Drive

  attr_accessor :options
  attr_accessor :media

  def initialize(args)
    @options = args.dup
    @media   = @options.delete(:media) # nil if not given
  end

end
