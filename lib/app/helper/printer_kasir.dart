import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintKasir extends StatefulWidget {
  const PrintKasir({
    super.key,
  });
  @override
  // ignore: no_logic_in_create_state
  PrintKasirState createState() => PrintKasirState(dataPrint: null, item: null);
}

class PrintKasirState extends State<PrintKasir> {
  final Map<String, dynamic>? dataPrint;
  final List? item;
  PrintKasirState({required this.dataPrint, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printing"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ElevatedButton(
              onPressed: null,
              child: Text(
                'Create & Print PDF',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _displayPdf,
              child: const Text(
                'Display PDF',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: generatePdf,
              child: const Text(
                'Generate Advanced PDF',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// create PDF & print it
  createPdf() async {
    final doc = pw.Document();

    /// for using an image from assets
    // final image = await imageFromAssetBundle('assets/logo.png');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw
              .Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            // pw.Image(image),
            pw.Text('${dataPrint!["cabang"]}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Profesional Auto Detailing',
                style: const pw.TextStyle(fontSize: 9)),
            pw.Text(dataPrint!["telp"], style: const pw.TextStyle(fontSize: 9)),
            pw.Text(dataPrint!["alamat"],
                style: const pw.TextStyle(fontSize: 9),
                textAlign: pw.TextAlign.center),
            pw.Text('${dataPrint!["kota"]}',
                style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 35),
            pw.Row(children: [
              pw.Expanded(
                  flex: 1,
                  child: pw.Text('No Trx',
                      style: const pw.TextStyle(fontSize: 9))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Text(' : ${dataPrint!["no_trx"]}',
                      style: const pw.TextStyle(fontSize: 9)))
            ]),
            pw.Row(children: [
              pw.Expanded(
                  flex: 1,
                  child: pw.Text('Tanggal',
                      style: const pw.TextStyle(fontSize: 9))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Text(' : ${dataPrint!["tanggal"]}',
                      style: const pw.TextStyle(fontSize: 9)))
            ]),
            pw.Row(children: [
              pw.Expanded(
                  flex: 1,
                  child:
                      pw.Text('Kasir', style: const pw.TextStyle(fontSize: 9))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Text(' : ${dataPrint!["kasir"]}',
                      style: const pw.TextStyle(fontSize: 9)))
            ]),
            pw.SizedBox(height: dataPrint!["kendaraan"] != "" ? 20 : 0),
            dataPrint!["kendaraan"] != ""
                ? pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                        pw.Text('${dataPrint!["kendaraan"]}',
                            style: const pw.TextStyle(fontSize: 9)),
                        pw.Text('${dataPrint!["nopol"]}',
                            style: const pw.TextStyle(fontSize: 9)),
                      ])
                : pw.Container(),
            pw.SizedBox(height: 15),
            dataPrint!["kendaraan"] != ""
                ? pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text('Petugas',
                              style: const pw.TextStyle(fontSize: 9)),
                        ),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Text(' : ${dataPrint!["petugas"]}',
                                style: const pw.TextStyle(fontSize: 9))),
                      ])
                : pw.Container(),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(dataPrint!["kendaraan"] != "" ? "Services" : "Menu",
                      style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('Total', style: const pw.TextStyle(fontSize: 9)),
                ]),
            pw.Divider(),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(dataPrint!["service_name"],
                      style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(dataPrint!["harga"],
                      style: const pw.TextStyle(fontSize: 9)),
                ]),
            pw.Divider(),
            // remove diskon
            // pw.Row(
            //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //     children: [
            //       pw.Text('Diskon', style: const pw.TextStyle(fontSize: 9)),
            //       pw.Text(
            //           '${dataPrint!["diskon"] != "" ? dataPrint!["diskon"] : 0}%',
            //           style: const pw.TextStyle(fontSize: 9)),
            //     ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Grand Total',
                      style: const pw.TextStyle(fontSize: 9)),
                  pw.Row(children: [
                    pw.RichText(
                        text: pw.TextSpan(
                            text: NumberFormat.simpleCurrency(
                                    locale: 'in', decimalDigits: 0)
                                .format(dataPrint!["grand_total"])
                                .toString(),
                            style: pw.TextStyle(
                                decoration:
                                    dataPrint!["total_setelah_diskon"] > 0
                                        ? pw.TextDecoration.lineThrough
                                        : pw.TextDecoration.none,
                                color: dataPrint!["total_setelah_diskon"] > 0
                                    ? PdfColors.grey
                                    : PdfColors.black,
                                fontSize: 9))),
                    pw.SizedBox(
                        width: dataPrint!["total_setelah_diskon"] > 0 ? 3 : 0),
                    dataPrint!["total_setelah_diskon"] > 0
                        ? pw.Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'in', decimalDigits: 0)
                                .format(dataPrint!["total_setelah_diskon"])
                                .toString(),
                            style: const pw.TextStyle(fontSize: 9))
                        : pw.Container(),
                  ])
                ]),

            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Bayar', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(
                      NumberFormat.simpleCurrency(
                              locale: 'in', decimalDigits: 0)
                          .format(dataPrint!["bayar"])
                          .toString(),
                      style: const pw.TextStyle(fontSize: 9)),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Kembali', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(
                      NumberFormat.simpleCurrency(
                              locale: 'in', decimalDigits: 0)
                          .format(dataPrint!["kembali"])
                          .toString(),
                      style: const pw.TextStyle(fontSize: 9)),
                ]),
            pw.SizedBox(height: 15),
            pw.Text(dataPrint!["pembayaran"],
                style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 25),
            pw.Text('-- Terima Kasih --',
                style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 15),

            pw.Text('kami siap melayani komplain ditempat',
                style: const pw.TextStyle(fontSize: 9)),
            pw.Text('area Saputra Carwash',
                style: const pw.TextStyle(fontSize: 9)),
            pw.Text('kami tidak menerima komplain apabila sudah',
                style: const pw.TextStyle(fontSize: 9)),
            pw.Text('meninggalkan area Saputra Carwash',
                style: const pw.TextStyle(fontSize: 9))

            // pw.Text(dataPrint!["kota"]),
            // }
          ]); // Center
        },
      ),
    ); // Page

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    /// share the document to other applications:
    // await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

    /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
    /// save PDF with Flutter library "path_provider":
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());
  }

  /// create PDF & print it
  createPdfDaily() async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw
              .Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            pw.Text('${item![0]["cabang"]}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Profesional Auto Detailing',
                style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${item![0]["kota"]}',
                style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 35),
            pw.Row(children: [
              pw.Expanded(
                  flex: 2,
                  child: pw.Text('Start Date',
                      style: const pw.TextStyle(fontSize: 9))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                      ' : ${item![0]["startDate"]} at ${DateFormat('HH:mm').format(DateTime.now()).toString()}',
                      style: const pw.TextStyle(fontSize: 9)))
            ]),
            pw.Row(children: [
              pw.Expanded(
                  flex: 2,
                  child: pw.Text('End Date',
                      style: const pw.TextStyle(fontSize: 9))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                      ' : ${item![0]["endDate"]} at ${DateFormat('HH:mm').format(DateTime.now()).toString()}',
                      style: const pw.TextStyle(fontSize: 9)))
            ]),
            pw.Row(children: [
              pw.Expanded(
                  flex: 2,
                  child: pw.Text('Sold Item',
                      style: const pw.TextStyle(fontSize: 9))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Text(' : ${item![0]["totalQty"]}',
                      style: const pw.TextStyle(fontSize: 9)))
            ]),
            pw.SizedBox(height: 10),
            pw.Text('------------------------------------------------',
                style: const pw.TextStyle(fontSize: 9)),
            pw.Text('ORDER DETAIL',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            pw.Text('------------------------------------------------',
                style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 10),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('SOLD ITEM',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9)),
                  pw.Text('TOTAL',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9))
                ]),
            pw.SizedBox(height: 5),
            pw.ListView.builder(
                itemCount: item!.length,
                itemBuilder: (ctx, idx) {
                  return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('${item![idx]["jenis"]}',
                            style: const pw.TextStyle(fontSize: 9)),
                        pw.Text(
                            '(${item![idx]["qty"]}) ${NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(int.parse(item![idx]["harga"]) * item![idx]["qty"])}',
                            style: const pw.TextStyle(fontSize: 9)),
                      ]);
                }),
            pw.SizedBox(height: 15),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('TOTAL AMOUNT',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9)),
                  pw.Text(
                      ' ${NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(int.parse(item![0]["totalHarga"]))}',
                      style: const pw.TextStyle(fontSize: 9)),
                ]),
            pw.SizedBox(height: 25),
            pw.Text('-- Terima Kasih --',
                style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 15),
            pw.Text(item![0]["alamat"],
                style: const pw.TextStyle(fontSize: 9),
                textAlign: pw.TextAlign.center),
            pw.Text(item![0]["telp"], style: const pw.TextStyle(fontSize: 9))
          ]);
        },
      ),
    ); // Page

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    /// share the document to other applications:
    // await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

    /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
    /// save PDF with Flutter library "path_provider":
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());
  }

  /// display a pdf document.
  void _displayPdf() {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Hello eclectify Enthusiast',
              style: const pw.TextStyle(fontSize: 30),
            ),
          );
        },
      ),
    );

    /// open Preview Screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(doc: doc),
        ));
  }

  /// Convert a Pdf to images, one image per page, get only pages 1 and 2 at 72 dpi
  void _convertPdfToImages(pw.Document doc) async {
    await for (var page
        in Printing.raster(await doc.save(), pages: [0, 1], dpi: 72)) {
      final image = page.toImage(); // ...or page.toPng()
      // print(image);
    }
  }

  /// print an existing Pdf file from a Flutter asset
  void _printExistingPdf() async {
    // import 'package:flutter/services.dart';
    final pdf = await rootBundle.load('assets/document.pdf');
    await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
  }

  /// more advanced PDF styling
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  void generatePdf() async {
    const title = 'eclectify Demo';
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}
