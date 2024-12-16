FROM --platform=$TARGETPLATFORM node:18-alpine

# Create app directory and non-root user
RUN mkdir -p /usr/src/app && \
    addgroup -S notifications && \
    adduser -S telegram -G notifications && \
    chown -R telegram:notifications /usr/src/app

# Set working directory
WORKDIR /usr/src/app

# Switch to non-root user
USER telegram

# Copy package files with correct ownership
COPY --chown=telegram:notifications package.json package-lock.json ./

# Install dependencies
RUN npm install && npm cache clean --force

# Copy application code with correct ownership
COPY --chown=telegram:notifications . .

HEALTHCHECK CMD ["npm", "run", "healthcheck"]
CMD ["npm", "run", "start"]
