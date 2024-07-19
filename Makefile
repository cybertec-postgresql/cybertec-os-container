
# Define Default if Values not exist
BASE_IMAGE ?= rockylinux:9
BASEOS ?= rocky9
CONTAINERIMAGE ?= rockylinux/rockylinux:9-ubi-micro
IMAGE_REPOSITORY ?= docker.io
IMAGE_PATH ?= cybertec-pg-container
CONTAINERSUITE ?= cybertec-pg-container
PGVERSION ?= 16
PGVERSION_FULL ?= 16.3
OLD_PG_VERSIONS ?= 13 14 15
PATRONI_VERSION ?= 3.3.1
PGBACKREST_VERSION ?= 2.52.1
POSTGIS_VERSION ?= 34
FERRETDBVERSION ?= v1.22.0
PACKAGER ?= dnf
BUILD ?= 1
ARCH ?= amd64
IMAGE_TAG ?= $(BASEOS)-$(PGVERSION_FULL)-$(BUILD)
POSTGIS_IMAGE_TAG ?= $(BASEOS)-$(PGVERSION_FULL)-$(POSTGIS_VERSION)-$(BUILD)

# Public-Beta
PUBLICBETA ?= 2
BETAVERSION ?= 17

# Settings for the Build-Process
BUILDWITH ?= docker
ROOTPATH ?= $(GOPATH)/src/github.com/cybertec/cybertec-pg-container

# Build Images

all: base pgbackrest postgres
base: base
pgbackrest: pgbackrest
postgres: base postgres
postgres-stage: base postgres-stage
postgres-gis: base postgres-gis
postgres-oracle: base postgres-oracle
pgbouncer: pgbouncer
ferrtedb: ferretdb
exporter: exporter
publicbeta: publicbeta-pg publicbeta-pgbackrest

base-build:
		docker build $(ROOTPATH)								\
			--file $(ROOTPATH)/docker/base/Dockerfile 		 	\
			--tag cybertec-pg-container/base:$(BASEOS)-$(BUILD) \
			--build-arg BASE_IMAGE=$(BASE_IMAGE)				\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)	\
			--build-arg BASEOS=$(BASEOS) 						\
			--build-arg PACKAGER=$(PACKAGER) 					\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 		

base: base-build;		

pgbackrest-build:
		docker build $(ROOTPATH)											\
			--file $(ROOTPATH)/docker/pgbackrest/Dockerfile 				\
			--tag cybertec-pg-container/pgbackrest:$(IMAGE_TAG) 	\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)							\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 					\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)				\
			--build-arg BASEOS=$(BASEOS)									\
			--build-arg PACKAGER=$(PACKAGER)								\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE)					\
			--build-arg BUILD=$(BUILD)										\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION)			\
			--build-arg OLD_PG_VERSIONS="$(OLD_PG_VERSIONS)"				\
			--build-arg PGVERSION=$(PGVERSION)

pgbackrest: pgbackrest-build;
			
postgres-build:
		docker build $(ROOTPATH)												\
			--file $(ROOTPATH)/docker/postgres/Dockerfile 						\
			--tag cybertec-pg-container/postgres:$(IMAGE_TAG)	\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)								\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 						\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)					\
			--build-arg BASEOS=$(BASEOS) 										\
			--build-arg PACKAGER=$(PACKAGER) 									\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 						\
			--build-arg BUILD=$(BUILD) 											\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION) 				\
			--build-arg PATRONI_VERSION=$(PATRONI_VERSION) 						\
			--build-arg OLD_PG_VERSIONS="$(OLD_PG_VERSIONS)"					\
			--build-arg PGVERSION=$(PGVERSION)									\
			--build-arg ARCH=$(ARCH)			

postgres: postgres-build

postgres-stage-build:
		docker build $(ROOTPATH)															\
			--file $(ROOTPATH)/docker/postgres-stage/Dockerfile 							\
			--tag cybertec-pg-container/postgres-stage:$(PGVERSION_FULL)					\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)											\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 									\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)								\
			--build-arg BASEOS=$(BASEOS) 													\
			--build-arg PACKAGER=$(PACKAGER) 												\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 									\
			--build-arg BUILD=$(BUILD) 														\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION) 							\
			--build-arg PATRONI_VERSION=$(PATRONI_VERSION) 									\
			--build-arg OLD_PG_VERSIONS="$(OLD_PG_VERSIONS)"								\
			--build-arg PGVERSION=$(PGVERSION)												\
			--build-arg ARCH=$(ARCH)

postgres-stage: postgres-stage-build

postgres-gis-build:
		docker build $(ROOTPATH)													\
			--file $(ROOTPATH)/docker/postgres-gis/Dockerfile 						\
			--tag cybertec-pg-container/postgres-gis:$(IMAGE_TAG)					\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)									\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 							\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)						\
			--build-arg BASEOS=$(BASEOS) 											\
			--build-arg PACKAGER=$(PACKAGER) 										\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 							\
			--build-arg BUILD=$(BUILD) 												\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION) 					\
			--build-arg PATRONI_VERSION=$(PATRONI_VERSION) 							\
			--build-arg OLD_PG_VERSIONS="$(OLD_PG_VERSIONS)"						\
			--build-arg PGVERSION=$(PGVERSION)										\
			--build-arg POSTGIS_VERSION=$(POSTGIS_VERSION)							

postgres-gis: postgres-gis-build

postgres-oracle-build:
		docker build $(ROOTPATH)														\
			--file $(ROOTPATH)/docker/postgres-oracle/Dockerfile 						\
			--tag cybertec-pg-container/postgres-oracle:$(IMAGE_TAG)					\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)										\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 								\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)							\
			--build-arg BASEOS=$(BASEOS) 												\
			--build-arg PACKAGER=$(PACKAGER) 											\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 								\
			--build-arg BUILD=$(BUILD) 													\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION) 						\
			--build-arg PATRONI_VERSION=$(PATRONI_VERSION) 								\
			--build-arg OLD_PG_VERSIONS="$(OLD_PG_VERSIONS)"							\
			--build-arg PGVERSION=$(PGVERSION)

postgres-oracle: postgres-oracle-build

pgbouncer-build:
		docker build $(ROOTPATH)														\
			--file $(ROOTPATH)/docker/pgbouncer/Dockerfile 								\
			--tag cybertec-pg-container/pgbouncer:$(IMAGE_TAG)							\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)										\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 								\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)							\
			--build-arg BASEOS=$(BASEOS) 												\
			--build-arg PACKAGER=$(PACKAGER) 											\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 								\
			--build-arg BUILD=$(BUILD) 													\
			--build-arg PGVERSION=$(PGVERSION)

pgbouncer: pgbouncer-build

ferretdb-build:
		docker build $(ROOTPATH)														\
			--file $(ROOTPATH)/docker/ferretdb/Dockerfile 								\
			--tag cybertec-pg-container/ferretdb:$(IMAGE_TAG)							\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)										\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 								\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)							\
			--build-arg BASEOS=$(BASEOS) 												\
			--build-arg PACKAGER=$(PACKAGER) 											\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 								\
			--build-arg BUILD=$(BUILD) 													\
			--build-arg PGVERSION=$(PGVERSION)											\
			--build-arg FERRETDBVERSION=$(FERRETDBVERSION)								\
			--build-arg ARCH=$(ARCH)

ferretdb: ferretdb-build

exporter-build:
		docker build $(ROOTPATH)														\
			--file $(ROOTPATH)/docker/exporter/Dockerfile 								\
			--tag cybertec-pg-container/exporter:$(IMAGE_TAG)							\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)										\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 								\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)							\
			--build-arg BASEOS=$(BASEOS) 												\
			--build-arg PACKAGER=$(PACKAGER) 											\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 								\
			--build-arg BUILD=$(BUILD) 													\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION) 						\
			--build-arg PGVERSION=$(PGVERSION)

exporter: exporter-build

publicbeta-pg-build:
		docker build $(ROOTPATH)													\
			--file $(ROOTPATH)/docker/pg-public-beta/Dockerfile 					\
			--tag cybertec-pg-container/postgres:$(IMAGE_TAG)-beta${PUBLICBETA}		\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)									\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 							\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)						\
			--build-arg BASEOS=$(BASEOS) 											\
			--build-arg PACKAGER=$(PACKAGER) 										\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE) 							\
			--build-arg BUILD=$(BUILD) 												\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION) 					\
			--build-arg PATRONI_VERSION=$(PATRONI_VERSION) 							\
			--build-arg OLD_PG_VERSIONS="$(OLD_PG_VERSIONS)"						\
			--build-arg PGVERSION=$(BETAVERSION)									\
			--build-arg ARCH=$(ARCH)	

publicbeta-pg: publicbeta-pg-build

publicbeta-pgbackrest-build:
		docker build $(ROOTPATH)													\
			--file $(ROOTPATH)/docker/pgbackrest-public-beta/Dockerfile 			\
			--tag cybertec-pg-container/pgbackrest:$(IMAGE_TAG)-beta${PUBLICBETA} 	\
			--build-arg BASE_IMAGE=$(BASE_IMAGE)									\
			--build-arg CONTAINERIMAGE=${CONTAINERIMAGE} 							\
			--build-arg IMAGE_REPOSITORY=$(IMAGE_REPOSITORY)						\
			--build-arg BASEOS=$(BASEOS)											\
			--build-arg PACKAGER=$(PACKAGER)										\
			--build-arg CONTAINERSUITE=$(CONTAINERSUITE)							\
			--build-arg BUILD=$(BUILD)												\
			--build-arg PGBACKREST_VERSION=$(PGBACKREST_VERSION)					\
			--build-arg OLD_PG_VERSIONS="$(OLD_PG_VERSIONS)"						\
			--build-arg PGVERSION=$(BETAVERSION)

publicbeta-pgbackrest: publicbeta-pgbackrest-build;