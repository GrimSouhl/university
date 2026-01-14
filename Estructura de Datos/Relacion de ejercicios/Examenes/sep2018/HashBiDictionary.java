package dataStructures.dictionary;
import dataStructures.list.LinkedList;
import dataStructures.list.List;
import dataStructures.set.AVLSet;
import dataStructures.set.Set;
import dataStructures.tuple.Tuple2;

/**
 * Estructuras de Datos. Grados en Informatica. UMA.
 * Examen de septiembre de 2018.
 *
 * Apellidos, Nombre:
 * Titulacion, Grupo:
 */
public class HashBiDictionary<K,V> implements BiDictionary<K,V>{
	private Dictionary<K,V> bKeys;
	private Dictionary<V,K> bValues;
	
	public HashBiDictionary() {
		bKeys = new HashDictionary<>();
		bValues = new HashDictionary<>();
	}
	
	public boolean isEmpty() {
		return bKeys.isEmpty();
	}
	
	public int size() {
		return bKeys.size();
	}
	
	public void insert(K k, V v) {
		if (bKeys.isDefinedAt(k)) {
			V oldV = bKeys.valueOf(k);
			if (oldV != null && !oldV.equals(v)) {
				bValues.delete(oldV);
			}
		}
		if (bValues.isDefinedAt(v)) {
			K oldK = bValues.valueOf(v);
			if (oldK != null && !oldK.equals(k)) {
				bKeys.delete(oldK);
			}
		}
		bKeys.insert(k, v);
		bValues.insert(v, k);
	}
	
	public V valueOf(K k) {
		
		if ( k == null ) {
			throw new IllegalArgumentException("La clave no puede ser null");
		}
		return bKeys.valueOf(k);
	}
	
	public K keyOf(V v) {
		if ( v == null){
			throw new IllegalArgumentException("El valor no puede ser null");
		}
		return bValues.valueOf(v);
	}
	
	public boolean isDefinedKeyAt(K k) {
		return bKeys.isDefinedAt(k);
	}
	
	public boolean isDefinedValueAt(V v) {
		return bValues.isDefinedAt(v);
	}
	
	public void deleteByKey(K k) {
		if ( !bKeys.isDefinedAt(k) ) {
			throw new IllegalArgumentException("La clave no est� definida");
		}
		V v = bKeys.valueOf(k);
		bKeys.delete(k);
		bValues.delete(v);
	}
	
	public void deleteByValue(V v) {
		if ( !bValues.isDefinedAt(v) ) {
			throw new IllegalArgumentException("El valor no est� definido");
		}
		K k = bValues.valueOf(v);
		bValues.delete(v);
		bKeys.delete(k);
	}
	
	public Iterable<K> keys() {
		return bKeys.keys();
	}
	
	public Iterable<V> values() {
		return bValues.keys();
	}
	
	public Iterable<Tuple2<K, V>> keysValues() {
		return bKeys.keysValues();
	}
	
		
	public static <K,V extends Comparable<? super V>> BiDictionary<K, V> toBiDictionary(Dictionary<K,V> dict) {
			if (dict == null) {
				throw new IllegalArgumentException("El diccionario no puede ser null");
			}
			HashBiDictionary<K, V> bd = new HashBiDictionary<>();
			Dictionary<V, K> seenValues = new HashDictionary<>();
			for (Tuple2<K, V> kv : dict.keysValues()) {
				K k = kv._1();
				V v = kv._2();
				if (seenValues.isDefinedAt(v)) {
					throw new IllegalArgumentException("El diccionario no es inyectivo");
				}
				seenValues.insert(v, k);
				bd.insert(k, v);
			}
			return bd;
	}
	
	public <W> BiDictionary<K, W> compose(BiDictionary<V,W> bdic) {
		// TODO
		HashBiDictionary<K, W> res = new HashBiDictionary<>();
		for (Tuple2<K, V> kv : bKeys.keysValues()) {
			K k = kv._1();
			V v = kv._2();
			W w = bdic.valueOf(v);
			if (w != null) {
				res.insert(k, w);
			}
		}
		return res;
	}
		
	public static <K extends Comparable<? super K>> boolean isPermutation(BiDictionary<K,K> bd) {
		
		
		Set<K> keys = new AVLSet<>();
		Set<K> values = new AVLSet<>();

		for (K k : bd.keys()) {
			keys.insert(k);
		}
		for (K v : bd.values()) {
			values.insert(v);
		}
		if (keys.size() != values.size()) {
			return false;
		}
		for (K k : keys) {
			if (!values.isElem(k)) {
				return false;
			}
		}
		return true;
	}
	
	// Solo alumnos con evaluaci�n por examen final.
    // =====================================
	
	public static <K extends Comparable<? super K>> List<K> orbitOf(K k, BiDictionary<K,K> bd) {
		// TODO
		if (!isPermutation(bd)) {
			throw new IllegalArgumentException("El BiDictionary no es una permutacion");
		}
		List<K> orbit = new LinkedList<>();
		K start = k;
		K current = start;
		do {
			orbit.append(current);
			current = bd.valueOf(current);
			if (current == null) {
				throw new IllegalArgumentException("El BiDictionary no es una permutacion");
			}
		} while (!current.equals(start));
		return orbit;
	}
	
	public static <K extends Comparable<? super K>> List<List<K>> cyclesOf(BiDictionary<K,K> bd) {
		// TODO
		if (!isPermutation(bd)) {
			throw new IllegalArgumentException("El BiDictionary no es una permutacion");
		}
		List<List<K>> cycles = new LinkedList<>();
		Set<K> remaining = new AVLSet<>();
		for (K k : bd.keys()) {
			remaining.insert(k);
		}

		while (!remaining.isEmpty()) {
			K x = null;
			for (K elem : remaining) {
				x = elem;
				break;
			}
			List<K> orbit = orbitOf(x, bd);
			cycles.append(orbit);
			for (K elem : orbit) {
				remaining.delete(elem);
			}
		}
		return cycles;
	}

    // =====================================
	
	
	@Override
	public String toString() {
		return "HashBiDictionary [bKeys=" + bKeys + ", bValues=" + bValues + "]";
	}
	
	
}
