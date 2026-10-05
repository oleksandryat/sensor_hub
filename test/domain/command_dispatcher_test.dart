import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/command.dart';
import 'package:sensor_hub/domain/command_ack.dart';
import 'package:sensor_hub/domain/command_dispatcher.dart';
import 'package:sensor_hub/domain/command_result.dart';
import 'package:sensor_hub/domain/mqtt_gateway.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/mqtt_gateway_message.dart';
import 'package:sensor_hub/domain/mqtt_topics.dart';

class MockMqttGateway extends Mock implements MqttGateway {}

void main() {
  late MockMqttGateway gateway;
  late StreamController<MqttGatewayMessage> messagesController;
  late MqttCommandDispatcher dispatcher;
  final topics = MqttTopics('sensorhub-test/');

  setUp(() {
    gateway = MockMqttGateway();
    messagesController = StreamController.broadcast();
    when(() => gateway.messages).thenAnswer((_) => messagesController.stream);
    dispatcher = MqttCommandDispatcher(gateway, topics);
  });

  test('succeeded when a matching ok ack arrives', () {
    fakeAsync((async) {
      CommandResult? result;

      dispatcher
          .send(Command.reboot(cmdId: 'c1'), deviceId: '1')
          .then((value) => result = value);

      messagesController.add(
        MqttGatewayMessage(
          topic: topics.cmdAckFilter('1'),
          payload: jsonEncode(
            CommandAck(cmdId: 'c1', ok: true, error: null).toJson(),
          ),
        ),
      );

      async.flushMicrotasks();

      expect(result, const CommandResult.succeeded(cmdId: 'c1'));
      expect(async.pendingTimers, isEmpty);
    });
  });

  test('failed when an ack with error arrives', () {
    fakeAsync((async) {
      CommandResult? result;

      dispatcher
          .send(Command.reboot(cmdId: 'c1'), deviceId: '1')
          .then((value) => result = value);

      messagesController.add(
        MqttGatewayMessage(
          topic: topics.cmdAckFilter('1'),
          payload: jsonEncode(
            CommandAck(
              cmdId: 'c1',
              ok: false,
              error: 'Something went wrong',
            ).toJson(),
          ),
        ),
      );

      async.flushMicrotasks();

      expect(
        result,
        const CommandResult.failed(cmdId: 'c1', error: 'Something went wrong'),
      );
      expect(async.pendingTimers, isEmpty);
    });
  });

  test('failed when an ack with null error arrives', () {
    fakeAsync((async) {
      CommandResult? result;

      dispatcher
          .send(Command.reboot(cmdId: 'c1'), deviceId: '1')
          .then((value) => result = value);

      messagesController.add(
        MqttGatewayMessage(
          topic: topics.cmdAckFilter('1'),
          payload: jsonEncode(
            CommandAck(cmdId: 'c1', ok: false, error: null).toJson(),
          ),
        ),
      );

      async.flushMicrotasks();

      expect(
        result,
        const CommandResult.failed(cmdId: 'c1', error: 'unknown error'),
      );
      expect(async.pendingTimers, isEmpty);
    });
  });

  test('timed out when no ack arrives', () {
    fakeAsync((async) {
      CommandResult? result;

      dispatcher
          .send(Command.reboot(cmdId: 'c1'), deviceId: '1')
          .then((value) => result = value);

      async.elapse(Duration(seconds: 5));

      expect(result, const CommandResult.timedOut(cmdId: 'c1'));
      expect(async.pendingTimers, isEmpty);
    });
  });

  test(
    'ignores a non-matching ack, then succeeds once the real one arrives',
    () {
      fakeAsync((async) {
        CommandResult? result;

        dispatcher
            .send(Command.reboot(cmdId: 'c1'), deviceId: '1')
            .then((value) => result = value);

        messagesController.add(
          MqttGatewayMessage(
            topic: topics.cmdAckFilter('1'),
            payload: jsonEncode(
              CommandAck(cmdId: 'c2', ok: true, error: null).toJson(),
            ),
          ),
        );

        async.flushMicrotasks();

        expect(result, isNull);

        messagesController.add(
          MqttGatewayMessage(
            topic: topics.cmdAckFilter('1'),
            payload: jsonEncode(
              CommandAck(cmdId: 'c1', ok: true, error: null).toJson(),
            ),
          ),
        );

        async.flushMicrotasks();

        expect(result, const CommandResult.succeeded(cmdId: 'c1'));
        expect(async.pendingTimers, isEmpty);
      });
    },
  );
}
