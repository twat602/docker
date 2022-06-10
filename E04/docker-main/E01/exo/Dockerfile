FROM node:latest

WORKDIR /home/server

COPY package*.json /home/server/package.json
COPY index.js /home/server/index.js

RUN npm install
#RUN npm i -g nodemon
EXPOSE 3000

ENTRYPOINT ["node"]

CMD ["index.js"]

