Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF40C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 17:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiLURIx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 12:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiLURIv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 12:08:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AA219000
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 09:08:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D688C3FF4D;
        Wed, 21 Dec 2022 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671642527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nsktGZv6Jt2diNjLfysOsst14ARbWqmf7yjYocUcvvQ=;
        b=rdzQjeBBaO9y13Vrhd51V2MDzMWvOyUEQEeSrUvYqx0TKJ1BvokIMsHpyVXDbjDWWsShou
        tsPXsCb0EyABTq+eAhTTZjyECabY66yL7AuQ+gEbbDlqm1A1VfdWTS0s0cjXrti5nfHx6R
        HsQCVMd64BvCg8ntza8EYe5HvZCNhVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671642527;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nsktGZv6Jt2diNjLfysOsst14ARbWqmf7yjYocUcvvQ=;
        b=neAiZPRAiVP9EsQV4lSayuHkx7BHdqCogqqFCSl2BPYdtz0vCHbTjQwEGpmOnSswoXCrZs
        HnHz23vKqeukNMAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C7D6C1390E;
        Wed, 21 Dec 2022 17:08:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id M2rJMJ89o2MfXQAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 21 Dec 2022 17:08:47 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v1 1/2] libtracecmd: Add initial support for meson
Date:   Wed, 21 Dec 2022 18:08:43 +0100
Message-Id: <20221221170844.10977-2-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221221170844.10977-1-dwagner@suse.de>
References: <20221221170844.10977-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add support for building the project with meson.

As libtracecmd lives in the same source tree as trace-cmd, we have
to place the 'top' meson.builld file under lib but we can't reference
it from the root meson.build which controlling the main trace-cmd
build.

This implies we can't access resources/path which are not below the
library's main meson.build directly. Thus, to be able to build the
documentation we have to use the symlink as workaround.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 Documentation/libtracecmd/list-txt.sh     |   5 +
 Documentation/libtracecmd/meson.build     | 115 ++++++++++++++++++++++
 lib/Documentation                         |   1 +
 lib/meson.build                           | 107 ++++++++++++++++++++
 lib/meson_options.txt                     |  23 +++++
 lib/trace-cmd/include/meson.build         |   5 +
 lib/trace-cmd/include/private/meson.build |  14 +++
 lib/trace-cmd/meson.build                 |  61 ++++++++++++
 8 files changed, 331 insertions(+)
 create mode 100644 Documentation/libtracecmd/list-txt.sh
 create mode 100644 Documentation/libtracecmd/meson.build
 create mode 120000 lib/Documentation
 create mode 100644 lib/meson.build
 create mode 100644 lib/meson_options.txt
 create mode 100644 lib/trace-cmd/include/meson.build
 create mode 100644 lib/trace-cmd/include/private/meson.build
 create mode 100644 lib/trace-cmd/meson.build

diff --git a/Documentation/libtracecmd/list-txt.sh b/Documentation/libtracecmd/list-txt.sh
new file mode 100644
index 000000000000..373e5551ae63
--- /dev/null
+++ b/Documentation/libtracecmd/list-txt.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+TXT_PATH=$1
+
+ls -1 ${TXT_PATH}/libtracecmd-*.txt
diff --git a/Documentation/libtracecmd/meson.build b/Documentation/libtracecmd/meson.build
new file mode 100644
index 000000000000..db7fca01f725
--- /dev/null
+++ b/Documentation/libtracecmd/meson.build
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
diff --git a/lib/Documentation b/lib/Documentation
new file mode 120000
index 000000000000..fb996f28ab31
--- /dev/null
+++ b/lib/Documentation
@@ -0,0 +1 @@
+../Documentation
\ No newline at end of file
diff --git a/lib/meson.build b/lib/meson.build
new file mode 100644
index 000000000000..7de5f565bce1
--- /dev/null
+++ b/lib/meson.build
@@ -0,0 +1,107 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+project(
+    'libtrace-cmd', ['c'],
+    meson_version: '>= 0.50.0',
+    license: 'GPL-2.0',
+    version: '1.3.0',
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
+mandir    = join_paths(prefixdir, get_option('mandir'))
+htmldir   = join_paths(prefixdir, get_option('htmldir'))
+
+library_version = meson.project_version()
+
+conf = configuration_data()
+
+libtraceevent_dep = dependency('libtraceevent', version: '>= 1.7.0', required: true)
+libtracefs_dep = dependency('libtracefs', version: '>= 1.6.3', required: true)
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
+add_project_arguments(
+    [
+      '-D_GNU_SOURCE',
+      '-include', 'trace-cmd/include/private/config.h',
+    ],
+    language : 'c',
+)
+
+trace_cmd_incdir = include_directories(['../include',
+                                        '../include/trace-cmd',
+                                        '../tracecmd/include'])
+
+subdir('trace-cmd/include')
+subdir('trace-cmd/include/private')
+subdir('trace-cmd')
+if get_option('docs-build')
+    custom_target('check-doc',
+                   output: 'dummy',
+                   command : [meson.source_root() + '/../check-manpages.sh',
+                              meson.source_root() + '/../Documentation/libtracecmd'],
+	           build_by_default : true)
+    # subdir() doesn't allow '..' in the path
+    subdir('Documentation/libtracecmd')
+endif
diff --git a/lib/meson_options.txt b/lib/meson_options.txt
new file mode 100644
index 000000000000..5dc031acbf54
--- /dev/null
+++ b/lib/meson_options.txt
@@ -0,0 +1,23 @@
+# -*- mode: meson -*-
+# SPDX-License-Identifier: LGPL-2.1
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
diff --git a/lib/trace-cmd/include/meson.build b/lib/trace-cmd/include/meson.build
new file mode 100644
index 000000000000..e85ba4771b22
--- /dev/null
+++ b/lib/trace-cmd/include/meson.build
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+incdir = include_directories(['.'])
diff --git a/lib/trace-cmd/include/private/meson.build b/lib/trace-cmd/include/private/meson.build
new file mode 100644
index 000000000000..ef4f9b0a5d02
--- /dev/null
+++ b/lib/trace-cmd/include/private/meson.build
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+config_h = configure_file(
+    output: 'config.h',
+    configuration: conf
+)
+
+private_incdir = include_directories(['.'])
+
+config_dep = declare_dependency(
+  include_directories : private_incdir,
+  sources: config_h)
diff --git a/lib/trace-cmd/meson.build b/lib/trace-cmd/meson.build
new file mode 100644
index 000000000000..124ea8e9fa49
--- /dev/null
+++ b/lib/trace-cmd/meson.build
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+sources = [
+    'trace-hash.c',
+    'trace-hooks.c',
+    'trace-input.c',
+    'trace-output.c',
+    'trace-recorder.c',
+    'trace-util.c',
+    'trace-filter-hash.c',
+    'trace-filter.c',
+    'trace-msg.c',
+    'trace-plugin.c',
+    'trace-maps.c',
+    'trace-timesync.c',
+    'trace-timesync-ptp.c',
+    'trace-compress.c',
+    'trace-blk-hack.c',
+    'trace-ftrace.c',
+]
+
+if perf_defined
+    sources += 'trace-perf.c'
+endif
+
+if vsock_defined
+    sources += 'trace-timesync-kvm.c'
+endif
+
+if zlib_dep.found()
+    sources += 'trace-compress-zlib.c'
+endif
+
+if libzstd_dep.found()
+    sources += 'trace-compress-zstd.c'
+endif
+
+libtracecmd = library(
+    'tracecmd',
+    sources,
+    version: library_version,
+    dependencies: [libtraceevent_dep, libtracefs_dep, zlib_dep, libzstd_dep, audit_dep],
+    include_directories: [incdir, private_incdir, trace_cmd_incdir],
+    install: true,
+)
+
+pkg = import('pkgconfig')
+pkg.generate(
+    libtracecmd,
+    filebase: meson.project_name(),
+    name: meson.project_name(),
+    version: meson.project_version(),
+    description: 'Library for creating and reading trace-cmd data files',
+    url: 'https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/'
+)
+
+libtracecmd_dep = declare_dependency(
+    include_directories: ['.'],
+    link_with: libtracecmd,
+)
-- 
2.39.0

