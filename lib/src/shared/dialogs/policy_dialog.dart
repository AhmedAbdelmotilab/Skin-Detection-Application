import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    Key? key,
    required this.mdFileName,
    this.radius = 8,
  })  : assert(mdFileName.contains('.md'),
            'The file must contain the .md extension'),
        super(key: key);

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: FutureBuilder<String>(
              future: Future.delayed(const Duration(milliseconds: 150))
                  .then((value) {
                return rootBundle.loadString('assets/$mdFileName');
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(data: snapshot.data!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              color: Colors.orangeAccent,
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
