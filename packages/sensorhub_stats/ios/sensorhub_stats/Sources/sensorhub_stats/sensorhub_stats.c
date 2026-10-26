#include "sensorhub_stats.h"

#include <math.h>
#include <stddef.h>

// Fewer samples than this make a z-score meaningless.
#define MIN_SAMPLES 3
#define MIN_STDDEV 1e-9

FFI_PLUGIN_EXPORT int32_t sh_stats_analyze(const double *window, int32_t length,
                                           double value, double z_threshold,
                                           sh_stats_result *out) {
  if (out == NULL || length < 0 || (length > 0 && window == NULL) ||
      isnan(value) || isinf(value)) {
    return SH_STATS_INVALID_ARGUMENT;
  }

  double mean = 0;
  double stddev = 0;
  if (length > 0) {
    double sum = 0;
    for (int32_t i = 0; i < length; i++) sum += window[i];
    mean = sum / length;

    double squares = 0;
    for (int32_t i = 0; i < length; i++) {
      double diff = window[i] - mean;
      squares += diff * diff;
    }
    stddev = sqrt(squares / length);
  }

  double z = 0;
  if (length >= MIN_SAMPLES && stddev > MIN_STDDEV) {
    z = (value - mean) / stddev;
  }

  out->mean = mean;
  out->stddev = stddev;
  out->z_score = z;
  out->is_anomaly = fabs(z) > z_threshold ? 1 : 0;
  return SH_STATS_OK;
}
