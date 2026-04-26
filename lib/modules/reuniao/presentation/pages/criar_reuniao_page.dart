import 'package:flutter/material.dart';
import '../../application/usecases/reuniao_usecases.dart';
import '../../application/usecases/pessoa_usecases.dart';
import '../../infra/models/reuniao_model.dart';
import '../../infra/models/participante_model.dart';
import '../../infra/models/pessoa_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/locale/date_formatter.dart';

class CriarReuniaoPage extends StatefulWidget {
  const CriarReuniaoPage({Key? key}) : super(key: key);

  @override
  State<CriarReuniaoPage> createState() => _CriarReuniaoPageState();
}

class _CriarReuniaoPageState extends State<CriarReuniaoPage> {
  final _formKey = GlobalKey<FormState>();
  late final SalvarReuniaoUseCase _salvarReuniaoUseCase;
  late final ListarPessoasUseCase _listarPessoasUseCase;

  final _numeroController = TextEditingController();
  final _tipoController = TextEditingController(text: 'Ordinária');
  final _horaController = TextEditingController(text: '14:00');
  final _localController = TextEditingController(text: 'Sala Virtual');

  DateTime? _dataSelecionada;
  int _statusSelecionado = 0; // Agendada
  final _participantes = <ParticipanteModel>[];

  final _nomeParticipanteController = TextEditingController();
  final _titulacaoParticipanteController = TextEditingController(text: 'Prof.');
  int _tipoParticipanteSelecionado = 2; // Membro

  List<PessoaModel> _pessoasDisponiveis = [];
  final Set<int> _pessoasSelecionadas = {};

  @override
  void initState() {
    super.initState();
    _salvarReuniaoUseCase = Modular.get<SalvarReuniaoUseCase>();
    _listarPessoasUseCase = Modular.get<ListarPessoasUseCase>();
    _carregarPessoas();
  }

  void _carregarPessoas() {
    setState(() {
      _pessoasDisponiveis = _listarPessoasUseCase();
    });
  }

  void _adicionarParticipantesSelecionados() {
    for (final index in _pessoasSelecionadas) {
      if (index < _pessoasDisponiveis.length) {
        final pessoa = _pessoasDisponiveis[index];
        final participante = ParticipanteModel(
          nome: pessoa.nome,
          titulacao: pessoa.titulacao,
          tipo: 2, // Membro por padrão
          siape: pessoa.siape,
          cpf: pessoa.cpf,
        );
        _participantes.add(participante);
      }
    }
    setState(() {
      _pessoasSelecionadas.clear();
    });
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _tipoController.dispose();
    _horaController.dispose();
    _localController.dispose();
    _nomeParticipanteController.dispose();
    _titulacaoParticipanteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Reunião'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Seção de informações básicas
              _buildSectionTitle('Informações da Reunião'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número (ex: 1, 2, 3)',
                  hintText: '1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _tipoController.text,
                items: ['Ordinária', 'Extraordinária']
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _tipoController.text = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de Reunião',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selecionarData,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _dataSelecionada == null
                        ? 'Selecione a data'
                        : DateFormatter.formatDate(_dataSelecionada!),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(
                  labelText: 'Hora (ex: 14:00)',
                  hintText: '14:00',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(
                  labelText: 'Local',
                  hintText: 'Sala virtual, Sala 001, etc.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _statusSelecionado,
                items: StatusReuniao.values
                    .asMap()
                    .entries
                    .map((entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(_statusToString(entry.value)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _statusSelecionado = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
           
              // const SizedBox(height: 24),

              // // Seção de participantes
              // _buildSectionTitle('Participantes'),
              // const SizedBox(height: 8),

              // // Seção de seleção de pessoas pré-cadastradas
              // if (_pessoasDisponiveis.isNotEmpty) ...[
              //   Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(12),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           const Text(
              //             'Selecionar Pessoas Cadastradas',
              //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //           ),
              //           const SizedBox(height: 8),
              //           Wrap(
              //             spacing: 8,
              //             runSpacing: 8,
              //             children: _pessoasDisponiveis.asMap().entries.map((entry) {
              //               final index = entry.key;
              //               final pessoa = entry.value;
              //               final isSelected = _pessoasSelecionadas.contains(index);
              //               return FilterChip(
              //                 label: Text('${pessoa.titulacao} ${pessoa.nome}'),
              //                 selected: isSelected,
              //                 onSelected: (selected) {
              //                   setState(() {
              //                     if (selected) {
              //                       _pessoasSelecionadas.add(index);
              //                     } else {
              //                       _pessoasSelecionadas.remove(index);
              //                     }
              //                   });
              //                 },
              //               );
              //             }).toList(),
              //           ),
              //           const SizedBox(height: 12),
              //           ElevatedButton.icon(
              //             onPressed: _pessoasSelecionadas.isNotEmpty ? _adicionarParticipantesSelecionados : null,
              //             icon: const Icon(Icons.add),
              //             label: const Text('Adicionar Selecionados'),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   const SizedBox(height: 16),
              // ],

              // Seção de adicionar participante manualmente
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         const Text(
              //           'Adicionar Participante Manualmente',
              //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //         ),
              //         const SizedBox(height: 12),
              //         TextFormField(
              //           controller: _nomeParticipanteController,
              //           decoration: const InputDecoration(
              //             labelText: 'Nome do Participante',
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //         const SizedBox(height: 12),
              //         Row(
              //           children: [
              //             Expanded(
              //               child: TextFormField(
              //                 controller: _titulacaoParticipanteController,
              //                 decoration: const InputDecoration(
              //                   labelText: 'Titulação',
              //                   border: OutlineInputBorder(),
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(width: 12),
              //             Expanded(
              //               child: DropdownButtonFormField<int>(
              //                 value: _tipoParticipanteSelecionado,
              //                 items: [
              //                   const DropdownMenuItem(
              //                     value: 0,
              //                     child: Text('Presidente'),
              //                   ),
              //                   const DropdownMenuItem(
              //                     value: 1,
              //                     child: Text('Secretário'),
              //                   ),
              //                   const DropdownMenuItem(
              //                     value: 2,
              //                     child: Text('Membro'),
              //                   ),
              //                 ],
              //                 onChanged: (value) {
              //                   if (value != null) {
              //                     setState(() {
              //                       _tipoParticipanteSelecionado = value;
              //                     });
              //                   }
              //                 },
              //                 decoration: const InputDecoration(
              //                   labelText: 'Tipo',
              //                   border: OutlineInputBorder(),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 12),
              //         ElevatedButton.icon(
              //           onPressed: _adicionarParticipante,
              //           icon: const Icon(Icons.add),
              //           label: const Text('Adicionar Participante'),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),
              if (_participantes.isNotEmpty) ...[
                ..._participantes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final participante = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        title: Text(participante.nome),
                        subtitle: Text(
                          '${participante.titulacao} - ${TipoParticipante.values[participante.tipo].name}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _participantes.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 12),
              ],

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _dataSelecionada != null) {
                          _salvarReuniao();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Preencha todos os campos'),
                            ),
                          );
                        }
                      },
                      child: const Text('Salvar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () => Modular.to.pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  void _adicionarParticipante() {
    if (_nomeParticipanteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome do participante'),
        ),
      );
      return;
    }

    setState(() {
      _participantes.add(
        ParticipanteModel(
          nome: _nomeParticipanteController.text,
          titulacao: _titulacaoParticipanteController.text,
          tipo: _tipoParticipanteSelecionado,
        ),
      );
      _nomeParticipanteController.clear();
      _titulacaoParticipanteController.text = 'Prof.';
      _tipoParticipanteSelecionado = 2;
    });
  }

  Future<void> _salvarReuniao() async {
    final reuniao = ReuniaoModel(
      numero: _numeroController.text,
      tipo: _tipoController.text,
      data: _dataSelecionada!,
      hora: _horaController.text,
      local: _localController.text,
      status: _statusSelecionado,
      pautas: [],
      participantes: _participantes,
      dataInclusao: DateTime.now(),
    );

    try {
      print('Salvando reunião: ${reuniao.numero}');
      await _salvarReuniaoUseCase(reuniao);
      print('Reunião salva com sucesso');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reunião criada com sucesso'),
          ),
        );
        Modular.to.pop();
      }
    } catch (e) {
      print('Erro ao salvar reunião: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar reunião: $e'),
          ),
        );
      }
    }
  }

  String _statusToString(StatusReuniao status) {
    switch (status) {
    
      case StatusReuniao.agendada:
        return 'Agendada';
      case StatusReuniao.realizada:
        return 'Realizada';
      
    }
  }
}
