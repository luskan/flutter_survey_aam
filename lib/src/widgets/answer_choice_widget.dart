import 'package:flutter/material.dart';

import '../models/question.dart';

class AnswerChoiceWidget extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  final double paddingBetweenAnswers;
  final TextStyle answerStyle;
  final maxLines;
  final Function onTextChange;

  const AnswerChoiceWidget(
      {Key? key, required this.question, required this.onChange, this.paddingBetweenAnswers=4, this.answerStyle=const TextStyle(), this.maxLines=1, required this.onTextChange})
      : super(key: key);

  @override
  State<AnswerChoiceWidget> createState() => _AnswerChoiceWidgetState();
}

class _AnswerChoiceWidgetState extends State<AnswerChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.question.answerChoices.isNotEmpty) {
      if (widget.question.singleChoice) {
        return SingleChoiceAnswer(
            onChange: widget.onChange, question: widget.question, paddingBetweenAnswers: widget.paddingBetweenAnswers, answerStyle: widget.answerStyle);
      } else {
        return MultipleChoiceAnswer(
          onChange: widget.onChange, question: widget.question, answerStyle: widget.answerStyle,);
      }
    } else {
      return SentenceAnswer(
        key: ObjectKey(widget.question),
        onChange: widget.onChange,
        question: widget.question,
        maxLines: widget.maxLines,
        answerStyle: widget.answerStyle,
        onTextChange: widget.onTextChange
      );
    }
  }
}

class SingleChoiceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  final double paddingBetweenAnswers;
  final TextStyle answerStyle;

  const SingleChoiceAnswer(
      {Key? key, required this.onChange, required this.question, this.paddingBetweenAnswers=4.0, this.answerStyle=const TextStyle()})
      : super(key: key);

  @override
  State<SingleChoiceAnswer> createState() => _SingleChoiceAnswerState();
}

class _SingleChoiceAnswerState extends State<SingleChoiceAnswer> {
  String? _selectedAnswer;
  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _selectedAnswer = widget.question.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.question.answerChoices.keys
            .map((answer) => Padding(
          padding: EdgeInsets.only(bottom: widget.paddingBetweenAnswers),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedAnswer = answer;
              });
              widget.onChange([_selectedAnswer!]);
            },
            child: Row(
              children: [
                Radio(
                    fillColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Color(0xFF74AD00);
                        } else {
                          return widget.answerStyle.color;
                        }
                      },
                    ),
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    value: answer,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value as String;
                      });
                      widget.onChange([_selectedAnswer!]);
                    }),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(answer, style: widget.answerStyle),
                )
              ],
            ),
          ),
        ))
            .toList());
  }
}

class MultipleChoiceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  final TextStyle answerStyle;
  const MultipleChoiceAnswer(
      {Key? key, required this.onChange, required this.question, this.answerStyle=const TextStyle()})
      : super(key: key);

  @override
  State<MultipleChoiceAnswer> createState() => _MultipleChoiceAnswerState();
}

class _MultipleChoiceAnswerState extends State<MultipleChoiceAnswer> {
  late List<String> _answers;

  @override
  void initState() {
    _answers = [];
    _answers.addAll(widget.question.answers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.question.answerChoices.keys
            .map((answer) => Row(
          children: [
            Checkbox(
                value: _answers.contains(answer),
                onChanged: (value) {
                  if (value == true) {
                    _answers.add(answer);
                  } else {
                    _answers.remove(answer);
                  }
                  widget.onChange(_answers);
                  setState(() {});
                }),
            Text(answer, style: widget.answerStyle)
          ],
        ))
            .toList());
  }
}

class SentenceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  final int maxLines;
  final TextStyle answerStyle;
  final Function onTextChange;
  const SentenceAnswer(
      {Key? key, required this.onChange, required this.question, this.maxLines=1, required this.answerStyle, required this.onTextChange})
      : super(key: key);

  @override
  State<SentenceAnswer> createState() => _SentenceAnswerState();
}

class _SentenceAnswerState extends State<SentenceAnswer> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _textEditingController.text = widget.question.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Color(0xFFD3D3D3);
    return TextFormField(
      style: widget.answerStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),

      ),
      maxLines: widget.maxLines,
      controller: _textEditingController,
      onChanged: (value) {
        widget.onChange([_textEditingController.text]);
        widget.onTextChange.call();
      },
    );
  }
}
