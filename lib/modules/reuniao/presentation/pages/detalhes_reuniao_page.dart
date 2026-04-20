import 'package:flutter/material.dart';
import '../../application/usecases/reuniao_usecases.dart';
import '../../infra/models/pauta_model.dart';
import '../../infra/models/reuniao_model.dart';
import '../../infra/models/participante_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/locale/date_formatter.dart';

class DetalhesReuniaoPage extends StatefulWidget {
  final int id;

  const DetalhesReuniaoPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetalhesReuniaoPage> createState() => _DetalhesReuniaoPageState();
}

class _DetalhesReuniaoPageState extends State<DetalhesReuniaoPage> {
  late final BuscarReuniaoUseCase _buscarReuniaoUseCase;
  late final AtualizarReuniaoUseCase _atualizarReuniaoUseCase;

  ReuniaoModel? _reuniao;

  @override
  void initState() {
    super.initState();
    _buscarReuniaoUseCase = Modular.get<BuscarReuniaoUseCase>();
    _atualizarReuniaoUseCase = Modular.get<AtualizarReuniaoUseCase>();
    _reuniao = _buscarReuniaoUseCase(widget.id);
  }

  void _reloadReuniao() {
    final reuniao = _buscarReuniaoUseCase(widget.id);
    if (mounted) {
      setState(() {
        _reuniao = reuniao;
      });
    }
  }

  Future<void> _atualizarReuniaoModelo(ReuniaoModel reuniaoAtualizada) async {
    await _atualizarReuniaoUseCase(widget.id, reuniaoAtualizada);
    if (mounted) {
      setState(() {
        _reuniao = reuniaoAtualizada;
      });
    }
  }

  Future<void> _removerPauta(int index) async {
    final pautas = List<PautaModel>.from(_reuniao!.pautas)..removeAt(index);
    final reuniaoAtualizada = _reuniao!.copyWith(pautas: pautas);
    await _atualizarReuniaoModelo(reuniaoAtualizada);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pauta removida com sucesso')),
      );
    }
  }

  Future<void> _removerParticipante(int index) async {
    final participantes = List<ParticipanteModel>.from(_reuniao!.participantes)
      ..removeAt(index);
    final reuniaoAtualizada = _reuniao!.copyWith(participantes: participantes);
    await _atualizarReuniaoModelo(reuniaoAtualizada);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Participante removido com sucesso')),
      );
    }
  }

  Future<void> _editarPauta(PautaModel pauta, int index) async {
    final numeroController = TextEditingController(
      text: pauta.numero.toString(),
    );
    final tituloController = TextEditingController(text: pauta.titulo);
    final descricaoController = TextEditingController(text: pauta.descricao);
    final processoController = TextEditingController(
      text: pauta.processoSei ?? '',
    );
    final solicitanteController = TextEditingController(
      text: pauta.solicitante ?? '',
    );
    final relatorController = TextEditingController(text: pauta.relator ?? '');
    final decisaoController = TextEditingController(text: pauta.decisao ?? '');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Pauta'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: numeroController,
                    decoration: const InputDecoration(labelText: 'Número'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Informe o número da pauta';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Informe o título';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descricaoController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: processoController,
                    decoration: const InputDecoration(
                      labelText: 'Processo SEI',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: solicitanteController,
                    decoration: const InputDecoration(labelText: 'Solicitante'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: relatorController,
                    decoration: const InputDecoration(labelText: 'Relator'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: decisaoController,
                    decoration: const InputDecoration(labelText: 'Decisão'),
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
                  final pautaAtualizada = pauta.copyWith(
                    numero: int.tryParse(numeroController.text) ?? pauta.numero,
                    titulo: tituloController.text,
                    descricao: descricaoController.text,
                    processoSei:
                        processoController.text.isEmpty
                            ? null
                            : processoController.text,
                    solicitante:
                        solicitanteController.text.isEmpty
                            ? null
                            : solicitanteController.text,
                    relator:
                        relatorController.text.isEmpty
                            ? null
                            : relatorController.text,
                    decisao:
                        decisaoController.text.isEmpty
                            ? null
                            : decisaoController.text,
                  );

                  final pautas = List<PautaModel>.from(_reuniao!.pautas);
                  pautas[index] = pautaAtualizada;

                  await _atualizarReuniaoModelo(
                    _reuniao!.copyWith(pautas: pautas),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pauta atualizada com sucesso'),
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

  Future<void> _editarParticipante(
    ParticipanteModel participante,
    int index,
  ) async {
    final nomeController = TextEditingController(text: participante.nome);
    final titulacaoController = TextEditingController(
      text: participante.titulacao,
    );
    int tipoSelecionado = participante.tipo;
    final siapeController = TextEditingController(text: participante.siape ?? '');
    final cpfController = TextEditingController(text: participante.cpf ?? '');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Participante'),
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
                  DropdownButtonFormField<int>(
                    value: tipoSelecionado,
                    items: TipoParticipante.values
                        .map(
                          (tipo) => DropdownMenuItem(
                            value: tipo.index,
                            child: Text(tipo.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        tipoSelecionado = value;
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Tipo'),
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
                  final participanteAtualizado = participante.copyWith(
                    nome: nomeController.text,
                    titulacao: titulacaoController.text,
                    tipo: tipoSelecionado,
                    siape: siapeController.text.isEmpty
                        ? null
                        : siapeController.text,
                    cpf: cpfController.text.isEmpty
                        ? null
                        : cpfController.text,
                  );

                  final participantes = List<ParticipanteModel>.from(
                    _reuniao!.participantes,
                  );
                  participantes[index] = participanteAtualizado;

                  await _atualizarReuniaoModelo(
                    _reuniao!.copyWith(participantes: participantes),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Participante atualizado com sucesso'),
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

  Future<void> _adicionarParticipante() async {
    final nomeController = TextEditingController();
    final titulacaoController = TextEditingController();
    int tipoSelecionado = TipoParticipante.membro.index;
    final siapeController = TextEditingController();
    final cpfController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Participante'),
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
                  DropdownButtonFormField<int>(
                    value: tipoSelecionado,
                    items: TipoParticipante.values
                        .map(
                          (tipo) => DropdownMenuItem(
                            value: tipo.index,
                            child: Text(tipo.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        tipoSelecionado = value;
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Tipo'),
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
                  final novoParticipante = ParticipanteModel(
                    nome: nomeController.text,
                    titulacao: titulacaoController.text,
                    tipo: tipoSelecionado,
                    siape: siapeController.text.isEmpty
                        ? null
                        : siapeController.text,
                    cpf: cpfController.text.isEmpty
                        ? null
                        : cpfController.text,
                  );

                  final participantes = List<ParticipanteModel>.from(
                    _reuniao!.participantes,
                  )..add(novoParticipante);

                  await _atualizarReuniaoModelo(
                    _reuniao!.copyWith(participantes: participantes),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Participante adicionado com sucesso'),
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

  @override
  Widget build(BuildContext context) {
    if (_reuniao == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhes da Reunião')),
        body: const Center(child: Text('Reunião não encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Reunião'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildParticipantesCard(),
            const SizedBox(height: 16),
            _buildPautasCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Modular.to.pushNamed('/convocacao/${widget.id}');
                    },
                    icon: const Icon(Icons.file_open),
                    label: const Text('Ver Convocação'),
                  ),
                ),
                const SizedBox(width: 8),
                if (_reuniao!.status == StatusReuniao.realizada.index)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Modular.to.pushNamed('/criar-ata/${widget.id}');
                      },
                      icon: const Icon(Icons.description),
                      label: const Text('Criar Ata'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_reuniao!.numero} Reunião ${_reuniao!.tipo}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Data:', DateFormatter.formatDate(_reuniao!.data)),
            _buildInfoRow('Hora:', _reuniao!.hora),
            _buildInfoRow('Local:', _reuniao!.local),
            _buildInfoRow(
              'Status:',
              _statusToString(StatusReuniao.values[_reuniao!.status]),
            ),
            if (_reuniao!.notas != null && _reuniao!.notas!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Notas:', _reuniao!.notas!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Participantes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _adicionarParticipante,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_reuniao!.participantes.isEmpty)
              const Text('Nenhum participante adicionado')
            else
              ..._reuniao!.participantes.asMap().entries.map((entry) {
                final index = entry.key;
                final participante = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${participante.titulacao} ${participante.nome}',
                      ),
                      subtitle: Text(
                        TipoParticipante.values[participante.tipo].name,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed:
                                () => _editarParticipante(participante, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Remover Participante'),
                                      content: const Text(
                                        'Deseja remover este participante?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Remover'),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                await _removerParticipante(index);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPautasCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pautas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Modular.to.pushNamed('/criar-pauta/${widget.id}').then((
                      result,
                    ) {
                      if (result == true) {
                        _reloadReuniao();
                      }
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_reuniao!.pautas.isEmpty)
              const Text('Nenhuma pauta adicionada')
            else
              ..._reuniao!.pautas.asMap().entries.map((entry) {
                final index = entry.key;
                final pauta = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${pauta.numero}. ${pauta.titulo}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pauta.descricao.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(pauta.descricao),
                          ],
                          if (pauta.processoSei != null &&
                              pauta.processoSei!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Processo: ${pauta.processoSei}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editarPauta(pauta, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Remover Pauta'),
                                      content: const Text(
                                        'Deseja remover esta pauta?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Remover'),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                await _removerPauta(index);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _statusToString(StatusReuniao status) {
    switch (status) {
      case StatusReuniao.planejamento:
        return 'Planejamento';
      case StatusReuniao.agendada:
        return 'Agendada';
      case StatusReuniao.realizada:
        return 'Realizada';
      case StatusReuniao.cancelada:
        return 'Cancelada';
    }
  }
}
