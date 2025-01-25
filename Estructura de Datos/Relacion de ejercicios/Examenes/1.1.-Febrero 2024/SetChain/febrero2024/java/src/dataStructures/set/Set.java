/**
 * @author Pepe Gallardo, Data Structures, Grado en Informática. UMA.
 *
 * Interface for sets.
 */

package dataStructures.set;

import java.util.Iterator;

/**
 * Interface for sets (collection of non repeated elements).
 *
 * @param <T> Type of elements in set.
 */
public interface Set<T> extends Iterable<T> {
	/** 
	 * Test for set emptiness. 
	 * @return {@code true} if set is empty, else {@code false}.
	 */
	boolean isEmpty();
	
	/**
	 * Retrieves number of elements in set (its cardinal).
	 * @return Number of elements in set.
	 */
    int size();
  
	/**
	 * Inserts new element in set. If element was already included, set is not modified
	 * (this is not considered an error and thus no exception is thrown).
	 * @param x Element to insert.
	 */
	void insert(T x);
	
	/**
	 * Tests whether element is included in set.
	 * @param x Element to test for inclusion.
	 * @return {@code true} if element {@code x} is in set, else {@code false}. 
	 */
	boolean isElem(T x);

	/**
	 * Removes element from set. If element is not in set, set is not modified
	 * (this is not considered an error and thus no exception is thrown).
	 * @param x Element to remove.
	 */
	void delete(T x);
	
	static <T> boolean equals(Set<T> set1, Set<T> set2){

	    boolean res = true;
	    Iterator<T> it = set2.iterator();
	    while (it.hasNext() && res)
	       res = set1.isElem(it.next());
	    if (!res) return false;
	    it = set1.iterator();
	    while (it.hasNext() && res)
	       res = set2.isElem(it.next());
	    return res;
	}

	static <T> int hashCode(Set<T> set) {
	    Iterator<T> it = set.iterator();
	    int sum = 0;
	    while (it.hasNext())
	       sum += it.next().hashCode();
	    return sum;
	}
}
