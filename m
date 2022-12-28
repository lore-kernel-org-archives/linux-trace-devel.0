Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04F1C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Dec 2022 08:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiL1I3Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Dec 2022 03:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiL1I3M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Dec 2022 03:29:12 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776A1FAE5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Dec 2022 00:29:10 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D986221A38;
        Wed, 28 Dec 2022 08:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672216148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hkQpfmRtZP4ZyiIn/6wA5e/kEg0kM2Jt7qixku8WVHs=;
        b=sruxc9agm4xm8GqQLzVjWJey9F/vgBdmR0I1iCh7yvrQe5lONIhpnGB/NDIGnCS3GajO42
        +uyOr4A1zsbSPN/1TbRxSBIW14tQ0faNjxReaVg9w9VzB6JlpHybIPrsOzo8yGBN7k3sVa
        oARVRfcw32/Xz7B0HZccDsNMRnS3404=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672216148;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hkQpfmRtZP4ZyiIn/6wA5e/kEg0kM2Jt7qixku8WVHs=;
        b=ib2Tcj/9d641GU7X9K9EVe8I/QIo8e7821KjlxCDJgh3mwctbjQ8WgP+37hIHYg+yb1r/9
        +M7YAaC+1G+v/GDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CAAB1134F5;
        Wed, 28 Dec 2022 08:29:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id m/13MVT+q2OOQAAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 28 Dec 2022 08:29:08 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v5] libtraceevent: Add initial support for meson
Date:   Wed, 28 Dec 2022 09:29:06 +0100
Message-Id: <20221228082906.3272-1-dwagner@suse.de>
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

I had to fallback to use a workaround to install the man pages to the
correct directory. Meson insistet to install them into subdirs and
failed to install them when I forced Meson not to do this. I am sure I
am doing something wrong but couldn't figure out what. I think
it's okay to use the workaround until we figured how to do this
'correct'.

Tested this by packaging it up for OpenSUSE and the it looks
reasonable:

https://build.opensuse.org/project/show/home:wagi:branches:devel:tools

v5:
 - build unit test only if CUnit is found
 - default build target is debug
 - do not install man pages into subdirs
 
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


 Documentation/install-man.sh.in |  15 +++
 Documentation/meson.build       | 177 ++++++++++++++++++++++++++++++++
 include/traceevent/meson.build  |  14 +++
 meson.build                     |  55 ++++++++++
 meson_options.txt               |  20 ++++
 plugins/dynamic_list.sh         |  14 +++
 plugins/meson.build             |  44 ++++++++
 samples/meson.build             |  11 ++
 src/meson.build                 |  37 +++++++
 utest/meson.build               |  16 +++
 10 files changed, 403 insertions(+)
 create mode 100755 Documentation/install-man.sh.in
 create mode 100644 Documentation/meson.build
 create mode 100644 include/traceevent/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100755 plugins/dynamic_list.sh
 create mode 100644 plugins/meson.build
 create mode 100644 samples/meson.build
 create mode 100644 src/meson.build
 create mode 100644 utest/meson.build

diff --git a/Documentation/install-man.sh.in b/Documentation/install-man.sh.in
new file mode 100755
index 000000000000..8ab2cb982e1d
--- /dev/null
+++ b/Documentation/install-man.sh.in
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+for man in $(find @SRCDIR@ -name '*\.1' -type f); do
+    [ ! -d ${DESTDIR}/@MANDIR@/man1/ ] && install -d ${DESTDIR}/@MANDIR@/man1/
+
+    echo Installing $man to ${DESTDIR}/@MANDIR@/man1/
+    install -m 0644 $man ${DESTDIR}/@MANDIR@/man1/
+done
+
+for man in $(find @SRCDIR@ -name '*\.3' -type f); do
+    [ ! -d ${DESTDIR}/@MANDIR@/man3/ ] && install -d ${DESTDIR}/@MANDIR@/man3/
+
+    echo Installing $man to ${DESTDIR}/@MANDIR@/man3/
+    install -m 0644 $man ${DESTDIR}/@MANDIR@/man3/
+done
diff --git a/Documentation/meson.build b/Documentation/meson.build
new file mode 100644
index 000000000000..097da50857b3
--- /dev/null
+++ b/Documentation/meson.build
@@ -0,0 +1,177 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+# input text file: man page section
+sources = {
+    'libtraceevent.txt': '3',
+    'libtraceevent-func_apis.txt': '3',
+    'libtraceevent-commands.txt': '3',
+    'libtraceevent-cpus.txt': '3',
+    'libtraceevent-debug.txt': '3',
+    'libtraceevent-endian_read.txt': '3',
+    'libtraceevent-event_find.txt': '3',
+    'libtraceevent-event_get.txt': '3',
+    'libtraceevent-event_list.txt': '3',
+    'libtraceevent-event_print.txt': '3',
+    'libtraceevent-field_find.txt': '3',
+    'libtraceevent-field_get_val.txt': '3',
+    'libtraceevent-field_print.txt': '3',
+    'libtraceevent-field_read.txt': '3',
+    'libtraceevent-fields.txt': '3',
+    'libtraceevent-file_endian.txt': '3',
+    'libtraceevent-filter.txt': '3',
+    'libtraceevent-func_find.txt': '3',
+    'libtraceevent-handle.txt': '3',
+    'libtraceevent-header_page.txt': '3',
+    'libtraceevent-host_endian.txt': '3',
+    'libtraceevent-kbuffer-create.txt': '3',
+    'libtraceevent-kbuffer-read.txt': '3',
+    'libtraceevent-kbuffer-timestamp.txt': '3',
+    'libtraceevent-kvm-plugin.txt': '3',
+    'libtraceevent-log.txt': '3',
+    'libtraceevent-long_size.txt': '3',
+    'libtraceevent-page_size.txt': '3',
+    'libtraceevent-parse_event.txt': '3',
+    'libtraceevent-parse-files.txt': '3',
+    'libtraceevent-parse_head.txt': '3',
+    'libtraceevent-plugins.txt': '3',
+    'libtraceevent-record_parse.txt': '3',
+    'libtraceevent-reg_event_handler.txt': '3',
+    'libtraceevent-reg_print_func.txt': '3',
+    'libtraceevent-set_flag.txt': '3',
+    'libtraceevent-strerror.txt': '3',
+    'libtraceevent-tseq.txt': '3',
+}
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
+foreach txt, section : sources
+    # build man page(s)
+    xml = gen.process(txt)
+    man = custom_target(txt.underscorify() + '_man',
+                        input: xml,
+                        output: '@BASENAME@.' + section,
+                        command: [xmlto,
+                        '-m', manpage_xsl,
+                        'man',
+                        '-o', '@OUTPUT@']
+                        + xmlto_extra
+                        + ['@INPUT@'],
+                        build_by_default : true)
+
+    # build html pages
+    custom_target(
+       txt.underscorify() + '_html',
+       input: txt,
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
+
+# Install path workaround because:
+#
+# - xmlto might generate more than one file and we would to tell meson
+#   about those output files. We could figure out which files are generated
+#   (see sed match in check-manpages.sh).
+#
+# - The man page generation puts all the generated files under sub dirs
+#   and it's not obvious how to tell Meson it should not do this without
+#   causing the install step to fail (confusion where the generated files
+#   are stored)
+#
+# Thus just use a plain old shell script to move the generated files to the
+# right location.
+
+conf = configuration_data()
+conf.set('SRCDIR', meson.current_build_dir())
+conf.set('MANDIR', mandir)
+configure_file(
+    input:         'install-man.sh.in',
+    output:        'install-man.sh',
+    configuration: conf,
+)
+
+meson.add_install_script(
+    join_paths(meson.current_build_dir(), 'install-man.sh'))
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
index 000000000000..54621a6d05c4
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,55 @@
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
+      'buildtype=debug',
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
+if cunit_dep.found()
+    subdir('utest')
+endif
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

