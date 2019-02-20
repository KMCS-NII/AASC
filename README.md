## AASC: ACL Anthology Sentence Corpus

AASC is a corpus of natural language text extracted from scientific papers.
It contains 6,144,852 sentences from PDF-format papers from the ACL Anthology [1], a comprehensive scientific paper repository on computational linguistics and natural language processing.

For PDF document analysis, we use PDFNLT 1.0 [2], a PDF paper analysis tool specifically trained for ACL Anthology. After excluding papers with non-standard structures (eg. no _abstract_, or no _references_), the rest 38,864 papers were further processed by (1) sentence splitting, and (2) section type labeling.

The `ACL_2018_v2.tar.gz` file contains the extracted natural language sentences for each `<paper_ID>`, where the `<paper_ID>` is the unique identifier of the paper on the ACL Anthology. The corresponding PDF version can be found using the URL:
[http://aclweb.org/anthology/<paper_ID>](http://aclweb.org/anthology/<paper_ID>).

Each sentence file is named as `<paper_ID>.ss` within which each line represents tab-separated values of a sentence:

|Column|Example  (A00-1001.ss)|
|:-----------|:-----------|
| Sentence ID | `s-1-1-0-0` |
| Section type | `abstract` | 
| Sentence text: | `The paper describes a natural language based expert system route advisor for the public bus transport in Trondheim, Norway.` |
|||

A simple dictionary-based classifier was used for the section type labeling.

[1] http://aclanthology.info/  
[2] https://github.com/KMCS-NII/PDFNLT-1.0

