class Evento {
  final String id;
  final String titulo;
  final String categoria;
  final String data;
  final String local;
  final String organizador;
  final String descricao;
  final String banner;

  const Evento({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.data,
    required this.local,
    required this.organizador,
    required this.descricao,
    required this.banner,
  });
}

const List<Evento> eventos = [
  Evento(
    id: '1',
    titulo: 'Abertura da Semana Acadêmica',
    categoria: 'Palestra',
    data: 'Segunda, 09:00',
    local: 'Auditório Central',
    organizador: 'Reitoria e Centros Acadêmicos',
    descricao:
        'Cerimônia de abertura com a apresentação da programação da semana, '
        'fala da coordenação dos cursos e sorteio de brindes. As inscrições '
        'para as oficinas abrem neste dia.',
    banner: 'assets/banners/semana.jpg',
  ),
  Evento(
    id: '2',
    titulo: 'Hackathon 24h',
    categoria: 'Competição',
    data: 'Sexta, 18:00',
    local: 'Laboratório de Inovação',
    organizador: 'Núcleo de Computação',
    descricao:
        'Maratona de programação por 24 horas. Equipes de até 4 pessoas '
        'desenvolvem uma solução para um desafio do campus, com mentoria de '
        'professores e premiação para os três primeiros colocados.',
    banner: 'assets/banners/hackathon.jpg',
  ),
  Evento(
    id: '3',
    titulo: 'Oficina de Flutter',
    categoria: 'Oficina',
    data: 'Terça, 14:00',
    local: 'Sala 204, Bloco B',
    organizador: 'Prof. Marina Souza',
    descricao:
        'Oficina prática de 3 horas: construa um app com duas telas, '
        'navegação e notificações push. Traga o notebook com o Flutter '
        'instalado. Vagas limitadas a 30 participantes.',
    banner: 'assets/banners/flutter.jpg',
  ),
  Evento(
    id: '4',
    titulo: 'Feira de Projetos',
    categoria: 'Exposição',
    data: 'Quinta, 10:00',
    local: 'Pátio do Campus',
    organizador: 'Coordenação de Extensão',
    descricao:
        'Exposição dos projetos de disciplinas e de iniciação científica. '
        'Visitantes votam no projeto favorito do público.',
    banner: 'assets/banners/feira.jpg',
  ),
  Evento(
    id: '5',
    titulo: 'Carreira em TI',
    categoria: 'Bate-papo',
    data: 'Quarta, 19:00',
    local: 'Auditório Central',
    organizador: 'Egressos do curso',
    descricao:
        'Ex-alunos contam como foi a entrada no mercado, falam sobre '
        'estágios e respondem perguntas da plateia.',
    banner: 'assets/banners/carreira.jpg',
  ),
];

Evento? eventoPorId(String? id) {
  if (id == null) return null;
  for (final e in eventos) {
    if (e.id == id) return e;
  }
  return null;
}
