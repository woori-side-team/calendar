import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/domain/repositories/memo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMemoByIdUseCase {
  final MemoRepository _memoRepository;

  const GetMemoByIdUseCase(this._memoRepository);

  Future<MemoModel?> call(String id) async {
    return await _memoRepository.getMemoByID(id);
  }
}

@injectable
class AddMemoUseCase {
  final MemoRepository _memoRepository;

  const AddMemoUseCase(this._memoRepository);

  Future<void> call(MemoModel memoModel) async {
    await _memoRepository.addMemo(memoModel);
  }
}

@injectable
class UpdateMemoUseCase {
  final MemoRepository _memoRepository;

  const UpdateMemoUseCase(this._memoRepository);

  Future<void> call(MemoModel memoModel) async {
    await _memoRepository.updateMemo(memoModel);
  }
}

@injectable
class DeleteMemoUseCase {
  final MemoRepository _memoRepository;

  const DeleteMemoUseCase(this._memoRepository);

  Future<void> call(String id) async {
    await _memoRepository.deleteMemo(id);
  }
}

@injectable
class GetAllMemosUseCase {
  final MemoRepository _memoRepository;

  const GetAllMemosUseCase(this._memoRepository);

  Future<List<MemoModel>> call() async {
    return await _memoRepository.getAllMemos();
  }
}

@injectable
class DeleteAllMemosUseCase {
  final MemoRepository _memoRepository;

  const DeleteAllMemosUseCase(this._memoRepository);

  Future<void> call() async {
    await _memoRepository.deleteAllMemos();
  }
}
