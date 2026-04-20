import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../application/usecases/pessoa_usecases.dart';
import '../../infra/models/pessoa_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GerenciarPessoasPage extends StatefulWidget {
  const GerenciarPessoasPage({Key? key}) : super(key: key);

  @override
  State<GerenciarPessoasPage> createState() => _GerenciarPessoasPageState();
}

class _GerenciarPessoasPageState extends State<GerenciarPessoasPage> {
  late final RemoverPessoaUseCase _removerPessoaUseCase;

  @override
  void initState() {
    super.initState();
    _removerPessoaUseCase = Modular.get<RemoverPessoaUseCase>();
  }

  Future<void> _adicionarPessoa() async {
    final nomeController = TextEditingController();
    final titulacaoController = TextEditingController(text: 'Prof.');
    final siapeController = TextEditingController();
    final cpfController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Pessoa'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Informe o nome';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titulacaoController,
                    decoration: const InputDecoration(labelText: 'Titulação'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Informe a titulação';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: siapeController,
                    decoration: const InputDecoration(labelText: 'SIAPE'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final pessoa = PessoaModel(
                    nome: nomeController.text,
                    titulacao: titulacaoController.text,
                    siape: siapeController.text.isEmpty ? null : siapeController.text,
                    cpf: cpfController.text.isEmpty ? null : cpfController.text,
                    dataInclusao: DateTime.now(),
                  );

                  final salvarPessoaUseCase = Modular.get<SalvarPessoaUseCase>();
                  await salvarPessoaUseCase(pessoa);

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pessoa adicionada com sucesso'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarPessoa(PessoaModel pessoa, int index) async {
    final nomeController = TextEditingController(text: pessoa.nome);
    final titulacaoController = TextEditingController(text: pessoa.titulacao);
    final siapeController = TextEditingController(text: pessoa.siape ?? '');
    final cpfController = TextEditingController(text: pessoa.cpf ?? '');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Pessoa'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Informe o nome';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titulacaoController,
                    decoration: const InputDecoration(labelText: 'Titulação'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Informe a titulação';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: siapeController,
                    decoration: const InputDecoration(labelText: 'SIAPE'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final pessoaAtualizada = pessoa.copyWith(
                    nome: nomeController.text,
                    titulacao: titulacaoController.text,
                    siape: siapeController.text.isEmpty ? null : siapeController.text,
                    cpf: cpfController.text.isEmpty ? null : cpfController.text,
                    dataAtualizacao: DateTime.now(),
                  );

                  final atualizarPessoaUseCase = Modular.get<AtualizarPessoaUseCase>();
                  await atualizarPessoaUseCase(index, pessoaAtualizada);

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pessoa atualizada com sucesso'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removerPessoa(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Pessoa'),
        content: const Text('Deseja remover esta pessoa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _removerPessoaUseCase(index);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pessoa removida com sucesso')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Pessoas'),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarPessoa,
        tooltip: 'Adicionar Pessoa',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder<Box<PessoaModel>>(
      valueListenable: Hive.box<PessoaModel>('pessoas').listenable(),
      builder: (context, box, _) {
        final pessoas = box.values.toList();

        if (pessoas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma pessoa cadastrada',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: pessoas.length,
          itemBuilder: (context, index) {
            final pessoa = pessoas[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                title: Text('${pessoa.titulacao} ${pessoa.nome}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pessoa.siape != null && pessoa.siape!.isNotEmpty)
                      Text('SIAPE: ${pessoa.siape}'),
                    if (pessoa.cpf != null && pessoa.cpf!.isNotEmpty)
                      Text('CPF: ${pessoa.cpf}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editarPessoa(pessoa, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerPessoa(index),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}