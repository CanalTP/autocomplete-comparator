FROM node:8-alpine as client
WORKDIR /client
ARG GOOGLE_KEY=""
ENV REACT_APP_GOOGLE_KEY ${GOOGLE_KEY}
COPY . .
RUN yarn install && yarn build

FROM node:8-alpine
WORKDIR /app
COPY --from=client /client/build build
COPY yarn.lock package.json ./
RUN yarn install --production && yarn global add pm2 && yarn cache clean --force
COPY server.js ./
EXPOSE 9000
USER node
CMD ["pm2", "start", "server.js", "--name", "autocomplete-comparator", "--no-daemon"]
