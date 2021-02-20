load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

licenses(["notice"])

# Workaround for the rules_apple integration tests to force the use of a
# "worker" that isn't actually a worker but which simply spawns `swiftc`
# directly, because some of the worker dependencies are too complex to
# properly mock out in the test workspace.
#
# This flag is incompatible with the "worker" strategy for SwiftCompile
# actions because it doesn't actually start a processing loop. It merely
# provides an executable with isolated dependencies that can be more easily
# built.
config_setting(
    name = "no_worker",
    define_values = {
        "RULES_SWIFT_BUILD_DUMMY_WORKER": "1",
    },
)

cc_library(
    name = "compile_with_worker",
    srcs = [
        "compile_with_worker.cc",
        "output_file_map.cc",
        "output_file_map.h",
        "work_processor.cc",
        "work_processor.h",
    ],
    hdrs = ["compile_with_worker.h"],
    deps = [
        ":swift_runner",
        "//third_party/bazel_protos:worker_protocol_cc_proto",
        "//tools/common:file_system",
        "//tools/common:path_utils",
        "//tools/common:string_utils",
        "//tools/common:temp_file",
        "@com_github_nlohmann_json//:json",
        "@com_google_protobuf//:protobuf",
    ],
)

cc_library(
    name = "compile_without_worker",
    srcs = ["compile_without_worker.cc"],
    hdrs = ["compile_without_worker.h"],
    deps = [
        ":swift_runner",
    ],
)

cc_library(
    name = "swift_runner",
    srcs = ["swift_runner.cc"],
    hdrs = ["swift_runner.h"],
    deps = [
        "//tools/common:file_system",
        "//tools/common:process",
        "//tools/common:string_utils",
        "//tools/common:temp_file",
    ],
)

cc_binary(
    name = "worker",
    srcs = select({
        ":no_worker": ["no_worker_main.cc"],
        "//conditions:default": ["worker_main.cc"],
    }),
    visibility = ["//visibility:public"],
    deps = select({
        ":no_worker": [":compile_without_worker"],
        "//conditions:default": [
            ":compile_without_worker",
            ":compile_with_worker",
        ],
    }),
)

# Internal hinge for index while building V2 feature
config_setting(
    name = "index_while_building_v2",
    values = {
        "features": "swift.index_while_building_v2"
    },
)


filegroup(
   name = "worker_output_processor",
   # with index_while_building_v2 we want to add a dependency on the tool that
   # manages the per swift_library index. Otherwise, don't load it
   # This is mainly an internal capability right now - check
   # tools/worker/work_processor.cc for usage:
   # build_bazel_rules_swift_index_import is be provided by the user for now
   srcs = select({
       ":index_while_building_v2": ["@build_bazel_rules_swift_index_import//:index_import"],
       "//conditions:default": []
   }),
   visibility = ["//visibility:public"],
)

# Consumed by Bazel integration tests.
filegroup(
    name = "for_bazel_tests",
    testonly = 1,
    srcs = glob(["**"]),
    visibility = [
        "//tools:__pkg__",
    ],
)
