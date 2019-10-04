Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF4FC4CED1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7FB820700
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mb2hpcPS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388244AbfJDNgz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:36:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36365 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388272AbfJDNgz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 09:36:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so7273577wrd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 06:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7HVPvMkHId7shPJR7QSW7ONG80bylQ1cwLiTUhTiNkw=;
        b=mb2hpcPSEGTDOBtb+fLRAV8tJCk27Qf2D203k0FYF0v6sKQduXmZBPoE52KX+oxbYg
         FnvBc2LS9ZkG5sPAFA2Ec7zMnkYaLSgod62OGwWrmXfcbOOFR6cZwX3jGS/WDAnRpobt
         g7F2zxNQx7cg21FKNMuJH77fpelvxt3aIGMwdSAezyCj6RiFqBYgoDUO7M8jDdEwYuD4
         DM1gad/jdITNeEWDH3+tV3J46AfnTCtbIax5pkbStI0BjEyxhJLhF29Ozn1bwnhResT9
         5rwzCphXyOI/ZpcSB8Rx3ioDm3QaH0GefKBgmpovFFWILvpkz7czf9FRLJfEQwr2x0xF
         2QCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7HVPvMkHId7shPJR7QSW7ONG80bylQ1cwLiTUhTiNkw=;
        b=blscOD95XmeiEMcF7cz4hrbESEgoyxXqsMZxGdkrRr0ZvccN9mhkh7IUWkA2TkNL6+
         1FyAIgeV/eXcddyEfnoBMo4BuBleYgsCUXiu9f2wPhyDHdhT4mEeaYfO+tjNGikLNSOD
         efW9lKaGDmv9XRZ4NP+b7svHHhybNVz0lUMz8QGRymOSRVr+59WaZ5MRtkrCtzV+tltB
         4DsQ8o9qg+LR1mBc1Qne6t+OPQJZN2b4suUA8PALDeUvrI9eoqsouOEzEt5sjAQzlMIb
         ZB7owPUbnxitjX2Zxr2o1oZXl+AkeIoBDHxus3t7kIzyEecdtcZPl/sg8p+3BU1AAG4x
         4D6A==
X-Gm-Message-State: APjAAAXgmjqgMiU39BmgMozeCKdQQ3kFg1be2lNUopiAMoui1BYBBbk1
        Jv8WZ4v3oaV3mN76wDHUZp4=
X-Google-Smtp-Source: APXvYqzFH0j5oKzS2twpbQNKUos09NspFyhzAKPnCiLNKOqkwNvimjG1N2lLtbxiHBIDdvb75XafgA==
X-Received: by 2002:a5d:4f8e:: with SMTP id d14mr11708228wru.384.1570196212954;
        Fri, 04 Oct 2019 06:36:52 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7029988wrm.52.2019.10.04.06.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 06:36:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/5] trace-cmd: Rename plugin_python to plugin_python_loader.
Date:   Fri,  4 Oct 2019 16:36:44 +0300
Message-Id: <20191004133647.27759-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004133647.27759-1-tz.stoyanov@gmail.com>
References: <20191004133647.27759-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The plugin_python is renamed to plugin_python_loader, to make
the name more closer to the actual plugin role.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                                               | 10 +---------
 lib/traceevent/plugins/Makefile                        |  6 +++---
 .../{plugin_python.c => plugin_python_loader.c}        |  0
 3 files changed, 4 insertions(+), 12 deletions(-)
 rename lib/traceevent/plugins/{plugin_python.c => plugin_python_loader.c} (100%)

diff --git a/Makefile b/Makefile
index f336f7a..e20eced 100644
--- a/Makefile
+++ b/Makefile
@@ -116,8 +116,7 @@ PYTHON_PKGCONFIG_VERS ?= $(PYTHON_VERS)
 
 # Can build python?
 ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_PKGCONFIG_VERS) > /dev/null 2>&1 && echo y"), y)
-	PYTHON_PLUGINS := plugin_python.so
-	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
+	BUILD_PYTHON := $(PYTHON)
 	BUILD_PYTHON_WORKS := 1
 else
 	BUILD_PYTHON := report_nopythondev
@@ -125,7 +124,6 @@ else
 endif
 endif # NO_PYTHON
 
-export PYTHON_PLUGINS
 export BUILD_PYTHON_WORKS
 export NO_PYTHON
 
@@ -418,12 +416,6 @@ python: $(PYTHON)
 PHONY += python-gui
 python-gui: $(PYTHON_GUI)
 
-PHONY += python-plugin
-python-plugin: $(PYTHON_PLUGINS)
-
-plugin_python.so: force $(obj)/lib/traceevent/plugins/trace_python_dir
-	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $(obj)/lib/traceevent/plugins/plugin_python.so
-
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
 		> ../trace-cmd-$(TRACECMD_VERSION).tar
diff --git a/lib/traceevent/plugins/Makefile b/lib/traceevent/plugins/Makefile
index e0a7566..061d919 100644
--- a/lib/traceevent/plugins/Makefile
+++ b/lib/traceevent/plugins/Makefile
@@ -21,7 +21,7 @@ PLUGIN_OBJS := $(PLUGIN_OBJS:%.o=$(bdir)/%.o)
 PLUGIN_BUILD := $(PLUGIN_OBJS:$(bdir)/%.o=$(bdir)/%.so)
 PLUGINS := $(PLUGIN_BUILD)
 ifndef NO_PYTHON
-PLUGINS += $(bdir)/plugin_python.so
+PLUGINS += $(bdir)/plugin_python_loader.so
 endif
 DEPS := $(PLUGIN_OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
@@ -44,10 +44,10 @@ $(DEPS): $(bdir)/.%.d: %.c
 
 $(PLUGIN_OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
-$(bdir)/plugin_python.o: $(bdir)/%.o : %.c $(bdir)/trace_python_dir
+$(bdir)/plugin_python_loader.o: $(bdir)/%.o : %.c $(bdir)/trace_python_dir
 	$(Q)$(do_compile_python_plugin_obj)
 
-$(bdir)/plugin_python.so: $(bdir)/%.so: $(bdir)/%.o
+$(bdir)/plugin_python_loader.so: $(bdir)/%.so: $(bdir)/%.o
 	$(Q)$(do_python_plugin_build)
 
 PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS))
diff --git a/lib/traceevent/plugins/plugin_python.c b/lib/traceevent/plugins/plugin_python_loader.c
similarity index 100%
rename from lib/traceevent/plugins/plugin_python.c
rename to lib/traceevent/plugins/plugin_python_loader.c
-- 
2.21.0

