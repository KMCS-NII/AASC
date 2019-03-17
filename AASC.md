onstruction of a New ACL Anthology Corpus for Deeper Analysis of Scientific Papers

AASC (ACL Anthology Sentence Corpus) is a new ACL Anthology corpus for deeper analysis of scientific papers. The corpus is constructed using [PDFNLT 1.0](https://github.com/KMCS-NII/PDFNLT-1.0), an on-going project to develop a PDF analysis tool suitable for NLP. The corpus has two features distinguishing it from existing scientific paper corpora. First, the output is a collection of natural language sentences rather than texts directly extracted from PDF files. Second, non-textual elements in a sentence, such as citation marks and inline math formulae, are substituted for uniquely identifiable tokens. 

## Pipeline of the Corpus Construction

#### Layout analysis

Scientific papers formatted in PDF are converted into XHTML files. First, figures and tables are extracted with an open-source software tool, [pdffigures](http://pdffigures.allenai.org)[1]. Next, using pdftotext, which is included in [Poppler](https://poppler.freedesktop.org), words and their physical coordinates on a page are extracted. In order to simultaneously extract font properties, a patch is applied to Poppler. Then, on the basis of the vertical and horizontal alignments of words, words are arranged to form text lines.

#### Logical structure analysis
The output from the layout analysis is represented as text lines containing information about (1) word attributes such as word notations, coordinates in the paper, typeface and font size, and (2) geometric attributes of lines such as position in the page, width, gap from the previous line, indentation and hanging. With these used as features, the most appropriate label for each text line is selected using a Conditional Random Field (CRF) [2] based classifier. The label set specifies major components of scientific papers such as _abstract_, _section label_, _math formula_, or _reference_. Then, adjacent text lines with the same labels are merged into a single block.

Each block is categorized as one of three element types: _header-element_, _floating-element_, and _text-element_. _Header-elements_ include abstract header, section titles and reference header. _Floating-elements_ include footnotes, figures, tables, or captions. _Text-elements_ are contents of sections. For _text-elements_, distant blocks with page/column breaks are connected to each other. In our current implementation, our CRF is trained using 147 papers from the ACL Anthology.

After serializing _body-text_ blocks in reading order, the logical structure of the sections in the document is determined on the basis of the section labels. Finally, an initial XHTML file is generated with both layout and logical structure tags. By specifying options, non-textual blocks such as tables, figures and independent-line mathematical formulae can also be output as images.

#### Sentence extraction

For texts in _body-text_ blocks, dehyphenation and sentence splitting are applied. Each extracted sentence is given a unique ID number. Also, for each sentence, non-textual elements are substituted with uniquely identifiable tokens so that they do not deteriorate subsequent syntax parsing. These non-textual elements include independent and inline mathematical expressions and citation marks that refer to tables, figures, and bibliographies. For math formulae and bibliographic items, mapping tables between the non-textual elements' IDs and their strings are stored in a separate file. Finally, all sentence IDs, non-textual elements' IDs, and citation IDs are embedded into the output XHTML files. 

#### Section type classifier

We categorize first-level sections of each paper into one of eight classes: _abstract, introduction, background, method, result, discussion, method-general_ and _others_. In our categorization, we adopted a simple keyword-based method that is based on a manually constructed dictionary. In addition, using our preliminary corpus dated January 2018, we manually checked all the titles that appeared at least ten times to enumerate all exceptional cases, such as ``document summarization'' as a topic for natural language processing instead of _conclusion_ of the paper. For the remaining section titles that did not contain any matched keywords in the dictionary, we observed that most of them referred to specific method or resource names. In our corpus, we grouped them into a single category named _method-general_. _Background_ includes related work. _Others_ includes minor cases such as acknowledgment or references recognized as sections.

### AASC Corpus Statistics

#### Statistics as of September 2018

We crawled 44,481 PDF files from the ACL Anthology, and first converted all the files into XHTML format using our analysis tool. In total, 1,174,419 math formulae, 250,082 tables and figures, and 768,290 references were extracted. Then, we selected papers that had both _abstract_ and _references_ blocks. After the filtering, we obtained 38,864 papers with a total of 6,144,852 sentences (158.1 sentences per paper on the average). 

#### Dataset quality: comparison with existing PDF analysis tools

Many PDF analysis systems dedicated to scientific papers have been developed as PDF document analysis is almost indispensable for any research that handles scientific papers. These existing systems process documents using pipelined multiple CRFs (or Support Vector Machines) corresponding to different block types such as references, names, or affiliations trained with annotated documents of larger size.

Since we used a single CRF trained with only a limited amount of training data, the objective of the comparison is to check whether our simplified model with a limited amount of training data still achieves a satisfactory quality level comparable to that of other existing tools. Note that despite the disadvantage of possible performance degeneration, the simplicity makes in-house customization for Japanese papers easy for us.

We evaluated our model's performance using 30 manually annotated papers randomly selected either from in- or out-of-domain paper collections. The out-of-domain papers were taken from material science journals in diverse formats.  As a baseline method, we selected GROBID [3],
one of the state-of-the-art PDF analysis tools, and
used online conversion tools publicly available on the Web. Once the outputs from each PDF analysis system are obtained, we first determine the position of each text line in the manually annotated reference file. Since non-negligible differences exist in the output formats (e.g., how citation marks and inline math formulae are processed), we used dynamic programming-based matching. 

In our evaluation, we used (1) section titles and (2) sequential numbers of text lines in the reference files. Tables 1 shows the recognition errors of first-level sections. Table 2 shows the errors in text line extraction where the main reason for the difference between _Missed lines (all)_ and _Missed lines (text-elements)_ is the treatment of the abstracts.

Based on the comparison, we confirm that, in terms of section structure and reading order determination, the quality of the extracted text is comparable to the ones of state-of-the-art systems such as GROBID. 

<div style="text-align: center;">
Table 1: Section level performance comparison.
</div>

||Total number of errors|Falsely recognized sections|Missed sections| Total number of sections|
|:-----------|:-----------|:-----------|:-----------|:-----------|
|pdfanalyzer (acl) |37|10|27|212|
|grobid (acl) |46|25|21|212|
|pdfanalyzer (material) |67|28|39|149|
|grobid (material) |30|13|17|149|

<div style="text-align: center;">
Table 2: Text level performance comparison.
</div>

||Missed lines (all)|Missed lines (_text-elements_)| Incorrect line order| Extra text (in chars)|
|:-----------|:-----------|:-----------|:-----------|:-----------|
|pdfanalyzer (acl) |0.0045|0.0033|0.0003|0.0366|
|grobid (acl) |0.0229|0.0148|0.0005|0.1127|
|pdfanalyzer (material) |0.0938|0.0849|0.0016|0.0906|
|grobid (material) |0.0480|0.0332|0.0012|0.0544|

### References

1. Clark, C.A., Divvala, S.K.: Looking beyond text: Extracting figures, tables and
  captions from computer science papers. In: Proceedings of the AAAI Workshop:
  Scholarly Big Data: AI Perspectives, Challenges, and Ideas (2015)
2. Lafferty, J.D., McCallum, A., Pereira, F.C.N.: Conditional random fields:
  Probabilistic models for segmenting and labeling sequence data. In:
  Proceedings of the Eighteenth International Conference on Machine Learning
  (ICML). pp. 282--289 (2001)
3. Lopez, P.: Grobid: Combining automatic bibliographic data recognition and term
  extraction for scholarship publications. In: Agosti, M., Borbinha, J.,
  Kapidakis, S., Papatheodorou, C., Tsakonas, G. (eds.) Research and Advanced
  Technology for Digital Libraries. pp. 473--474. Springer Berlin Heidelberg,
  Berlin, Heidelberg (2009)
