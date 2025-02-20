// Copyright 2021-2023 the Kubeapps contributors.
// SPDX-License-Identifier: Apache-2.0

// @generated by protoc-gen-connect-es v1.4.0 with parameter "target=ts,import_extension=none"
// @generated from file kubeappsapis/core/plugins/v1alpha1/plugins.proto (package kubeappsapis.core.plugins.v1alpha1, syntax proto3)
/* eslint-disable */
// @ts-nocheck

import { GetConfiguredPluginsRequest, GetConfiguredPluginsResponse } from "./plugins_pb";
import { MethodKind } from "@bufbuild/protobuf";

/**
 * @generated from service kubeappsapis.core.plugins.v1alpha1.PluginsService
 */
export const PluginsService = {
  typeName: "kubeappsapis.core.plugins.v1alpha1.PluginsService",
  methods: {
    /**
     * GetConfiguredPlugins returns a map of short and longnames for the configured plugins.
     *
     * @generated from rpc kubeappsapis.core.plugins.v1alpha1.PluginsService.GetConfiguredPlugins
     */
    getConfiguredPlugins: {
      name: "GetConfiguredPlugins",
      I: GetConfiguredPluginsRequest,
      O: GetConfiguredPluginsResponse,
      kind: MethodKind.Unary,
    },
  },
} as const;
