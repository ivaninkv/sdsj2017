# Sberbank Data Science Journey 2017

Контест от Сбербанка [sdsj.ru](https://contest.sdsj.ru/?locale=ru)

## Соревнование

В этом году для ежегодного соревнования по машинному обучению Sberbank Data Science Contest мы подготовили 2 задачи разной степени сложности: определение релевантности вопроса (Задача А) и построение вопрос-ответной системы (Задача В).

Вопрос-ответные системы и задачи понимания прочитанного текста — сложное передовое направление в анализе текста. Эти задачи имеют большую практическую ценность для любых бизнес-приложений, имеющих дело с вопросами от клиентов.

Общий призовой фонд соревнования — 2 000 000 рублей. Авторы лучших 10 решений по задаче В смогут также посоревноваться за дополнительный Приз Жюри в 250 000 рублей.

Церемония награждения победителей и розыгрыш специального Приза Жюри состоится 11 ноября в Москве в рамках однодневной конференции Sberbank Data Science Day.

## Данные

Специально для данного соревнования был собран первый в своем роде набор данных для вопрос-ответных систем на русском языке. Данные были собраны из русскоязычных статей, лежащих в открытом доступе. Совместными усилиями более тысячи человек удалось собрать 100 543 пары вопросов и ответов по 18 334 уникальным параграфам.

В двух представленных нами задачах мы предоставим участникам 50 365 пар вопросов и ответов с их параграфами для анализа и построения моделей. Оставшиеся пары вопросов и ответов будут скрыты и использоваться в качестве тестовых множеств двух задач.

Мы надеемся, что этот набор данных будет полезен не только участникам соревнования, но и будет использован профессиональными исследователями в своей работе.

## Задача А: определение релевантности вопроса
В данной задаче участникам необходимо построить алгоритм, определяющий релевантность поставленных вопросов к параграфу текста. Для решения этой задачи требуется не только понимать, относится ли вопрос к параграфу, но и насколько корректно он поставлен.

Это задача бинарной классификации, в которой целевая переменная `target` принимает два значения: 0 и 1. Классу 1 соответствуют релевантные вопросы, заданные к параграфу человеком. К классу 0 относятся вопросы, либо заданные человеком к другим параграфам, либо были составлены компьютером. В качестве целевой метрики используется `ROC-AUC`.

Для решения задачи А участникам дается два файла:

1. Тренировочные 119 399 пар вопросов и параграфов `train_taskA.csv`, имеющие вид: `paragraph_id`, `question_id`, `paragraph`, `question`, `target`.
2. Тестовые 74 295 пар вопросов и параграфов `test_taskA.csv`, имеющие вид: `paragraph_id`, `question_id`, `paragraph`, `question`.

В предоставленных тренировочных и тестовых данных релевантные вопросы класса 1 были случайно выбраны из собранных вопросов и ответов. Нерелевантные примеры класса 0, составленные человеком, были получены случайным выбором вопроса к другому параграфу по той же теме. Нерелевантные вопросы класса 0, заданные компьютером, в тренировочных данных отсутствуют. Участникам необходимо самим генерировать такие вопросы для достижения лучшего качества. Также, несмотря на то, что целевая переменная target принимает два значения 0 и 1, в качестве предсказаний можно отправлять вещественные числа.

Решением задачи является `.csv` файл на основе `test_taskA.csv`, с заполненным полем `target`. Файл с решением задачи должен иметь следующий вид: `paragraph_id`, `question_id`, `target`.

[Пример решения на Python](http://nbviewer.jupyter.org/github/sberbank-ai/data-science-journey-2017/blob/master/taskA/baseline.ipynb "Ссылка на nbviewer")

[Описание метрики ROC-AUC](http://www.machinelearning.ru/wiki/index.php?title=ROC-%D0%BA%D1%80%D0%B8%D0%B2%D0%B0%D1%8F "www.machinelearning.ru")

[Материалы соревнования](https://github.com/sberbank-ai/data-science-journey-2017 "GitHub")

<b><em>[Моё решение](taskA/taskA.html)</em></b>

## Задача B: построение вопрос-ответной системы

В ходе решения данной задачи участники построят систему ответов на вопросы. Для полноценного решения участникам предстоит научиться понимать человеческий язык, о чем вопрос и как правильно ответить на него. Эта сложная задача сделана по мотивам исследовательской задачи [SQuAD](https://rajpurkar.github.io/SQuAD-explorer/), но в этот раз с данными на русском языке.

В этой задаче участникам предстоит по парам из параграфов текста и поставленным по ним релевантным вопросам найти в параграфе точный ответ в виде подстроки параграфа. В качестве целевой метрики используется `(Macro-Averaged) F1-score`.

В задаче B дается только файл `train_taskB.csv`, также имеющий 50 365 пар вопросов и ответов, который выглядит следующим образом: `paragraph_id`, `question_id`, `paragraph`, `question`, `answer`.

Поле `answer` всегда является точной текстовой подстрокой `paragraph` с точностью до знаков пунктуации и регистра текста. Участникам не предоставляется тестовый набор данных в явном виде, решение необходимо формировать через docker. Тренировочные данные составляют 50 365 вопрос-ответных пар, публичная часть тестового множества — 14 927 пар, приватная часть — 25 001.

Решением задачи является `zip`-архив с кодом, запускающим обученную модель, а также всеми ее зависимыми файлами, например, весами модели. Решения запускаются на сервере с помощью docker - заранее заготовленной среды с предустановленными языками и библиотеками. Docker решение при старте считывает файл с тестовыми данными, применяет отправленный участником алгоритм и сохраняет результат в специальный файл. Обучать модель в отправленном решении не нужно, от участников требуется только готовая для предсказания обученная модель.

Используемый в конкурсе подход на docker контейнерах — простая в ознакомлении технология, позволяющая гибко настраивать окружение для решений. Мы также подготовили готовый набор docker образов с основными имеющимися библиотеками для языков `python` и `R`. Если вам нужно специфическое окружение или скомпилированный бинарный код, просто создайте свой образ и залейте его на [docker-hub](https://hub.docker.com/) чтобы мы могли его использовать.

Вы всегда можете написать организаторам запрос на форуме с просьбой добавить библиотеки в стандартный набор docker образов. Также для вас был специально подготовлен скрипт для тестирования вашего решения, который позволит вам отлаживать работу решения без непосредственной посылки в систему. В случае вопросов или проблем, вы всегда можете задать вопрос в разделе "Обсуждение".

Настоятельно рекомендуем ознакомиться с материалами соревнования, где подробно описан формат решений.

[Пример решения на Python](https://github.com/sberbank-ai/data-science-journey-2017/tree/master/taskB/simple-baseline)

[Код расчет метрики](https://github.com/sberbank-ai/data-science-journey-2017/tree/master/taskB)

[Материалы соревнования](https://github.com/sberbank-ai/data-science-journey-2017)
