
import Foundation
/// Configure the URL for our request.
/// In this case, an example JSON response from httpbin.
var url = URL(string: "https://httpbin.org/get")!
url = URL(string: "https://pubchem.ncbi.nlm.nih.gov/rest/pug/gene/geneid/1956,13649/summary/JSON")! 

/// Use URLSession to fetch the data asynchronously.
let (data, response) = try await URLSession.shared.data(from: url)

print(data, response)