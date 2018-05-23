-- Rewrite relative links to other docs by replacing .md with .html, accounting
-- for anchors into specific sections.
--
function rewrite_link (el)
    -- The regexp equivalent is roughly \.md(#|$), refer to
    -- https://www.lua.org/manual/5.3/manual.html#6.4.1
    --
    local dot_md = "%.md%f[#\0]"
    local href = el.target

    if (not href:match("^[^:]+://") and href:match(dot_md)) then
        return pandoc.Link(
            el.content,
            href:gsub(dot_md, ".html"),
            el.title,
            el.attr
        )
    else
        return el
    end
end

return { { Link = rewrite_link } }
