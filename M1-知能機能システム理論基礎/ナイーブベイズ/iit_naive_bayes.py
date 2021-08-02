from janome.tokenizer import Tokenizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
import numpy as np

class IITNaiveBayses:
    def __init__(self, file1, file2, mode):
        f = open(file1)
        self.file1_text = f.read()
        f = open(file2)
        self.file2_text = f.read()

        full_text = self.file1_text + self.file2_text
        if mode == "jpn":
           self.cv = CountVectorizer(analyzer=self.split_words)
        else:
           self.cv = CountVectorizer()
           
        self.cv.fit([self.file1_text, self.file2_text])

        self.clf = MultinomialNB()
        x1 = self.cv.transform([self.file1_text])
        x2 = self.cv.transform([self.file2_text])
        X = np.concatenate((x1.toarray(), x2.toarray()))
        self.clf.fit(X, [1,2])
        
    def split_words(self,text):
        t = Tokenizer()
        tokens =  t.tokenize(text)
        return [token.surface for token in tokens] 

    def print_file1(self):
        print(self.file1_text)

    def print_file2(self):
        print(self.file2_text)

    def get_words_frequency_file1(self):
        return self.cv.transform([self.file1_text]).toarray()

    def get_words_frequency_file2(self):
        return self.cv.transform([self.file2_text]).toarray()

    def get_vocabulary(self):
        return self.cv.vocabulary_

    def predict(self, text):
        x = self.cv.transform([text]).toarray()
        return self.clf.predict(x)

    def predict_log_proba(self, text):
        x = self.cv.transform([text]).toarray()
        return self.clf.predict_log_proba(x)

    def predict_proba(self, text):
        x = self.cv.transform([text]).toarray()
        return self.clf.predict_proba(x)
