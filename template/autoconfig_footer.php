  "directory"     => "/data",
  "appcodechecker" => false,
  "apps_paths" => array (
    0 => array (
      "path"     => OC::$SERVERROOT."/apps",
      "url"      => "/apps",
      "writable" => false,
    ),
    1 => array (
      "path"     => OC::$SERVERROOT."/extra_apps",
      "url"      => "/extra_apps",
      "writable" => true,
    ),
    'forcessl' => true,
);
