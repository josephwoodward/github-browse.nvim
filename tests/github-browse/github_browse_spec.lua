local gh = require("github-browse.browse")

describe("setup", function()
  it("works with default", function()
    assert("my first function with param = Hello!", gh.browse())
  end)
end)
