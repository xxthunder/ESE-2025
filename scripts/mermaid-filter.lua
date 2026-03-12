-- Pandoc Lua filter: renders mermaid code blocks to SVG via mmdc
-- Usage: pandoc --lua-filter=mermaid-filter.lua

local counter = 0

function CodeBlock(block)
    if block.classes[1] == "mermaid" then
        counter = counter + 1
        local outdir = os.getenv("MERMAID_OUT_DIR") or "/tmp"
        local outfile = outdir .. "/mermaid-" .. counter .. ".png"
        local infile = os.tmpname()

        -- Write mermaid source to temp file
        local f = io.open(infile, "w")
        f:write(block.text)
        f:close()

        -- Render with mmdc
        local cmd = string.format(
            "mmdc -i %s -o %s -b white -s 2 --puppeteerConfigFile %s 2>/dev/null",
            infile, outfile,
            os.getenv("PUPPETEER_CONFIG") or "/dev/null"
        )
        os.execute(cmd)
        os.remove(infile)

        -- Return as image with absolute path
        local abs_path = io.popen("realpath " .. outfile):read("*l")
        return pandoc.Para({
            pandoc.Image({}, abs_path or outfile, "")
        })
    end
end
