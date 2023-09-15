return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>hy",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon Yank file",
      },
      {
        "<leader>ha",
        function()
          require("harpoon.mark").nav_file(1)
        end,
        desc = "Harpoon goto 1",
      },
      {
        "<leader>hs",
        function()
          require("harpoon.mark").nav_file(2)
        end,
        desc = "Harpoon goto 2",
      },
      {
        "<leader>hd",
        function()
          require("harpoon.mark").nav_file(3)
        end,
        desc = "Harpoon goto 3",
      },
      {
        "<leader>hf",
        function()
          require("harpoon.mark").nav_file(4)
        end,
        desc = "Harpoon goto 4",
      },
      {
        "<leader>hp",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Harpoon Preview",
      },
    },
  },
}
