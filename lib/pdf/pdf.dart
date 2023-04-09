import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';

class PDFyap {
  static void createpdf(
    //!é
    List<String> pdfText,
    List<bool> kk,
  ) async {
    var font = await PdfGoogleFonts.robotoMedium();
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.ListView.builder(
              itemBuilder: (context, index) {
                var yazi = pdfText[index];
                var a = utf8.encode(yazi);
                var b = utf8.decode(a);

                return kk[index]
                    ? pw.Text(
                        b,
                        textAlign: pw.TextAlign.left,
                        softWrap: true,
                        overflow: pw.TextOverflow.clip,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 26,
                            color: const PdfColor.fromInt(5646840)),
                      )
                    : pw.Text(
                        b,
                        textAlign: pw.TextAlign.left,
                        softWrap: true,
                        overflow: pw.TextOverflow.clip,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 22,
                        ),
                      );
              },
              itemCount: pdfText.length);
        },
      ),
    );

    await Printing.layoutPdf(
        dynamicLayout: true,
        format: PdfPageFormat.a4,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
