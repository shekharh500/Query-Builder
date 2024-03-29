global abstract class ConditionGroup implements NestableCondition {
    global List<Condition> conditions { get; private set; }

    private String separator { get; set; }

    global ConditionGroup(String separator) {
        this.separator = separator;
        this.conditions = new List<Condition>();
    }

    global NestableCondition add(Condition c) {
        if (c != null) {
            this.conditions.add(c);
        }
        return this;
    }

    global String toSoql() {
        return this.toSoql(null);
    }

    global String toSoql(SoqlOptions options) {
        if (options == null) {
            options = SoqlOptions.DEFAULT_OPTIONS;
        }
        String soql = '';
        if (conditions.size() == 1) {
            return conditions.get(0).toSoql(options);
        } else if (conditions.size() > 1) {
            Boolean hasOpenParenBeenAdded = false;
            String additionalSoql = null;
            for (Condition condition : conditions) {
                additionalSoql = condition.toSoql(options);
                if (ApexLangUtils.isBlank(additionalSoql)) {
                    continue;
                }
                if (hasOpenParenBeenAdded) {
                    soql += ' ' + separator + ' ';
                } else {
                    soql = '(';
                    hasOpenParenBeenAdded = true;
                }
                soql += additionalSoql;
            }
            if (hasOpenParenBeenAdded) {
                soql += ')';
            }
        }
        return soql;
    }
}