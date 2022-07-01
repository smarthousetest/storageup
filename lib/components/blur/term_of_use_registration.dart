import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/injection.dart';

class TermOfUseBlur extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  TermOfUseBlur();
}

class _ButtonTemplateState extends State<TermOfUseBlur> {
  S translate = getIt<S>();
  var myController = TextEditingController();

  @override
  void initState() {
    myController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: Container(
                  color: Colors.black.withAlpha(25),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 1000,
              height: 660,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 342, top: 40),
                          child: Text(
                            translate.privacy_policy,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 22, top: 22),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: SvgPicture.asset(
                                      'assets/file_page/close.svg')),
                            )),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 15),
                    child: Divider(
                      thickness: 0.5,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text(
                          textTermOfUse,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16.8,
                            fontFamily: kNormalTextFontFamily,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 40),
                    child: Divider(
                      thickness: 0.5,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//danny sposop realizacii vibran SergeySorokin
  var textTermOfUse = '''
1. Общие положения
1.1. Использование Сервиса в любой форме означает безоговорочное согласие Пользователя с условиями настоящей Политики конфиденциальности и указанными в ней условиями обработки его персональной информации. В случае несогласия с условиями Политики конфиденциальности Пользователь должен воздержаться от использования Сервиса. 
1.2. Политика конфиденциальности (в том числе любая из ее частей) может быть изменена Администрацией без какого-либо специального уведомления и без выплаты какой-либо компенсации в связи с этим. Новая редакция Политики конфиденциальности вступает в силу с момента ее размещения на сайте Администрации. 
1.3. Принимая условия настоящей Политики, Пользователь выражает свое согласие на обработку Администрацией данных о Пользователе в целях, предусмотренных настоящей Политикой, а также на передачу данных о Пользователе третьим лицам в случаях, перечисленных в настоящей Политике. Указанное согласие может быть отозвано Пользователем только при условии письменного уведомления им Администрации не менее чем за 180 дней до предполагаемой даты прекращения использования данных Администрацией. Использование Сервиса с помощью веб-браузера, который принимает данные из cookies, означает выражение согласия Пользователя с тем, что Администрация может собирать и обрабатывать данные из cookies в целях, предусмотренных настоящей Политикой, а также на передачу данных из cookies третьим лицам в случаях, перечисленных в настоящей Политике. Отключение и/или блокировка Пользователем опции веб-браузера по приему данных из cookies означает запрет на сбор и обработку Администрацией данных из cookies в соответствии с условиями настоящей Политики конфиденциальности. 
1.4. По общему правилу Администрация не проверяет достоверность предоставляемой Пользователями персональной информации. Вместе с тем в случаях, предусмотренных Пользовательским соглашением, Пользователь обязан предоставить подтверждение достоверности предоставленной им персональной информации о себе. 
2. Состав информации о Пользователях, которую получает и обрабатывает Администрация 
2.1. Настоящая Политика распространяется на следующие виды персональной информации: 
2.1.1. Персональная информация, размещаемая Пользователями, в т.ч. о себе самостоятельно при заполнении формы отправки сообщения, иная персональная информация, доступ к которой Пользователь предоставляет Администрации через веб-сайты или сервисы третьих лиц, или персональная информация, размещаемая Пользователями в процессе использования Сервиса. К персональной информации, полученной таким образом, могут относиться, в частности, фамилия, имя, номер телефона, адрес электронной почты Пользователя, адрес для доставки заказа. Иная информация предоставляется Пользователем на его усмотрение. Запрещается предоставление Пользователем персональных данных третьих лиц без полученного от третьих лиц разрешения на такое распространение либо, если такие персональные данные третьих лиц не были получены самим Пользователем из общедоступных источников информации. 
2.1.2. Настоящая Политика распространяет свое действие так же на кандидатов на имеющиеся вакансии Администрации, наряду с иными Пользователями. Кандидаты на вакансии, отправляя резюме Администрации с помощью Сервиса, либо по электронной почте, с целью прохождения собеседования и дальнейшего трудоустройства, выражают таким образом согласие на обработку следующих персональных данных: фамилия, имя, отчество, дата рождения, гражданство, город проживания, контакты (телефон, адрес электронной почты), места работы и даты работы, а также иных данных, указанных кандидатами на вакансии в резюме. 
2.1.3. Продавец гарантирует Покупателю сохранение конфиденциальности следующей персональной информации о Покупателе: — информация о карте пользователя (последние 4 цифры); — сведения о покупках и заказах.''';
}
