FROM alpine:3.19.1
# Check latest alpine version: https://endoflife.date/alpine

# TODO: Follow the rule "Don't use Alpine Linux for Python images"
# But use the Debian-based python:3.12-slim or later (https://endoflife.date/python)
# However, python is required by texliveonfly package, only. (see below)

LABEL maintainer="Christoph P. Neumann"

RUN apk update && apk add --no-cache bash zsh make zip unzip curl gnupg perl python3 py3-pip

# installation settings
ARG TL_MIRROR="https://texlive.info/CTAN/systems/texlive/tlnet"
ARG TL_YEAR="2024"

RUN apk update && apk add --no-cache fontconfig libgcc && \
    mkdir "/tmp/texlive" && cd "/tmp/texlive" && \
    wget "$TL_MIRROR/install-tl-unx.tar.gz" && \
    tar xzvf ./install-tl-unx.tar.gz && \
    ( \
        echo "selected_scheme scheme-minimal" && \
        echo "instopt_adjustpath 0" && \
        echo "tlpdbopt_install_docfiles 0" && \
        echo "tlpdbopt_install_srcfiles 0" && \
        echo "TEXDIR /opt/texlive/${TL_YEAR}" && \
        echo "TEXMFLOCAL /opt/texlive/texmf-local" && \
        echo "TEXMFSYSCONFIG /opt/texlive/${TL_YEAR}/texmf-config" && \
        echo "TEXMFSYSVAR /opt/texlive/${TL_YEAR}/texmf-var" && \
        echo "TEXMFHOME ~/.texmf" \
    ) > "/tmp/texlive.profile" && \
    "./install-tl-${TL_YEAR}"*"/install-tl" --location "$TL_MIRROR" -profile "/tmp/texlive.profile" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl.log" && \
    rm -vrf /tmp/*

ENV PATH="${PATH}:/opt/texlive/${TL_YEAR}/bin/x86_64-linuxmusl"

# Texlive scheme:
RUN tlmgr install scheme-basic
# Alternatives: scheme-small, scheme-medium, scheme-full
# cf. https://tex.stackexchange.com/questions/397174/minimal-texlive-installation

# Latex fonts:
RUN tlmgr install collection-fontsrecommended marvosym fontawesome fontawesome5
# Optional: collection-fontsextra

# Essential latex tools:
RUN tlmgr install latexmk texliveonfly
# latexmk      req. perl
# texliveonfly req. python

# Essential latex packages (scholary computer science context):
RUN tlmgr install ieeetran biblatex biblatex-ieee biber hypdoc ncctools sttools babel babel-english babel-german xcolor microtype pgf

# Personal/opinionated latex package selection:
RUN tlmgr install csquotes paralist relsize lipsum orcidlink xpatch subfig caption

WORKDIR /app

ENV USER=app
ENV GROUPNAME=$USER
ENV UID=10000
ENV GID=10001

RUN addgroup \
    --gid "$GID" \
    $GROUPNAME \
 && adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$GROUPNAME" \
    --no-create-home \
    --uid "$UID" \
    $USER \
 && chown -R $USER:$GROUPNAME /app

USER $USER:$GROUPNAME

CMD make dist