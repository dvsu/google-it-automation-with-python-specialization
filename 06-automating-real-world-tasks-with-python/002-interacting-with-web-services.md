# Week 2: Interacting with Web Services

## Reading Material

---

[What is an API Endpoint?](https://rapidapi.com/blog/api-glossary/endpoint/)  
[JavaScript Object Notation (JSON)](https://www.json.org/json-en.html)  
[YAML](https://yaml.org/)  
[YAML (Wikipedia)](https://en.wikipedia.org/wiki/YAML)  
[PyYAML Documentation](https://pyyaml.org/wiki/PyYAMLDocumentation)  
[`pickle`: Python Object Serialization](https://docs.python.org/3/library/pickle.html)  
[Extensible Markup Language (XML)](https://www.w3.org/XML/)  
[Simple Object Access Protocol (SOAP)](https://en.wikipedia.org/wiki/SOAP)  
[Comparison of Data-Serialization Formats](https://en.wikipedia.org/wiki/Comparison_of_data-serialization_formats)  
[Python `requests` Library](https://requests.readthedocs.io/)  
[`requests` Developer Interface](https://docs.python-requests.org/en/master/api/#requests.Response)  
[`requests` Response.ok](https://docs.python-requests.org/en/master/api/#requests.Response.ok)  
[Hypertext Transfer Protocol (HTTP) Status Code Registry](https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml)  
[HTTP Response Status Codes (MDN)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)  
[`requests` Response.raise_for_status()](https://docs.python-requests.org/en/master/api/#requests.Response.raise_for_status)  
[Query String (Wikipedia)](https://en.wikipedia.org/wiki/Query_string)  
[Request Method Definitions](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3)  
[`requests` Library Quickstart](https://docs.python-requests.org/en/master/user/quickstart/)  
[Django: Python Web Framework](https://www.djangoproject.com/)  
[Flask: Full Stack Python](https://www.fullstackpython.com/flask.html)  
[Bottle: Python Web Framework](https://bottlepy.org/docs/dev/)  
[CherryPy: A Minimalist Python Web Framework](https://cherrypy.org/)  
[CubicWeb: Semantic Web Application Framework](https://www.cubicweb.org/)  
[Object-relational Mapping (Wikipedia)](https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping)  

***Python `json` library***

Core methods:

* `dump()` -> serialize Python object and write JSON to a file
* `dumps()` -> serialize Python object and convert to string
* `load()` -> deserialize JSON from a file to Python object
* `loads()` -> deserialize JSON from string to Python object

***Python `requests` library***

Core methods:

* `get()`
* `post()`
* `put()`
* `head()`
* `options()`
