// Student's name:
// Student's group:
// Identity number (DNI if Spanish/passport if Erasmus):

package dataStructures.skewedTree;

import dataStructures.list.*;

import java.util.Iterator;

class Tree<K> {
  K elem;
  Tree<K> left, right;

  public Tree(K k, Tree<K> l, Tree<K> r) {
    elem = k;
    left = l;
    right = r;
  }
}

class SimpleBST<K extends Comparable<? super K>> {
  Tree<K> root;

  public SimpleBST(Tree<K> r) {
    root = r;
  }
}

public class SkewedTree {
  private static SimpleBST<Integer> bst1() {
    Tree<Integer> b20 = new Tree<>(20, null, null);
    Tree<Integer> b18 = new Tree<>(18, null, b20);
    Tree<Integer> b25 = new Tree<>(25, b18, null);
    Tree<Integer> b30 = new Tree<>(30, b25, null);
    Tree<Integer> b15 = new Tree<>(15, null, b30);
    return new SimpleBST<>(b15);
  }

  private static SimpleBST<Integer> bst2() {
    Tree<Integer> b20 = new Tree<>(20, null, null);
    Tree<Integer> b16 = new Tree<>(16, null, null);
    Tree<Integer> b18 = new Tree<>(18, b16, b20);
    Tree<Integer> b25 = new Tree<>(25, b18, null);
    Tree<Integer> b30 = new Tree<>(30, b25, null);
    Tree<Integer> b15 = new Tree<>(15, null, b30);
    return new SimpleBST<>(b15);
  }

  private static void skewedTest() {
    List<Integer> list = invPreOrder(bst1());
    System.out.println(list); // LinkedList(20,18,25,30,15)
    boolean b = skewed(list); // is skewed
    System.out.println(b); // true

    list = invPreOrder(bst2());
    System.out.println(list); // LinkedList(20,16,18,25,30,15)
    b = skewed(list); // isn't skewed
    System.out.println(b); // false
  }

  public static void main(String[] args) {
    skewedTest();
  }

  /* *************************** */
  /* DON'T MODIFY THE CODE ABOVE */
  /* *************************** */

  // * Exercise k)
  private static <K extends Comparable<? super K>> List<K> invPreOrder(SimpleBST<K> bst) {
    throw new UnsupportedOperationException("to be implemented");
  }

  // * Exercise l)
  public static <K extends Comparable<? super K>> boolean skewed(List<K> rpo) {
    throw new UnsupportedOperationException("to be implemented");
  }
}
