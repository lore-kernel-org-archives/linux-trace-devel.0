Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B861FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 18:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiLTSIr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 13:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLTSIp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 13:08:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A7310A7
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 10:08:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 067544D63A;
        Tue, 20 Dec 2022 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671559723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tgj4qG922REMLEUrCk5jhr2XkKzpLW8IJLXN+35lO+U=;
        b=Ow8IifAAq1KVFyu+oSZDccmHH9EP48ZWrtYQ3Y+3dWqG/OBtueViyt392xPbvYhAK8eUsY
        DpF089Mo4riNlNATp4VI3lNV8k3k3O+uoLCCLKEzxj4FDEesnxIcR1N0HYH7197M90463X
        EygXPdaQYRFwb8U9ES/b+mrxU12pqwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671559723;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tgj4qG922REMLEUrCk5jhr2XkKzpLW8IJLXN+35lO+U=;
        b=YEwm/SulVkUPKy2PLO7p+5ixIrueloVbptWLRXI91elTfZ+QR5TlX9I64QFuGrF5G+N1uo
        1L6CMQ71RD9A3CAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E3F8F1390E;
        Tue, 20 Dec 2022 18:08:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id h0weNyr6oWNFHQAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 20 Dec 2022 18:08:42 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v4] libtraceevent: Add initial support for meson
Date:   Tue, 20 Dec 2022 19:08:40 +0100
Message-Id: <20221220180840.32586-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce Meson as build framework for building libtraceevent. This
lives besides the Makefiles until all the expected initial fallouts
have been dealed with.

The build steps are:

  # configure using .build as build directory and install destination
  # /tmp/test
  meson --prefix=/tmp/libtraceevent .build

  # trigger the build
  ninja -C .build

  # install the library
  ninja -C .build install

In case you want to build/install the documentation the setup is

  meson -Ddocs-build=true .build

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
v4:
 - install man pages to correct section, in this case 3
 - run check-doc when building the docs

v3:
 - build documentation
 - build samples
 - changed default install to /usr/local

v2:
 - changed include path exported in pkg-config
   exports the same paths as per Makefile

v1:
 - initial version

 Documentation/list-txt.sh      |   6 ++
 Documentation/meson.build      | 115 +++++++++++++++++++++++++++++++++
 include/traceevent/meson.build |  14 ++++
 meson.build                    |  53 +++++++++++++++
 meson_options.txt              |  20 ++++++
 plugins/dynamic_list.sh        |  14 ++++
 plugins/meson.build            |  44 +++++++++++++
 samples/meson.build            |  11 ++++
 src/meson.build                |  37 +++++++++++
 utest/meson.build              |  16 +++++
 10 files changed, 330 insertions(+)
 create mode 100644 Documentation/list-txt.sh
 create mode 100644 Documentation/meson.build
 create mode 100644 include/traceevent/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100755 plugins/dynamic_list.sh
 create mode 100644 plugins/meson.build
 create mode 100644 samples/meson.build
 create mode 100644 src/meson.build
 create mode 100644 utest/meson.build

diff --git a/Documentation/list-txt.sh b/Documentation/list-txt.sh
new file mode 100644
index 000000000000..78e9f7a5d02c
--- /dev/null
+++ b/Documentation/list-txt.sh
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+TXT_PATH=$1
+
+ls -1 ${TXT_PATH}/libtraceevent-*.txt
+ls -1 ${TXT_PATH}/libtraceevent.txt
diff --git a/Documentation/meson.build b/Documentation/meson.build
new file mode 100644
index 000000000000..4ad45dca8365
--- /dev/null
+++ b/Documentation/meson.build
@@ -0,0 +1,115 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+list_txt = find_program('list-txt.sh')
+r = run_command(list_txt, meson.current_source_dir(), check: true)
+sources3 = r.stdout().strip().split('\n')
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
+foreach src : sources3
+    # build man pages
+    xml = gen.process(src)
+    custom_target(
+        src.underscorify() + '_man',
+        input: xml,
+        output: '@BASENAME@.3',
+        command: [xmlto,
+                 '-m', manpage_xsl,
+                 'man',
+                 '-o', '@OUTPUT@']
+                 + xmlto_extra
+                 + ['@INPUT@'],
+        install: true,
+        install_dir: join_paths(mandir, 'man3'))
+
+    # build html pages
+    custom_target(
+       src.underscorify() + '_html',
+       input: src,
+       output: '@BASENAME@.html',
+       command: [asciidoc,
+                '-b', asciidoc_html,
+                '-d', 'manpage',
+	        '-a', 'libtraceevent_version=' + meson.project_version(),
+                '-o', '@OUTPUT@']
+                + asciidoc_extra
+                + ['@INPUT@'],
+       install: true,
+       install_dir: htmldir)
+endforeach
diff --git a/include/traceevent/meson.build b/include/traceevent/meson.build
new file mode 100644
index 000000000000..187b136ed138
--- /dev/null
+++ b/include/traceevent/meson.build
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+headers = [
+   'event-parse.h',
+   'event-utils.h',
+   'kbuffer.h',
+   'trace-seq.h',
+]
+
+foreach h : headers
+	install_headers(h, subdir : 'traceevent')
+endforeach
diff --git a/meson.build b/meson.build
new file mode 100644
index 000000000000..1e523db00b49
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+project(
+    'libtraceevent', ['c'],
+    meson_version: '>= 0.50.0',
+    license: 'LGPL-2.1',
+    version: '1.7.0',
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
+cunit_dep = dependency('cunit', required : false)
+
+prefixdir = get_option('prefix')
+mandir    = join_paths(prefixdir, get_option('mandir'))
+htmldir   = join_paths(prefixdir, get_option('htmldir'))
+libdir    = join_paths(prefixdir, get_option('libdir'))
+plugindir = get_option('plugindir')
+if plugindir == ''
+    plugindir = join_paths(libdir, 'libtraceevent/plugins')
+endif
+
+add_project_arguments(
+    [
+      '-D_GNU_SOURCE',
+      '-DPLUGIN_DIR="@0@"'.format(plugindir),
+    ],
+    language : 'c',
+)
+
+incdir = include_directories(['include', 'include/traceevent'])
+
+subdir('src')
+subdir('include/traceevent')
+subdir('plugins')
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
index 000000000000..14c6fc0cc36d
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+option('plugindir', type : 'string',
+       description : 'set the plugin dir')
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
diff --git a/plugins/dynamic_list.sh b/plugins/dynamic_list.sh
new file mode 100755
index 000000000000..e1480eaa694f
--- /dev/null
+++ b/plugins/dynamic_list.sh
@@ -0,0 +1,14 @@
+#!/bin/sh
+# SPDX-License-Identifier: LGPL-2.1
+
+symbol_type=$(nm -u -D $@ | awk 'NF>1 {print $1}' | xargs echo "U w W" |
+	      tr 'w ' 'W\n' | sort -u | xargs echo)
+
+if [ "$symbol_type" = "U W" ]; then
+	echo '{'
+
+	nm -u -D $@ | awk 'NF>1 {sub("@.*", "", $2); print "\t"$2";"}' |
+	sort -u
+
+	echo '};'
+fi
diff --git a/plugins/meson.build b/plugins/meson.build
new file mode 100644
index 000000000000..f3260b17d69a
--- /dev/null
+++ b/plugins/meson.build
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+plugins = [
+    'plugin_jbd2.c',
+    'plugin_hrtimer.c',
+    'plugin_kmem.c',
+    'plugin_kvm.c',
+    'plugin_mac80211.c',
+    'plugin_sched_switch.c',
+    'plugin_function.c',
+    'plugin_futex.c',
+    'plugin_xen.c',
+    'plugin_scsi.c',
+    'plugin_cfg80211.c',
+    'plugin_tlb.c',
+]
+
+pdeps = []
+foreach plugin : plugins
+    pdeps += library(
+        plugin.replace('.c', ''),
+        plugin,
+        name_prefix: '',
+        version: library_version,
+        dependencies: [libtraceevent_dep],
+        include_directories: [incdir],
+        install: true,
+        install_dir: plugindir)
+endforeach
+
+# perf needs the exported symbol list
+dynamic_list_file = find_program('dynamic_list.sh')
+custom_target(
+    'dynamic_list',
+    depends: pdeps,
+    input: pdeps,
+    output: 'libtraceevent-dynamic-list',
+    command: [dynamic_list_file, '@INPUT@'],
+    capture: true,
+    build_by_default: true,
+    install: true,
+    install_dir: plugindir)
diff --git a/samples/meson.build b/samples/meson.build
new file mode 100644
index 000000000000..827d044c8720
--- /dev/null
+++ b/samples/meson.build
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+executable(
+    'test-event',
+    ['test-event.c'],
+    dependencies: libtraceevent_dep,
+    include_directories: [incdir]
+)
+
diff --git a/src/meson.build b/src/meson.build
new file mode 100644
index 000000000000..d9c0bd315735
--- /dev/null
+++ b/src/meson.build
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+sources= [
+   'event-parse-api.c',
+   'event-parse.c',
+   'event-plugin.c',
+   'kbuffer-parse.c',
+   'parse-filter.c',
+   'parse-utils.c',
+   'tep_strerror.c',
+   'trace-seq.c',
+]
+
+libtraceevent = library(
+    'traceevent',
+    sources,
+    version: library_version,
+    include_directories: [incdir],
+    install: true,
+)
+
+pkg = import('pkgconfig')
+pkg.generate(libtraceevent,
+    subdirs: 'traceevent',
+    filebase: meson.project_name(),
+    name: meson.project_name(),
+    version: meson.project_version(),
+    description: 'Manage trace event',
+    url: 'https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/',
+)
+
+libtraceevent_dep = declare_dependency(
+    include_directories: ['.'],
+    link_with: libtraceevent,
+)
diff --git a/utest/meson.build b/utest/meson.build
new file mode 100644
index 000000000000..06eb887e35e6
--- /dev/null
+++ b/utest/meson.build
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+source = [
+    'trace-utest.c',
+    'traceevent-utest.c',
+]
+
+e = executable(
+   'trace-utest',
+   source,
+   include_directories: [incdir],
+   dependencies: [libtraceevent_dep, cunit_dep])
+
+test('trace-utest', e)
-- 
2.39.0

