/**
 * Student's name:
 *
 * Student's group:
 */

import dataStructures.list.List;
import dataStructures.list.ArrayList;
import dataStructures.list.LinkedList;

import java.util.Iterator;


class Bin {
    private int remainingCapacity; // capacity left for this bin
    private List<Integer> weights; // weights of objects included in this bin

    public Bin(int initialCapacity) {
        this.remainingCapacity = initialCapacity;
        this.weights = new ArrayList<>();
    }

    // returns capacity left for this bin
    public int remainingCapacity() {
        return remainingCapacity;
    }

    // adds a new object to this bin
    public void addObject(int weight) {
        if(weight > remainingCapacity){
            throw new IllegalArgumentException("Weight exceeds remaining capacity");
        }
        else {
            remainingCapacity -= weight;
            weights.append(weight);
        }
    }

    // returns an iterable through weights of objects included in this bin
    public Iterable<Integer> objects() {
        
        return weights;
    }

    public String toString() {
        String className = getClass().getSimpleName();
        StringBuilder sb = new StringBuilder(className);
        sb.append("(");
        sb.append(remainingCapacity);
        sb.append(", ");
        sb.append(weights.toString());
        sb.append(")");
        return sb.toString();
    }
}

// Class for representing an AVL tree of bins
public class AVL {
    static private class Node {
        Bin bin; // Bin stored in this node
        int height; // height of this node in AVL tree
        int maxRemainingCapacity; // max capacity left among all bins in tree rooted at this node
        Node left, right; // left and right children of this node in AVL tree

        Node(Bin bin){
            this.bin = bin;
            this.height = 1;
            this.maxRemainingCapacity = bin.remainingCapacity();
            this.left = null;
            this.right = null;
        }
        // recomputes height of this node
        void setHeight() {
            this.height = 1 + Math.max(height(left), height(right));
        }

        // recomputes max capacity among bins in tree rooted at this node
        void setMaxRemainingCapacity() {
            this.maxRemainingCapacity = Math.max( bin.remainingCapacity(), Math.max(maxRemainingCapacity(left), maxRemainingCapacity(right)) );
        }

        // left-rotates this node. Returns root of resulting rotated tree
        Node rotateLeft() {
            Node newRoot = this.right;
            this.right = newRoot.left;
            newRoot.setHeight();
            newRoot.setMaxRemainingCapacity();
            return newRoot;
        }
    }

    private static int height(Node node) {
        int height = 0;
        if(node!=null){
            height =node.height;
        }
        return height;
    }

    private static int maxRemainingCapacity(Node node) {
        int remaincap = 0;

        if(node!=null){
            remaincap = node.maxRemainingCapacity;
        }
        return remaincap;
    }

    private Node root; // root of AVL tree

    public AVL() {
        this.root = null;
    }

    // adds a new bin at the end of right spine.
    private void addNewBin(Bin bin) {
        
        root = addNewBin(root,bin);
    }
    private Node addNewBin(Node n, Bin bin) {
        if (n == null) {
            Node nod= new Node(bin);
            return nod;
        }

        n.right = addNewBin(n.right, bin);

        if (height(n.right) > height(n.left) + 1) {
            n = n.rotateLeft();
        } else {
            n.setHeight();
            n.setMaxRemainingCapacity();
        }

        return n;
    }
    // adds an object to first suitable bin. Adds
    // a new bin if object cannot be inserted in any existing bin
/*f) (2.0 puntos) 
Define el método void addFirst(int initialCapacity, int weight) de 
la clase AVL que tome la capacidad de los cubos del problema (W), el peso de un objeto a añadir y 
que añada dicho objeto al primer cubo que pueda albergarlo o añada un nuevo cubo al final de la 
espina derecha si el nuevo objeto no cabe en ningún cubo. El algoritmo será el siguiente: 
 Si el AVL está vacío o no cabe en ningún cubo, se añadirá un nuevo nodo con un cubo con el 
objeto al final de la espina derecha. 
 En otro caso, si la capacidad restante máxima del hijo izquierdo es mayor o igual al peso del 
objeto, se añadirá el objeto al primer cubo posible del hijo izquierdo. 
 En otro caso, si la capacidad restante del cubo en el nodo raíz es mayor o igual al peso del 
objeto, se añadirá el objeto al cubo en la raíz. 
 En otro caso, se añadirá el objeto al primer cubo posible del hijo derecho.  */
    public void addFirst(int initialCapacity, int weight) {
        root = addFirst(root,initialCapacity,weight);
    }
    private Node addFirst(Node n, int initialCapacity, int weight) {
        if(n == null ){
            Bin newBin = new Bin(initialCapacity);
            newBin.addObject(weight);
            return new Node(newBin);
        }

        if(weight <= maxRemainingCapacity(n.left)){
            n.left = addFirst(n.left, initialCapacity, weight);
        }else if(weight <= n.bin.remainingCapacity()){
            n.bin.addObject(weight);
        }else{
            n.right = addFirst(n.right,initialCapacity,weight);
        }

        n.setHeight();
        n.setMaxRemainingCapacity();

        return n;
    }
  

    public void addAll(int initialCapacity, int[] weights) {
        for (int weight : weights) {
            addFirst(initialCapacity, weight);
        }
    }
    

    public List<Bin> toList() {
        List<Bin> binList = new ArrayList<>();
        toListHelper(root, binList);
        return binList;
    }
    
    private void toListHelper(Node node, List<Bin> binList) {
        if (node != null) {
            toListHelper(node.left, binList);
            binList.append(node.bin);
            toListHelper(node.right, binList);
        }
    }
    

    public String toString() {
        String className = getClass().getSimpleName();
        StringBuilder sb = new StringBuilder(className);
        sb.append("(");
        stringBuild(sb, root);
        sb.append(")");
        return sb.toString();
    }

    private static void stringBuild(StringBuilder sb, Node node) {
        if(node==null)
            sb.append("null");
        else {
            sb.append(node.getClass().getSimpleName());
            sb.append("(");
            sb.append(node.bin);
            sb.append(", ");
            sb.append(node.height);
            sb.append(", ");
            sb.append(node.maxRemainingCapacity);
            sb.append(", ");
            stringBuild(sb, node.left);
            sb.append(", ");
            stringBuild(sb, node.right);
            sb.append(")");
        }
    }
}

class LinearBinPacking {
    public static List<Bin> linearBinPacking(int initialCapacity, List<Integer> weights) {
        List<Bin> bins = new ArrayList<>();

        for(int weight : weights){
            boolean placed = false;
            for(Bin bin: bins){
                if(bin.remainingCapacity() >= weight){
                    bin.addObject(weight);
                    placed = true;
                    break;
                }
            }
            if(!placed){
                Bin newBin = new Bin (initialCapacity);
                newBin.addObject(weight);
            }
        }
        return bins;
    }
	
	public static Iterable<Integer> allWeights(Iterable<Bin> bins) {
        List<Integer> allweighs = new ArrayList<>();
        for(Bin bin: bins){
            for(int weight: bin.objects()){
                allweighs.append(weight);
            }
        }
        return allweighs;		
	}
}