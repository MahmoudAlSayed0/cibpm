import 'package:cibpm/models/results_model.dart';
import 'package:flutter/material.dart';

class ResultsWidget extends StatefulWidget {
  const ResultsWidget(
      {Key? key, required this.results, required this.elapsedTime})
      : super(key: key);
  final MessageResult results;
  final String elapsedTime;

  @override
  _ResultsWidgetState createState() => _ResultsWidgetState();
}

class _ResultsWidgetState extends State<ResultsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            widget.elapsedTime,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'VGG16',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Mean SBP : '),
              Text(widget.results.vgg16.meanSbp!),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Mean DBP : '),
              Text(widget.results.vgg16.meanDbp!),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'ResNet101',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Mean SBP : '),
              Text(widget.results.resNet101.meanSbp!),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Mean DBP : '),
              Text(widget.results.resNet101.meanDbp!),
            ],
          ),
        ],
      ),
    );
  }
}
