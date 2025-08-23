ARG BUILDPLATFORM
ARG TARGETPLATFORM

FROM --platform=$BUILDPLATFORM node:24-alpine AS builder

RUN apk add --no-cache git curl jq

RUN LATEST_TAG=$(curl -s https://api.github.com/repos/srl-labs/vscode-containerlab/releases/latest | jq -r '.tag_name') && \
    git clone --depth 1 --branch "$LATEST_TAG" https://github.com/srl-labs/vscode-containerlab.git

WORKDIR /vscode-containerlab

RUN --mount=type=cache,target=/root/.npm npm install
RUN npm run package

FROM --platform=$TARGETPLATFORM codercom/code-server:latest

COPY --from=builder /vscode-containerlab/*.vsix /vsix/
COPY config.yaml /home/coder/.config/code-server/config.yaml

EXPOSE 8080

RUN code-server --install-extension /vsix/*.vsix