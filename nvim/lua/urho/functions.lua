-- Custom utility functions

-- Unwrap prose paragraphs while preserving code blocks, lists, and headings
function UnwrapProse()
  local in_code_block = false
  local line_num = 1
  local total_lines = vim.fn.line('$')

  while line_num <= total_lines do
    local line = vim.fn.getline(line_num)

    -- Toggle code block flag
    if line:match('^```') then
      in_code_block = not in_code_block
      line_num = line_num + 1
      goto continue
    end

    -- Skip if in code block, blank line, list, or heading
    if in_code_block or
       line:match('^\%s*$') or
       line:match('^\%s*[-*]') or
       line:match('^#') then
      line_num = line_num + 1
      goto continue
    end

    -- If it's a prose paragraph (starts with letter)
    if line:match('^[A-Za-z]') then
      -- Find end of paragraph
      local end_line = line_num
      while end_line < total_lines do
        local next_line = vim.fn.getline(end_line + 1)
        if next_line:match('^\%s*$') or next_line:match('^```') then
          break
        end
        end_line = end_line + 1
      end

      -- Join the paragraph
      if end_line > line_num then
        vim.cmd(line_num .. ',' .. end_line .. 'j!')
      end

      -- Update total lines after joining
      total_lines = vim.fn.line('$')
    end

    line_num = line_num + 1
    ::continue::
  end

  print("Unwrapped prose paragraphs")
end

-- Create command
vim.api.nvim_create_user_command('UnwrapProse', UnwrapProse, {})
