# -*- coding: utf-8 -*-
require "pathname"
require "json"
require "open3"
require "paint"

# Namesspace of this libary.
module Qemu

  # The command used to execute <tt>qemu-img</tt>,
  # defaulting to <tt>qemu-img</tt>.
  def self.qemu_img_command
    @qemu_img_command ||= "qemu-img"
  end

  # Sets the command used to execute <tt>qemu-img</tt>.
  # Spaces are automatically escaped.
  def self.qemu_img_command=(str)
    @qemu_img_command = str
  end

  # Enable or disable debug output.
  def self.debug_mode=(val)
    @debug_mode = !!val
  end

  # True if debug output is enabled.
  def self.debug_mode?
    @debug_mode
  end

  # Execute <tt>qemu-img</tt>.
  # == Parameters
  # [*args]
  #   The arguments for <tt>qemu-img</tt>. May either be passed
  #   as a single array or as separate arguments.
  # == Raises
  # [CommandFailed]
  #   If the command returns a nonzero exitstatus.
  # == Return value
  # The command’s output on the standard output stream.
  def self.execute_qemu_img(*args)
    args = args.flatten

    if debug_mode?
      print "Execute: "
      puts [qemu_img_command].concat(args).map{|a| a.to_s =~ /\s/ ? "'#{a}'" : a}.join(" ")
    end

    output = nil
    status = Open3.popen3(qemu_img_command, *args.map(&:to_s)) do |stdin, stdout, stderr, thr|
      yield(stdin) if block_given?
      stdin.close

      output = stdout.read

      if debug_mode?
        puts output
        puts Paint[stderr.read, :yellow, :bold]
      end

      thr.value
    end

    raise(Qemu::Errors::CommandFailed.new(qemu_img_command, status.exitstatus)) unless status.exitstatus.zero?
    output
  end

end

require_relative "qemu/version"
require_relative "qemu/errors"
require_relative "qemu/image"
require_relative "qemu/image/raw"
require_relative "qemu/image/qcow2"
