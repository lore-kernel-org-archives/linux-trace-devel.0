Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E06C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B8120936
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLWEfO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgLWEfO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:35:14 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D80DC0613D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:33 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m5so17293851wrx.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c2Vt0gcY/s1rCKQnQVFkwQO6OAU+C95/f3sNY1H7X3I=;
        b=jOb7WflWVQgrv8kGiTtS4i6lIPXZdYqP+ajWKEsCqc9BOJ4YqcNKGDXoyO7rrmoGR5
         Z2GXz3xKO7os9X6EvRPG5R0Rgjua4ngl4oH7MacqRPZsIO5CRVViRoAhxvXYr+8GSszw
         a+A8fnXy8hqaG1N+RdVEkWkvj9VRd/SDXVxkqgnIhJ7wT8QNyHrBgUXQQvgglGNztgnU
         NFeO0YSw5YkLDkFgc9lU72F2sYnviMQsASU8HPb1X91Z63TIcUR1afFRFx8/CsltOecS
         DExpdw9RxFGPn8sOFXc8liKPbCKsnV/yl2xfvJgK6X2Sjpd+ABsDRsM3cr8WsTZQRMW7
         P8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c2Vt0gcY/s1rCKQnQVFkwQO6OAU+C95/f3sNY1H7X3I=;
        b=rhq2nTI5OlZCaWmMH8nndVZBbBBgKTDqikmwAdM9dbbiAjUdzXtfCO0L7DRaiY37wm
         hiPUkzA/EgdYqf4yDJd/Qvj+2ptF+gXG8N/Q3Q5IrAURvKt0sk82ZTGZUArlwzW44i57
         HnTg5dNPPe6Mu/l2qTJ+Z1xFsZuQjXeDJPs/a27P8WPkZj+pmXKksgdxJG2ug8CCvmDp
         Siih12AQJTcgHUbVwUxGhyOXRvAGFXLvjInmoKTMxag5ALa3+FG57cmO8MVMS3WG+lsz
         52tKLtRET0BjXES892EZtLt007qVtrKlg+To54uoH3y11lmQIzhly4/9BGzR9BBOn600
         KtKw==
X-Gm-Message-State: AOAM531cn6sXt0p/zpYQTZyth15h/jwL/zwzgGpqrHIEndxTrCopnebR
        m1+fFlTe0VpQ4ZQxQq4iUJCNoesVwcG7oVo2
X-Google-Smtp-Source: ABdhPJyoJcGa2ptQACYthVE/lcy7CCFvg2FOku8x2fHIWxD3gOLk9wMIw4Sat8CyuVBMKYyY4emDKw==
X-Received: by 2002:adf:f88d:: with SMTP id u13mr28016590wrp.161.1608698072162;
        Tue, 22 Dec 2020 20:34:32 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm28909095wmj.28.2020.12.22.20.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:34:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/6] trace-cmd: libtracecmd man pages
Date:   Wed, 23 Dec 2020 06:34:24 +0200
Message-Id: <20201223043429.586162-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201223043429.586162-1-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementation of trace-cmd library man pages.
trace-cmd/Documentation directory is reorganized to hold both trace-cmd
application and library man pages, each in its own subdirectory. The
first libtracecmd man page is implemented: "man libtracecmd" with a list
of all library APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/Makefile                        | 97 +++----------------
 Documentation/libtracecmd/Makefile            | 34 +++++++
 Documentation/libtracecmd/libtracecmd.3.txt   | 83 ++++++++++++++++
 Documentation/trace-cmd/Makefile              | 44 +++++++++
 .../trace-cmd-check-events.1.txt              |  0
 .../{ => trace-cmd}/trace-cmd-clear.1.txt     |  0
 .../{ => trace-cmd}/trace-cmd-dump.1.txt      |  0
 .../{ => trace-cmd}/trace-cmd-extract.1.txt   |  0
 .../{ => trace-cmd}/trace-cmd-hist.1.txt      |  0
 .../{ => trace-cmd}/trace-cmd-list.1.txt      |  0
 .../{ => trace-cmd}/trace-cmd-listen.1.txt    |  0
 .../{ => trace-cmd}/trace-cmd-mem.1.txt       |  0
 .../{ => trace-cmd}/trace-cmd-options.1.txt   |  0
 .../{ => trace-cmd}/trace-cmd-profile.1.txt   |  0
 .../{ => trace-cmd}/trace-cmd-record.1.txt    |  0
 .../{ => trace-cmd}/trace-cmd-report.1.txt    |  0
 .../{ => trace-cmd}/trace-cmd-reset.1.txt     |  0
 .../{ => trace-cmd}/trace-cmd-restore.1.txt   |  0
 .../{ => trace-cmd}/trace-cmd-set.1.txt       |  0
 .../{ => trace-cmd}/trace-cmd-show.1.txt      |  0
 .../{ => trace-cmd}/trace-cmd-snapshot.1.txt  |  0
 .../{ => trace-cmd}/trace-cmd-split.1.txt     |  0
 .../{ => trace-cmd}/trace-cmd-stack.1.txt     |  0
 .../{ => trace-cmd}/trace-cmd-start.1.txt     |  0
 .../{ => trace-cmd}/trace-cmd-stat.1.txt      |  0
 .../{ => trace-cmd}/trace-cmd-stop.1.txt      |  0
 .../{ => trace-cmd}/trace-cmd-stream.1.txt    |  0
 Documentation/{ => trace-cmd}/trace-cmd.1.txt |  0
 .../{ => trace-cmd}/trace-cmd.dat.5.txt       |  0
 scripts/utils.mk                              | 42 ++++++++
 30 files changed, 214 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/libtracecmd/Makefile
 create mode 100644 Documentation/libtracecmd/libtracecmd.3.txt
 create mode 100644 Documentation/trace-cmd/Makefile
 rename Documentation/{ => trace-cmd}/trace-cmd-check-events.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-clear.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-dump.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-extract.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-hist.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-list.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-listen.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-mem.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-options.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-profile.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-record.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-report.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-reset.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-restore.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-set.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-show.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-snapshot.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-split.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stack.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-start.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stat.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stop.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stream.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd.1.txt (100%)
 rename Documentation/{ => trace-cmd}/trace-cmd.dat.5.txt (100%)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index f2c32640..8e979ece 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1,48 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
 
-obj := $(obj)/Documentation
-src := $(src)/Documentation
-
-ifeq ($(VERBOSE),1)
-  Q =
-  print_asciidoc =
-  print_xsltproc =
-  print_install =
-  hide_xsltproc_output =
-else
-  Q = @
-  print_asciidoc =		echo '      ASCIIDOC            '`basename $@`;
-  print_xsltproc =		echo '      XSLTPROC            '`basename $@`;
-  print_install =		echo '      INSTALL             '`basename $1`'	to	$(DESTDIR_SQ)'$2;
-  hide_xsltproc_output = 2> /dev/null
-endif
-
-define manpage.xsl
-	if [ -z ${MANPAGE_DOCBOOK_XSL} ]; then 			\
-		echo "*********************************";	\
-		echo "** No docbook.xsl is installed **";	\
-		echo "** Can't make man pages        **";	\
-		echo "*********************************";	\
-		exit 1;						\
-	fi
-endef
-
-do_asciidoc_build =				\
-	($(print_asciidoc)			\
-	 asciidoc -d manpage -b docbook -o $@ $<)
-
-do_xsltproc_build =				\
-	($(print_xsltproc)			\
-	 xsltproc --nonet -o $@ ${MANPAGE_DOCBOOK_XSL} $< $(hide_xsltproc_output))
-
-#
-# asciidoc requires a synopsis, but file format man pages (5) do
-# not require them. This removes it from the file in the final step.
-define remove_synopsis
-	(sed -e '/^\.SH "SYNOPSIS"/,/ignore/d' $1 > $1.tmp;\
-	 mv $1.tmp $1)
-endef
-
-#
 # Most likely a docbook.xsl is already installed on the users system
 # instead of creating a new wheel, lets reuse what's already there.
 #
@@ -50,51 +7,19 @@ FIND_MANPAGE_DOCBOOK_XSL :=  $(shell find /usr -name docbook.xsl 2>/dev/null | g
 
 MANPAGE_DOCBOOK_XSL ?= ${FIND_MANPAGE_DOCBOOK_XSL}
 
-$(obj)/%.xsl: $(src)/%.txt
-	$(Q)mkdir -p $(obj)
-	$(Q)$(do_asciidoc_build)
-
-
-$(obj)/%.1: $(obj)/%.1.xsl
-	@$(call manpage.xsl)
-	$(Q)$(do_xsltproc_build)
-
-$(obj)/%.5: $(obj)/%.5.xsl
-	@$(call manpage.xsl)
-	$(Q)$(do_xsltproc_build)
-	$(Q)$(call remove_synopsis, $@)
-
-TEXT1 = $(wildcard *.1.txt)
-MAN1 = $(patsubst %.1.txt,$(obj)/%.1, ${TEXT1})
-TEXT5 = $(wildcard *.5.txt)
-MAN5 = $(patsubst %.5.txt,$(obj)/%.5, ${TEXT5})
-
-all: $(MAN1) $(MAN5)
-
-# Need to find out how to export a macro instead of
-# copying this from the main Makefile.
-define do_install_data
-	$(print_install)				\
-	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
-	fi;						\
-	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
-endef
+doc_dir:=$(src)/Documentation
 
+export MANPAGE_DOCBOOK_XSL doc_dir
 
-MAN1_INSTALL = $(MAN1:%.1=%.1.install)
-MAN5_INSTALL = $(MAN5:%.5=%.5.install)
+SUBDIR += trace-cmd
+SUBDIR += libtracecmd
 
-$(MAN1_INSTALL): %.1.install : %.1 force
-	$(Q)$(call do_install_data,$<,$(man_dir_SQ)/man1)
-$(MAN5_INSTALL): %.5.install : %.5 force
-	$(Q)$(call do_install_data,$<,$(man_dir_SQ)/man5)
+.PHONY: $(SUBDIR)
 
-install: $(MAN1_INSTALL) $(MAN5_INSTALL)
+all: $(SUBDIR)
+clean: $(SUBDIR)
+install: $(SUBDIR)
 
-clean:
-	(cd $(obj); \
-	 $(RM) *.xml *.xsl *.1 *.5)
+$(SUBDIR):
+	make -C $@ $(MAKECMDGOALS)
 
-.PHONE: force
-force:
diff --git a/Documentation/libtracecmd/Makefile b/Documentation/libtracecmd/Makefile
new file mode 100644
index 00000000..196cac7c
--- /dev/null
+++ b/Documentation/libtracecmd/Makefile
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Include the utils
+include $(src)/scripts/utils.mk
+
+bdir:=$(doc_dir)/libtracecmd
+
+$(bdir)/%.xsl: $(bdir)/%.txt
+	$(Q)mkdir -p $(bdir)
+	$(Q)$(do_asciidoc_build)
+
+
+$(bdir)/%.3: $(bdir)/%.3.xsl
+	@$(call manpage.xsl)
+	$(Q)$(do_xsltproc_build)
+
+TEXT3 = $(wildcard $(bdir)/*.3.txt)
+MAN3 = $(patsubst $(bdir)/%.3.txt,$(bdir)/%.3, ${TEXT3})
+
+all: $(MAN3)
+
+MAN3_INSTALL = $(MAN3:%.3=%.3.install)
+
+$(MAN3_INSTALL): %.3.install : %.3 force
+	$(Q)$(call do_install_docs,$<,$(man_dir_SQ)/man3)
+
+install: $(MAN3_INSTALL)
+
+clean:
+	$(Q)(cd $(bdir); \
+		$(RM) *.xml *.xsl *.3)
+
+.PHONE: force
+force:
diff --git a/Documentation/libtracecmd/libtracecmd.3.txt b/Documentation/libtracecmd/libtracecmd.3.txt
new file mode 100644
index 00000000..f080b04d
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd.3.txt
@@ -0,0 +1,83 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+libtracecmd - trace-cmd library APIs
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+Open and close trace file:
+	struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_);
+	void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
+
+Read tracing records from a trace file:
+	int *tracecmd_init_data*(struct tracecmd_input pass:[*]_handle_);
+	struct tep_record pass:[*]*tracecmd_read_cpu_first*(struct tracecmd_input pass:[*]_handle_, int _cpu_);
+	struct tep_record pass:[*]*tracecmd_read_data*(struct tracecmd_input pass:[*]_handle_, int _cpu_);
+	struct tep_record pass:[*]*tracecmd_read_at*(struct tracecmd_input pass:[*]_handle_, unsigned long long _offset_, int pass:[*]_cpu_);
+	void *tracecmd_free_record*(struct tep_record pass:[*]_record_);
+	struct tep_handle pass:[*]*tracecmd_get_tep*(struct tracecmd_input pass:[*]_handle_);
+
+Read tracing instances from a trace file:
+	int *tracecmd_buffer_instances*(struct tracecmd_input pass:[*]_handle_);
+	const char pass:[*]*tracecmd_buffer_instance_name*(struct tracecmd_input pass:[*]_handle_, int _indx_);
+	struct tracecmd_input pass:[*]*tracecmd_buffer_instance_handle*(struct tracecmd_input pass:[*]_handle_, int _indx_);
+
+Get traceing peer information from a trace file:
+	int *tracecmd_pair_peer*(struct tracecmd_input pass:[*]_handle_, struct tracecmd_input pass:[*]_peer_);
+	void tracecmd_unpair_peer(struct tracecmd_input pass:[*]handle);
+	unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
+	int *tracecmd_get_guest_cpumap*(struct tracecmd_input pass:[*]_handle_, unsigned long long _trace_id_, const char pass:[*]pass:[*]_name_, int pass:[*]_vcpu_count_, const int pass:[*]pass:[*]_cpu_pid_);
+--
+
+DESCRIPTION
+-----------
+The libtracecmd(3) library provides APIs to read, parse and write
+_trace-cmd.dat(5)_ files, recorded with _trace-cmd(1)_ application and containing
+tracing information from ftrace, the official Linux kernel tracer.
+
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-libtracecmd*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_
+_libtracefs(3)_
+_trace-cmd(1)_
+_trace-cmd.dat(5)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracecmd is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/trace-cmd/Makefile b/Documentation/trace-cmd/Makefile
new file mode 100644
index 00000000..3f28d39c
--- /dev/null
+++ b/Documentation/trace-cmd/Makefile
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Include the utils
+include $(src)/scripts/utils.mk
+
+bdir:=$(doc_dir)/trace-cmd
+
+$(bdir)/%.xsl: $(bdir)/%.txt
+	$(Q)mkdir -p $(bdir)
+	$(Q)$(do_asciidoc_build)
+
+
+$(bdir)/%.1: $(bdir)/%.1.xsl
+	@$(call manpage.xsl)
+	$(Q)$(do_xsltproc_build)
+
+$(bdir)/%.5: $(bdir)/%.5.xsl
+	@$(call manpage.xsl)
+	$(Q)$(do_xsltproc_build)
+	$(Q)$(call remove_synopsis, $@)
+
+ TEXT1 = $(wildcard $(bdir)/*.1.txt)
+ MAN1 = $(patsubst $(bdir)/%.1.txt,$(bdir)/%.1, ${TEXT1})
+ TEXT5 = $(wildcard $(bdir)/*.5.txt)
+ MAN5 = $(patsubst $(bdir)/%.5.txt,$(bdir)/%.5, ${TEXT5})
+
+all: $(MAN1) $(MAN5)
+
+MAN1_INSTALL = $(MAN1:%.1=%.1.install)
+MAN5_INSTALL = $(MAN5:%.5=%.5.install)
+
+$(MAN1_INSTALL): %.1.install : %.1 force
+	$(Q)$(call do_install_docs,$<,$(man_dir_SQ)/man1)
+$(MAN5_INSTALL): %.5.install : %.5 force
+	$(Q)$(call do_install_docs,$<,$(man_dir_SQ)/man5)
+
+install: $(MAN1_INSTALL) $(MAN5_INSTALL)
+
+clean:
+	$(Q)(cd $(bdir); \
+		$(RM) *.xml *.xsl *.1 *.5)
+
+.PHONE: force
+force:
diff --git a/Documentation/trace-cmd-check-events.1.txt b/Documentation/trace-cmd/trace-cmd-check-events.1.txt
similarity index 100%
rename from Documentation/trace-cmd-check-events.1.txt
rename to Documentation/trace-cmd/trace-cmd-check-events.1.txt
diff --git a/Documentation/trace-cmd-clear.1.txt b/Documentation/trace-cmd/trace-cmd-clear.1.txt
similarity index 100%
rename from Documentation/trace-cmd-clear.1.txt
rename to Documentation/trace-cmd/trace-cmd-clear.1.txt
diff --git a/Documentation/trace-cmd-dump.1.txt b/Documentation/trace-cmd/trace-cmd-dump.1.txt
similarity index 100%
rename from Documentation/trace-cmd-dump.1.txt
rename to Documentation/trace-cmd/trace-cmd-dump.1.txt
diff --git a/Documentation/trace-cmd-extract.1.txt b/Documentation/trace-cmd/trace-cmd-extract.1.txt
similarity index 100%
rename from Documentation/trace-cmd-extract.1.txt
rename to Documentation/trace-cmd/trace-cmd-extract.1.txt
diff --git a/Documentation/trace-cmd-hist.1.txt b/Documentation/trace-cmd/trace-cmd-hist.1.txt
similarity index 100%
rename from Documentation/trace-cmd-hist.1.txt
rename to Documentation/trace-cmd/trace-cmd-hist.1.txt
diff --git a/Documentation/trace-cmd-list.1.txt b/Documentation/trace-cmd/trace-cmd-list.1.txt
similarity index 100%
rename from Documentation/trace-cmd-list.1.txt
rename to Documentation/trace-cmd/trace-cmd-list.1.txt
diff --git a/Documentation/trace-cmd-listen.1.txt b/Documentation/trace-cmd/trace-cmd-listen.1.txt
similarity index 100%
rename from Documentation/trace-cmd-listen.1.txt
rename to Documentation/trace-cmd/trace-cmd-listen.1.txt
diff --git a/Documentation/trace-cmd-mem.1.txt b/Documentation/trace-cmd/trace-cmd-mem.1.txt
similarity index 100%
rename from Documentation/trace-cmd-mem.1.txt
rename to Documentation/trace-cmd/trace-cmd-mem.1.txt
diff --git a/Documentation/trace-cmd-options.1.txt b/Documentation/trace-cmd/trace-cmd-options.1.txt
similarity index 100%
rename from Documentation/trace-cmd-options.1.txt
rename to Documentation/trace-cmd/trace-cmd-options.1.txt
diff --git a/Documentation/trace-cmd-profile.1.txt b/Documentation/trace-cmd/trace-cmd-profile.1.txt
similarity index 100%
rename from Documentation/trace-cmd-profile.1.txt
rename to Documentation/trace-cmd/trace-cmd-profile.1.txt
diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
similarity index 100%
rename from Documentation/trace-cmd-record.1.txt
rename to Documentation/trace-cmd/trace-cmd-record.1.txt
diff --git a/Documentation/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
similarity index 100%
rename from Documentation/trace-cmd-report.1.txt
rename to Documentation/trace-cmd/trace-cmd-report.1.txt
diff --git a/Documentation/trace-cmd-reset.1.txt b/Documentation/trace-cmd/trace-cmd-reset.1.txt
similarity index 100%
rename from Documentation/trace-cmd-reset.1.txt
rename to Documentation/trace-cmd/trace-cmd-reset.1.txt
diff --git a/Documentation/trace-cmd-restore.1.txt b/Documentation/trace-cmd/trace-cmd-restore.1.txt
similarity index 100%
rename from Documentation/trace-cmd-restore.1.txt
rename to Documentation/trace-cmd/trace-cmd-restore.1.txt
diff --git a/Documentation/trace-cmd-set.1.txt b/Documentation/trace-cmd/trace-cmd-set.1.txt
similarity index 100%
rename from Documentation/trace-cmd-set.1.txt
rename to Documentation/trace-cmd/trace-cmd-set.1.txt
diff --git a/Documentation/trace-cmd-show.1.txt b/Documentation/trace-cmd/trace-cmd-show.1.txt
similarity index 100%
rename from Documentation/trace-cmd-show.1.txt
rename to Documentation/trace-cmd/trace-cmd-show.1.txt
diff --git a/Documentation/trace-cmd-snapshot.1.txt b/Documentation/trace-cmd/trace-cmd-snapshot.1.txt
similarity index 100%
rename from Documentation/trace-cmd-snapshot.1.txt
rename to Documentation/trace-cmd/trace-cmd-snapshot.1.txt
diff --git a/Documentation/trace-cmd-split.1.txt b/Documentation/trace-cmd/trace-cmd-split.1.txt
similarity index 100%
rename from Documentation/trace-cmd-split.1.txt
rename to Documentation/trace-cmd/trace-cmd-split.1.txt
diff --git a/Documentation/trace-cmd-stack.1.txt b/Documentation/trace-cmd/trace-cmd-stack.1.txt
similarity index 100%
rename from Documentation/trace-cmd-stack.1.txt
rename to Documentation/trace-cmd/trace-cmd-stack.1.txt
diff --git a/Documentation/trace-cmd-start.1.txt b/Documentation/trace-cmd/trace-cmd-start.1.txt
similarity index 100%
rename from Documentation/trace-cmd-start.1.txt
rename to Documentation/trace-cmd/trace-cmd-start.1.txt
diff --git a/Documentation/trace-cmd-stat.1.txt b/Documentation/trace-cmd/trace-cmd-stat.1.txt
similarity index 100%
rename from Documentation/trace-cmd-stat.1.txt
rename to Documentation/trace-cmd/trace-cmd-stat.1.txt
diff --git a/Documentation/trace-cmd-stop.1.txt b/Documentation/trace-cmd/trace-cmd-stop.1.txt
similarity index 100%
rename from Documentation/trace-cmd-stop.1.txt
rename to Documentation/trace-cmd/trace-cmd-stop.1.txt
diff --git a/Documentation/trace-cmd-stream.1.txt b/Documentation/trace-cmd/trace-cmd-stream.1.txt
similarity index 100%
rename from Documentation/trace-cmd-stream.1.txt
rename to Documentation/trace-cmd/trace-cmd-stream.1.txt
diff --git a/Documentation/trace-cmd.1.txt b/Documentation/trace-cmd/trace-cmd.1.txt
similarity index 100%
rename from Documentation/trace-cmd.1.txt
rename to Documentation/trace-cmd/trace-cmd.1.txt
diff --git a/Documentation/trace-cmd.dat.5.txt b/Documentation/trace-cmd/trace-cmd.dat.5.txt
similarity index 100%
rename from Documentation/trace-cmd.dat.5.txt
rename to Documentation/trace-cmd/trace-cmd.dat.5.txt
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 03389126..3425d4e8 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -32,6 +32,10 @@ ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_install =
   print_uninstall =
   print_update =
+  print_asciidoc =
+  print_xsltproc =
+  print_install =
+  hide_xsltproc_output =
 else
   print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
   print_app_build =		echo '  $(GUI)BUILD              '$(GOBJ);
@@ -43,6 +47,10 @@ else
   print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
   print_update =		echo '  $(GUI)UPDATE             '$(GOBJ);
   print_uninstall =		echo '  $(GUI)UNINSTALLING $(DESTDIR_SQ)$1';
+  print_asciidoc =		echo '  ASCIIDOC            '`basename $@`;
+  print_xsltproc =		echo '  XSLTPROC            '`basename $@`;
+  print_install =		echo '  INSTALL             '`basename $1`'	to	$(DESTDIR_SQ)'$2;
+  hide_xsltproc_output = 2> /dev/null
 endif
 
 do_fpic_compile =					\
@@ -163,3 +171,37 @@ define do_make_pkgconfig_file
 	sed -i "s|LIB_DIR|$(libdir)|g" ${PKG_CONFIG_FILE}; \
 	sed -i "s|HEADER_DIR|$(includedir)/trace-cmd|g" ${PKG_CONFIG_FILE};
 endef
+
+define manpage.xsl
+	if [ -z ${MANPAGE_DOCBOOK_XSL} ]; then 			\
+		echo "*********************************";	\
+		echo "** No docbook.xsl is installed **";	\
+		echo "** Can't make man pages        **";	\
+		echo "*********************************";	\
+		exit 1;						\
+	fi
+endef
+
+do_asciidoc_build =				\
+	($(print_asciidoc)			\
+	 asciidoc -d manpage -b docbook -o $@ $<)
+
+do_xsltproc_build =				\
+	($(print_xsltproc)			\
+	 xsltproc --nonet -o $@ ${MANPAGE_DOCBOOK_XSL} $< $(hide_xsltproc_output))
+
+#
+# asciidoc requires a synopsis, but file format man pages (5) do
+# not require them. This removes it from the file in the final step.
+define remove_synopsis
+	(sed -e '/^\.SH "SYNOPSIS"/,/ignore/d' $1 > $1.tmp;\
+	 mv $1.tmp $1)
+endef
+
+define do_install_docs
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
+endef
-- 
2.28.0

