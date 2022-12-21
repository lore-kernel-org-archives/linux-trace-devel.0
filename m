Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F37C10F1B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 17:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiLURIx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 12:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLURIv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 12:08:51 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22F719033
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 09:08:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7AB6D16E2F;
        Wed, 21 Dec 2022 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671642528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YgY7q5U0+Q7ijQo+JSFHzL8xVBx4abpRPMp9TQ8Jme8=;
        b=KQTjGuhdQ4DiINtveCI0PrEVXCGiXchqHZBNAoR0Pm26+iU5AikmPY9+2/w39Wc00/SL82
        a9AhPLVTcKZQ8K1uk+5WdSifdKjPf9KQUZdsaWjM9oEqG1UCYqSk7ILX0uAyeoaCvN/Zq3
        YJt48XPFItX3YMaiZSTzS0YuKgLc3q8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671642528;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YgY7q5U0+Q7ijQo+JSFHzL8xVBx4abpRPMp9TQ8Jme8=;
        b=DW0MQwszZF8QjSyRbfVyZEe8M2X8U/DRnX2GFtMZb9oEcfR6y3jygHZEo0n7DXnloRUbby
        06CwSF/kbUTCk6CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C1101390E;
        Wed, 21 Dec 2022 17:08:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VTRRGqA9o2MhXQAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 21 Dec 2022 17:08:48 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v1 2/2] trace-cmd: Add initial support for meson
Date:   Wed, 21 Dec 2022 18:08:44 +0100
Message-Id: <20221221170844.10977-3-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221221170844.10977-1-dwagner@suse.de>
References: <20221221170844.10977-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add support for building the project with meson.

trace-cmd depends on a statically linked libtracecmd
(e.g. trace_perf_open, trace_perf_close, trace_perf_init).

That means before kicking off the trace-cmd build a statically build
libtracecmd needs to be available:

  cd lib
  meson setup --prefix=/tmp/trace-cmd --default-library=static .build
  meson compile -C .build
  meson install -C .build

then

  cd ..
  export PKG_PATH_PATH=/tmp/trace-cmd/lib64/pkgconfig
  meson setup .build

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 Documentation/trace-cmd/list-txt.sh |   5 ++
 Documentation/trace-cmd/meson.build | 115 ++++++++++++++++++++++++++++
 meson.build                         | 112 +++++++++++++++++++++++++++
 meson_options.txt                   |  25 ++++++
 python/meson.build                  |  40 ++++++++++
 tracecmd/meson.build                |  47 ++++++++++++
 utest/meson.build                   |  18 +++++
 7 files changed, 362 insertions(+)
 create mode 100644 Documentation/trace-cmd/list-txt.sh
 create mode 100644 Documentation/trace-cmd/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 python/meson.build
 create mode 100644 tracecmd/meson.build
 create mode 100644 utest/meson.build

diff --git a/Documentation/trace-cmd/list-txt.sh b/Documentation/trace-cmd/list-txt.sh
new file mode 100644
index 000000000000..e603b536ff8b
--- /dev/null
+++ b/Documentation/trace-cmd/list-txt.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+TXT_PATH=$1
+
+ls -1 ${TXT_PATH}/trace-cmd*.txt
diff --git a/Documentation/trace-cmd/meson.build b/Documentation/trace-cmd/meson.build
new file mode 100644
index 000000000000..2ff4271b4005
--- /dev/null
+++ b/Documentation/trace-cmd/meson.build
@@ -0,0 +1,115 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+list_txt = find_program('list-txt.sh')
+r = run_command(list_txt, meson.current_source_dir(), check: true)
+sources1 = r.stdout().strip().split('\n')
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
+    asciidoc_extra += ['-f', meson.current_source_dir() + '/../asciidoc.conf']
+    asciidoc_html = 'xhtml11'
+
+    r = run_command(asciidoc, '--version', check: true)
+    v = r.stdout().strip()
+    if v.version_compare('>=8.0')
+        asciidoc_extra += ['-a', 'asciidoc7compatible']
+    endif
+endif
+
+manpage_xsl = meson.current_source_dir() + '/../manpage-normal.xsl'
+
+if get_option('docbook-xls-172')
+    asciidoc_extra += ['-a', 'libtraceevent-asciidoc-no-roff']
+    manpage_xsl = meson.current_source_dir() + '/../manpage-1.72.xsl'
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
+    xmlto_extra += ['-m ', meson.current_source_dir() + '/../manpage-bold-literal.xsl']
+endif
+
+if get_option('docbook-suppress-sp')
+    xmlto_extra += ['-m ',  meson.current_source_dir() + '/../manpage-suppress-sp.xsl']
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
+foreach src : sources1
+    # build man pages
+    xml = gen.process(src)
+    custom_target(
+        src.underscorify() + '_man',
+        input: xml,
+        output: '@BASENAME@.1',
+        command: [xmlto,
+                 '-m', manpage_xsl,
+                 'man',
+                 '-o', '@OUTPUT@']
+                 + xmlto_extra
+                 + ['@INPUT@'],
+        install: true,
+        install_dir: join_paths(mandir, 'man1'))
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
diff --git a/meson.build b/meson.build
new file mode 100644
index 000000000000..9ca178a82a5f
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,112 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+project(
+    'trace-cmd', ['c'],
+    meson_version: '>= 0.50.0',
+    license: 'GPL-2.0',
+    version: '3.1.5',
+    default_options: [
+      'c_std=gnu99',
+      'buildtype=release',
+      'prefix=/usr/local',
+      'warning_level=1',
+    ]
+)
+
+cc = meson.get_compiler('c')
+
+prefixdir = get_option('prefix')
+bindir    = join_paths(prefixdir, get_option('bindir'))
+mandir    = join_paths(prefixdir, get_option('mandir'))
+htmldir   = join_paths(prefixdir, get_option('htmldir'))
+
+conf = configuration_data()
+
+libtraceevent_dep = dependency('libtraceevent', version: '>= 1.7.0', required: true)
+libtracefs_dep = dependency('libtracefs', version: '>= 1.6.3', required: true)
+libtracecmd_dep = dependency('libtracecmd', version: '>= 1.3.0', required: true,
+                             static: true)
+
+zlib_dep = dependency('zlib', required: false)
+conf.set('HAVE_ZLIB', zlib_dep.found(), description: 'Is zlib avialable?')
+
+libzstd_dep = dependency('libzstd', version: '>= 1.4.0', required: false)
+conf.set('HAVE_ZSTD', libzstd_dep.found(), description: 'Is libzstd available?')
+
+cunit_dep = dependency('cunit', required : false)
+
+vsock_defined = get_option('vsock') and cc.has_header('linux/vm_sockets.h')
+conf.set('VSOCK', vsock_defined, description: 'Is vsock available?')
+
+perf_defined = cc.has_header('linux/perf_event.h')
+conf.set('PERF', perf_defined, description: 'Is perf available?')
+
+have_ptrace = get_option('ptrace') and cc.compiles(
+    '''
+    #include <stdio.h>
+    #include <sys/ptrace.h>
+
+    int main (void)
+    {
+            int ret;
+            ret = ptrace(PTRACE_ATTACH, 0, NULL, 0);
+            ptrace(PTRACE_TRACEME, 0, NULL, 0);
+            ptrace(PTRACE_GETSIGINFO, 0, NULL, NULL);
+            ptrace(PTRACE_GETEVENTMSG, 0, NULL, NULL);
+            ptrace(PTRACE_SETOPTIONS, NULL, NULL,
+                           PTRACE_O_TRACEFORK |
+                           PTRACE_O_TRACEVFORK |
+                           PTRACE_O_TRACECLONE |
+                           PTRACE_O_TRACEEXIT);
+            ptrace(PTRACE_CONT, NULL, NULL, 0);
+            ptrace(PTRACE_DETACH, 0, NULL, NULL);
+            ptrace(PTRACE_SETOPTIONS, 0, NULL,
+                   PTRACE_O_TRACEFORK |
+                   PTRACE_O_TRACEVFORK |
+                   PTRACE_O_TRACECLONE |
+                   PTRACE_O_TRACEEXIT);
+            return ret;
+    }
+    ''',
+    name: 'ptrace')
+if not have_ptrace
+    conf10.set('NO_PTRACE', true, description: 'Is ptrace missing?')
+    conf.set('WARN_NO_PTRACE', true, description: 'Issue no ptrace warning?')
+endif
+
+audit_dep = dependency('audit', required: get_option('audit'))
+if not audit_dep.found()
+    conf10.set('NO_AUDIT', true, description: 'Is audit missing?')
+    conf.set('WARN_NO_AUDIT', true, description: 'Issue no audit warning?')
+endif
+
+config_h = configure_file(
+    output: 'config.h',
+    configuration: conf
+)
+
+add_project_arguments(
+    [
+      '-D_GNU_SOURCE',
+      '-include', 'config.h',
+    ],
+    language : 'c',
+)
+
+incdir = include_directories(['.', 'include',
+                              'lib/trace-cmd/include',
+                              'lib/trace-cmd/include/private'])
+
+subdir('tracecmd')
+subdir('python')
+subdir('utest')
+if get_option('docs-build')
+    custom_target('check-doc',
+                   output: 'dummy',
+                   command : ['check-manpages.sh',
+                              meson.current_source_dir() + '/Documentation/trace-cmd'],
+	           build_by_default : true)
+    subdir('Documentation/trace-cmd')
+endif
diff --git a/meson_options.txt b/meson_options.txt
new file mode 100644
index 000000000000..808b0d06908d
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,25 @@
+# -*- mode: meson -*-
+# SPDX-License-Identifier: GPL-2.0
+
+option('vsock', type : 'boolean', value : true,
+       description : 'build with vsock support')
+option('ptrace', type : 'boolean', value : true,
+       description : 'build with ptrace support')
+option('audit', type : 'boolean', value : true,
+       description : 'build with audit support')
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
+option('python', type : 'combo', choices : ['auto', 'true', 'false'],
+       description : 'Generate trac-cmd Python bindings')
diff --git a/python/meson.build b/python/meson.build
new file mode 100644
index 000000000000..dab3fab72994
--- /dev/null
+++ b/python/meson.build
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+want_python = get_option('python')
+if want_python != 'false'
+    python3 = import('python').find_installation('python3')
+    py3_dep = python3.dependency(required: want_python == 'true')
+    swig = find_program('swig', required: want_python == 'true')
+    header_found = cc.has_header('Python.h', dependencies: py3_dep)
+    have_python_support = py3_dep.found() and swig.found() and header_found
+else
+    have_python_support = false
+endif
+
+if have_python_support
+    pymod_swig = custom_target(
+        'ctracecmd.py',
+        input:   ['ctracecmd.i'],
+        output:  ['ctracecmd.py', 'ctracecmd_wrap.c'],
+        command: [swig, '-python',
+                  '-I' + meson.current_source_dir() + '/../include/trace-cmd',
+                  '-I' + libtraceevent_dep.get_pkgconfig_variable('prefix') +
+                         '/include/traceevent',
+                  '-o', '@OUTPUT1@', '@INPUT0@'],
+        install: true,
+        install_dir: [python3.get_install_dir(pure: false, subdir: 'trace-cmd'), false],
+    )
+
+    incdir_py = include_directories(['.', '../include/trace-cmd'])
+
+    pyctracecmd_clib = python3.extension_module(
+        '_ctracecmd',
+        pymod_swig[1],
+        dependencies : [libtraceevent_dep, libtracefs_dep, py3_dep],
+        include_directories: [incdir, incdir_py],
+        install: true,
+        subdir: 'trace-cmd',
+    )
+endif
diff --git a/tracecmd/meson.build b/tracecmd/meson.build
new file mode 100644
index 000000000000..4f00445ae74c
--- /dev/null
+++ b/tracecmd/meson.build
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+sources = [
+    'trace-cmd.c',
+    'trace-record.c',
+    'trace-read.c',
+    'trace-split.c',
+    'trace-listen.c',
+    'trace-stack.c',
+    'trace-hist.c',
+    'trace-mem.c',
+    'trace-snapshot.c',
+    'trace-stat.c',
+    'trace-profile.c',
+    'trace-stream.c',
+    'trace-record.c',
+    'trace-restore.c',
+    'trace-check-events.c',
+    'trace-show.c',
+    'trace-list.c',
+    'trace-usage.c',
+    'trace-dump.c',
+    'trace-clear.c',
+    'trace-vm.c',
+    'trace-convert.c',
+    'trace-agent.c',
+    'trace-tsync.c',
+    'trace-setup-guest.c',
+]
+
+if vsock_defined
+    sources += 'trace-vsock.c'
+endif
+
+trace_cmd_incdir = include_directories(['.', 'include'])
+
+executable(
+    'trace-cmd',
+    sources,
+    dependencies: [libtraceevent_dep, libtracefs_dep, libtracecmd_dep,
+                   zlib_dep, libzstd_dep, audit_dep],
+    include_directories: [incdir, trace_cmd_incdir],
+    install: true,
+    install_dir: bindir,
+)
diff --git a/utest/meson.build b/utest/meson.build
new file mode 100644
index 000000000000..d1f3d29d41cf
--- /dev/null
+++ b/utest/meson.build
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+sources = [
+    'tracecmd-utest.c',
+    'trace-utest.c',
+]
+
+e = executable(
+   'trace-utest',
+   sources,
+   include_directories: [incdir],
+   dependencies: [libtraceevent_dep, libtracefs_dep, libtracecmd_dep,
+                  zlib_dep, libzstd_dep, cunit_dep],
+)
+
+test('trace-utest', e)
-- 
2.39.0

