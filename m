Return-Path: <SRS0=PpJY=X3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B70ECE58B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483CA21920
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rZWOKf0F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfJBLmB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 07:42:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33215 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfJBLmA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 07:42:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so19287812wrs.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Oct 2019 04:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7HVPvMkHId7shPJR7QSW7ONG80bylQ1cwLiTUhTiNkw=;
        b=rZWOKf0FpyEUWs2dwVsl+aN0TYoJTMZc+Ia8qmYi02WZ7BoMC5edFKkm/jwMkzlwaZ
         fBKqJkm8vapNeZpCE+SKugzvHJoKaxr7KDgxASXQF5WUNNYIZcI1VGsko17yL7H/gWFy
         oYyCajSCNQYcVER5rBA7UiCJ109PrAXlknMccrcF+pnw81+Pz/INv/0Cdq93mCTgBo3C
         yVB5MNV26YTS3MBHrAk77uHNAkNu5hmg4AHhE4EN4UK8URSZ9YttmUcycgUgtyUgUiBJ
         pTeNK4E6a7/a070GJMuV/rGA5GxlOu+wopVeVXr/xGz4GDy6GquzqfwBgaswroP9cZLY
         EqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7HVPvMkHId7shPJR7QSW7ONG80bylQ1cwLiTUhTiNkw=;
        b=Kyxhhr7vUMACdZdTg4orUAjQmiJbNLPZboj1/tkrdKC6h3CIzhpe2J0sArITzoVb0u
         Pu0VLq6fWSjOZW3sNeN7NucqOgiQQpUpfm0c5V6VAmERj3o46yW5jiBsC3AOc1jAQURw
         K6DaEtvQoHeHOcLD/cwkjOrx3oJpXijCSIDx97sawU4+ErCMX0u2M9BWDdQeSt8dD0He
         HUMHsYYJh2mZdYNh1eYid2xU4XXUK0XRn7mWHl4Ia319aM772XrSyNc6Vz2OR9hFs271
         UjHt1kWzj5vVrcnSgq2YXcHyI7oIs6MpKKq4x6HJuwWuH9N7rUOr3cqXctkQ2ht+D7Sb
         JQBg==
X-Gm-Message-State: APjAAAX54MDYG5cIl+GtYn+faOxcWyAvV6Id7jOD6v4u8qfmUfGpd7TM
        AiMsxjIncwR5RHEPyZeDlkIRSAil
X-Google-Smtp-Source: APXvYqwLfQMvS6y0wj/gAOLR5kP2Rf3gQAqVtx2FY4msC2kt6870vSG6phlLNSM8bjZ4+bQRl75urg==
X-Received: by 2002:a5d:69c7:: with SMTP id s7mr2269996wrw.295.1570016517017;
        Wed, 02 Oct 2019 04:41:57 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l4sm3004658wrw.6.2019.10.02.04.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 04:41:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/5] trace-cmd: Rename plugin_python to plugin_python_loader.
Date:   Wed,  2 Oct 2019 14:41:49 +0300
Message-Id: <20191002114152.30048-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002114152.30048-1-tz.stoyanov@gmail.com>
References: <20191002114152.30048-1-tz.stoyanov@gmail.com>
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

