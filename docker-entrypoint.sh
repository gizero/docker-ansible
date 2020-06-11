#!/usr/bin/env bash

if [[ -n "${SSH_KEY}" ]] && [[ -f ${HOME}/.ssh/${SSH_KEY} ]]; then
  eval $(ssh-agent -s)
  ssh-add ${HOME}/.ssh/${SSH_KEY}
fi

if [ -f ${PYTHON_REQUIREMENTS:-requirements-pip.txt} ]; then
  pip3 install -r ${PYTHON_REQUIREMENTS:--requirements-pip.txt}
fi

if [ -f ${ANSIBLE_REQUIREMENTS:-requirements.yml} ]; then
  ansible-galaxy install --force -r ${ANSIBLE_REQUIREMENTS:-requirements.yml}
fi

if [[ -n "${ANSIBLE_PRE_PLAYBOOK}" ]] && [[ -f "${ANSIBLE_PRE_PLAYBOOK}" ]]; then
  echo ""
  echo "	Running playbook ${ANSIBLE_PRE_PLAYBOOK}"
  ansible-playbook ${ANSIBLE_PRE_PLAYBOOK_OPTS} "${ANSIBLE_PRE_PLAYBOOK}"
  echo ""
fi

exec ansible-playbook $@
