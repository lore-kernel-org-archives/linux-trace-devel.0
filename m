Return-Path: <SRS0=4i+i=V6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727B4C32750
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39DC22087E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pZQnXr4M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbfHBLBP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 07:01:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46350 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbfHBLBP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 07:01:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so76703477wru.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Aug 2019 04:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hBXQStQUH38OFJFxvwv9NxlSSXIMvPmUF30az/v4TqY=;
        b=pZQnXr4MW7veDhVSy8Wq2Wi0Gg5hBAawbdly6L0egTsgZ0u7BgOHG5p6qu5b2d8srD
         2/OH8kzhcBLhmTk/d0ihJzM59oUOaNNOjd4dY6LlrpimAoIfYAZJAyNqnVw02KXCUZQz
         TEX7R6mR/RhEiJjCAuI0q5wu5F2Kml5LPQAzfNkT8Axisu68s+cTTDQ+KJOJDULwuu6Y
         IiOb3lnsGfzf03YvVJ1r44aWC6a5SoOn/v9JDMXJPUV9yfDhJ1bMDlxa+h55XZJHFtlD
         IUdWtN9uzRK2abxNvjBAgqkKo6spilsXbfZZLbKlXBfGdxZDqFiSm20XBrDrUbad4q/2
         fFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hBXQStQUH38OFJFxvwv9NxlSSXIMvPmUF30az/v4TqY=;
        b=BjX8uRX7VKvqyB+0fVnkTA1JgjYB930damsmv7RcCgPIiP/vG6gy1zv6r6/oy6NkC8
         54Mb3dLBMc9nj62SVy5KNTaAJNBMbmxTYBMUV27eCbnvmS31uSGf5lOXqWdWDryJO3MS
         o4z57l98v9yj5GfNVn16/QrkeBwccmwINpSGMWh0KnQQzASL0wTi9SzeLczw7o5alFEM
         qx01uEZw7sSlDmoVelGgkuAZy9dxmTRQiO/u2aig0FWbTldQ1mp6dKRVyM28ammnxQZ1
         PuMfHomhz3hMD8jkKRN+w7WHJ7L1o2C2+faeZQRspndym7/EEKTEBqIYz4rKGU4tH2Lh
         j8XA==
X-Gm-Message-State: APjAAAWWIM6nNbYxc2Y5x5BZqCckfFLQJ5saBnWnz66P6mEd3nhBWBOP
        Ld/7JjmDY7HtFLaH5w2aX1E=
X-Google-Smtp-Source: APXvYqwSeSJTzIhQr077uvV32yoGu2xQSTRw4wGv1XPo4roZmxji3XisruuxlM/mpgydpYmiM8+8pQ==
X-Received: by 2002:adf:e2c1:: with SMTP id d1mr153312274wrj.283.1564743672143;
        Fri, 02 Aug 2019 04:01:12 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm79511433wrj.68.2019.08.02.04.01.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 04:01:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/6] trace-cmd: Change plugin install directories
Date:   Fri,  2 Aug 2019 14:01:01 +0300
Message-Id: <20190802110101.14759-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190802110101.14759-1-tz.stoyanov@gmail.com>
References: <20190802110101.14759-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

To be compliant with XDG user directory layout,
the user's plugin directory is changed from
~/.traceevent/plugins to ~/.local/lib/traceevent/plugins/
Thanks to Patrick McLean:
https://lore.kernel.org/linux-trace-devel/20190313144206.41e75cf8@patrickm/

The system plugin directory is changed from
(install_prefix)/lib/trace-cmd/plugins to (install_prefix)/lib/traceevent/plugins
This change paves the way for implementing trace-cmd specific plugins.

Suggested-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                      | 16 ++++++++--------
 lib/traceevent/event-plugin.c |  6 +++---
 plugins/traceevent/Makefile   |  6 +++---
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 8b228f5..5bfb558 100644
--- a/Makefile
+++ b/Makefile
@@ -59,15 +59,15 @@ export img_install img_install_SQ
 export DESTDIR DESTDIR_SQ
 
 ifeq ($(prefix),$(HOME))
-plugin_dir = $(HOME)/.trace-cmd/plugins
+plugin_traceevent_dir = $(HOME)/.local/lib/traceevent/plugins
 python_dir = $(HOME)/.trace-cmd/python
 var_dir = $(HOME)/.trace-cmd/
 else
-plugin_dir = $(libdir)/trace-cmd/plugins
+plugin_traceevent_dir = $(libdir)/traceevent/plugins
 python_dir = $(libdir)/trace-cmd/python
-PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
+PLUGIN_TRACEEVENT_DIR = -DPLUGIN_DIR="$(plugin_traceevent_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
-PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
+PLUGIN_TRACEEVENT_DIR_SQ = '$(subst ','\'',$(PLUGIN_TRACEEVENT_DIR))'
 PYTHON_DIR_SQ = '$(subst ','\'',$(PYTHON_DIR))'
 var_dir = /var
 endif
@@ -75,7 +75,7 @@ endif
 # Shell quotes
 bindir_SQ = $(subst ','\'',$(bindir))
 bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
+plugin_traceevent_dir_SQ = $(subst ','\'',$(plugin_traceevent_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
 
 VAR_DIR = -DVAR_DIR="$(var_dir)"
@@ -88,10 +88,10 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 
 BASH_COMPLETE_DIR ?= /etc/bash_completion.d
 
-export PLUGIN_DIR
+export PLUGIN_TRACEEVENT_DIR
 export PYTHON_DIR
 export PYTHON_DIR_SQ
-export plugin_dir_SQ
+export plugin_traceevent_dir_SQ
 export python_dir_SQ
 export var_dir
 
@@ -235,7 +235,7 @@ LIBS += -laudit
 endif
 
 # Append required CFLAGS
-override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
+override CFLAGS += $(INCLUDES) $(PLUGIN_TRACEEVENT_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 
 CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index fdaadba..383a8be 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -20,7 +20,7 @@
 #include "event-utils.h"
 #include "trace-seq.h"
 
-#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
+#define LOCAL_PLUGIN_DIR ".local/lib/traceevent/plugins/"
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
@@ -579,9 +579,9 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 	 * If a system plugin directory was defined,
 	 * check that first.
 	 */
-#ifdef PLUGIN_DIR
+#ifdef PLUGIN_TRACEEVENT_DIR
 	if (!tep || !(tep->flags & TEP_DISABLE_SYS_PLUGINS))
-		load_plugins_dir(tep, suffix, PLUGIN_DIR,
+		load_plugins_dir(tep, suffix, PLUGIN_TRACEEVENT_DIR,
 				 load_plugin, data);
 #endif
 
diff --git a/plugins/traceevent/Makefile b/plugins/traceevent/Makefile
index 8ed65d3..98fcc4d 100644
--- a/plugins/traceevent/Makefile
+++ b/plugins/traceevent/Makefile
@@ -53,16 +53,16 @@ $(bdir)/plugin_python.so: $(bdir)/%.so: $(bdir)/%.o
 PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS))
 
 $(PLUGINS_INSTALL): $(bdir)/%.install : $(bdir)/%.so force
-	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
+	$(Q)$(call do_install_data,$<,$(plugin_traceevent_dir_SQ))
 
 install_plugins: $(PLUGINS_INSTALL)
 
-# The following targets are necessary to trigger a rebuild when $(PLUGIN_DIR)
+# The following targets are necessary to trigger a rebuild when $(PLUGIN_TRACEEVENT_DIR)
 # and $(PYTHON_DIR) change. Without them, a full clean build would necessary
 # in order to get the binaries updated.
 
 $(bdir)/traceevent_plugin_dir: $(bdir) force
-	$(Q)$(N)$(call update_dir, 'PLUGIN_DIR=$(PLUGIN_DIR)')
+	$(Q)$(N)$(call update_dir, 'PLUGIN_TRACEEVENT_DIR=$(PLUGIN_TRACEEVENT_DIR)')
 
 $(bdir)/trace_python_dir: $(bdir) force
 	$(Q)$(N)$(call update_dir, 'PYTHON_DIR=$(PYTHON_DIR)')
-- 
2.21.0

