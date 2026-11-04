import 'package:serverpod/serverpod.dart';
import '../access/current_permission.dart';
import '../generated/protocol.dart';

class ContentEndpoint extends Endpoint {
  Future<void> _authorize(Session session) async {
    if (!(session.authenticated?.scopes.contains(
          const Scope('content.write'),
        ) ??
        false)) {
      throw AccessDeniedException(message: 'Acesso negado');
    }
    await requireCurrentPermission(session, 'content.write');
  }

  void _page(int offset) {
    if (offset < 0) throw ArgumentError('Página inválida');
  }

  String _text(String value, int max, {bool required = true}) {
    final text = value.trim();
    if ((required && text.isEmpty) || text.length > max) {
      throw ArgumentError('Texto inválido');
    }
    return text;
  }

  String? _url(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (text.length > 2048 ||
        uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw ArgumentError('URL inválida');
    }
    return text;
  }

  Future<List<PublicArticle>> articles(Session session, int offset) async {
    _page(offset);
    return PublicArticle.db.find(
      session,
      where: (t) => t.published.equals(true),
      offset: offset,
      limit: 25,
      orderByList: (t) => [
        Order(column: t.createdAt, orderDescending: true),
        Order(column: t.id, orderDescending: true),
      ],
    );
  }

  Future<List<PublicPartner>> partners(Session session, int offset) async {
    _page(offset);
    return PublicPartner.db.find(
      session,
      where: (t) => t.active.equals(true),
      offset: offset,
      limit: 25,
      orderByList: (t) => [Order(column: t.name), Order(column: t.id)],
    );
  }

  Future<List<PublicArticle>> adminArticles(Session session, int offset) async {
    await _authorize(session);
    _page(offset);
    return PublicArticle.db.find(
      session,
      offset: offset,
      limit: 25,
      orderByList: (t) => [
        Order(column: t.updatedAt, orderDescending: true),
        Order(column: t.id, orderDescending: true),
      ],
    );
  }

  Future<List<PublicPartner>> adminPartners(Session session, int offset) async {
    await _authorize(session);
    _page(offset);
    return PublicPartner.db.find(
      session,
      offset: offset,
      limit: 25,
      orderByList: (t) => [Order(column: t.name), Order(column: t.id)],
    );
  }

  Future<PublicArticle> saveArticle(
    Session session,
    int? id,
    String title,
    String summary,
    String body,
    String? externalUrl,
    bool published,
  ) async {
    await _authorize(session);
    final now = DateTime.now().toUtc();
    final article = PublicArticle(
      title: _text(title, 200),
      summary: _text(summary, 1000),
      body: _text(body, 50000, required: false),
      externalUrl: _url(externalUrl),
      published: published,
      createdAt: now,
      updatedAt: now,
    );
    if (article.body.isEmpty && article.externalUrl == null) {
      throw ArgumentError('Informe conteúdo ou link');
    }
    if (id == null) return PublicArticle.db.insertRow(session, article);
    final existing = await PublicArticle.db.findById(session, id);
    if (existing == null) throw ArgumentError('Artigo não encontrado');
    return PublicArticle.db.updateRow(
      session,
      article.copyWith(id: id, createdAt: existing.createdAt),
    );
  }

  Future<PublicPartner> savePartner(
    Session session,
    int? id,
    String name,
    String description,
    String website,
    bool active,
  ) async {
    await _authorize(session);
    final url = _url(website);
    if (url == null) throw ArgumentError('Informe o site');
    final now = DateTime.now().toUtc();
    final partner = PublicPartner(
      name: _text(name, 200),
      description: _text(description, 2000),
      website: url,
      active: active,
      createdAt: now,
      updatedAt: now,
    );
    if (id == null) return PublicPartner.db.insertRow(session, partner);
    final existing = await PublicPartner.db.findById(session, id);
    if (existing == null) throw ArgumentError('Parceiro não encontrado');
    return PublicPartner.db.updateRow(
      session,
      partner.copyWith(id: id, createdAt: existing.createdAt),
    );
  }
}
