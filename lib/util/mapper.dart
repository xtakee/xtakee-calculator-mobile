// generic mapper class
abstract class Mapper<T, V> {
  V from(T from);
  T to(V from);
}
