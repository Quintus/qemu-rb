# Namespace for error classes.
module Qemu::Errors

  # Base class for errors in this library.
  class QemuError < StandardError
  end

  # Raised when some shellout went wrong.
  class CommandFailed < QemuError

    # The command executed.
    attr_reader :command
    # The exitstatus number it returned.
    attr_reader :exitstatus

    # Creates a new exception of this type. Pass in
    # the faulty command and the exitstatus it returned,
    # plus a nondefault error message if you want to.
    def initialize(command, exitstatus, msg = "#{command} failed with status #{exitstatus}.")
      @command    = command
      @exitstatus = exitstatus
      super(msg)
    end

  end

end
