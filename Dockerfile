# use Cypress provided image with all dependencies included
FROM cypress/base:12

# use a work directory
WORKDIR /app

# copy our test page and test files
COPY cypress.json package.json package-lock.json reporter-config.json ./ 
COPY cypress ./cypress
COPY requirements.txt ./



RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y dbus-x11 google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*

# print version of current software


# install software
RUN apt-get update && apt-get install -y zip
RUN npm install
RUN npm install cypress --save-dev
RUN npm install npm-run-all --save-dev
RUN npm install --save-dev mocha cypress-multi-reporters mochawesome
RUN npm install mochawesome-merge --save-dev


# versions of local tools
RUN node -v
RUN npm -v
RUN yarn -v
RUN google-chrome --version
RUN zip --version
RUN git --version
RUN npm cypress --version

# run test cases

RUN npm run e2e

# generate report
RUN npm run report
