FROM node:16 as starter
RUN mkdir /build
WORKDIR /build
COPY . /build
#ENV http_proxy=http://172.27.226.11:10809
#ENV https_proxy=http://172.27.226.11:10809
#RUN npm config set http_proxy http://172.27.226.11:10809 && \
#    npm config set http_proxy http://172.27.226.11:10809 && \
#    npm config set http_proxy http://172.27.226.11:10809 && \
#    npm set strict-ssl false

RUN yarn
RUN yarn admin-codegen
RUN yarn commerce-codegen
RUN yarn admin-build
EXPOSE 4000
#ENV http_proxy=""
#ENV https_proxy=""

FROM node:16-alpine
COPY --from=starter /build /build
WORKDIR /build
CMD yarn admin --configuration=production --host 0.0.0.0

