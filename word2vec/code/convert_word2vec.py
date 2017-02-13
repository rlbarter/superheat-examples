# This script was adapted from Franck Dernoncourt's response to this Stack Overflow post: http://stackoverflow.com/questions/27324292/convert-word2vec-bin-file-to-text

import gensim
import codecs
from gensim.models import Word2Vec
import json
 
def export_to_file(path_to_model, output_file):
	output = codecs.open(output_file, 'w' , 'utf-8')
	model = Word2Vec.load_word2vec_format(path_to_model, binary=True)
	vocab = model.vocab
	for mid in vocab:
		#print(model[mid])
		print(mid)
		vector = list()
		for dimension in model[mid]:
			vector.append(str(dimension))
		#line = { "mid": mid, "vector": vector  }
		vector_str = ",".join(vector)
		line = mid + "\t"  + vector_str
		#line = json.dumps(line)
		output.write(line + "\n")
	output.close()

export_to_file("GoogleNews-vectors-negative300.bin.gz", "GoogleNews.txt")
