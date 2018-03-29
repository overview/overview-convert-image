Converts image files for [Overview](https://github.com/overview/overview-server).

# Methodology

This program always outputs `0.json`, `0.txt`, `0.blob`, and a thumbnail:
`0-thumbnail.png` or `0-thumbnail.jpg`.

If JSON specifies `wantOcr`, runs [tesseract](https://github.com/tesseract-ocr/tesseract/)
with `pdf` and `txt` configurations to generate `0.blob` and `0.txt`.

Otherwise, `pdflatex` wraps the input image into a PDF for `0.blob`, and
`0.txt` is empty.

The output `0.json` has `wantOcr:false` and `wantSplitByPage:false`. That
makes the output is ready for viewing: no further conversions are needed.
