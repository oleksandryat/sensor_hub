# MQTT topic contract

Use a unique topic prefix (e.g. `sensorhub-<random>/`) when testing against public brokers, so multiple developers don't collide on the same topics.

Command ack timeout: **5 seconds**.

| Topic                    | Direction    | Payload                                             | QoS | Retained |
|--------------------------|--------------|-----------------------------------------------------|-----|----------|
| `devices/{id}/telemetry` | device → app | `{"ts": int (ms), "value": double, "unit": string}` | 0   | no       |
| `devices/{id}/status`    | device → app | `{"online": bool}` (LWT sets `false`)               | 1   | yes      |
| `devices/{id}/cmd`       | app → device | `{"cmdId": string, "type": "reboot"}`               | 1   | no       |
| `devices/{id}/cmd/ack`   | device → app | `{"cmdId": string, "ok": bool, "error": string?}`   | 1   | no       |

`{id}` is a device identifier segment carried in the topic itself — it is not repeated inside the JSON payload.
