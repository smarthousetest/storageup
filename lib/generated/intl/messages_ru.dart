// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(count) => "${count} Б";

  static String m1(date, count_of_gb) =>
      "Ваша подписка на ${count_of_gb} ГБ будет действительна до ${date} после чего";

  static String m2(count) => "${count} файлов";

  static String m3(date, cost) => "Следующая оплата ${date} составит ${cost} ₽";

  static String m4(count_of_gb, cost) => "${count_of_gb} ГБ за ${cost} ₽/месяц";

  static String m5(count_of_gb) =>
      "объекты из разделов файлы и медиа, заполняющие ${count_of_gb}";

  static String m6(count) => "${count} Гб";

  static String m7(count) => "${count} Кб";

  static String m8(count) => "${count} Мб";

  static String m9(count) => "${count} Пб";

  static String m10(count) => "${count} ₽/месяц";

  static String m11(count) => "${count} Тб";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accaunt_deleting":
            MessageLookupByLibrary.simpleMessage("Удаление аккаунта"),
        "active_sub":
            MessageLookupByLibrary.simpleMessage("Действующая подписка"),
        "add": MessageLookupByLibrary.simpleMessage("Добавить"),
        "add_location": MessageLookupByLibrary.simpleMessage("Добавить место"),
        "all": MessageLookupByLibrary.simpleMessage("Все"),
        "all_files": MessageLookupByLibrary.simpleMessage("Все файлы"),
        "already_have_an_account":
            MessageLookupByLibrary.simpleMessage("Уже есть аккаунт?"),
        "already_registered_email": MessageLookupByLibrary.simpleMessage(
            "Пользователь с данным e-mail уже зарегистрирован"),
        "b": m0,
        "back_to_authorization":
            MessageLookupByLibrary.simpleMessage("Вернуться к авторизации"),
        "back_to_main":
            MessageLookupByLibrary.simpleMessage("Вернуться на главную"),
        "before_deleting":
            MessageLookupByLibrary.simpleMessage("До удаления аккаунта "),
        "by_date_added":
            MessageLookupByLibrary.simpleMessage("По дате добавления"),
        "by_date_viewed":
            MessageLookupByLibrary.simpleMessage("По дате просмотра"),
        "by_name": MessageLookupByLibrary.simpleMessage("По названию"),
        "by_size": MessageLookupByLibrary.simpleMessage("По размеру"),
        "by_type": MessageLookupByLibrary.simpleMessage("По типу"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "cancel_sub": m1,
        "canceled": MessageLookupByLibrary.simpleMessage("Отменить"),
        "cannot_recovered": MessageLookupByLibrary.simpleMessage(
            "Ваши файлы исчезнут навсегда без возможности восстановления."),
        "card": MessageLookupByLibrary.simpleMessage("Карта:"),
        "change": MessageLookupByLibrary.simpleMessage("Изменить"),
        "change_Password":
            MessageLookupByLibrary.simpleMessage("Изменение пароля"),
        "change_password":
            MessageLookupByLibrary.simpleMessage("Изменить пароль"),
        "change_photo": MessageLookupByLibrary.simpleMessage("Изменить фото"),
        "changed": MessageLookupByLibrary.simpleMessage("Изменено"),
        "confirm_email":
            MessageLookupByLibrary.simpleMessage("Подтвердите свою почту!"),
        "contact_us": MessageLookupByLibrary.simpleMessage(" свяжитесь с нами"),
        "continue_button": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "count_of_files": m2,
        "create_a_folder":
            MessageLookupByLibrary.simpleMessage("Создать папку"),
        "create_album": MessageLookupByLibrary.simpleMessage("Создать альбом"),
        "create_folder": MessageLookupByLibrary.simpleMessage("Создание папки"),
        "created": MessageLookupByLibrary.simpleMessage("Создано"),
        "currency": MessageLookupByLibrary.simpleMessage("₽"),
        "current_subscription_payment": m3,
        "current_subscription_title": m4,
        "date": MessageLookupByLibrary.simpleMessage("Дата"),
        "date_format": MessageLookupByLibrary.simpleMessage("Формат даты"),
        "day": MessageLookupByLibrary.simpleMessage("день"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Удалить аккаунт"),
        "delete_file": MessageLookupByLibrary.simpleMessage("Удалить файлы"),
        "delete_keeper_text1": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить место хранения? "),
        "delete_keeper_text2":
            MessageLookupByLibrary.simpleMessage("Данное действие необратимо."),
        "delete_keeper_text3": MessageLookupByLibrary.simpleMessage(
            "Нам будет необходимо провести очистку места на вашем компьютере, пожалуйста не выходите из приложения."),
        "delete_permanently":
            MessageLookupByLibrary.simpleMessage("Удалить навсегда"),
        "delete_pic":
            MessageLookupByLibrary.simpleMessage("Удаление фотографии"),
        "deleting": MessageLookupByLibrary.simpleMessage("Удаление"),
        "documents": MessageLookupByLibrary.simpleMessage("Документы"),
        "download": MessageLookupByLibrary.simpleMessage("Загрузить"),
        "earnings":
            MessageLookupByLibrary.simpleMessage("Ваш заработок составит"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "email_confirming":
            MessageLookupByLibrary.simpleMessage("Подтверждение Email"),
        "email_confirming_after": MessageLookupByLibrary.simpleMessage(
            " отправлено письмо, для подтверждения e-mail адреса, перейдите по ссылке внутри письма"),
        "email_confirming_confirm": MessageLookupByLibrary.simpleMessage(
            "Чтобы закончить регистрацию, подтвердите свой e-mail адрес."),
        "email_confirming_letter": MessageLookupByLibrary.simpleMessage(
            "Мы отправили письмо на почту "),
        "email_confirming_link": MessageLookupByLibrary.simpleMessage(
            "Для подтверждения перейдите по ссылке внутри письма."),
        "email_confirming_reg":
            MessageLookupByLibrary.simpleMessage("Подтверждение e-mail адреса"),
        "email_successfully": MessageLookupByLibrary.simpleMessage(
            "Ваш e-mail адрес успешно подтверждён"),
        "english": MessageLookupByLibrary.simpleMessage("Английский"),
        "enter_password":
            MessageLookupByLibrary.simpleMessage("Введите пароль"),
        "exit": MessageLookupByLibrary.simpleMessage("Выйти"),
        "file_sorting":
            MessageLookupByLibrary.simpleMessage("Сортировка файлов"),
        "files": MessageLookupByLibrary.simpleMessage("Файлы"),
        "filled_gb": m5,
        "finance": MessageLookupByLibrary.simpleMessage("Финансы"),
        "folder": MessageLookupByLibrary.simpleMessage("Выберите папку"),
        "folder_dir": MessageLookupByLibrary.simpleMessage("Папки"),
        "foldr": MessageLookupByLibrary.simpleMessage("Папка"),
        "for_confirm": MessageLookupByLibrary.simpleMessage(
            "Для подтверждения перейдите по ссылке внутри письма."),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Забыли пароль?"),
        "format": MessageLookupByLibrary.simpleMessage("Формат"),
        "free_sub": MessageLookupByLibrary.simpleMessage("Бесплатная подписка"),
        "funds": MessageLookupByLibrary.simpleMessage("Вывод средств"),
        "further_use": MessageLookupByLibrary.simpleMessage(
            "Дальнейшее использование приложения станет для вас бесплатным."),
        "gb": m6,
        "get_out": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите выйти?"),
        "go_to": MessageLookupByLibrary.simpleMessage("Перейти"),
        "go_to_authorization":
            MessageLookupByLibrary.simpleMessage("Перейти к авторизации"),
        "good": MessageLookupByLibrary.simpleMessage("Хорошо"),
        "home": MessageLookupByLibrary.simpleMessage("Главная"),
        "how_work": MessageLookupByLibrary.simpleMessage("Как это работает?"),
        "in_StorageUp": MessageLookupByLibrary.simpleMessage("в StorageUp?"),
        "info": MessageLookupByLibrary.simpleMessage("Свойства"),
        "install_update":
            MessageLookupByLibrary.simpleMessage("Установить обновление"),
        "kb": m7,
        "language": MessageLookupByLibrary.simpleMessage("Язык"),
        "latest_file": MessageLookupByLibrary.simpleMessage("Последние файлы"),
        "location": MessageLookupByLibrary.simpleMessage("Расположение"),
        "mail": MessageLookupByLibrary.simpleMessage("Почта"),
        "make_money": MessageLookupByLibrary.simpleMessage(
            "диске - сдавайте пространство в аренду и зарабатывайте на нём!"),
        "management":
            MessageLookupByLibrary.simpleMessage("Управление подпиской"),
        "max_storage": MessageLookupByLibrary.simpleMessage(
            "Максимальный размер для вашего диска: 180 ГБ"),
        "mb": m8,
        "media": MessageLookupByLibrary.simpleMessage("Медиа"),
        "min_storage": MessageLookupByLibrary.simpleMessage(
            "Минимальный размер хранилища: 32 ГБ"),
        "money":
            MessageLookupByLibrary.simpleMessage("сможете на этом заработать."),
        "money_two_step": MessageLookupByLibrary.simpleMessage(
            "Начните зарабатывать в два шага:"),
        "more_space": MessageLookupByLibrary.simpleMessage(
            "Получите больше пространства, поменяйте подписку!"),
        "move": MessageLookupByLibrary.simpleMessage("Переместить"),
        "name": MessageLookupByLibrary.simpleMessage("Имя"),
        "name_storage":
            MessageLookupByLibrary.simpleMessage("Название места хранения"),
        "new_album": MessageLookupByLibrary.simpleMessage("Новый альбом"),
        "new_folder": MessageLookupByLibrary.simpleMessage("Новая папка"),
        "new_password": MessageLookupByLibrary.simpleMessage("Новый пароль"),
        "new_password_8": MessageLookupByLibrary.simpleMessage(
            "Новый пароль должен содержать не менее 8 символов"),
        "non_existent_email":
            MessageLookupByLibrary.simpleMessage("Неcуществующий e-mail"),
        "not_space": MessageLookupByLibrary.simpleMessage("Не хватает места?"),
        "not_storage":
            MessageLookupByLibrary.simpleMessage("У вас ещё нет мест хранения"),
        "nothing_on_email":
            MessageLookupByLibrary.simpleMessage("На почту ничего не пришло?"),
        "notification_re_auth": MessageLookupByLibrary.simpleMessage(
            "Вам нужно снова зайти в аккаунт"),
        "offer": MessageLookupByLibrary.simpleMessage(
            "Выгодное предложение - переход на годовую подписку"),
        "old_password":
            MessageLookupByLibrary.simpleMessage("Введите старый пароль"),
        "open": MessageLookupByLibrary.simpleMessage("Открыть"),
        "options": MessageLookupByLibrary.simpleMessage("Параметры "),
        "or_continue_with":
            MessageLookupByLibrary.simpleMessage("или продолжить с"),
        "other_sub": MessageLookupByLibrary.simpleMessage("Другие подписки"),
        "our_tariff": MessageLookupByLibrary.simpleMessage(
            "Наш тариф предполагает оплату 0,2 ₽/день за 1 ГБ сданного пространства"),
        "overview": MessageLookupByLibrary.simpleMessage("Обзор"),
        "parameters": MessageLookupByLibrary.simpleMessage("Общие параметры"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "password_recovery":
            MessageLookupByLibrary.simpleMessage("Восстановление пароля"),
        "password_recovery_enter_email": MessageLookupByLibrary.simpleMessage(
            "Для восстановления пароля введите в поле адрес вашей электронной почты"),
        "passwords_dont_match":
            MessageLookupByLibrary.simpleMessage("Пароли не совпадают"),
        "path": MessageLookupByLibrary.simpleMessage("Путь"),
        "payment": MessageLookupByLibrary.simpleMessage("Оплата:"),
        "pb": m9,
        "permanently_delete": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите окончательно удалить ваш аккаунт"),
        "personal": MessageLookupByLibrary.simpleMessage(
            "Настоящая политика обработки персональных данных составлена в соответствии с требованиями Федерального закона от 27.07.2006. №152-ФЗ «О персональных данных» (далее - Закон о персональных данных) и определяет порядок обработки персональных данных и меры по обеспечению безопасности персональных данных, предпринимаемые Михайловым Иваном Сергеевичем (далее – Оператор).1.1. Оператор ставит своей важнейшей целью и условием осуществления своей деятельности соблюдение прав и свобод человека и гражданина при обработке его персональных данных, в том числе защиты прав на неприкосновенность частной жизни, личную и семейную тайну.1.2. Настоящая политика Оператора в отношении обработки персональных данных (далее – Политика) применяется ко всей информации, которую Оператор может получить о посетителях веб-сайта httpsː//thismywebsite·com."),
        "personal_data": MessageLookupByLibrary.simpleMessage("Личные данные"),
        "photos": MessageLookupByLibrary.simpleMessage("Фото"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Политика конфиденциальности"),
        "profile_photo": MessageLookupByLibrary.simpleMessage("Фото профиля"),
        "properties": MessageLookupByLibrary.simpleMessage("Свойства"),
        "provisions":
            MessageLookupByLibrary.simpleMessage("1. Общие положения"),
        "really_delete_pic": MessageLookupByLibrary.simpleMessage(
            "Вы действительно хотите удалить фото профиля?"),
        "realy_delete": MessageLookupByLibrary.simpleMessage(
            "Вы действительно хотите удалить?"),
        "realy_delete_keeper":
            MessageLookupByLibrary.simpleMessage("Удаление места хранения"),
        "reason_deleting":
            MessageLookupByLibrary.simpleMessage("Причина удаления"),
        "recent": MessageLookupByLibrary.simpleMessage("Недавние"),
        "register": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "register_complete":
            MessageLookupByLibrary.simpleMessage("Регистрация завершена"),
        "registration": MessageLookupByLibrary.simpleMessage("Регистрация"),
        "regulations":
            MessageLookupByLibrary.simpleMessage("Нормативные документы"),
        "remember_me": MessageLookupByLibrary.simpleMessage("Запомнить меня"),
        "rent": MessageLookupByLibrary.simpleMessage("Сдать"),
        "rent_space": MessageLookupByLibrary.simpleMessage(
            "Вы можете использовать свободное место на вашем жестком"),
        "repeat_passsword":
            MessageLookupByLibrary.simpleMessage("Повторите новый пароль"),
        "restore_password_after_email": MessageLookupByLibrary.simpleMessage(
            " отправлено письмо. Для восстановления пароля перейдите по ссылке внутри письма."),
        "restore_password_before_email":
            MessageLookupByLibrary.simpleMessage("На вашу электронную почту "),
        "russian": MessageLookupByLibrary.simpleMessage("Русский"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "search": MessageLookupByLibrary.simpleMessage("Поиск"),
        "select": MessageLookupByLibrary.simpleMessage("Выбрать"),
        "select_folder": MessageLookupByLibrary.simpleMessage(
            "Выберите папку на диске, где у вас есть свободное пространство."),
        "select_storage":
            MessageLookupByLibrary.simpleMessage("Выберите место хранения"),
        "sell_space": MessageLookupByLibrary.simpleMessage("Сдача места"),
        "set_size":
            MessageLookupByLibrary.simpleMessage("Установите размер хранилища"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Войти"),
        "sign_in_to_account":
            MessageLookupByLibrary.simpleMessage("Вход в учетную запись"),
        "size": MessageLookupByLibrary.simpleMessage("Размер"),
        "size_of_space": MessageLookupByLibrary.simpleMessage(
            "Укажите размер места под аренду"),
        "something_goes_wrong": MessageLookupByLibrary.simpleMessage(
            "Что-то пошло не так. Попробуйте позднее"),
        "still_dont_have_account": MessageLookupByLibrary.simpleMessage(
            "Еще нет аккаунта? Скорее присоединяйся к нам!"),
        "store_files": MessageLookupByLibrary.simpleMessage(
            "Мы используем это пространство для хранения файлов, а вы"),
        "subscription_pay_mounth": m10,
        "tb": m11,
        "tell_us": MessageLookupByLibrary.simpleMessage(
            "Расскажите нам, почему вы решили удалить аккаунт"),
        "term_of_use": MessageLookupByLibrary.simpleMessage(
            "Пользовательского соглашения"),
        "term_of_use_after": MessageLookupByLibrary.simpleMessage(
            " и даю согласие на обработку моих персональных данных"),
        "term_of_use_before":
            MessageLookupByLibrary.simpleMessage("Я принимаю условия "),
        "to_send_letter":
            MessageLookupByLibrary.simpleMessage("Отправить письмо еще раз"),
        "trust_level": MessageLookupByLibrary.simpleMessage("Уровень доверия"),
        "type": MessageLookupByLibrary.simpleMessage("Тип"),
        "unsubscribe": MessageLookupByLibrary.simpleMessage("Отмена подписки"),
        "upload": MessageLookupByLibrary.simpleMessage("Загрузить"),
        "upload_file": MessageLookupByLibrary.simpleMessage(
            "Как только мы загрузим туда первые файлы, на ваш баланс "),
        "upload_files": MessageLookupByLibrary.simpleMessage("Загрузить файл"),
        "upload_folder":
            MessageLookupByLibrary.simpleMessage("Загрузить папку"),
        "upload_media": MessageLookupByLibrary.simpleMessage("Загрузить медиа"),
        "upload_to_files":
            MessageLookupByLibrary.simpleMessage("Загрузить в файлы"),
        "upload_to_media":
            MessageLookupByLibrary.simpleMessage("Загрузить в медиа"),
        "user_name": MessageLookupByLibrary.simpleMessage("Имя пользователя"),
        "video": MessageLookupByLibrary.simpleMessage("Видео"),
        "viewed": MessageLookupByLibrary.simpleMessage("Просмотрено"),
        "we_can_help": MessageLookupByLibrary.simpleMessage(
            ", возможно, мы сможем вам помочь."),
        "we_send": MessageLookupByLibrary.simpleMessage(
            "Мы отправили письмо на почту"),
        "welcome_to_upstorage": MessageLookupByLibrary.simpleMessage(
            "Добро пожаловать в StorageUp"),
        "will_be_deleted": MessageLookupByLibrary.simpleMessage(
            "пространства, будут удалены без возможности восстановления."),
        "wrong_cred":
            MessageLookupByLibrary.simpleMessage("Неверный e-mail или пароль!"),
        "wrong_email":
            MessageLookupByLibrary.simpleMessage("Введите корректный e-mail"),
        "wrong_old_password":
            MessageLookupByLibrary.simpleMessage("Неверный пароль"),
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "Пароль должен содержать более 8 символов"),
        "wrong_username": MessageLookupByLibrary.simpleMessage(
            "Имя пользователя должно содержать более 2 символов"),
        "you_cant_enter": MessageLookupByLibrary.simpleMessage(
            "Вы не можете войти, подтвердите свой e-mail адрес."),
        "you_rent": MessageLookupByLibrary.simpleMessage("Вы арендуете"),
        "you_turn_in": MessageLookupByLibrary.simpleMessage("Вы сдаете"),
        "your_balance":
            MessageLookupByLibrary.simpleMessage("начислятся деньги."),
        "your_income": MessageLookupByLibrary.simpleMessage("Ваш доход")
      };
}
