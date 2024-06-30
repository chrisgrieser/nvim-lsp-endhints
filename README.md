<!-- LTeX: enabled=false -->
# nvim-eol-lsp-hints 🪧
<!-- LTeX: enabled=true -->
<!-- TODO uncomment shields when available in dotfyle.com 
<a href="https://dotfyle.com/plugins/chrisgrieser/nvim-eol-lsp-hints">
<img alt="badge" src="https://dotfyle.com/plugins/chrisgrieser/nvim-eol-lsp-hints/shield"/></a>
-->

A minimal plugin that displays LSP inlay-hints at the end of line, out of your
way.

<img alt="Showcase" width=70% src="https://github.com/chrisgrieser/nvim-eol-lsp-hints/assets/73286100/acd538a7-f2ee-4b8e-9c07-bd7c0c4ad20e">

*Color scheme: nightfox.nvim, dawnfox variant*

<!-- toc -->

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Background](#background)
- [Limitations](#limitations)
- [About the author](#about-the-author)

<!-- tocstop -->

## Installation
**Requirements:**
- nvim >= 0.10
- LSP client that supports inlay hints (`textDocument/inlayHint`)

```lua
-- lazy.nvim
{
	"chrisgrieser/nvim-eol-lsp-hints",
	event = "LspAttach",
	opts = {},
},

-- packer
use {
	"chrisgrieser/nvim-eol-lsp-hints",
}
```

## Configuration

The `.setup()` call it required, and takes an optional table:

```lua
-- default settings
require("eol-lsp-hints").setup {
	icons = {
		type = "󰜁 ",
		parameter = "󰏪 ",
	},
	label = {
		padding = 1,
		marginLeft = 0,
	},
	autoEnableHints = true,
}
```

The hints use the default highlight group `LspInlayHint`.

## Usage
The plugin automatically enables inlay hints when attaching to an LSP, there is
nothing to do other than loading plugin. This behavior can be disabled with
`autoEnable = false`.

## Background
- [The LSP specification stipulates that inlay hints have a fixed position in
  the line, which Neovim core follows.](https://github.com/neovim/neovim/issues/28261#issuecomment-2194659088)
- This plugin overrides the `textDocument/inlayHint` handler to move the hints
  to the end of the line.
- [nvim-inlayhint](https://github.com/lvimuser/lsp-inlayhints.nvim) did pretty
  much the same thing for nvim < 0.10, but it is archived by now. Other than
  being maintained, `nvim-eol-lsp-hints` just overrides the handler introduced
  in nvim 0.10, resulting in a much simpler implementation.

## Limitations
Disabling LSP hints is not implemented yet.

<!-- vale Google.FirstPerson = NO -->
## About the author
In my day job, I am a sociologist studying the social mechanisms underlying the
digital economy. For my PhD project, I investigate the governance of the app
economy and how software ecosystems manage the tension between innovation and
compatibility. If you are interested in this subject, feel free to get in touch.

I also occasionally blog about vim: [Nano Tips for Vim](https://nanotipsforvim.prose.sh)

- [Academic Website](https://chris-grieser.de/)
- [Mastodon](https://pkm.social/@pseudometa)
- [ResearchGate](https://www.researchgate.net/profile/Christopher-Grieser)
- [LinkedIn](https://www.linkedin.com/in/christopher-grieser-ba693b17a/)

<a href='https://ko-fi.com/Y8Y86SQ91' target='_blank'><img
	height='36'
	style='border:0px;height:36px;'
	src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3'
	border='0'
	alt='Buy Me a Coffee at ko-fi.com'
/></a>
