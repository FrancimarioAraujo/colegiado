import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../application/usecases/reuniao_usecases.dart';
import '../../infra/models/reuniao_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/locale/date_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final RemoverReuniaoUseCase _removerReuniaoUseCase;

  @override
  void initState() {
    super.initState();
    _removerReuniaoUseCase = Modular.get<RemoverReuniaoUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reuniões do Colegiado'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Gerenciar Pessoas',
            onPressed: () => Modular.to.pushNamed('/pessoas'),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed('/criar'),
        tooltip: 'Nova Reunião',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder<Box<ReuniaoModel>>(
      valueListenable: Hive.box<ReuniaoModel>('reunioes').listenable(),
      builder: (context, box, _) {
        final reunioes = box.values.toList();
        print('Reuniões no box: ${reunioes.length}');

        if (reunioes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma reunião cadastrada',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: reunioes.length,
          itemBuilder: (context, index) {
            final reuniao = reunioes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                title: Text('${reuniao.numero}ª Reunião ${reuniao.tipo}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data: ${DateFormatter.formatDate(reuniao.data)} às ${reuniao.hora} horas',
                    ),
                    Text('Local: ${reuniao.local}'),
                    Text('Pautas: ${reuniao.pautas.length}'),
                  ],
                ),
                isThreeLine: true,
                trailing: PopupMenuButton(
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          onTap: () {
                            Modular.to.pushNamed('/detalhes/$index');
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.visibility),
                              SizedBox(width: 8),
                              Text('Detalhes'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Modular.to.pushNamed('/criar-pauta/$index');
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.note_add),
                              SizedBox(width: 8),
                              Text('Adicionar Pauta'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Modular.to.pushNamed('/convocacao/$index');
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.file_open),
                              SizedBox(width: 8),
                              Text('Convocação'),
                            ],
                          ),
                        ),
                        if (reuniao.status == StatusReuniao.realizada.index)
                          PopupMenuItem(
                            onTap: () {
                              Modular.to.pushNamed('/criar-ata/$index');
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.description),
                                SizedBox(width: 8),
                                Text('Criar Ata'),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          onTap: () => _removerReuniaoConfirm(context, index),
                          child: const Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Remover',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
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

  void _removerReuniaoConfirm(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remover Reunião'),
            content: const Text('Tem certeza que deseja remover esta reunião?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await _removerReuniaoUseCase(index);
                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reunião removida com sucesso'),
                      ),
                    );
                  }
                },
                child: const Text('Remover'),
              ),
            ],
          ),
    );
  }
}
