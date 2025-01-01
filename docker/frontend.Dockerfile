FROM alpine:3.20 AS development

ARG PROJECT

ARG SERVER_IP
ARG API_PORT

ARG UNAME
ARG UID
ARG UPASSWORD
ARG UHOME="/home/${UNAME}"

ARG GIT_UNAME
ARG GIT_UEMAIL

RUN apk --no-cache add bash
RUN apk --no-cache add --update nodejs yarn

RUN adduser -S \
    --gecos "" \
    --home "${UHOME}" \
    --ingroup "wheel" \
    --uid "${UID}" \
    "${UNAME}"
RUN chown -R ${UNAME} "${UHOME}"
RUN echo "${UNAME}:${UPASSWORD}" | chpasswd;

RUN apk --no-cache add git vim sudo busybox-suid
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

RUN yarn global add serve

USER ${UNAME}
WORKDIR "/${UHOME}/${PROJECT}"

RUN git config --global user.name "${GIT_UNAME}"
RUN git config --global user.email "${GIT_UEMAIL}"

ENV REACT_APP_SERVER_IP=${SERVER_IP}
ENV REACT_APP_API_PORT=${API_PORT}

ENTRYPOINT ["/bin/bash"]

FROM development as build

ARG PROJECT
ARG WORKD="/tmp/${PROJECT}"

USER root
COPY "./home/${PROJECT}" ${WORKD}
WORKDIR ${WORKD}

RUN yarn
RUN yarn build

FROM httpd:2.4-alpine AS production

ARG PROJECT
ARG WORKD="/usr/local/apache2/htdocs"

RUN apk --no-cache add bash
COPY --from=build "/tmp/${PROJECT}/build" ${WORKD}