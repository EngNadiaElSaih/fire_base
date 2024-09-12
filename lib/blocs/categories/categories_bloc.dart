import 'package:flutter_bloc/flutter_bloc.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesInitial()) {
    on<FetchCategoriesEvent>((event, emit) async {
      try {
        emit(CategoriesLoading());
        // استرجاع البيانات من مصدر البيانات (مثل Firebase)
        List<String> categories = await fetchCategoriesFromFirestore();
        emit(CategoriesLoaded(categories: categories));
      } catch (e) {
        emit(CategoriesError(error: e.toString()));
      }
    });
  }

  Future<List<String>> fetchCategoriesFromFirestore() async {
    // يمكنك إضافة الكود لجلب البيانات من Firebase أو أي مصدر آخر
    await Future.delayed(const Duration(seconds: 2)); // محاكاة تأخير
    return ['Business', 'UI/UX', 'Software Engineering'];
  }
}
