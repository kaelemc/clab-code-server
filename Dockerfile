ARG TARGETPLATFORM
FROM --platform=$TARGETPLATFORM codercom/code-server:latest


RUN URL=$(curl -s https://api.github.com/repos/srl-labs/vscode-containerlab/releases/latest \
    | grep browser_download_url \
    | grep vsix \
    | cut -d'"' -f4) && curl -L -o extension.vsix "$URL"

COPY config.yaml /config.yaml

EXPOSE 8080

RUN sudo code-server --install-extension extension.vsix --extensions-dir /extensions