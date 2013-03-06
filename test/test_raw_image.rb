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

  it "should properly load existing images" do
    `qemu-img create -f raw #@tmpdir/foo.img 1G`
    img = Qemu::Image::Raw.from_image(@tmpdir + "foo.img")

    assert_equal @tmpdir + "foo.img", img.path
    assert_equal 1073741824, img.size
  end

end
