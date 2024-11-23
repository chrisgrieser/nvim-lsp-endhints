<!-- LTeX: enabled=false -->
# nvim-lsp-endhints 🪧
<!-- LTeX: enabled=true -->
<a href="https://dotfyle.com/plugins/chrisgrieser/nvim-lsp-endhints">
<img alt="badge" src="https://dotfyle.com/plugins/chrisgrieser/nvim-lsp-endhints/shield"/></a>

Minimal plugin that displays LSP inlay hints at the end of the line, rather than
within the line.

<img alt="Showcase" width=70% src="https://github.com/chrisgrieser/nvim-lsp-endhints/assets/73286100/57894d2f-2c82-4e42-b1e3-ab103c928020">

*Color scheme: nightfox.nvim, dawnfox variant*

## Table of Contents

<!-- toc -->

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Background](#background)
- [FAQ](#faq)
  * [How to display hints only for the current line?](#how-to-display-hints-only-for-the-current-line)
  * [How to enable inlay hints for a language?](#how-to-enable-inlay-hints-for-a-language)
- [About the author](#about-the-author)

<!-- tocstop -->

## Installation
**Requirements**
- nvim >= 0.10
- LSP client that supports inlay hints (`textDocument/inlayHint`)
- Inlay hints enabled in the config of the LSP

```lua
-- lazy.nvim
{
	"chrisgrieser/nvim-lsp-endhints",
	event = "LspAttach",
	opts = {}, -- required, even if empty
},

-- packer
use {
	"chrisgrieser/nvim-lsp-endhints",
}
```

## Configuration
The `.setup()` call is required.

```lua
-- default settings
require("lsp-endhints").setup {
	icons = {
		type = "󰜁 ",
		parameter = "󰏪 ",
		offspec = " ", -- hint kind not defined in official LSP spec
		unknown = " ", -- hint kind is nil
	},
	label = {
		padding = 1,
		marginLeft = 0,
		sameKindSeparator = ", ",
	},
	autoEnableHints = true,
}
```

The hints use the default highlight group `LspInlayHint`.

## Usage
By default, the plugin automatically enables inlay hints when attaching to an
LSP, there is nothing to do other than loading the plugin.

All regular inlay hint functions like `vim.lsp.inlay_hint.enable()` work the
same as before. Use them [as described in the Neovim
documentation](https://neovim.io/doc/user/lsp.html#vim.lsp.inlay_hint.enable())
to enable/disable/toggle hints manually.

You can switch between displaying inlay hints at the end of the line (this plugin)
and within the line (Neovim default) by using the `enable`, `disable` and `toggle`
functions:

```lua
-- inlay hints will show at the end of the line (default)
require("lsp-endhints").enable()

-- inlay hints will show as if the plugin was not installed
require("lsp-endhints").disable()

-- toggle between the two
require("lsp-endhints").toggle()
```

## Background
- [The LSP specification stipulates that inlay hints have a fixed position in
  the line, which Neovim core follows.](https://github.com/neovim/neovim/issues/28261#issuecomment-2194659088)
- However, for many people, hints being positioned within the line disturbs the
  flow of vim motions. This is particularly troublesome for languages with long
  type hints, such as TypeScript.
- [nvim-inlayhint](https://github.com/lvimuser/lsp-inlayhints.nvim) did pretty
  much the same thing for nvim < 0.10, but it is archived by now. Other than
  being maintained, `nvim-lsp-endhints` just overrides the
  `textDocument/inlayHint` handler introduced in nvim 0.10, resulting in a much
  simpler and more maintainable implementation (~250 LoC instead of ~1000 LoC).

## FAQ

### How to display hints only for the current line?
That is not supported by the plugin. However, [it only takes a small snippet to
implement it
yourself.](https://github.com/neovim/neovim/issues/28261#issuecomment-2130338921)
(Note that the linked snippet is not compatible with this plugin.)

### How to enable inlay hints for a language?

> [!NOTE]
> Not all LSPs support inlay hints. The following list is not exhaustive,
> there are more LSPs that support inlay hints. Please refer to your LSP's
> documentation.

```lua
-- lua-ls
require("lspconfig").lua_ls.setup {
	settings = {
		Lua = {
			hint = { enable = true },
		},
	},
}

-- tsserver
local inlayHints = {
	includeInlayParameterNameHints = "all",
	includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	includeInlayFunctionParameterTypeHints = true,
	includeInlayVariableTypeHints = true,
	includeInlayVariableTypeHintsWhenTypeMatchesName = false,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}
require("lspconfig").tsserver.setup {
	settings = {
		typescript = {
			inlayHints = inlayHints,
		},
		javascript = {
			inlayHints = inlayHints,
		},
	},
}

-- gopls
require("lspconfig").gopls.setup {
	settings = {
		hints = {
			rangeVariableTypes = true,
			parameterNames = true,
			constantValues = true,
			assignVariableTypes = true,
			compositeLiteralFields = true,
			compositeLiteralTypes = true,
			functionTypeParameters = true,
		},
	},
}

-- clangd
require("lspconfig").clangd.setup {
	settings = {
		clangd = {
			InlayHints = {
				Designators = true,
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true,
			},
			fallbackFlags = { "-std=c++20" },
		},
	},
}
```

## About the author
In my day job, I am a sociologist studying the social mechanisms underlying the
digital economy. For my PhD project, I investigate the governance of the app
economy and how software ecosystems manage the tension between innovation and
compatibility. If you are interested in this subject, feel free to get in touch.

I also occasionally blog about vim: [Nano Tips for Vim](https://nanotipsforvim.prose.sh)

- [Website](https://chris-grieser.de/)
- [Mastodon](https://pkm.social/@pseudometa)
- [ResearchGate](https://www.researchgate.net/profile/Christopher-Grieser)
- [LinkedIn](https://www.linkedin.com/in/christopher-grieser-ba693b17a/)

<a href='https://ko-fi.com/Y8Y86SQ91' target='_blank'><img height='36'
style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3'
border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
