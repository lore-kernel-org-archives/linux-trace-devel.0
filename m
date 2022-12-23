Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F451C3DA6E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 10:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLWKPK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 05:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLWKPJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 05:15:09 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CE6A1BD
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 02:15:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 101C4344EE;
        Fri, 23 Dec 2022 10:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671790505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ek/joypSY9KRv7ZDrqCDkoS2s48PXI88C1E3Jr0byY0=;
        b=jM8OEr6rOEn3Bb2IpeF5hJyw52SaMdOrmqqiZJstbSm+LJvi8nIwvhOBqepFv0WCcMYf9J
        UOXFgdA74cHVJuZPt/jP+XixNCNEgnRQks+IkcOlTJKBDahgEyp7orvvOQYgirdWnH3xwH
        CjryoUYpXLfirEhrDHIORL/qQnfW9qY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671790505;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ek/joypSY9KRv7ZDrqCDkoS2s48PXI88C1E3Jr0byY0=;
        b=Mn2BVD9LAnQeT6G6NBef8/a7KGKdLaWdHQoDoIncfXv8nNsxGu+XJib4aEx8BXFBe8RHdW
        fbIYW8tlhAT78BBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00436138E4;
        Fri, 23 Dec 2022 10:15:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 97YLAKl/pWNtBAAAMHmgww
        (envelope-from <dwagner@suse.de>); Fri, 23 Dec 2022 10:15:04 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 2/2] trace-cmd: Add initial support for meson
Date:   Fri, 23 Dec 2022 11:15:02 +0100
Message-Id: <20221223101502.12269-3-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221223101502.12269-1-dwagner@suse.de>
References: <20221223101502.12269-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add support for building the project with meson.

trace-cmd depends on a statically linked libtracecmd
(e.g. trace_perf_open, trace_perf_close, trace_perf_init).

Instead depending libtracecmd to be compiled and installed
separately add libtracecmd directly to trace-cmd build. This
avoids an additional step.

We still are able to build libtracecmd as stand alone project.
The top meson.build file just lives in the lib directory.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 Documentation/trace-cmd/meson.build | 117 +++++++++++++++++++++++++++
 meson.build                         | 119 ++++++++++++++++++++++++++++
 meson_options.txt                   |  23 ++++++
 python/meson.build                  |  40 ++++++++++
 tracecmd/meson.build                |  55 +++++++++++++
 utest/meson.build                   |  25 ++++++
 6 files changed, 379 insertions(+)
 create mode 100644 Documentation/trace-cmd/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 python/meson.build
 create mode 100644 tracecmd/meson.build
 create mode 100644 utest/meson.build

diff --git a/Documentation/trace-cmd/meson.build b/Documentation/trace-cmd/meson.build
new file mode 100644
index 000000000000..85befe080642
--- /dev/null
+++ b/Documentation/trace-cmd/meson.build
@@ -0,0 +1,117 @@
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (c) 2022 Daniel Wagner, SUSE LLC
+
+list_txt = find_program('../list-txt.sh')
+r = run_command(list_txt,
+                meson.current_source_dir() + '/trace-cmd*.txt',
+                check: true)
+sources = r.stdout().strip().split('\n')
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
+foreach src : sources
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
index 000000000000..31f8a101190e
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,119 @@
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
+libtraceevent_dep = dependency('libtraceevent', version: '>= 1.5.0', required: true)
+libtracefs_dep = dependency('libtracefs', version: '>= 1.6.0', required: true)
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
+audit_dep = dependency('audit', required: false)
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
+      '-include', 'lib/trace-cmd/include/private/config.h'
+    ],
+    language : 'c',
+)
+
+incdir = include_directories(['.', 'include'])
+
+# libtracecmd: trace-cmd currently depends on a statically linked
+# libtracecmd.  libtracecmd is sill very strongly coupled with
+# trace-cmd (or the other way around). To reduce the development setup
+# complexity we add some of the 'top meson.build' from libtracecmd and
+# make it simpler to use.
+library_version = '1.3.0'
+libtracecmd_standalone_build = false
+libtracecmd_ext_incdir = include_directories(['include',
+                                              'include/trace-cmd',
+                                              'tracecmd/include'])
+subdir('lib/trace-cmd/include')
+subdir('lib/trace-cmd/include/private')
+subdir('lib/trace-cmd')
+
+# trace-cmd
+subdir('tracecmd')
+subdir('python')
+subdir('utest')
+if get_option('docs-build')
+    subdir('Documentation/trace-cmd')
+endif
diff --git a/meson_options.txt b/meson_options.txt
new file mode 100644
index 000000000000..662b5e35e38d
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,23 @@
+# -*- mode: meson -*-
+# SPDX-License-Identifier: GPL-2.0
+
+option('vsock', type : 'boolean', value : true,
+       description : 'build with vsock support')
+option('ptrace', type : 'boolean', value : true,
+       description : 'build with ptrace support')
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
index 000000000000..b4ccfaba919d
--- /dev/null
+++ b/tracecmd/meson.build
@@ -0,0 +1,55 @@
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
+    dependencies: [libtraceevent_dep,
+                   libtracefs_dep,
+                   zlib_dep,
+                   libzstd_dep,
+                   audit_dep],
+    include_directories: [incdir,
+                          trace_cmd_incdir,
+                          libtracecmd_incdir,
+                          libtracecmd_private_incdir,
+                          libtracecmd_ext_incdir],
+    link_with: [static_libtracecmd],
+    install: true,
+    install_dir: bindir,
+)
diff --git a/utest/meson.build b/utest/meson.build
new file mode 100644
index 000000000000..4f87515f3d1c
--- /dev/null
+++ b/utest/meson.build
@@ -0,0 +1,25 @@
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
+   include_directories: [incdir,
+                         libtracecmd_incdir,
+                         libtracecmd_private_incdir,
+                         libtracecmd_ext_incdir],
+   dependencies: [libtraceevent_dep,
+                  libtracefs_dep,
+                  zlib_dep,
+                  libzstd_dep,
+                  cunit_dep],
+   link_with: [static_libtracecmd],
+)
+
+test('trace-utest', e)
-- 
2.39.0

