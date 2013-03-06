require_relative "helpers"

describe Qemu::Image::Raw do

  before do
    @tmpdir = Pathname.new(Dir.mktmpdir)
  end

  after do
    FileUtils.rm_rf(@tmpdir)
  end

  it "should create a new blank image" do
    img = Qemu::Image::Raw.new(@tmpdir + "new.img", 4294967296) # 4 GiB

    assert_equal @tmpdir + "new.img", img.path
    assert_equal 4294967296, File::Stat.new(img.path).size
  end

end
