import 'package:auto_route/auto_route.dart';
import 'package:to_do_app/views/home_view.dart';
import 'package:to_do_app/views/product_view.dart';
// part 'router.gr.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  MaterialRoute(page: HomeView, initial: true, ),
  MaterialRoute(page: ProductView, usesTabsRouter: false, fullMatch: false, fullscreenDialog: false),
],preferRelativeImports: true, )
class $AppRouter {}