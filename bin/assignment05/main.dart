void main() {
  Dictionary dictionary = Dictionary();

  // add, get, delete, update, showAll, count, upsert, exists 메소드 테스트
  dictionary.add('apple', 'a fruit');
  print(dictionary.get('apple')); // 'a fruit'
  dictionary.delete('apple');
  print(dictionary.get('apple')); // null
  dictionary.add('banana', 'another fruit');
  dictionary.update('banana', 'yellow fruit');
  dictionary.showAll(); // 'banana: yellow fruit'
  print(dictionary.count()); // 1
  dictionary.upsert('orange', 'a citrus fruit');
  print(dictionary.get('orange')); // 'a citrus fruit'
  dictionary.upsert('orange', 'a round fruit');
  print(dictionary.get('orange')); // 'a round fruit'
  print(dictionary.exists('orange')); // true
  print(dictionary.exists('grape')); // false

  // bulkAdd, bulkDelete 메소드 테스트
  dictionary.bulkAdd([
    {"term": "dog", "definition": "a domestic animal"},
    {"term": "cat", "definition": "another domestic animal"}
  ]);
  print(dictionary.get('dog')); // 'a domestic animal'
  print(dictionary.count()); // 4
  dictionary.bulkDelete(['dog', 'cat']);
  print(dictionary.count()); // 2
}

typedef Definition = String;

class Dictionary {
  final Map<String, Definition> _words = {};

  void add(String word, Definition definition) {
    _words[word] = definition;
  }

  Definition? get(String word) {
    return _words[word];
  }

  void delete(String word) {
    _words.remove(word);
  }

  void update(String word, Definition definition) {
    if (_words.containsKey(word)) {
      _words[word] = definition;
    }
  }

  void showAll() {
    _words.forEach((word, definition) {
      print('$word: $definition');
    });
  }

  int count() {
    return _words.length;
  }

  void upsert(String word, Definition definition) {
    _words[word] = definition;
  }

  bool exists(String word) {
    return _words.containsKey(word);
  }

  void bulkAdd(List<Map<String, Definition>> words) {
    for (var word in words) {
      add(word['term']!, word['definition']!);
    }
  }

  void bulkDelete(List<String> words) {
    for (var word in words) {
      delete(word);
    }
  }
}
