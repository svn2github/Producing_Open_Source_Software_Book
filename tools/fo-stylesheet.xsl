<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="xsl/fo/docbook.xsl"/>
  <xsl:import href="xsl/fo/profile-docbook.xsl"/>

  <xsl:param name="alignment">left</xsl:param>
  <xsl:param name="fop1.extensions" select="1" />
  <xsl:param name="variablelist.as.blocks" select="1" />
  <xsl:param name="profile.condition">treeware</xsl:param>

  <!-- Generate PDF output suitable for a paperback of appx 7" x 9".

       See these:

         http://www.sagehill.net/docbookxsl/PrintOutput.html
         http://docbook.sourceforge.net/release/xsl/current/doc/fo/page.width.portrait.html
         http://www.sagehill.net/docbookxsl/ParametersInFile.html

       Oh wait, we can't generate the right size PDF output, because
       using either 'B5' or 'C5' raises an error (see below).  The
       answer is clearly to upgrade FOP, since the version used by
       POSS is like two major versions behind now.  I guess I'll start
       there.  It's not just a drop-in replacement; it requires some
       adjustments.  So for now I'm just recording state here.

       This is the error:
       
         [ERROR] FOP - Exception <org.apache.fop.apps.FOPException: java.lang.IndexOutOfBoundsException: Index 10 out of bounds for length 10
         java.lang.IndexOutOfBoundsException: Index 10 out of bounds for length 10>org.apache.fop.apps.FOPException: java.lang.IndexOutOfBoundsException: Index 10 out of bounds for length 10
         java.lang.IndexOutOfBoundsException: Index 10 out of bounds for length 10
         	at org.apache.fop.cli.InputHandler.transformTo(InputHandler.java:289)
         	at org.apache.fop.cli.InputHandler.renderTo(InputHandler.java:115)
         	at org.apache.fop.cli.Main.startFOP(Main.java:186)
         	at org.apache.fop.cli.Main.main(Main.java:217)
         Caused by: java.lang.IndexOutOfBoundsException: Index 10 out of bounds for length 10
         	at java.base/jdk.internal.util.Preconditions.outOfBounds(Preconditions.java:64)
         	at java.base/jdk.internal.util.Preconditions.outOfBoundsCheckIndex(Preconditions.java:70)
         	at java.base/jdk.internal.util.Preconditions.checkIndex(Preconditions.java:248)
         	at java.base/java.util.Objects.checkIndex(Objects.java:372)
         	at java.base/java.util.ArrayList.get(ArrayList.java:458)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.getFootnoteList(PageBreakingAlgorithm.java:1166)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.getFootnoteSplit(PageBreakingAlgorithm.java:788)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.getFootnoteSplit(PageBreakingAlgorithm.java:727)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.computeDifference(PageBreakingAlgorithm.java:580)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.considerLegalBreak(BreakingAlgorithm.java:936)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.considerLegalBreak(PageBreakingAlgorithm.java:510)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.handlePenaltyAt(PageBreakingAlgorithm.java:405)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.handleElementAt(BreakingAlgorithm.java:760)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.findBreakingPoints(BreakingAlgorithm.java:557)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.findBreakingPoints(BreakingAlgorithm.java:506)
         	at org.apache.fop.layoutmgr.AbstractBreaker.doLayout(AbstractBreaker.java:413)
         	at org.apache.fop.layoutmgr.PageBreaker.doLayout(PageBreaker.java:114)
         	at org.apache.fop.layoutmgr.PageSequenceLayoutManager.activateLayout(PageSequenceLayoutManager.java:138)
         	at org.apache.fop.area.AreaTreeHandler.endPageSequence(AreaTreeHandler.java:267)
         	at org.apache.fop.fo.pagination.PageSequence.endOfNode(PageSequence.java:130)
         	at org.apache.fop.fo.FOTreeBuilder$MainFOHandler.endElement(FOTreeBuilder.java:360)
         	at org.apache.fop.fo.FOTreeBuilder.endElement(FOTreeBuilder.java:190)
         	at org.apache.xalan.transformer.TransformerIdentityImpl.endElement(TransformerIdentityImpl.java:1102)
         	at org.apache.xerces.parsers.AbstractSAXParser.endElement(Unknown Source)
         	at org.apache.xerces.xinclude.XIncludeHandler.endElement(Unknown Source)
         	at org.apache.xerces.impl.XMLNSDocumentScannerImpl.scanEndElement(Unknown Source)
         	at org.apache.xerces.impl.XMLDocumentFragmentScannerImpl$FragmentContentDispatcher.dispatch(Unknown Source)
         	at org.apache.xerces.impl.XMLDocumentFragmentScannerImpl.scanDocument(Unknown Source)
         	at org.apache.xerces.parsers.XML11Configuration.parse(Unknown Source)
         	at org.apache.xerces.parsers.XML11Configuration.parse(Unknown Source)
         	at org.apache.xerces.parsers.XMLParser.parse(Unknown Source)
         	at org.apache.xerces.parsers.AbstractSAXParser.parse(Unknown Source)
         	at org.apache.xerces.jaxp.SAXParserImpl$JAXPSAXParser.parse(Unknown Source)
         	at org.apache.xalan.transformer.TransformerIdentityImpl.transform(TransformerIdentityImpl.java:485)
         	at org.apache.fop.cli.InputHandler.transformTo(InputHandler.java:286)
         	... 3 more
         
         - - - - - - - - -
         
         java.lang.IndexOutOfBoundsException: Index 10 out of bounds for length 10
         	at java.base/jdk.internal.util.Preconditions.outOfBounds(Preconditions.java:64)
         	at java.base/jdk.internal.util.Preconditions.outOfBoundsCheckIndex(Preconditions.java:70)
         	at java.base/jdk.internal.util.Preconditions.checkIndex(Preconditions.java:248)
         	at java.base/java.util.Objects.checkIndex(Objects.java:372)
         	at java.base/java.util.ArrayList.get(ArrayList.java:458)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.getFootnoteList(PageBreakingAlgorithm.java:1166)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.getFootnoteSplit(PageBreakingAlgorithm.java:788)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.getFootnoteSplit(PageBreakingAlgorithm.java:727)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.computeDifference(PageBreakingAlgorithm.java:580)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.considerLegalBreak(BreakingAlgorithm.java:936)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.considerLegalBreak(PageBreakingAlgorithm.java:510)
         	at org.apache.fop.layoutmgr.PageBreakingAlgorithm.handlePenaltyAt(PageBreakingAlgorithm.java:405)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.handleElementAt(BreakingAlgorithm.java:760)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.findBreakingPoints(BreakingAlgorithm.java:557)
         	at org.apache.fop.layoutmgr.BreakingAlgorithm.findBreakingPoints(BreakingAlgorithm.java:506)
         	at org.apache.fop.layoutmgr.AbstractBreaker.doLayout(AbstractBreaker.java:413)
         	at org.apache.fop.layoutmgr.PageBreaker.doLayout(PageBreaker.java:114)
         	at org.apache.fop.layoutmgr.PageSequenceLayoutManager.activateLayout(PageSequenceLayoutManager.java:138)
         	at org.apache.fop.area.AreaTreeHandler.endPageSequence(AreaTreeHandler.java:267)
         	at org.apache.fop.fo.pagination.PageSequence.endOfNode(PageSequence.java:130)
         	at org.apache.fop.fo.FOTreeBuilder$MainFOHandler.endElement(FOTreeBuilder.java:360)
         	at org.apache.fop.fo.FOTreeBuilder.endElement(FOTreeBuilder.java:190)
         	at org.apache.xalan.transformer.TransformerIdentityImpl.endElement(TransformerIdentityImpl.java:1102)
         	at org.apache.xerces.parsers.AbstractSAXParser.endElement(Unknown Source)
         	at org.apache.xerces.xinclude.XIncludeHandler.endElement(Unknown Source)
         	at org.apache.xerces.impl.XMLNSDocumentScannerImpl.scanEndElement(Unknown Source)
         	at org.apache.xerces.impl.XMLDocumentFragmentScannerImpl$FragmentContentDispatcher.dispatch(Unknown Source)
         	at org.apache.xerces.impl.XMLDocumentFragmentScannerImpl.scanDocument(Unknown Source)
         	at org.apache.xerces.parsers.XML11Configuration.parse(Unknown Source)
         	at org.apache.xerces.parsers.XML11Configuration.parse(Unknown Source)
         	at org.apache.xerces.parsers.XMLParser.parse(Unknown Source)
         	at org.apache.xerces.parsers.AbstractSAXParser.parse(Unknown Source)
         	at org.apache.xerces.jaxp.SAXParserImpl$JAXPSAXParser.parse(Unknown Source)
         	at org.apache.xalan.transformer.TransformerIdentityImpl.transform(TransformerIdentityImpl.java:485)
         	at org.apache.fop.cli.InputHandler.transformTo(InputHandler.java:286)
         	at org.apache.fop.cli.InputHandler.renderTo(InputHandler.java:115)
         	at org.apache.fop.cli.Main.startFOP(Main.java:186)
         	at org.apache.fop.cli.Main.main(Main.java:217)
         
         make[1]: *** [../tools/Makefile.base-rules:63: producingoss.pdf] Error 1
         make[1]: Leaving directory '/home/kfogel/src/producingoss/en'
         make: *** [Makefile:17: en] Error 2
  -->
  <xsl:param name="paper.type" select="'USLetter'"></xsl:param>

</xsl:stylesheet>
