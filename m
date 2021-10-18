Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B15FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 630C760FC2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhJRQvm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 12:51:42 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:60602 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233887AbhJRQv2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 12:51:28 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-CDEcwjRuOlCQUYT6uyO26w-1; Mon, 18 Oct 2021 12:49:13 -0400
X-MC-Unique: CDEcwjRuOlCQUYT6uyO26w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5015918125C2;
        Mon, 18 Oct 2021 16:49:12 +0000 (UTC)
Received: from x1.com (unknown [10.22.18.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D47410016F4;
        Mon, 18 Oct 2021 16:49:08 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 06/19] rtla: Real-Time Linux Analysis tool
Date:   Mon, 18 Oct 2021 18:48:19 +0200
Message-Id: <65fbb9b508a2c1803bacfe255c1d568eb8f4ba4f.1634574261.git.bristot@kernel.org>
In-Reply-To: <cover.1634574261.git.bristot@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The rtla is a meta-tool that includes a set of commands that aims
to analyze the real-time properties of Linux. But instead of testing
Linux as a black box, rtla leverages kernel tracing capabilities to
provide precise information about the properties and root causes of
unexpected results.

rtla --help works and provide information about the available options.

This is just the "main" and the Makefile, no function yet.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/Makefile   | 59 ++++++++++++++++++++++++++++
 tools/tracing/rtla/src/rtla.c | 72 +++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+)
 create mode 100644 tools/tracing/rtla/Makefile
 create mode 100644 tools/tracing/rtla/src/rtla.c

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
new file mode 100644
index 000000000000..b3ddd5138829
--- /dev/null
+++ b/tools/tracing/rtla/Makefile
@@ -0,0 +1,59 @@
+NAME	:=	rtla
+VERSION	:=	0.1
+
+INSTALL	=	install
+CC	:=	gcc
+FOPTS	:=	-flto=auto -ffat-lto-objects -fexceptions -fstack-protector-strong \
+		-fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection
+MOPTS	:=	-m64 -mtune=generic
+WOPTS	:= 	-Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
+
+TRACEFS_HEADERS		:= $$(pkg-config --cflags libtracefs)
+
+CFLAGS	:=	-O -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(TRACEFS_HEADERS)
+LDFLAGS	:=	-ggdb
+LIBS	:=	-ltracefs -ltraceevent -lpthread -lprocps
+
+SRC	:=	$(wildcard src/*.c)
+HDR	:=	$(wildcard src/*.h)
+OBJ	:=	$(SRC:.c=.o)
+DIRS	:=	src
+FILES	:=	Makefile
+CEXT	:=	bz2
+TARBALL	:=	$(NAME)-$(VERSION).tar.$(CEXT)
+TAROPTS	:=	-cvjf $(TARBALL)
+BINDIR	:=	/usr/bin
+DATADIR	:=	/usr/share
+DOCDIR	:=	$(DATADIR)/doc
+MANDIR	:=	$(DATADIR)/man
+LICDIR	:=	$(DATADIR)/licenses
+
+.PHONY:	all tests
+
+all:	rtla
+
+rtla: $(OBJ)
+	$(CC) -o rtla $(LDFLAGS) $(OBJ) $(LIBS)
+
+static: $(OBJ)
+	$(CC) -o rtla-static $(LDFLAGS) --static $(OBJ) $(LIBS) -lpthread -ldl
+
+.PHONY: install
+install:
+	$(INSTALL) rtla -m 755 $(DESTDIR)$(BINDIR)
+	@test ! -f $(DESTDIR)$(BINDIR)/osnoise || rm $(DESTDIR)$(BINDIR)/osnoise
+	ln -s $(DESTDIR)$(BINDIR)/rtla $(DESTDIR)$(BINDIR)/osnoise
+
+.PHONY: clean tarball push
+clean:
+	@test ! -f rtla || rm rtla
+	@test ! -f rtla-static || rm rtla-static
+	@test ! -f src/rtla.o || rm src/rtla.o
+	@test ! -f $(TARBALL) || rm -f $(TARBALL)
+	@rm -rf *~ $(OBJ) *.tar.$(CEXT)
+
+tarball:  clean
+	rm -rf $(NAME)-$(VERSION) && mkdir $(NAME)-$(VERSION)
+	cp -r $(DIRS) $(FILES) $(NAME)-$(VERSION)
+	tar $(TAROPTS) --exclude='*~' $(NAME)-$(VERSION)
+	rm -rf $(NAME)-$(VERSION)
diff --git a/tools/tracing/rtla/src/rtla.c b/tools/tracing/rtla/src/rtla.c
new file mode 100644
index 000000000000..5ae2664ed47d
--- /dev/null
+++ b/tools/tracing/rtla/src/rtla.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Red Hat Inc, Daniel Bristot de Oliveira <bristot@kernel.org>
+ */
+
+#include <getopt.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+
+/*
+ * rtla_usage - print rtla usage
+ */
+static void rtla_usage(void)
+{
+	int i;
+
+	static const char *msg[] = {
+		"",
+		"rtla version " VERSION,
+		"",
+		"  usage: rtla COMMAND ...",
+		"",
+		"  commands:",
+		"",
+		NULL,
+	};
+
+	for (i = 0; msg[i]; i++)
+		fprintf(stderr, "%s\n", msg[i]);
+	exit(1);
+}
+
+/*
+ * run_command - try to run a rtla tool command
+ *
+ * It returns 0 if it fails. The tool's main will generally not
+ * return as they should call exit().
+ */
+int run_command(int argc, char **argv, int start_position)
+{
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int retval;
+
+	/* is it an alias? */
+	retval = run_command(argc, argv, 0);
+	if (retval)
+		exit(0);
+
+	if (argc < 2)
+		goto usage;
+
+	if (strcmp(argv[1], "-h") == 0) {
+		rtla_usage();
+		exit(0);
+	} else if (strcmp(argv[1], "--help") == 0) {
+		rtla_usage();
+		exit(0);
+	}
+
+	retval = run_command(argc, argv, 1);
+	if (retval)
+		exit(0);
+
+usage:
+	rtla_usage();
+	exit(1);
+}
-- 
2.31.1

