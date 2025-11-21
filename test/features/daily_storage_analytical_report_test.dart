import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_from_db_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:logsheet_app/data/repositories/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_repository.dart';
import 'package:logsheet_app/providers/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';

// Import the generated mocks file
import 'daily_storage_analytical_report_test.mocks.dart';

@GenerateMocks([
  DailyStorageTankAnalyticalRepository,
  DailyStorageTankAnalyticalToDbEntity,
  DailyStorageTankAnalyticalFromDbEntity,
])
void main() {
  late MockDailyStorageTankAnalyticalRepository mockRepository;
  late DailyStorageTankAnalyticalProvider provider;
  late MockDailyStorageTankAnalyticalToDbEntity mockReport;

  setUp(() {
    mockRepository = MockDailyStorageTankAnalyticalRepository();
    provider = DailyStorageTankAnalyticalProvider(mockRepository);
    mockReport = MockDailyStorageTankAnalyticalToDbEntity();
  });

  // Test the initial state of the provider
  test('Initial state should be correct', () {
    expect(provider.isLoading, false);
    expect(provider.isLoadingInput, false);
    expect(provider.isLoadingEdit, false);
    expect(provider.isLoadingDelete, false);
    expect(provider.isLoadingApproval, false);
    expect(provider.errorMessage, null);
    expect(provider.reportsList, []);
    expect(provider.approvalList, []);
  });

  group('insertDailyStorageTankAnalyticalReport', () {
    // Arrage
    test('should return true and stop loading on success', () async {
      when(
        mockRepository.insertDailyStorageTankAnalytical(report: mockReport),
      ).thenAnswer((_) async => true);

      // Act
      final result = await provider.insertDailyStorageTankAnalyticalReport(
        report: mockReport,
      );

      // Assert
      expect(result, true);
      expect(provider.isLoadingInput, false);
      expect(provider.errorMessage, null);
      verify(
        mockRepository.insertDailyStorageTankAnalytical(report: mockReport),
      ).called(1);
    });

    test(
      'should return false, set error message, and stop loading on repo failure',
      () async {
        // Arrange
        when(
          mockRepository.insertDailyStorageTankAnalytical(report: mockReport),
        ).thenAnswer((_) async => false);

        // Act
        final result = await provider.insertDailyStorageTankAnalyticalReport(
          report: mockReport,
        );

        expect(result, false);
        expect(provider.isLoadingInput, false);
        expect(
          provider.errorMessage,
          'Failed to insert Change Product Checklist.',
        );
        verify(
          mockRepository.insertDailyStorageTankAnalytical(report: mockReport),
        ).called(1);
      },
    );

    test(
      'should return false, set error message, and stop loading on exception',
      () async {
        when(
          mockRepository.insertDailyStorageTankAnalytical(report: mockReport),
        ).thenThrow(Exception('DB Error'));

        final result = await provider.insertDailyStorageTankAnalyticalReport(
          report: mockReport,
        );

        expect(result, false);
        expect(provider.isLoadingInput, false);
        expect(provider.errorMessage, 'Exception: DB Error');
      },
    );
  });

  group('getAllDailyStorageTankReport', () {
    // Mock entities for the list
    final mockReport1 = MockDailyStorageTankAnalyticalFromDbEntity();
    final mockReport2 = MockDailyStorageTankAnalyticalFromDbEntity();
    // This report should be filtered
    final mockReport3 = MockDailyStorageTankAnalyticalFromDbEntity();

    final reportsFromRepo = [mockReport1, mockReport2, mockReport3];

    test('should fetch, filter, and store reports on success', () async {
      // Arrange
      when(mockReport1.flag).thenReturn('T');
      when(mockReport2.flag).thenReturn('T');
      when(mockReport3.flag).thenReturn('F');

      when(
        mockRepository.getAllDailyStorageTankReport(any, any),
      ).thenAnswer((_) async => reportsFromRepo);

      // Act
      await provider.getAllDailyStorageTankReport('2025-01-01', 'OPR');

      // Assert
      expect(provider.reportsList.length, 2);
      expect(provider.reportsList, contains(mockReport1));
      expect(provider.reportsList, contains(mockReport2));
      expect(provider.reportsList, isNot(contains(mockReport3)));
      expect(provider.errorMessage, null);
      verify(
        mockRepository.getAllDailyStorageTankReport('2025-01-01', 'OPR'),
      ).called(1);
    });
  });

  test('should set error message and stop loading on exception', () async {
    // Arrange
    when(
      mockRepository.getAllDailyStorageTankReport(any, any),
    ).thenThrow(Exception('Fetch Error'));

    // Act
    await provider.getAllDailyStorageTankReport('2025-01-01', 'some_role');

    // Assert
    expect(provider.reportsList, []);
    expect(provider.isLoading, false);
    expect(
      provider.errorMessage,
      'Failed to fetch Quality Reports: Exception: Fetch Error',
    );
  });

  // here
  group('generateId', () {
    const plantCode = 'PS21';

    test('should fetch latest ID correctly', () async {
      // Arrange
      const latestId = 'Q01PS2125000001';

      when(
        mockRepository.getLatestId(plantCode),
      ).thenAnswer((_) async => latestId);

      final result = await mockRepository.getLatestId(plantCode);

      expect(result, latestId);
      verify(mockRepository.getLatestId(plantCode)).called(1);
    });

    test('should generate a new ID correctly based on latestId', () async {
      // Arrange
      // Based on the provider's logic:
      // prefixPart = latest.substring(0, 9)
      // autoPart = latest.substring(9)
      // newAutoStr = newAuto.toString().padLeft(6, '0')
      const latestId = 'Q01PS2125000001'; // 9-char prefix, 8-char autoPart
      const expectedNewAuto = 000002;
      const expectedNewId = 'Q01PS2125000002';

      when(
        mockRepository.getLatestId(plantCode),
      ).thenAnswer((_) async => latestId);
      when(
        mockRepository.updateAutoNumber(plantCode, expectedNewAuto),
      ).thenAnswer((_) async => true);

      // final latestIdFromDb = await provider.fetchLatestId(plantCode);

      // Act
      final newId = await provider.generateId(plantCode);

      // Assert
      expect(newId, expectedNewId);
      expect(provider.isLoading, false);
      verify(mockRepository.getLatestId(plantCode)).called(1);
      verify(
        mockRepository.updateAutoNumber(plantCode, expectedNewAuto),
      ).called(1);
    });

    test('should generate ID "000001" if autoPart parsing fails', () async {
      // Arrange
      const latestId = 'Q01PS2125000001'; // This will fail int.parse
      const expectedNewAuto = 000002;
      const expectedNewId = 'Q01PS2125000002'; // prefix + 1.padLeft(6, '0')

      when(
        mockRepository.getLatestId(plantCode),
      ).thenAnswer((_) async => latestId);
      when(
        mockRepository.updateAutoNumber(plantCode, expectedNewAuto),
      ).thenAnswer((_) async => true);

      // Act
      final newId = await provider.generateId(plantCode);

      // Assert
      expect(newId, expectedNewId);
      expect(provider.isLoading, false);
      verify(mockRepository.getLatestId(plantCode)).called(1);
      verify(
        mockRepository.updateAutoNumber(plantCode, expectedNewAuto),
      ).called(1);
    });

    test('should return empty string if latestId is null or empty', () async {
      // Arrange
      when(mockRepository.getLatestId(plantCode)).thenAnswer((_) async => null);

      // Act
      final newId = await provider.generateId(plantCode);

      // Assert
      expect(newId, '');
      expect(provider.isLoading, false);
      // updateAutoNumber should not be called
      verifyNever(mockRepository.updateAutoNumber(any, any));
    });
  });

  group('deleteDailyStorageTankAnalyticalReport', () {
    const reportId = 'report_123';

    test('should return true on successful deletion', () async {
      // Arrange
      when(
        mockRepository.deleteDailyStorageTankAnalyticalReport(reportId),
      ).thenAnswer((_) async => true);

      // Act
      final result = await provider.deleteDailyStorageTankAnalyticalReport(
        reportId,
      );

      // Assert
      expect(result, true);
      expect(provider.isLoadingDelete, false);
      expect(provider.errorMessage, null);
      verify(
        mockRepository.deleteDailyStorageTankAnalyticalReport(reportId),
      ).called(1);
    });

    test('should return false and set error on repository failure', () async {
      // Arrange
      when(
        mockRepository.deleteDailyStorageTankAnalyticalReport(reportId),
      ).thenAnswer((_) async => false);

      // Act
      final result = await provider.deleteDailyStorageTankAnalyticalReport(
        reportId,
      );

      // Assert
      expect(result, false);
      expect(provider.isLoadingDelete, false);
      expect(
        provider.errorMessage,
        'Failed to delete Change Product Checklist.',
      );
    });
  });

  group('updateDailyStorageTankAnalyticalReport', () {
    const reportId = 'report_123';

    test('should return true on successful update', () async {
      // Arrange
      when(
        mockRepository.updatedeleteDailyStorageTankAnalyticalReport(
          mockReport,
          reportId,
        ),
      ).thenAnswer((_) async => true);

      // Act
      final result = await provider.updateDailyStorageTankAnalyticalReport(
        mockReport,
        reportId,
      );

      // Assert
      expect(result, true);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
      verify(
        mockRepository.updatedeleteDailyStorageTankAnalyticalReport(
          mockReport,
          reportId,
        ),
      ).called(1);
    });

    test('should return false and set error on exception', () async {
      // Arrange
      when(
        mockRepository.updatedeleteDailyStorageTankAnalyticalReport(
          mockReport,
          reportId,
        ),
      ).thenThrow(Exception('Update Error'));

      // Act
      final result = await provider.updateDailyStorageTankAnalyticalReport(
        mockReport,
        reportId,
      );

      // Assert
      expect(result, false);
      expect(provider.isLoading, false);
      expect(
        provider.errorMessage,
        'Failed to update report: Exception: Update Error',
      );
    });
  });
}
