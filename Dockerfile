FROM jupyter/base-notebook

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    cmake \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Rust installation
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN wget https://raw.githubusercontent.com/rust-lang/rustup/master/rustup-init.sh ;\ 
    chmod +x rustup-init.sh;\
    ./rustup-init.sh -y --no-modify-path;\
    rm  rustup-init.sh;\
    rustup --version; \
    cargo --version; \
    rustc --version; \
    cargo install evcxr_jupyter
RUN rustup component add rls rust-analysis rust-src

#Jupyter setting
USER 1000
RUN pip install --user jupytext;\
    pip install --user jupyterlab_vim;\
    pip install --user jupyterlab-vimrc;\
    pip install --user jupyterlab-lsp;\
    evcxr_jupyter --install;\
    wget https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz -O - | gunzip -c - > ~/.local/bin/rust-analyzer;\
    chmod +x ~/.local/bin/rust-analyzer
