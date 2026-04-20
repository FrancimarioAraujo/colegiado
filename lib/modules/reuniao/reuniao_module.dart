import 'package:flutter_modular/flutter_modular.dart';
import 'external/hive/reuniao_hive_service.dart';
import 'external/hive/ata_hive_service.dart';
import 'external/hive/pessoa_hive_service.dart';
import 'external/pdf/pdf_generator_service.dart';
import 'domain/repositories/reuniao_repository.dart';
import 'domain/repositories/ata_repository.dart';
import 'domain/repositories/pessoa_repository.dart';
import 'infra/repositories/reuniao_repository_impl.dart';
import 'infra/repositories/ata_repository_impl.dart';
import 'infra/repositories/pessoa_repository_impl.dart';
import 'application/usecases/reuniao_usecases.dart';
import 'application/usecases/ata_usecases.dart';
import 'application/usecases/pessoa_usecases.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/criar_reuniao_page.dart';
import 'presentation/pages/detalhes_reuniao_page.dart';
import 'presentation/pages/criar_pauta_page.dart';
import 'presentation/pages/criar_ata_page.dart';
import 'presentation/pages/visualizar_convocacao_page.dart';
import 'presentation/pages/visualizar_ata_page.dart';
import 'presentation/pages/gerenciar_pessoas_page.dart';

class ReuniaoModule extends Module {
  @override
  void binds(i) {
    // Services
    i.addSingleton<ReuniaoHiveService>(
      () => ReuniaoHiveService(),
    );
    i.addSingleton<AtaHiveService>(
      () => AtaHiveService(),
    );
    i.addSingleton<PessoaHiveService>(
      () => PessoaHiveService(),
    );
    i.addSingleton<PdfGeneratorService>(
      () => PdfGeneratorService(),
    );

    // Repositories
    i.addSingleton<ReuniaoRepository>(
      () => ReuniaoRepositoryImpl(i.get<ReuniaoHiveService>()),
    );
    i.addSingleton<AtaRepository>(
      () => AtaRepositoryImpl(i.get<AtaHiveService>()),
    );
    i.addSingleton<PessoaRepository>(
      () => PessoaRepositoryImpl(i.get<PessoaHiveService>()),
    );

    // Use Cases
    i.addSingleton<ListarReunioesUseCase>(
      () => ListarReunioesUseCase(i.get<ReuniaoRepository>()),
    );
    i.addSingleton<SalvarReuniaoUseCase>(
      () => SalvarReuniaoUseCase(i.get<ReuniaoRepository>()),
    );
    i.addSingleton<AtualizarReuniaoUseCase>(
      () => AtualizarReuniaoUseCase(i.get<ReuniaoRepository>()),
    );
    i.addSingleton<RemoverReuniaoUseCase>(
      () => RemoverReuniaoUseCase(i.get<ReuniaoRepository>()),
    );
    i.addSingleton<BuscarReuniaoUseCase>(
      () => BuscarReuniaoUseCase(i.get<ReuniaoRepository>()),
    );

    i.addSingleton<ListarAtasUseCase>(
      () => ListarAtasUseCase(i.get<AtaRepository>()),
    );
    i.addSingleton<SalvarAtaUseCase>(
      () => SalvarAtaUseCase(i.get<AtaRepository>()),
    );
    i.addSingleton<AtualizarAtaUseCase>(
      () => AtualizarAtaUseCase(i.get<AtaRepository>()),
    );
    i.addSingleton<RemoverAtaUseCase>(
      () => RemoverAtaUseCase(i.get<AtaRepository>()),
    );
    i.addSingleton<BuscarAtaPorNumeroReuniaoUseCase>(
      () => BuscarAtaPorNumeroReuniaoUseCase(i.get<AtaRepository>()),
    );

    i.addSingleton<ListarPessoasUseCase>(
      () => ListarPessoasUseCase(i.get<PessoaRepository>()),
    );
    i.addSingleton<SalvarPessoaUseCase>(
      () => SalvarPessoaUseCase(i.get<PessoaRepository>()),
    );
    i.addSingleton<AtualizarPessoaUseCase>(
      () => AtualizarPessoaUseCase(i.get<PessoaRepository>()),
    );
    i.addSingleton<RemoverPessoaUseCase>(
      () => RemoverPessoaUseCase(i.get<PessoaRepository>()),
    );
    i.addSingleton<BuscarPessoaUseCase>(
      () => BuscarPessoaUseCase(i.get<PessoaRepository>()),
    );
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const HomePage(),
    );
    r.child(
      '/pessoas',
      child: (context) => const GerenciarPessoasPage(),
    );
    r.child(
      '/criar',
      child: (context) => const CriarReuniaoPage(),
    );
    r.child(
      '/detalhes/:id',
      child: (context) => DetalhesReuniaoPage(
        id: int.parse(Modular.args.params['id'] ?? '0'),
      ),
    );
    r.child(
      '/criar-pauta/:reuniao_id',
      child: (context) => CriarPautaPage(
        reuniaoId: int.parse(Modular.args.params['reuniao_id'] ?? '0'),
      ),
    );
    r.child(
      '/criar-ata/:reuniao_id',
      child: (context) => CriarAtaPage(
        reuniaoId: int.parse(Modular.args.params['reuniao_id'] ?? '0'),
      ),
    );
    r.child(
      '/convocacao/:reuniao_id',
      child: (context) => VisualizarConvocacaoPage(
        reuniaoId: int.parse(Modular.args.params['reuniao_id'] ?? '0'),
      ),
    );
    r.child(
      '/ata/:ata_id',
      child: (context) => VisualizarAtaPage(
        ataId: int.parse(Modular.args.params['ata_id'] ?? '0'),
      ),
    );
  }
}
