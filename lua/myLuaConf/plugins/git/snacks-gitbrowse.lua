-- ============================================================================
-- SNACKS GITBROWSE CONFIGURATION
-- ============================================================================
-- Open files and repositories in browser (GitHub, GitLab, etc.)
-- Features:
-- - Smart URL generation for different git hosts
-- - Line number preservation
-- - Branch and commit support
-- - Supports GitHub URL patterns
-- 
-- Key mappings:
-- <leader>gB - Browse current file/repository in browser
-- ============================================================================

return {
  -- Open files in browser (GitHub, GitLab, etc.)
  gitbrowse = {
    enabled = true,
    url_patterns = {
      ['github.com'] = {
        branch = '/tree/{branch}',
        file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
        commit = '/commit/{commit}',
      },
    },
  },
}