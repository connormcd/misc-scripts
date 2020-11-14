accept a prompt 'a '
accept b prompt 'b '
accept c prompt 'c '

select  round(( -1 *  &&b  + sqrt ( power(&&b,2) - 4 * &&a * &&c ) ) / ( 2 * &a ),2) xint_1
from dual;

select  round(( -1 *  &&b  - sqrt ( power(&&b,2) - 4 * &&a * &&c ) ) / ( 2 * &a ),2) xint_2
from dual;

col tp_x new_value x

select round( -1 *  &&b / ( 2 * &a ),2) tp_x
from dual;

select &&a * power(&&x,2) + &&b * &&x + &&c tp_y
from dual;

