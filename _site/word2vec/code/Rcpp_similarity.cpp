// Based on Hadley Wickam's Rcpp tutorial:
// http://adv-r.had.co.nz/Rcpp.html

#include <Rcpp.h>


// The line [[Rcpp::export]] before a function tells R to treat it like
// a native function.
// [[Rcpp::export]]
Rcpp::NumericVector RcppSimilarity(Rcpp::IntegerVector membership1, Rcpp::IntegerVector membership2) {
  // Calculate the Jaccard similarity between two clusterings described by the R vectors membership1 and membership2
  
  // initialize variables
	double S = 0.0;
  
  // This is the length of the first membership vector.
	int n = membership1.size();
  
  // Check that the size is the same and return NA if it is not.
  if (membership2.size() != n) {
    Rcpp::Rcout << "Error: the size of membership vector must be the same.\n";
    return(Rcpp::NumericVector::create(NA_REAL));
  }
 
    double N11 = 0.0;
    double N10 = 0.0;
    double N01 = 0.0;
    
    // Calculate the values required for the Jaccard similarity measure
	for (int i = 0; i < n; i++) {
        for (int j = 0; j < i; j++) {
            if ( (membership1[i] == membership1[j]) & (membership2[i] == membership2[j]) ){
                N11++;
            }
            if ( (membership1[i] != membership1[j]) & (membership2[i] == membership2[j]) ){
                N01++;
            }
            if ( (membership1[i] == membership1[j]) & (membership2[i] != membership2[j]) ){
                N10++;
            }
        }
	}
    
  // Calculate the Jaccard similarity
    S = N11/(N10 + N01 + N11);
  // We need to convert between the double type and the R numeric vector type.
	return Rcpp::NumericVector::create(S);
}


