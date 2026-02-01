{ pkgs, ... }: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      settings = {
        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
        "sidebar.main.tools" = " ";
        "browser.startup.page" = 3;
        "browser.search.region" = "GB";
        "doh-rollout.home-region" = "GB";
        "browser.contentblocking.category" = "strict";
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\"],\"nav-bar\":[\"sidebar-button\",\"unified-extensions-button\",\"browserpass_maximbaz_com-browser-action\",\"back-button\",\"forward-button\",\"urlbar-container\",\"vertical-spacer\",\"developer-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[],\"vertical-tabs\":[\"tabbrowser-tabs\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"browserpass_maximbaz_com-browser-action\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"TabsToolbar\",\"vertical-tabs\",\"unified-extensions-area\",\"toolbar-menubar\",\"PersonalToolbar\"],\"currentVersion\":23,\"newElementCount\":5}";
        "browser.toolbars.bookmarks.visibility" = "newtab";

        "devtools.toolbox.host" = "right";
        "devtools.accessibility.enabled" = false;
        "devtools.application.enabled" = false;
        "devtools.memory.enabled" = false;
        "devtools.performance.enabled" = false;
        "devtools.storage.enabled" = false;
        "devtools.styleeditor.enabled" = false;
        "devtools.toolbox.tabsOrder" = "inspector,netmonitor,webconsole";
      };
    };


    # about:policies#documentation
    policies = {
      # Check about:support for extension/add-on ID strings.
      ExtensionSettings = {
        # blocks all addons except the ones specified below
        "*".installation_mode = "blocked";
      
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          installation_mode = "force_installed";
        };


        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      
        "browserpass@maximbaz.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/browserpass-ce/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      
      GenerativeAI.Enabled = false;

      DisableFirefoxAccounts        = true;
      DisableFirefoxScreenshots     = true;
      DisableFirefoxStudies         = true;
      DisableForgetButton           = true;
      DisableFormHistory            = true;
      DisableMasterPasswordCreation = true;
      DisablePasswordReveal         = true;
      DisablePocket                 = true;
      DisableProfileImport          = true;
      DisableProfileRefresh         = true;
      DisableSetDesktopBackground   = true;
      DisableTelemetry              = true;

      OfferToSaveLogins             = false;
    };
  };
}
