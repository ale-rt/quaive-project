from plone.app.registry.browser.records import FakeEnv
from plone.app.registry.exportimport.handler import RegistryImporter
from transaction import commit

import sys

sites = app.objectValues("Plone Site")  # noqa:F821


for filename in sys.argv[3:]:
    for site in sites:
        importer = RegistryImporter(site.portal_registry, FakeEnv())
        with open(filename) as f:
            print(f"Importing {filename} in {site}")
            importer.importDocument(f.read())
commit()
