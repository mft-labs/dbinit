FROM alpine:latest AS stage1
RUN mkdir /apps
WORKDIR /apps
COPY . /apps
RUN chmod +x /apps/dbmgr

FROM scratch
WORKDIR /apps
COPY --from=stage1 /apps/dbmgr /apps/dbmgr
COPY --from=stage1 /apps/dbinit.conf /apps/dbinit.conf
COPY --from=stage1 /apps/amf_schema.sql /apps/amf_schema.sql
ENTRYPOINT [ "/apps/dbmgr", "-conf", "/apps/dbinit.conf", "-schema", "/apps/amf_schema.sql" ]