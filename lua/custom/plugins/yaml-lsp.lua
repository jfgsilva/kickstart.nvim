return {
  -- https://www.arthurkoziel.com/json-schemas-in-neovim/
  'someone-stole-my-name/yaml-companion.nvim',
  'b0o/SchemaStore.nvim',
  config = function()
    local cfg = require('yaml-companion').setup {
      -- detect k8s schemas based on file content
      builtin_matchers = {
        kubernetes = { enabled = true },
      },

      -- schemas available in Telescope picker
      schemas = {
        -- not loaded automatically, manually select with
        -- :Telescope yaml_schema
        {
          name = 'Argo CD Application',
          uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
        },
        {
          name = 'SealedSecret',
          uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json',
        },
        -- schemas below are automatically loaded, but added
        -- them here so that they show up in the statusline
        {
          name = 'Kustomization',
          uri = 'https://json.schemastore.org/kustomization.json',
        },
        {
          name = 'GitHub Workflow',
          uri = 'https://json.schemastore.org/github-workflow.json',
        },
        {
          name = 'Ansible Execution Environment',
          description = 'Ansible execution-environment.yml file',
          fileMatch = { '**/execution-environment.yml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/execution-environment.json',
        },
        {
          name = 'Ansible Meta',
          description = 'Ansible meta/main.yml file',
          fileMatch = { '**/meta/main.yml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/meta.json',
        },
        {
          name = 'Ansible Meta Runtime',
          description = 'Ansible meta/runtime.yml file',
          fileMatch = { '**/meta/runtime.yml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/meta-runtime.json',
        },
        {
          name = 'Ansible Argument Specs',
          description = 'Ansible meta/argument_specs.yml file',
          fileMatch = { '**/meta/argument_specs.yml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/role-arg-spec.json',
        },
        {
          name = 'Ansible Requirements',
          description = 'Ansible requirements file',
          fileMatch = { 'requirements.yml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/requirements.json',
        },
        {
          name = 'Ansible Vars File',
          description = 'Ansible variables File',
          fileMatch = {
            '**/vars/*.yml',
            '**/vars/*.yaml',
            '**/defaults/*.yml',
            '**/defaults/*.yaml',
            '**/host_vars/*.yml',
            '**/host_vars/*.yaml',
            '**/group_vars/*.yml',
            '**/group_vars/*.yaml',
          },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/vars.json',
        },
        {
          name = 'Ansible Tasks File',
          description = 'Ansible tasks file',
          fileMatch = {
            '**/tasks/*.yml',
            '**/tasks/*.yaml',
            '**/handlers/*.yml',
            '**/handlers/*.yaml',
          },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks',
        },
        {
          name = 'Ansible Playbook',
          description = 'Ansible playbook files',
          fileMatch = {
            'playbook.yml',
            'playbook.yaml',
            'site.yml',
            'site.yaml',
            '**/playbooks/*.yml',
            '**/playbooks/*.yaml',
          },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook',
        },
        {
          name = 'Ansible Rulebook',
          description = 'Ansible rulebook files',
          fileMatch = { '**/rulebooks/*.yml', '**/rulebooks/*.yaml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-rulebook/main/ansible_rulebook/schema/ruleset_schema.json',
        },
        {
          name = 'Ansible Inventory',
          description = 'Ansible inventory files',
          fileMatch = { 'inventory.yml', 'inventory.yaml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json',
        },
        {
          name = 'Ansible Collection Galaxy',
          description = 'Ansible Collection Galaxy metadata',
          fileMatch = { 'galaxy.yml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/galaxy.json',
        },
        {
          name = 'Ansible-lint Configuration',
          description = 'Ansible-lint Configuration',
          fileMatch = { '.ansible-lint', '**/.config/ansible-lint.yml' },
          url = 'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible-lint-config.json',
        },
        {
          name = 'Ansible Navigator Configuration',
          description = 'Ansible Navigator Configuration',
          fileMatch = {
            '.ansible-navigator.json',
            '.ansible-navigator.yaml',
            '.ansible-navigator.yml',
            'ansible-navigator.json',
            'ansible-navigator.yaml',
            'ansible-navigator.yml',
          },
          url = 'https://raw.githubusercontent.com/ansible/ansible-navigator/main/src/ansible_navigator/data/ansible-navigator.json',
        },
      },

      lspconfig = {
        settings = {
          yaml = {
            validate = true,
            schemaStore = {
              enable = false,
              url = '',
            },

            -- schemas from store, matched by filename
            -- loaded automatically
            schemas = require('schemastore').yaml.schemas {
              select = {
                'Ansible Collection Galaxy',
                'Ansible Execution Environment',
                'Ansible Inventory',
                'Ansible Meta Runtime',
                'Ansible Meta',
                'Ansible Playbook',
                'Ansible Requirements',
                'Ansible Rulebook',
                'Ansible Tasks File',
                'Ansible Vars File',
                'Ansible-lint Configuration',
                'GitHub Workflow',
                'kustomization',
              },
            },
          },
        },
      },
    }

    require('lspconfig')['yamlls'].setup(cfg)

    require('telescope').load_extension 'yaml_schema'
    -- get schema for current buffer
    local function get_schema()
      local schema = require('yaml-companion').get_buf_schema(0)
      if schema.result[1].name == 'none' then
        return ''
      end
      return schema.result[1].name
    end

    require('lualine').setup {
      sections = {
        lualine_x = { 'fileformat', 'filetype', get_schema },
      },
    }
  end,
}
