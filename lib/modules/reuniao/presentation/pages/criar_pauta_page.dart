import 'package:flutter/material.dart';
import '../../application/usecases/reuniao_usecases.dart';
import '../../infra/models/reuniao_model.dart';
import '../../infra/models/pauta_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CriarPautaPage extends StatefulWidget {
  final int reuniaoId;

  const CriarPautaPage({Key? key, required this.reuniaoId}) : super(key: key);

  @override
  State<CriarPautaPage> createState() => _CriarPautaPageState();
}

class _CriarPautaPageState extends State<CriarPautaPage> {
    final List<String> _modelosPauta = [
      'Outro',
      'PRORROGAÇÃO DE PRAZO - PROPOSTA/QUALIFICAÇÃO',
      'PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE',
      'DIPLOMA',
      'INTERRUPÇÃO DE ESTUDOS',
      'APROVEITAMENTO DE DISCIPLINAS DE ALUNO ESPECIAL',
      'COORIENTAÇÃO',
      'EQUIVALÊNCIA DE TÍTULO DE MESTRE',
    ];
    String _modeloSelecionado = 'Outro';

    // Controladores para campos variáveis
    final _nomeAlunoController = TextEditingController();
    final _tipoDefesaController = TextEditingController();
    final _matriculaAlunoController = TextEditingController();
    final _nomeOrientadorController = TextEditingController();
    final _notaDisciplinaController = TextEditingController();
    final _codigoDisciplinaController = TextEditingController();
    final _nomeRelatorController = TextEditingController();
    final _nomeProfessorController = TextEditingController();
    final _semestreController = TextEditingController();
    final _matriculaEspecialController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final BuscarReuniaoUseCase _buscarReuniaoUseCase;
  late final AtualizarReuniaoUseCase _atualizarReuniaoUseCase;

  final _numeroController = TextEditingController();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _processoSeiController = TextEditingController();
 
 

  bool _adReferendum = false;
  bool _fixado = false;

  ReuniaoModel? _reuniao;

  @override
  void initState() {
    super.initState();
    _buscarReuniaoUseCase = Modular.get<BuscarReuniaoUseCase>();
    _atualizarReuniaoUseCase = Modular.get<AtualizarReuniaoUseCase>();
    _reuniao = _buscarReuniaoUseCase(widget.reuniaoId);

    // Auto-complete o número da pauta
    if (_reuniao != null) {
      _numeroController.text = '${_reuniao!.pautas.length + 1}';
    }
    // Inicializa campos se modelo não for "Outro"
    _aplicarModeloPauta(_modeloSelecionado);
  }

  void _aplicarModeloPauta(String modelo) {
    // Limpa todos os campos variáveis
    _tituloController.clear();
    _descricaoController.clear();
    _processoSeiController.clear();
    _nomeAlunoController.clear();
    _matriculaAlunoController.clear();
    _nomeOrientadorController.clear();
    _notaDisciplinaController.clear();
    _codigoDisciplinaController.clear();
    _nomeRelatorController.clear();
    _nomeProfessorController.clear();
    _semestreController.clear();
    _matriculaEspecialController.clear();
    _adReferendum = false;

    switch (modelo) {
      case 'PRORROGAÇÃO DE PRAZO - PROPOSTA/QUALIFICAÇÃO':
        _adReferendum = true;
        break;
      case 'PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE':
        _adReferendum = true;
        break;
      case 'DIPLOMA':
        _tituloController.text = 'PROCESSO SEI';
        _adReferendum = true;
        break;
      case 'INTERRUPÇÃO DE ESTUDOS':
        _tituloController.text = 'Interrupção de Estudos';
        _adReferendum = true;
        break;
      case 'APROVEITAMENTO DE DISCIPLINAS DE ALUNO ESPECIAL':
        _tituloController.text = 'Aproveitamento de Disciplinas de Aluno Especial';
        _adReferendum = true;
        break;
      case 'COORIENTAÇÃO':
        _tituloController.text = 'Coorientação';
        break;
      case 'EQUIVALÊNCIA DE TÍTULO DE MESTRE':
        _tituloController.text = 'Equivalência de Título de Mestre';
        break;
      default:
        break;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
    _processoSeiController.dispose();
  
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reuniao == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Adicionar Pauta')),
        body: const Center(child: Text('Reunião não encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Pauta'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _modeloSelecionado,
                items: _modelosPauta
                    .map((modelo) => DropdownMenuItem(
                          value: modelo,
                          child: Text(modelo, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _modeloSelecionado = value;
                    _aplicarModeloPauta(value);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Modelo de Pauta',
                  border: OutlineInputBorder(),
                ),
              ),
            
              // Container(
              //   padding: const EdgeInsets.only(top: 12),
              //   child: TextFormField(
              //     controller: _numeroController,
              //     decoration: const InputDecoration(
              //       labelText: 'Número da Pauta',
              //       border: OutlineInputBorder(),
              //     ),
              //     validator: (value) {
              //       if (value?.isEmpty ?? true) {
              //         return 'Campo obrigatório';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
           
              if(_modeloSelecionado != "DIPLOMA" && _modeloSelecionado != "PRORROGAÇÃO DE PRAZO - PROPOSTA/QUALIFICAÇÃO" && _modeloSelecionado != "PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE")
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
              ),
             
              // Campos dinâmicos conforme modelo
              if (
                  _modeloSelecionado == 'PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE' ||
                  _modeloSelecionado == 'INTERRUPÇÃO DE ESTUDOS' ||
                  _modeloSelecionado == 'APROVEITAMENTO DE DISCIPLINAS DE ALUNO ESPECIAL' ||
                  _modeloSelecionado == 'EQUIVALÊNCIA DE TÍTULO DE MESTRE' ||
                  _modeloSelecionado == 'DIPLOMA')
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    controller: _processoSeiController,
                    decoration: const InputDecoration(
                      labelText: 'Número do Processo SEI',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              if (_modeloSelecionado == 'PRORROGAÇÃO DE PRAZO - PROPOSTA/QUALIFICAÇÃO' ||
                  _modeloSelecionado == 'PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE' ||
                  _modeloSelecionado == 'INTERRUPÇÃO DE ESTUDOS' ||
                  _modeloSelecionado == 'APROVEITAMENTO DE DISCIPLINAS DE ALUNO ESPECIAL' ||
                  _modeloSelecionado == 'EQUIVALÊNCIA DE TÍTULO DE MESTRE')
                ...[
                  
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _nomeAlunoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Aluno',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _matriculaAlunoController,
                      decoration: const InputDecoration(
                        labelText: 'Número da Matrícula',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              if (_modeloSelecionado == 'PRORROGAÇÃO DE PRAZO - PROPOSTA/QUALIFICAÇÃO' ||
                  _modeloSelecionado == 'PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE' ||
                  _modeloSelecionado == 'INTERRUPÇÃO DE ESTUDOS' ||
                  _modeloSelecionado == 'APROVEITAMENTO DE DISCIPLINAS DE ALUNO ESPECIAL')
                ...[
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _nomeOrientadorController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Orientador',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              if (_modeloSelecionado == 'PRORROGAÇÃO DE PRAZO - PROPOSTA/QUALIFICAÇÃO' ||
                  _modeloSelecionado == 'PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE' ||
                  _modeloSelecionado == 'INTERRUPÇÃO DE ESTUDOS')
                ...[
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Justificativa do Aluno',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              if (_modeloSelecionado == 'APROVEITAMENTO DE DISCIPLINAS DE ALUNO ESPECIAL')
                ...[
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _semestreController,
                      decoration: const InputDecoration(
                        labelText: 'Semestre das Disciplinas',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _codigoDisciplinaController,
                      decoration: const InputDecoration(
                        labelText: 'Códigos das Disciplinas',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _notaDisciplinaController,
                      decoration: const InputDecoration(
                        labelText: 'Notas das Disciplinas',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _matriculaEspecialController,
                      decoration: const InputDecoration(
                        labelText: 'Matrícula do Aluno Especial',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              if (_modeloSelecionado == 'COORIENTAÇÃO')
                ...[
                
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _nomeProfessorController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Professor',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Texto da Solicitação',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              if (_modeloSelecionado == 'EQUIVALÊNCIA DE TÍTULO DE MESTRE')
                ...[
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _nomeRelatorController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Relator',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Texto do Parecer do Relator',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              if (_modeloSelecionado == 'DIPLOMA')
                ...[
                  
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: DropdownButtonFormField<String>(
                      value: _tipoDefesaController.text.isNotEmpty ? _tipoDefesaController.text : 'Dissertação',
                      items: const [
                        DropdownMenuItem(value: 'Dissertação', child: Text('DISSERTAÇÃO')),
                        DropdownMenuItem(value: 'Tese', child: Text('TESE')),
                      ],
                      onChanged: (value) { 
                        setState(() {
                          _tipoDefesaController.text = value ?? 'Dissertação';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Defesa',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecione o tipo de defesa';
                        }
                        return null;
                      },
                    ),
                  ),
                
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _nomeAlunoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Aluno',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              if (_modeloSelecionado == 'Outro')
                ...[
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _descricaoController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                 
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _processoSeiController,
                      decoration: const InputDecoration(
                        labelText: 'Processo SEI (opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
               
                
                ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _adReferendum,
                    onChanged: (value) {
                      setState(() {
                        _adReferendum = value ?? false;
                      });
                    },
                  ),
                  const Text('Ad Referendum'),
                  SizedBox(width: 24),
                  Checkbox(
                    value: _fixado,
                    onChanged: (value) {
                      setState(() {
                        _fixado = value ?? false;
                      });
                    },
                  ),
                  const Text('Fixar tópico'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if(_modeloSelecionado == "DIPLOMA"){
_adicionarPautaDiploma(_nomeAlunoController.text, _processoSeiController.text,_tipoDefesaController.text);
                          }
                          else if(_modeloSelecionado == "PRORROGAÇÃO DE PRAZO - PROPOSTA/QUALIFICAÇÃO"){
                            _adicionarPautaProposta(_nomeAlunoController.text, _matriculaAlunoController.text, _nomeOrientadorController.text, _descricaoController.text);
                          }
                          else if(_modeloSelecionado == "PRORROGAÇÃO DE PRAZO - DISSERTAÇÃO/TESE"){
                            _adicionarPautaDissertacaoTese(_processoSeiController.text, _nomeAlunoController.text, _matriculaAlunoController.text, _nomeOrientadorController.text, _descricaoController.text);
                          }
                          else{
                            _adicionarPauta(null);
                          }
                          
                        }
                      },
                      child: const Text('Adicionar'),
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

  Future<void> _adicionarPautaDiploma(String nomeAluno, String processoSei, String tipoDefesa) async {
final pauta = PautaModel(
      numero: int.parse(_numeroController.text),
      titulo: "PROCESSO SEI",
      descricao: """Homologação do resultado da Comissão Examinadora que aprovou a $tipoDefesa de $nomeAluno, como
também o processo de solicitação de Diploma.""",
      processoSei:
        _processoSeiController.text.isEmpty
          ? null
          : _processoSeiController.text,
      adReferendum: _adReferendum,
      fixado: _fixado, tipoPauta: TipoPauta.diploma,
    );
    await _adicionarPauta(pauta);
  }

    Future<void> _adicionarPautaProposta(String nomeAluno, String matricula, String orientador, String justificativa) async {
final pauta = PautaModel(
      numero: int.parse(_numeroController.text),
      titulo: nomeAluno,
      descricao: justificativa,
      adReferendum: _adReferendum,
      fixado: _fixado,
      matricula: matricula,
      orientador: orientador,
      tipoPauta: TipoPauta.prorrogacaoPropostaQualificacao,
    );
    await _adicionarPauta(pauta);
  }

  Future<void> _adicionarPautaDissertacaoTese(String processo,String aluno, String matricula, String orientador, String justificativa) async {
final pauta = PautaModel(
      numero: int.parse(_numeroController.text),
      titulo: "PROCESSO SEI",
      descricao: justificativa,
      processoSei:processo,
      adReferendum: _adReferendum,
      fixado: _fixado,
      matricula: matricula,
      orientador: orientador,
      tipoPauta: TipoPauta.prorrogacaoDissertacaoTese,
      nomeAluno: aluno,
    );
    await _adicionarPauta(pauta);
  }

  Future<void> _adicionarPauta(PautaModel? pautaPersonalizada) async {

    PautaModel pauta = PautaModel(
      numero: int.parse(_numeroController.text),
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      processoSei:
        _processoSeiController.text.isEmpty
          ? null
          : _processoSeiController.text,
        tipoDefesa: _tipoDefesaController.text.isEmpty
          ? null
          : _tipoDefesaController.text,
      adReferendum: _adReferendum,
      fixado: _fixado, tipoPauta: TipoPauta.outra
      ,
    );
    if(pautaPersonalizada != null){
  pauta = pautaPersonalizada;
}


    final pautas = [..._reuniao!.pautas, pauta];
    pautas.sort((a, b) {
      // Fixados primeiro
      if (a.fixado != b.fixado) {
        return a.fixado ? -1 : 1;
      }
      // Entre fixados, ordem de inclusão (numero)
      if (a.fixado && b.fixado) {
        return a.numero.compareTo(b.numero);
      }
      // Depois ad referendum
      if (a.adReferendum != b.adReferendum) {
        return a.adReferendum ? -1 : 1;
      }
      // Por fim, ordem de inclusão (numero)
      return a.numero.compareTo(b.numero);
    });
    final reuniaoAtualizada = _reuniao!.copyWith(pautas: pautas);

    await _atualizarReuniaoUseCase(widget.reuniaoId, reuniaoAtualizada);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pauta adicionada com sucesso')),
      );
      Modular.to.pop(true);
    }
  }
}
