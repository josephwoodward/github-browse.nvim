local gh = require("github-browse.browse")

describe("setup", function()
  it("should work with default values", function()
    assert(gh.browse(), "browse successfully")
  end)

  it("should work with custom values", function()
    gh.setup({ opt = "custom" })
    assert(gh.browse() == "custom", "does not provide custom value")
  end)
end)
