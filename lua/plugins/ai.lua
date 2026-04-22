return {
  {
    "yetone/avante.nvim",
    opts = {
      -- ui = {
      --   input = {
      --     provider = "snacks",
      --   },
      -- },
    input = {
      provider = "snacks",
      provider_opts = {
        title = "Avante Input",
        icon = "󰭻 ",
      },
    },
      provider = "openai",
      providers = {
        openai = {
          endpoint = "http://10.167.236.50:1234/v1",
          model = "broadcom/gemma-4-31b",
          timeout = 30000, -- 30 seconds
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },
    },
  },
}
