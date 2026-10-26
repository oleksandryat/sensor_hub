#ifndef SENSORHUB_STATS_H
#define SENSORHUB_STATS_H

#include <stdint.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default"), used))
#endif

typedef struct {
  // Mean and standard deviation of the window.
  double mean;
  double stddev;
  // How many standard deviations `value` is away from the mean.
  // 0 while the window is too small or has no spread.
  double z_score;
  // 1 when |z_score| is above the threshold, otherwise 0.
  int32_t is_anomaly;
} sh_stats_result;

#define SH_STATS_OK 0
#define SH_STATS_INVALID_ARGUMENT -1

// Compares `value` with the `length` earlier samples in `window`.
FFI_PLUGIN_EXPORT int32_t sh_stats_analyze(const double *window, int32_t length,
                                           double value, double z_threshold,
                                           sh_stats_result *out);

#endif
