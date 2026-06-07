ARG ARCH_PREFIX
FROM homeassistant/${ARCH_PREFIX}-addon-otbr:3.0.1 AS base
FROM base

COPY rootfs /
