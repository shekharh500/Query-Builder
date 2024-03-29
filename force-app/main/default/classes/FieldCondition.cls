global class FieldCondition implements Condition {
    private static final Operator EQUALS = Operator.EQUALS;
    private static final Operator NOT_EQUALS = Operator.NOT_EQUALS;
    private static final Operator LESS_THAN = Operator.LESS_THAN;
    private static final Operator LESS_THAN_OR_EQUAL_TO = Operator.LESS_THAN_OR_EQUAL_TO;
    private static final Operator GREATER_THAN = Operator.GREATER_THAN;
    private static final Operator GREATER_THAN_OR_EQUAL_TO = Operator.GREATER_THAN_OR_EQUAL_TO;
    private static final Operator LIKEX = Operator.LIKEX;
    private static final Operator INX = Operator.INX;
    private static final Operator NOT_IN = Operator.NOT_IN;

    private static final Operator DEFAULT_OPERATOR = EQUALS;

    global String field { get; private set; }
    global Operator operator { get; private set; }
    global Object value { get; private set; }

    global FieldCondition() {
    }

    global FieldCondition(String field) {
        this.field(field);
    }

    global FieldCondition(String field, Object value) {
        this(field, DEFAULT_OPERATOR, value);
    }

    global FieldCondition(String field, Operator operator, Object value) {
        this.field(field);
        if (operator != null) {
            this.setOperation(operator, value);
        }
    }

    global FieldCondition field(String field) {
        if (ApexLangUtils.isBlank(field)) {
            throw new IllegalArgumentException('illegal argument:  field is empty');
        }
        this.field = ApexLangUtils.trim(field);
        return this;
    }

    global FieldCondition equals(Object value) {
        return setOperation(EQUALS, value);
    }
    global FieldCondition notEquals(Object value) {
        return setOperation(NOT_EQUALS, value);
    }
    global FieldCondition lessThan(Object value) {
        return setOperation(LESS_THAN, value);
    }
    global FieldCondition lessThanOrEqualTo(Object value) {
        return setOperation(LESS_THAN_OR_EQUAL_TO, value);
    }
    global FieldCondition greaterThan(Object value) {
        return setOperation(GREATER_THAN, value);
    }
    global FieldCondition greaterThanOrEqualTo(Object value) {
        return setOperation(GREATER_THAN_OR_EQUAL_TO, value);
    }
    global FieldCondition likex(Object value) {
        return setOperation(LIKEX, value);
    }
    global FieldCondition inx(Object value) {
        return setOperation(INX, value);
    }
    global FieldCondition notIn(Object value) {
        return setOperation(NOT_IN, value);
    }

    private FieldCondition setOperation(Operator operator, Object value) {
        if (operatorToString(operator) == null) {
            throw new IllegalArgumentException('illegal operator: ' + operator);
        }
        this.operator = operator;
        this.value = value;
        return this;
    }

    global String toSoql() {
        return this.toSoql(null);
    }

    global String toSoql(SoqlOptions options) {
        if (options == null) {
            options = SoqlOptions.DEFAULT_OPTIONS;
        }
        Object manipulated = value;
        if (
            manipulated != null &&
            manipulated instanceof String &&
            operator == LIKEX &&
            options.wildcardStringsInLikeOperators
        ) {
            manipulated = ApexLangUtils.ensureStringStartsEndsWithChar(((String) manipulated), '');
        }
        return field + ' ' + operatorToString(operator) + ' ' + SoqlUtils.toLiteral(manipulated, options);
    }

    global static String operatorToString(Operator op) {
        String returnValue = null;
        if (op == EQUALS) {
            returnValue = '=';
        } else if (op == NOT_EQUALS) {
            returnValue = '!=';
        } else if (op == LESS_THAN) {
            returnValue = '<';
        } else if (op == LESS_THAN_OR_EQUAL_TO) {
            returnValue = '<=';
        } else if (op == GREATER_THAN) {
            returnValue = '>';
        } else if (op == GREATER_THAN_OR_EQUAL_TO) {
            returnValue = '>=';
        } else if (op == LIKEX) {
            returnValue = 'like';
        } else if (op == INX) {
            returnValue = 'IN';
        } else if (op == NOT_IN) {
            returnValue = 'NOT IN';
        }

        return returnValue;
    }
}