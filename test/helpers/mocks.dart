import 'package:bloc_test/bloc_test.dart';
import 'package:sensor_hub/features/connection/cubit/connection_cubit.dart';
import 'package:sensor_hub/features/dashboard/cubit/dashboard_cubit.dart';

class MockConnectionCubit extends MockCubit<ConnectionCubitState>
    implements ConnectionCubit {}

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}
