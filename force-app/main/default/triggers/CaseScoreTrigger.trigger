trigger CaseScoreTrigger on Case (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        CaseScoreHandler.calculateCaseScores(Trigger.new);
    }
}