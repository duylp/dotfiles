-- Patch nvim-treesitter (master branch) predicates/directives broken by the
-- vim.treesitter.query.iter_matches API change: on Neovim 0.11+, match values
-- are lists of nodes (to support capture quantifiers), not single nodes.
-- nvim-treesitter's master branch is in maintenance mode; remove this file
-- once you migrate to the `main` branch or upstream ships a fix.

local tsq = vim.treesitter.query
local get_text = vim.treesitter.get_node_text

local function node(match, id)
  local n = match[id]
  if type(n) == 'table' then n = n[#n] end
  return n
end

local aliases = { ex = 'elixir', pl = 'perl', sh = 'bash', uxn = 'uxntal', ts = 'typescript' }
local script_types = {
  importmap = 'json',
  module = 'javascript',
  ['application/ecmascript'] = 'javascript',
  ['text/ecmascript'] = 'javascript',
}
local opts = { force = true, all = true }

tsq.add_predicate('nth?', function(m, _, _, p)
  local n, idx = node(m, p[2]), tonumber(p[3])
  if n and n:parent() and n:parent():named_child_count() > idx then
    return n:parent():named_child(idx) == n
  end
  return false
end, opts)

tsq.add_predicate('is?', function(m, _, bufnr, p)
  local n = node(m, p[2])
  if not n then return true end
  local _, _, kind = require('nvim-treesitter.locals').find_definition(n, bufnr)
  return vim.tbl_contains(vim.list_slice(p, 3), kind)
end, opts)

tsq.add_predicate('kind-eq?', function(m, _, _, p)
  local n = node(m, p[2])
  if not n then return true end
  return vim.tbl_contains(vim.list_slice(p, 3), n:type())
end, opts)

tsq.add_directive('set-lang-from-mimetype!', function(m, _, bufnr, p, meta)
  local n = node(m, p[2])
  if not n then return end
  local v = get_text(n, bufnr)
  local configured = script_types[v]
  if configured then
    meta['injection.language'] = configured
  else
    local parts = vim.split(v, '/', {})
    meta['injection.language'] = parts[#parts]
  end
end, opts)

tsq.add_directive('set-lang-from-info-string!', function(m, _, bufnr, p, meta)
  local n = node(m, p[2])
  if not n then return end
  local alias = get_text(n, bufnr):lower()
  meta['injection.language'] = vim.filetype.match({ filename = 'a.' .. alias })
    or aliases[alias]
    or alias
end, opts)

tsq.add_directive('downcase!', function(m, _, bufnr, p, meta)
  local id = p[2]
  local n = node(m, id)
  if not n then return end
  local text = get_text(n, bufnr, { metadata = meta[id] }) or ''
  meta[id] = meta[id] or {}
  meta[id].text = text:lower()
end, opts)
