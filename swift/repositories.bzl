# Copyright 2018 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Definitions for handling Bazel repositories used by the Swift rules."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(
    "@build_bazel_rules_swift//swift/internal:swift_autoconfiguration.bzl",
    "swift_autoconfiguration",
)

def _maybe(repo_rule, name, **kwargs):
    """Executes the given repository rule if it hasn't been executed already.

    Args:
      repo_rule: The repository rule to be executed (e.g., `http_archive`.)
      name: The name of the repository to be defined by the rule.
      **kwargs: Additional arguments passed directly to the repository rule.
    """
    if not native.existing_rule(name):
        repo_rule(name = name, **kwargs)

def swift_rules_dependencies(include_bzlmod_ready_dependencies = True):
    """Fetches repositories that are dependencies of `rules_swift`.

    Users should call this macro in their `WORKSPACE` to ensure that all of the
    dependencies of the Swift rules are downloaded and that they are isolated
    from changes to those dependencies.

    Args:
        include_bzlmod_ready_dependencies: Whether or not bzlmod-ready
            dependencies should be included.
    """
    if include_bzlmod_ready_dependencies:
        _maybe(
            http_archive,
            name = "bazel_skylib",
            urls = [
                "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
            ],
            sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
        )

        _maybe(
            http_archive,
            name = "build_bazel_apple_support",
            urls = [
                "https://github.com/bazelbuild/apple_support/releases/download/1.3.2/apple_support.1.3.2.tar.gz",
            ],
            sha256 = "2e3dc4d0000e8c2f5782ea7bb53162f37c485b5d8dc62bb3d7d7fc7c276f0d00",
        )

        _maybe(
            http_archive,
            name = "rules_proto",
            # latest as of 2022-09-30
            urls = [
                "https://github.com/bazelbuild/rules_proto/archive/d3702796e768abe7086d2dc7e299d3f7aeb1dd34.tar.gz",
            ],
            sha256 = "a88c799bf19c0a157f9c423477277a0d0362f251388d7b28f0f00bfb0bf25b3d",
            strip_prefix = "rules_proto-d3702796e768abe7086d2dc7e299d3f7aeb1dd34",
        )

        _maybe(
            http_archive,
            name = "com_github_nlohmann_json",
            urls = [
                "https://github.com/nlohmann/json/releases/download/v3.6.1/include.zip",
            ],
            sha256 = "69cc88207ce91347ea530b227ff0776db82dcb8de6704e1a3d74f4841bc651cf",
            type = "zip",
            build_file = "@build_bazel_rules_swift//third_party:com_github_nlohmann_json/BUILD.overlay",
        )

    _maybe(
        http_archive,
        name = "com_github_apple_swift_protobuf",
        urls = ["https://github.com/apple/swift-protobuf/archive/1.19.0.tar.gz"],
        sha256 = "294443cd9ef26a7669220b7c4866775b96d5120b1fc9759c8bb5654124b534fe",
        strip_prefix = "swift-protobuf-1.19.0/",
        build_file = "@build_bazel_rules_swift//third_party:com_github_apple_swift_protobuf/BUILD.overlay",
    )

    _maybe(
        http_archive,
        name = "com_github_grpc_grpc_swift",
        urls = ["https://github.com/grpc/grpc-swift/archive/1.7.3.tar.gz"],
        sha256 = "c2337d2c6fe9605c653759ac6a79426eca215fc0e67658b4c3562b960261e94e",
        strip_prefix = "grpc-swift-1.7.3/",
        build_file = "@build_bazel_rules_swift//third_party:com_github_grpc_grpc_swift/BUILD.overlay",
    )

    _maybe(
        http_archive,
        name = "com_github_apple_swift_nio",
        urls = ["https://github.com/apple/swift-nio/archive/2.40.0.tar.gz"],
        sha256 = "65a57678a27e86dfdecf7fc8145e8c2299a246ed18a32c5464d04d2144f50f16",
        strip_prefix = "swift-nio-2.40.0/",
        build_file = "@build_bazel_rules_swift//third_party:com_github_apple_swift_nio/BUILD.overlay",
    )

    _maybe(
        http_archive,
        name = "com_github_apple_swift_nio_http2",
        urls = ["https://github.com/apple/swift-nio-http2/archive/1.21.0.tar.gz"],
        sha256 = "4c6d1f1bfd8e2d98a45b3ff898b169a6e9186233abae1c28777e6b3a023af84a",
        strip_prefix = "swift-nio-http2-1.21.0/",
        build_file = "@build_bazel_rules_swift//third_party:com_github_apple_swift_nio_http2/BUILD.overlay",
    )

    _maybe(
        http_archive,
        name = "com_github_apple_swift_nio_transport_services",
        urls = ["https://github.com/apple/swift-nio-transport-services/archive/1.12.0.tar.gz"],
        sha256 = "5e1e2a96a2cb80f3fa1796530342142d2cb800f666533dd0bc4f62d17a1b8d05",
        strip_prefix = "swift-nio-transport-services-1.12.0/",
        build_file = "@build_bazel_rules_swift//third_party:com_github_apple_swift_nio_transport_services/BUILD.overlay",
    )

    _maybe(
        http_archive,
        name = "com_github_apple_swift_nio_extras",
        urls = ["https://github.com/apple/swift-nio-extras/archive/1.11.0.tar.gz"],
        sha256 = "d8e8e07216690f1bb1bebd1e8c7432e3a9c3166e927562357e8d00637d05beaf",
        strip_prefix = "swift-nio-extras-1.11.0/",
        build_file = "@build_bazel_rules_swift//third_party:com_github_apple_swift_nio_extras/BUILD.overlay",
    )

    _maybe(
        http_archive,
        name = "com_github_apple_swift_log",
        urls = ["https://github.com/apple/swift-log/archive/1.4.2.tar.gz"],
        sha256 = "7507ff8904cc139c7d8fe81c7b49224035e09767413f546ce3cebe97e2360202",
        strip_prefix = "swift-log-1.4.2/",
        build_file = "@build_bazel_rules_swift//third_party:com_github_apple_swift_log/BUILD.overlay",
    )

    # It relies on `index-import` to import indexes into Bazel's remote
    # cache and allow using a global index internally in workers.
    # Note: this is only loaded if swift.index_while_building_v2 is enabled
    _maybe(
        http_archive,
        name = "build_bazel_rules_swift_index_import",
        build_file = "@build_bazel_rules_swift//third_party:build_bazel_rules_swift_index_import/BUILD.overlay",
        canonical_id = "index-import-5.7",
        urls = ["https://github.com/MobileNativeFoundation/index-import/releases/download/5.7/index-import.tar.gz"],
        sha256 = "802f33638b996abe76285d1e0246e661919c0c3222877681e66c519f78145511",
    )

    _maybe(
        swift_autoconfiguration,
        name = "build_bazel_rules_swift_local_config",
    )
