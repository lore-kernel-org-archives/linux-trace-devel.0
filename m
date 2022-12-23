Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3F4C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 08:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiLWI3F (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 03:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbiLWI26 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 03:28:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86DC35790
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 00:28:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D0C306A975;
        Fri, 23 Dec 2022 08:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671784123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2E2Xn5pw+XVrA1IG2Zy+k28EwefbPEIsaPaqWQsm8aI=;
        b=sAAuUDbhmATUU7G3zcK2L0/sb+K5AO/fuglVmvgV4reoMV/xte4wMvgbwsR/MSnHuwVUGM
        ljjYdmFxpYrHP0u6JGw5QFWazaflXsDopCS01QLEGF2jo788eArEYK7LBYoQg9YPUpMClY
        9wUxFi3J2Z++ah+ccTIIRuFdnGNhiGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671784123;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2E2Xn5pw+XVrA1IG2Zy+k28EwefbPEIsaPaqWQsm8aI=;
        b=t4Amwv1Z2jSzQZAggKwJ3QenzumxWE/PBeLk6jo89a4EZCbaKufaAHc4ucYQvYy3xYfxJf
        kcPpeI5+0P9S3gBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C034D138E4;
        Fri, 23 Dec 2022 08:28:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MnfiLrtmpWPKVwAAMHmgww
        (envelope-from <dwagner@suse.de>); Fri, 23 Dec 2022 08:28:43 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v4] libtracefs: Add initial support for meson
Date:   Fri, 23 Dec 2022 09:28:42 +0100
Message-Id: <20221223082842.13790-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce Meson as build framework for building libtracefs. This
lives besides the Makefiles until all the expected initial fallouts
have been dealed with.

The build steps are:

  # configure using .build as build directory and install destination
  # /tmp/test
  meson --prefix=/tmp/libtracefs .build

  # trigger the build
  ninja -C .build

  # install the library
  ninja -C .build install

In case you want to build/install the documentation the setup is

  meson -Ddocs-build=true .build

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 v4:
  - add subdir include path to cflags in pkgconfg file
  - refactoring build instruction for section 1 and section 3 documentation
    into one loop (reduce code duplication)

 v3:
  - build documetation
  - build samples
  - set default location to /usr/local

 v2:
  - updated commit message
  - dropped the include path patch, the pkg-config
    from libtraceevent is including them

 v1:
  - initial version

 Documentation/list-txt.sh  |  11 ++++
 Documentation/meson.build  | 123 +++++++++++++++++++++++++++++++++++++
 include/meson.build        |   9 +++
 meson.build                |  47 ++++++++++++++
 meson_options.txt          |  18 ++++++
 samples/extract-example.sh |   3 +
 samples/meson.build        |  44 +++++++++++++
 src/meson.build            |  65 ++++++++++++++++++++
 utest/meson.build          |  17 +++++
 9 files changed, 337 insertions(+)
 create mode 100644 Documentation/list-txt.sh
 create mode 100644 Documentation/meson.build
 create mode 100644 include/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 samples/extract-example.sh
 create mode 100644 samples/meson.build
 create mode 100644 src/meson.build
 create mode 100644 utest/meson.build

diff --git a/Documentation/list-txt.sh b/Documentation/list-txt.sh
new file mode 100644
index 000000000000..89c3bceff14c
--- /dev/null
+++ b/Documentation/list-txt.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+SECTION=$1
+TXT_PATH=$2
+
+if [ "$SECTION" = "1" ] ; then
+  ls -1 ${TXT_PATH}/libtracefs-*.txt.1
+elif [ "$SECTION" = "3" ] ; then
+  ls -1 ${TXT_PATH}/libtracefs-*.txt
+  ls -1 ${TXT_PATH}/libtracefs.txt
+fi
diff --git a/Documentation/meson.build b/Documentation/meson.build
new file mode 100644
index 000000000000..3c6f6312abd9
--- /dev/null
+++ b/Documentation/meson.build
@@ -0,0 +1,123 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+sources = {}
+
+list_txt = find_program('list-txt.sh')
+
+r = run_command(list_txt, '1', meson.current_source_dir(), check: true)
+sources += { '1': r.stdout().strip().split('\n') }
+
+r = run_command(list_txt, '3', meson.current_source_dir(), check: true)
+sources += { '3': r.stdout().strip().split('\n') }
+
+#
+# For asciidoc ...
+#	-7.1.2,	no extra settings are needed.
+#	8.0-,	set ASCIIDOC8.
+#
+
+#
+# For docbook-xsl ...
+#	-1.68.1,	set ASCIIDOC_NO_ROFF? (based on changelog from 1.73.0)
+#	1.69.0,		no extra settings are needed?
+#	1.69.1-1.71.0,	set DOCBOOK_SUPPRESS_SP?
+#	1.71.1,		no extra settings are needed?
+#	1.72.0,		set DOCBOOK_XSL_172.
+#	1.73.0-,	set ASCIIDOC_NO_ROFF
+#
+
+#
+# If you had been using DOCBOOK_XSL_172 in an attempt to get rid
+# of 'the ".ft C" problem' in your generated manpages, and you
+# instead ended up with weird characters around callouts, try
+# using ASCIIDOC_NO_ROFF instead (it works fine with ASCIIDOC8).
+#
+
+if get_option('asciidoctor')
+    asciidoc = find_program('asciidoctor')
+    asciidoc_extra  = ['-a', 'compat-mode']
+    asciidoc_extra += ['-I.']
+    asciidoc_extra += ['-r', 'asciidoctor-extensions']
+    asciidoc_extra += ['-a', 'mansource=libtraceevent']
+    asciidoc_extra += ['-a', 'manmanual="libtraceevent Manual"']
+    asciidoc_html = 'xhtml5'
+else
+    asciidoc = find_program('asciidoc')
+    asciidoc_extra  = ['--unsafe']
+    asciidoc_extra += ['-f', meson.current_source_dir() + '/asciidoc.conf']
+    asciidoc_html = 'xhtml11'
+
+    r = run_command(asciidoc, '--version', check: true)
+    v = r.stdout().strip()
+    if v.version_compare('>=8.0')
+        asciidoc_extra += ['-a', 'asciidoc7compatible']
+    endif
+endif
+
+manpage_xsl = meson.current_source_dir() + '/manpage-normal.xsl'
+
+if get_option('docbook-xls-172')
+    asciidoc_extra += ['-a', 'libtraceevent-asciidoc-no-roff']
+    manpage_xsl = meson.current_source_dir() + '/manpage-1.72.xsl'
+elif get_option('asciidoc-no-roff')
+    # docbook-xsl after 1.72 needs the regular XSL, but will not
+    # pass-thru raw roff codes from asciidoc.conf, so turn them off.
+    asciidoc_extra += ['-a', 'libtraceevent-asciidoc-no-roff']
+endif
+
+xmlto = find_program('xmlto')
+xmlto_extra = []
+
+if get_option('man-bold-literal')
+    xmlto_extra += ['-m ', meson.current_source_dir() + '/manpage-bold-literal.xsl']
+endif
+
+if get_option('docbook-suppress-sp')
+    xmlto_extra += ['-m ',  meson.current_source_dir() + '/manpage-suppress-sp.xsl']
+endif
+
+gen = generator(asciidoc,
+                output: '@BASENAME@.xml',
+                arguments: [
+                    '-b', 'docbook',
+                    '-d', 'manpage',
+                    '-a', 'libtraceevent_version=' + meson.project_version(),
+                    '-o', '@OUTPUT@']
+                    + asciidoc_extra
+                    + ['@INPUT@'])
+
+foreach section, list_txt : sources
+    foreach src : list_txt
+        # build man pages
+        xml = gen.process(src)
+        custom_target(
+            src.underscorify() + '_man',
+            input: xml,
+            output: '@BASENAME@.' + section,
+            command: [xmlto,
+                     '-m', manpage_xsl,
+                     'man',
+                     '-o', '@OUTPUT@']
+                     + xmlto_extra
+                     + ['@INPUT@'],
+            install: true,
+            install_dir: join_paths(mandir, 'man' + section))
+
+        # build html pages
+        custom_target(
+           src.underscorify() + '_html',
+           input: src,
+           output: '@BASENAME@.html',
+           command: [asciidoc,
+                    '-b', asciidoc_html,
+                    '-d', 'manpage',
+                    '-a', 'libtraceevent_version=' + meson.project_version(),
+                    '-o', '@OUTPUT@']
+                    + asciidoc_extra
+                    + ['@INPUT@'],
+           install: true,
+           install_dir: htmldir)
+    endforeach
+endforeach
diff --git a/include/meson.build b/include/meson.build
new file mode 100644
index 000000000000..1bbfe8afb280
--- /dev/null
+++ b/include/meson.build
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+headers = [
+   'tracefs.h',
+]
+
+foreach h : headers
+	install_headers(h, subdir : 'libtracefs')
+endforeach
diff --git a/meson.build b/meson.build
new file mode 100644
index 000000000000..310e96b9e23c
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+project(
+    'libtracefs', ['c'],
+    meson_version: '>= 0.50.0',
+    license: 'LGPL-2.1',
+    version: '1.6.3',
+    default_options: [
+      'c_std=gnu99',
+      'buildtype=release',
+      'prefix=/usr/local',
+      'warning_level=1',
+    ]
+)
+
+library_version = meson.project_version()
+
+libtraceevent_dep = dependency('libtraceevent', version: '>= 1.7.0', required: true)
+cunit_dep = dependency('cunit', required : false)
+
+prefixdir = get_option('prefix')
+mandir    = join_paths(prefixdir, get_option('mandir'))
+htmldir   = join_paths(prefixdir, get_option('htmldir'))
+
+add_project_arguments(
+    [
+      '-D_GNU_SOURCE',
+    ],
+    language : 'c',
+)
+
+incdir = include_directories(['include'])
+
+subdir('src')
+subdir('include')
+subdir('utest')
+subdir('samples')
+if get_option('docs-build')
+    custom_target('check-doc',
+                   output: 'dummy',
+                   command : ['check-manpages.sh',
+                              meson.current_source_dir() + '/Documentation'],
+	           build_by_default : true)
+    subdir('Documentation')
+endif
diff --git a/meson_options.txt b/meson_options.txt
new file mode 100644
index 000000000000..9bcd66f49f06
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+option('docs-build', type : 'boolean', value : false,
+       description : 'build documentation')
+option('htmldir', type : 'string', value : '',
+       description : 'directory for HTML documentation')
+option('asciidoctor', type : 'boolean', value: false,
+       description : 'use asciidoctor instead of asciidoc')
+option('docbook-xls-172', type : 'boolean', value : false,
+       description : 'enable docbook XLS 172 workaround')
+option('asciidoc-no-roff', type : 'boolean', value : false,
+       description : 'enable no roff workaround')
+option('man-bold-literal', type : 'boolean', value : false,
+       description : 'enable bold literals')
+option('docbook-suppress-sp', type : 'boolean', value : false,
+       description : 'docbook suppress sp')
diff --git a/samples/extract-example.sh b/samples/extract-example.sh
new file mode 100644
index 000000000000..c5c0f702e7f0
--- /dev/null
+++ b/samples/extract-example.sh
@@ -0,0 +1,3 @@
+#!/bin/bash
+
+cat $1 | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $2
diff --git a/samples/meson.build b/samples/meson.build
new file mode 100644
index 000000000000..e71edacc2dd9
--- /dev/null
+++ b/samples/meson.build
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+examples = [
+    'dynevents',
+    'kprobes',
+    'eprobes',
+    'uprobes',
+    'synth',
+    'error',
+    'filter',
+    'function-filter',
+    'hist',
+    'hist-cont',
+    'tracer',
+    'stream',
+    'instances-affinity',
+    'cpu',
+]
+
+extract_examples = find_program('extract-example.sh')
+gen = generator(extract_examples,
+                output: '@BASENAME@.c',
+                arguments: ['@INPUT@', '@OUTPUT@'])
+
+foreach ex : examples
+    src = gen.process(meson.current_source_dir() + '/../Documentation/libtracefs-@0@.txt'.format(ex))
+    executable(
+        ex.underscorify(),
+        src,
+        dependencies: [libtracefs_dep, libtraceevent_dep],
+        include_directories: [incdir]
+     )
+endforeach
+
+# sqlhist is unique and stands on its own
+src = gen.process(meson.current_source_dir() + '/../Documentation/libtracefs-sql.txt')
+executable(
+   'sqlhist',
+   src,
+   dependencies: [libtracefs_dep, libtraceevent_dep],
+   include_directories: [incdir]
+)
diff --git a/src/meson.build b/src/meson.build
new file mode 100644
index 000000000000..43139b6de268
--- /dev/null
+++ b/src/meson.build
@@ -0,0 +1,65 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+sources= [
+   'tracefs-dynevents.c',
+   'tracefs-eprobes.c',
+   'tracefs-events.c',
+   'tracefs-filter.c',
+   'tracefs-hist.c',
+   'tracefs-instance.c',
+   'tracefs-kprobes.c',
+   'tracefs-marker.c',
+   'tracefs-record.c',
+   'tracefs-sqlhist.c',
+   'tracefs-tools.c',
+   'tracefs-uprobes.c',
+   'tracefs-utils.c',
+]
+
+flex = find_program('flex', required: true)
+bison = find_program('bison', required: true)
+
+lgen = generator(flex,
+output : '@PLAINNAME@.yy.c',
+arguments : ['-o', '@OUTPUT@', '@INPUT@'])
+
+pgen = generator(bison,
+output : ['@BASENAME@.tab.c', '@BASENAME@.tab.h'],
+arguments : ['@INPUT@', '--defines=@OUTPUT1@', '--output=@OUTPUT0@'])
+
+lfiles = lgen.process('sqlhist.l')
+pfiles = pgen.process('sqlhist.y')
+
+libtracefs = library(
+    'tracefs',
+    sources, lfiles, pfiles,
+    version: library_version,
+    dependencies: [libtraceevent_dep],
+    include_directories: [incdir],
+    install: true,
+)
+
+libtracefs_static = static_library(
+    'tracefs_static',
+    sources, lfiles, pfiles,
+    dependencies: [libtraceevent_dep],
+    include_directories: [incdir],
+    install: false,
+)
+
+pkg = import('pkgconfig')
+pkg.generate(libtracefs,
+    subdirs: 'libtracefs',
+    filebase: meson.project_name(),
+    name: meson.project_name(),
+    version: meson.project_version(),
+    description: 'Manage trace fs',
+    url: 'https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/',
+)
+
+libtracefs_dep = declare_dependency(
+    include_directories: ['.'],
+    link_with: libtracefs,
+)
diff --git a/utest/meson.build b/utest/meson.build
new file mode 100644
index 000000000000..8c8caf37803d
--- /dev/null
+++ b/utest/meson.build
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+source = [
+    'trace-utest.c',
+    'tracefs-utest.c',
+]
+
+e = executable(
+   'trace-utest',
+   source,
+   include_directories: [incdir],
+   dependencies: [libtraceevent_dep, cunit_dep],
+   link_with: libtracefs_static)
+
+test('trace-utest', e)
-- 
2.39.0

