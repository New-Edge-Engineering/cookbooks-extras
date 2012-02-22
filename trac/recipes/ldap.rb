# this is to patch the TracAccountManager plugin.

cookbook_file "/usr/local/lib/python2.6/dist-packages/TracAccountManager-0.3.2-py2.6.egg/EGG-INFO/entry_points.txt" do
  source "entry_points.txt"
  mode "0644"
end

cookbook_file "/usr/local/lib/python2.6/dist-packages/TracAccountManager-0.3.2-py2.6.egg/acct_mgr/ldap_store.py" do
  source "ldap_store.py"
  mode "0644"
end