FROM overview/overview-converter-framework:0.0.3 AS framework
# multi-stage build

FROM debian:stretch-slim AS build
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    imagemagick \
    jq \
    tesseract-ocr \
    tesseract-ocr-ara \
    tesseract-ocr-cat \
    tesseract-ocr-deu \
    tesseract-ocr-eng \
    tesseract-ocr-fra \
    tesseract-ocr-ita \
    tesseract-ocr-nld \
    tesseract-ocr-nor \
    tesseract-ocr-por \
    tesseract-ocr-rus \
    tesseract-ocr-spa \
    tesseract-ocr-swe \
    texlive-base \
    texlive-latex-extra \
  && apt-get clean -y \
  && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /var/log/* /tmp/* /var/tmp/*

WORKDIR /app
# The framework provides the main executable
COPY --from=framework /app/run /app/run
COPY --from=framework /app/convert-single-file /app/convert
COPY ./0.latex /app/0.latex
COPY ./do-convert-single-file /app/do-convert-single-file
