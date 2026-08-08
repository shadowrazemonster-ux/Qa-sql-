# SQL для QA

Запросы которые я собирал во время тестирования. Тут все что нужно для проверки данных в БД - от базовых SELECT до поиска ошибок.

## Как использовать

1. Открываешь DBeaver или MySQL Workbench
2. Копируешь содержимое `qa_sql_queries.sql`
3. Вставляешь в Query
4. Запускаешь (Ctrl+Enter)
5. Таблицы создадутся со всеми тестовыми данными

Потом раскомментируешь нужные проверки и гонишь.

## Что внутри

**Таблицы:**
- users - пользователи
- orders - заказы
- products - товары  
- order_items - товары в заказах
- payments - платежи

**Проверки:**
- Orphaned заказы (заказ без юзера)
- Ошибки расчетов (total != amount + tax)
- Платежи которые зависли (pending больше 2 часов)
- Товары с отрицательным стоком
- Дублирующиеся email
- История заказов юзера
- Статистика платежей
- И еще 10+ запросов

## Примеры

Проверить что юзер зарегистрировался:
```sql
SELECT * FROM users WHERE email = 'test@test.com';
```

Сколько активных заказов:
```sql
SELECT COUNT(*) FROM orders WHERE status = 'pending';
```

Юзер потратил денег:
```sql
SELECT u.username, SUM(o.total) as spent FROM users u 
LEFT JOIN orders o ON u.id = o.user_id 
WHERE o.status = 'completed' 
GROUP BY u.id;
```

Заказы без товаров (баг если есть):
```sql
SELECT o.id, o.order_num FROM orders o 
WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.order_id = o.id)
AND o.status != 'cancelled';
```

Товары с отрицательным стоком (ошибка в системе!):
```sql
SELECT name, stock FROM products WHERE stock < 0;
```

## Тестовые данные

В файле уже есть:
- 5 пользователей (разные статусы)
- 7 товаров (включая с проблемами - 0 сток, отрицательный сток)
- 7 заказов (completed, pending, cancelled)
- 7 платежей (success, failed, pending)

Так что сразу можешь запускать проверки без подготовки данных.

## Удаление тестовых данных

После тестирования, если нужно очистить конкретного юзера:

```sql
DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE user_id = 5);
DELETE FROM payments WHERE order_id IN (SELECT id FROM orders WHERE user_id = 5);
DELETE FROM orders WHERE user_id = 5;
DELETE FROM users WHERE id = 5;
```

---

Собирал на протяжении работы когда нужно было что-то проверить в БД. Все запросы рабочие и протестированные.
