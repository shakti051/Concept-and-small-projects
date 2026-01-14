
import '../models/post.dart';
import '../models/user.dart';
import 'api_service.dart';

class HomeRepository {
  final ApiService apiService;

  HomeRepository(this.apiService);

  Future<(List<Post>, List<User>)> fetchHomeData() async {
    final results = await Future.wait([
      apiService.fetchPosts(),
      apiService.fetchUsers(),
    ]);

    return (
      results[0] as List<Post>,
      results[1] as List<User>,
    );
  }
}
