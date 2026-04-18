FROM --platform=$TARGETPLATFORM node:24-alpine3.23

ENV NODE_ENV=production

RUN apk add --no-cache su-exec \
    && mkdir -p /usr/src/app \
    && chown -R node:node /usr/src/app
WORKDIR /usr/src/app

COPY --chown=node:node package.json package-lock.json /usr/src/app/
RUN npm ci --omit=dev && npm cache clean --force
COPY --chown=node:node . /usr/src/app
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
HEALTHCHECK CMD ["npm", "run", "healthcheck"]
CMD ["npm", "run", "start"]
