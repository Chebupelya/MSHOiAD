

project_payments, project_stages, project_event_types




SELECT project_id, start_quarter, end_quarter
FROM (
    SELECT project_payments.project_id, 
           TO_CHAR(payment_date, 'YYYY-Q') AS quarter, 
           SUM(payment_amount) AS payment
    FROM project_payments
    INNER JOIN
        project_stages
        ON project_payments.associated_stage = project_stages.id
    INNER JOIN
        project_event_types
        ON project_stages.event_type = project_event_types.id
    WHERE project_event_types.id = 13
    GROUP BY project_payments.project_id, TO_CHAR(payment_date, 'YYYY-Q')
)
MATCH_RECOGNIZE (
    PARTITION BY project_id
    ORDER BY quarter
    MEASURES FIRST(quarter) AS start_quarter,
             NEXT(quarter) AS second_quarter,
             LAST(quarter) AS end_quarter
    ONE ROW PER MATCH
    PATTERN (GROWTH FALL GROWTH)
    DEFINE 
        GROWTH AS payment > PREV(payment),
        FALL AS payment < PREV(payment)
);