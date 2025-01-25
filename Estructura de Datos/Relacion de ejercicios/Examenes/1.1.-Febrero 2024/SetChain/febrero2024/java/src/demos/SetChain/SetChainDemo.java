package demos.SetChain;

import dataStructures.list.LinkedList;
import dataStructures.list.List;
import dataStructures.setChain.SetChain;
import dataStructures.setChain.SetChainException;


public class SetChainDemo {
  public static void main(String[] args) {
    testSetChain();
  }

  private static void testSetChain() {
    SetChain<Integer> sc = new SetChain<Integer>();
    System.out.println("SetChain created");
    if (sc.isEmpty()) {
      System.out.println("SetChain is empty: "+sc);
    }
    List<Integer> l = new LinkedList<>();
    l.append(1);
    l.append(2);
    l.append(3);
    sc.addAll(l);
    System.out.println("SetChain addAll <1,2,3>");
    if (sc.isEmpty()) {
      System.out.println("SetChain is empty: "+sc);
    }
    sc.validate();
    System.out.print("SetChain validated: ");
    if (sc.isEmpty()) {
      System.out.println("SetChain is empty: "+sc);
    } else {
      System.out.println(sc);
    }
    l = new LinkedList<Integer>();
    l.append(4);
    l.append(5);
    l.append(6);
    sc.addAll(l);
    sc.validate();
    l = new LinkedList<Integer>();
    l.append(7);
    l.append(8);
    l.append(9);
    sc.addAll(l);
    sc.validate();
    System.out.println("Contents " + sc.toString());

    l = new LinkedList<Integer>();
    l.append(9);
    l.append(7);
    l.append(8);
    sc.addAll(l);
    try {
      sc.validate();
    } catch (SetChainException e) {
      System.out.println(e);
    }

    System.out.println("Contents after validating existing transactions: " + sc);

    System.out.println("Epoch for validated transaction 6? " + sc.getEpoch(6));
    System.out.println("Epoch for validated transaction 11? " + sc.getEpoch(11));
  
  	System.out.println("Test iterator");
		for(Integer t : sc){
			System.out.println(t);
		}
  }
}
