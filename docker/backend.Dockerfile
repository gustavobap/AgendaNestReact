FROM ruby:alpine3.20 AS base

ARG PROJECT

ARG UNAME
ARG UID
ARG UPASSWORD

ARG GIT_UNAME
ARG GIT_UEMAIL

RUN apk --no-cache add build-base tzdata bash
RUN apk --no-cache add postgresql-dev
RUN apk --no-cache add git vim

RUN adduser -S -G wheel \
    --uid "${UID}" \
    "${UNAME}"

RUN echo "${UNAME}:${UPASSWORD}" | chpasswd;

FROM base as development

ARG PROJECT
ARG UNAME
ARG GIT_UNAME
ARG GIT_UEMAIL

RUN apk --no-cache add bash
RUN apk --no-cache add --update nodejs npm
RUN npm i -g @nestjs/cli
RUN npm i -g typeorm

RUN apk --no-cache add sudo busybox-suid
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

USER ${UNAME}
WORKDIR "/home/${UNAME}/${PROJECT}"

RUN git config --global user.name "${GIT_UNAME}"
RUN git config --global user.email "${GIT_UEMAIL}"

ENTRYPOINT ["/bin/bash"]

FROM base as production

ARG PROJECT
ARG UNAME
ARG WORKD="/home/${UNAME}/${PROJECT}"

COPY --chown=${UNAME}:wheel "./home/${PROJECT}" ${WORKD}
RUN chown -R ${UNAME} "/home/${UNAME}"

USER ${UNAME}
WORKDIR ${WORKD}

ENTRYPOINT npm run seed && npm run start:dev