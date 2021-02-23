import '../service/socketIo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

bool ifEmitUserId = false;

SocketUtil socketUtil = SocketUtil("456888");

Map<String, IO.Socket> socketMap = {};
