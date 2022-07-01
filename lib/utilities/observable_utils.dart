class Observer<T> {
  Function(T) _notify;

  Observer(this._notify);

  void notify(T notification) {
    _notify(notification);
  }
}

class Observable<T> {
  List<Observer<T>> _observers;

  Observable([List<Observer<T>>? observers]) : _observers = observers ?? [];

  void registerObserver(Observer<T> observer) {
    _observers.add(observer);
    print('register new observer, actual count: ${_observers.length}');
  }

  void unregisterObserver(Observer<T> observer) {
    _observers.remove(observer);
    print('unregister observer, actual count: ${_observers.length}');
  }

  void notifyObservers(T notification) {
    print('on notify ! observer actual count: ${_observers.length}');
    List<Observer>.from(_observers).forEach((element) {
      element.notify(notification);
    });
  }
}
