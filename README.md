Converts image files for [Overview](https://github.com/overview/overview-server).

# Methodology

This program always outputs `0.json`, `0.txt`, `0.blob`, and a thumbnail:
`0-thumbnail.png` or `0-thumbnail.jpg`.

If JSON specifies `wantOcr`, runs [tesseract](https://github.com/tesseract-ocr/tesseract/)
with `pdf` and `txt` configurations to generate `0.blob` and `0.txt`. The
output `0.json`'s `metadata` will include `"isFromOcr":true`.

Otherwise, `img2pdf` wraps the input image into a PDF for `0.blob`, and
`0.txt` is empty. (`img2pdf` requires an entire Python environment; but that's
peanuts next the `tesseract-ocr` datafiles, and the other viable alternative
is `pdflatex`, which is ~250MB larger.)

The output `0.json` has `wantOcr:false` and `wantSplitByPage:false`. That
makes the output is ready for viewing: no further conversions are needed.

# Testing

Write to `test/test-*`. `docker build .` will run the tests.

Each test has `input.blob` (which means the same as in production) and
`input.json` (whose contents are `$1` in `do-convert-single-file`). The files
`stdout`, `0.json`, `0.blob`, `0.txt`, and `0-thumbnail.(png|jpg)` in the
test directory are expected values. If actual values differ from expected
values, the test fails.

PDF, PNG and JPEG are tricky formats to get exactly right. You may need to use
the Docker image itself to generate expected output files. For instance, this is
how we built `test/test-jpg-ocr/0-thumbnail.jpg`:

1. Wrote `test/test-jpg-ocr/{input.json,input.blob,0.txt,0.blob,stdout}`
1. Ran `docker build .`. The end of the output looked like this:
    Step 12/13 : RUN [ "/app/test-convert-single-file" ]
     ---> Running in f65521f3a30c
    1..3
    Tesseract Open Source OCR Engine v3.04.01 with Leptonica
    not ok 1 - test-jpg-ocr
        do-convert-single-file wrote /tmp/test-do-convert-single-file912093989/0-thumbnail.jpg, but we expected it not to exist
    ...
1. `docker cp f65521f3a30c:/tmp/test-do-convert-single-file912093989/0-thumbnail.jpg test/test-jpg-ocr/`
1. `docker rm -f f65521f3a30c`
