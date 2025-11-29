import 'api_service.dart';

/// Game model
class Game {
  final String id;
  final String hostId;
  final String venueId;
  final String sport;
  final String title;
  final String? description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int duration;
  final int minPlayers;
  final int maxPlayers;
  final int currentPlayers;
  final List<String> playerIds;
  final String gameType;
  final String skillLevel;
  final String? genderPreference;
  final String? ageGroup;
  final double pricePerPerson;
  final double totalCost;
  final bool splitCost;
  final String status;
  final String? rules;
  final List<String> requiredEquipment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Game({
    required this.id,
    required this.hostId,
    required this.venueId,
    required this.sport,
    required this.title,
    this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.minPlayers,
    required this.maxPlayers,
    required this.currentPlayers,
    required this.playerIds,
    required this.gameType,
    required this.skillLevel,
    this.genderPreference,
    this.ageGroup,
    required this.pricePerPerson,
    required this.totalCost,
    required this.splitCost,
    required this.status,
    this.rules,
    required this.requiredEquipment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      hostId: json['host_id'],
      venueId: json['venue_id'],
      sport: json['sport'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      duration: json['duration'],
      minPlayers: json['min_players'],
      maxPlayers: json['max_players'],
      currentPlayers: json['current_players'],
      playerIds: List<String>.from(json['player_ids'] ?? []),
      gameType: json['game_type'],
      skillLevel: json['skill_level'],
      genderPreference: json['gender_preference'],
      ageGroup: json['age_group'],
      pricePerPerson: (json['price_per_person'] as num).toDouble(),
      totalCost: (json['total_cost'] as num).toDouble(),
      splitCost: json['split_cost'],
      status: json['status'],
      rules: json['rules'],
      requiredEquipment: List<String>.from(json['required_equipment'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Game API Service
class GameApiService {
  final ApiService _apiService = ApiService();

  /// Create a new game (host)
  Future<ApiResponse<Game>> createGame(
    String userId,
    Map<String, dynamic> gameData,
  ) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/games/$userId',
      data: gameData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Game.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create game');
  }

  /// Get game by ID
  Future<ApiResponse<Game>> getGame(String gameId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/games/$gameId',
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Game.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get game');
  }

  /// List games with filtering
  Future<ApiResponse<List<Game>>> listGames({
    int skip = 0,
    int limit = 20,
    String? sport,
    String? status,
    String? skillLevel,
    String? gameType,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/games/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (sport != null) 'sport': sport,
        if (status != null) 'status': status,
        if (skillLevel != null) 'skill_level': skillLevel,
        if (gameType != null) 'game_type': gameType,
      },
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final games = response.data!
          .map((json) => Game.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(games);
    }

    return ApiResponse.error(response.error ?? 'Failed to list games');
  }

  /// Join a game
  Future<ApiResponse<Game>> joinGame(String gameId, String userId) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/games/$gameId/join/$userId',
      data: {},
    );

    if (response.isSuccess && response.data != null) {
      final gameData = response.data!['game'] as Map<String, dynamic>;
      return ApiResponse.success(Game.fromJson(gameData));
    }

    return ApiResponse.error(response.error ?? 'Failed to join game');
  }

  /// Leave a game
  Future<ApiResponse<void>> leaveGame(String gameId, String userId) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/games/$gameId/leave/$userId',
      data: {},
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to leave game');
  }

  /// Update game
  Future<ApiResponse<Game>> updateGame(
    String gameId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/games/$gameId',
      data: updates,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Game.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update game');
  }

  /// Cancel game
  Future<ApiResponse<void>> cancelGame(String gameId, String userId) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/games/$gameId/$userId',
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to cancel game');
  }

  /// Get user's games
  Future<ApiResponse<List<Game>>> getUserGames(
    String userId, {
    bool includePast = false,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/games/user/$userId',
      queryParameters: {
        'include_past': includePast,
      },
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final games = response.data!
          .map((json) => Game.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(games);
    }

    return ApiResponse.error(response.error ?? 'Failed to get user games');
  }
}
