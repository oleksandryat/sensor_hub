# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(sensorhub_stats_library VERSION 0.0.1 LANGUAGES C)

# The sources live in the Swift package so iOS and Android share one copy.
set(STATS_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/../ios/sensorhub_stats/Sources/sensorhub_stats")

add_library(sensorhub_stats SHARED
  "${STATS_SOURCES}/sensorhub_stats.c"
)

target_include_directories(sensorhub_stats PUBLIC "${STATS_SOURCES}/include")

set_target_properties(sensorhub_stats PROPERTIES
  OUTPUT_NAME "sensorhub_stats"
)

target_compile_definitions(sensorhub_stats PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(sensorhub_stats PRIVATE "-Wl,-z,max-page-size=16384")
endif()
