require 'rbbt/workflow'

Workflow.require_workflow "ICGC"
Workflow.require_workflow "Study"
Sample.study_repo = ICGC.root.find
