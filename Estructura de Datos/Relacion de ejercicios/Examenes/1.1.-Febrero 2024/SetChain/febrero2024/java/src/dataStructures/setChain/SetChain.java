// Student's name:
// Student's group:
// Identity number (DNI if Spanish/passport if Erasmus):

package dataStructures.setChain;

import dataStructures.dictionary.Dictionary;
import dataStructures.dictionary.AVLDictionary;
import dataStructures.list.LinkedList;
import dataStructures.set.Set;
import dataStructures.set.HashSet;
import dataStructures.list.List;
import dataStructures.tuple.Tuple2;

import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.StringJoiner;

public class SetChain<T extends Comparable<? super T>> implements Iterable<T>{
  private Set<T> mempool;
  private final Dictionary<Integer, Set<T>> history;
  private int epochNum;

  /* *************************** */
  /* DON'T MODIFY THE CODE ABOVE */
  /* *************************** */

  // * Exercise a) 
  public SetChain() {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise b) 
  public boolean isEmpty() {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise c) 
  public int getEpoch(T transaction) {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise d) 
  public int size() {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise e) 
  public boolean pendingTransactions() {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise f) 
  public void add(T transaction) {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise g) 
  public void validate() {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise h) 
  public void addAll(List<T> transactions) {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise i) 
  private class SetChainIterator implements Iterator<T> {
    public SetChainIterator() {
      throw new UnsupportedOperationException("to be implemented");
    }

    @Override
    public boolean hasNext() {
      throw new UnsupportedOperationException("to be implemented");
    }

    @Override
    public T next() {
      throw new UnsupportedOperationException("to be implemented");
    }
  }

  // * Exercise j) 
  public Iterator<T> iterator() {
    throw new UnsupportedOperationException("to be implemented");
  }

  /* *************************** */
  /* DON'T MODIFY THE CODE BELOW */
  /* *************************** */

  private String setToString(Set<T> set) {
    if(set == null)
      return "(null)";

    StringJoiner sj = new StringJoiner(", ", "{", "}");
    for (T x : set) {
      sj.add(x.toString());
    }
    return sj.toString();
  }

  @Override
	public String toString() {
    String className = getClass().getSimpleName();
    StringJoiner sjHistory = new StringJoiner(", ", "History{", "}");

    StringJoiner sj = new StringJoiner(", ", className + "(", ")");
    sj.add("Mempool" + setToString(mempool));

    if(history == null)
      sj.add("null");
    else {
      for (Tuple2<Integer, Set<T>> t : history.keysValues()) {
        sjHistory.add(t._1() + " -> " + setToString(t._2()));
      }
      sj.add(sjHistory.toString());
    }

    sj.add("EpochNum -> " + epochNum);

    return sj.toString();
  }
	
	public boolean equals(Object object) {
    if(this == object)
      return true;

    if (!(object instanceof SetChain<?>))
      return false;

    SetChain<?> that = (SetChain<?>) object;

    if (this.epochNum != that.epochNum)
      return false;

    if (!this.mempool.equals(that.mempool))
      return false;

    for (Tuple2<Integer, Set<T>> t : this.history.keysValues()) {
      int epoch = t._1();
      Set<? extends Comparable<?>> set = that.history.valueOf(epoch);
      if (set == null || !set.equals(t._2()))
        return false;
    }
    return true;
  }
}
