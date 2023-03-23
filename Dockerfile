# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM node:16.0.0-alpine AS development

RUN mkdir /project
WORKDIR /project

COPY . .

RUN yarn global add @vue/cli
RUN yarn global add serve
RUN yarn install
ENV HOST=0.0.0.0
RUN yarn build
CMD ["yarn", "run", "serve"]

FROM development as dev-envs
RUN <<EOF
apk update
apk add git
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
RUN yarn build
CMD ["yarn", "run", "serve"]