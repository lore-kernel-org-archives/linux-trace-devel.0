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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E24C47404
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B092D222C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="durrgv4P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388376AbfJDNg6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:36:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35824 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbfJDNg6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 09:36:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so7280329wrt.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 06:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GFx24vPKmjI9q3Fl4A5Pvwia71Hjh1qC/tqQN7Bsp48=;
        b=durrgv4PyeVnhiagXpdyrPS7/a/Vu9RM0AvrDJbuUsFKrYv/FIPK/zwFfMF8Xfcpvk
         TfBwdli3nZEXzQnmbyF2wQCHShYWkfDKU/H4vHFnEKhF/7q/opBJ6+Igau3Q74ZbbRCn
         UTIHXatsIfx5nkkQDvPiTFP4XXrvxc9SuqQ9H2U6fdWoog36uJXI8nS9x4bydHxxwjuc
         ebv4CEsKAiTrLkYOm5Q4Xx+IwWBfw4OJg03cYzgZjbftiQ2Zud44Ro2aWb4JhloM+YVL
         yP2XYeiFcjnQe2qGn03ON9016AwU1q2w/2lhUcmUen3KZ+WPNMKBGx4cvPGAs/oVTeap
         c4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GFx24vPKmjI9q3Fl4A5Pvwia71Hjh1qC/tqQN7Bsp48=;
        b=Qj4mFXEbmvtS/raR/WX/alIHMtl8Tgy9i+VX4F7fFpp+soFBe0rAiq7wpkwkPm/36e
         Rk1xt1kVVLOUalIFqfzhCI0pm4nD3Tb0lCqENQKFIzjq0uw6ASOV2200erKOD8bh0UV3
         KHBY0qdDGiYxIwUf79CP75qD0CJHhl80My5dIX/WxtpnzfdpM6cpvGOY/7tmHuLYtGt1
         JKkpbf+EULOPyzBo2qnn+/6MpOo+YQoaK+kM649BsYdzWWkN+eFdoHzg6yxUkzW2Zc1i
         zcQfYJVR7gZFa5ovkxIEOPi1rpoFwKkdJQIO+gPKwjOAdh5PE147WShYuGZFnuanW98j
         kTwg==
X-Gm-Message-State: APjAAAVdubzKPnNAjlcTPy6+jYmC28JyWd3sbARX9++N93cxN65KMQb/
        dsK3LqDr82pA3ulfc0ZNQBw=
X-Google-Smtp-Source: APXvYqx7YlzHAeqDRZGWjroNpg/Py4C7siCq6rxEz1m6uU6FbPeIDSAJbJCVFdtzhUSfMS5tEfzwWQ==
X-Received: by 2002:a5d:51c9:: with SMTP id n9mr6377016wrv.398.1570196215391;
        Fri, 04 Oct 2019 06:36:55 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7029988wrm.52.2019.10.04.06.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 06:36:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 4/5] trace-cmd: Change plugin install directories
Date:   Fri,  4 Oct 2019 16:36:46 +0300
Message-Id: <20191004133647.27759-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004133647.27759-1-tz.stoyanov@gmail.com>
References: <20191004133647.27759-1-tz.stoyanov@gmail.com>
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
 Makefile                        | 16 ++++++++--------
 lib/traceevent/event-plugin.c   |  6 +++---
 lib/traceevent/plugins/Makefile |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index e20eced..cb5b07b 100644
--- a/Makefile
+++ b/Makefile
@@ -56,15 +56,15 @@ export img_install img_install_SQ
 export DESTDIR DESTDIR_SQ
 
 ifeq ($(prefix),$(HOME))
-plugin_dir = $(HOME)/.trace-cmd/plugins
+plugin_traceevent_dir = $(HOME)/.local/lib/traceevent/plugins
 python_dir = $(HOME)/.trace-cmd/python
 var_dir = $(HOME)/.trace-cmd/
 else
-plugin_dir = $(libdir)/trace-cmd/plugins
+plugin_traceevent_dir = $(libdir)/traceevent/plugins
 python_dir ?= $(libdir)/trace-cmd/python
-PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
+PLUGIN_DIR_TRACEEVENT = -DPLUGIN_TRACEEVENT_DIR="$(plugin_traceevent_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
-PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
+PLUGIN_DIR_TRACEEVENT_SQ = '$(subst ','\'',$(PLUGIN_DIR_TRACEEVENT))'
 PYTHON_DIR_SQ = '$(subst ','\'',$(PYTHON_DIR))'
 var_dir = /var
 endif
@@ -72,7 +72,7 @@ endif
 # Shell quotes
 bindir_SQ = $(subst ','\'',$(bindir))
 bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
+plugin_traceevent_dir_SQ = $(subst ','\'',$(plugin_traceevent_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
 
 VAR_DIR = -DVAR_DIR="$(var_dir)"
@@ -85,10 +85,10 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 
 BASH_COMPLETE_DIR ?= /etc/bash_completion.d
 
-export PLUGIN_DIR
+export PLUGIN_DIR_TRACEEVENT
 export PYTHON_DIR
 export PYTHON_DIR_SQ
-export plugin_dir_SQ
+export plugin_traceevent_dir_SQ
 export python_dir_SQ
 export var_dir
 
@@ -239,7 +239,7 @@ LIBS += -laudit
 endif
 
 # Append required CFLAGS
-override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
+override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_TRACEEVENT_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 override LDFLAGS += $(udis86-ldflags)
 
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index b2a30bb..ce9d53c 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -19,7 +19,7 @@
 #include "event-utils.h"
 #include "trace-seq.h"
 
-#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
+#define LOCAL_PLUGIN_DIR ".local/lib/traceevent/plugins/"
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
@@ -557,9 +557,9 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
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
 
diff --git a/lib/traceevent/plugins/Makefile b/lib/traceevent/plugins/Makefile
index 061d919..4050019 100644
--- a/lib/traceevent/plugins/Makefile
+++ b/lib/traceevent/plugins/Makefile
@@ -53,11 +53,11 @@ $(bdir)/plugin_python_loader.so: $(bdir)/%.so: $(bdir)/%.o
 PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS))
 
 $(PLUGINS_INSTALL): $(bdir)/%.install : $(bdir)/%.so force
-	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
+	$(Q)$(call do_install_data,$<,$(plugin_traceevent_dir_SQ))
 
 install_plugins: $(PLUGINS_INSTALL)
 
-# The following targets are necessary to trigger a rebuild when $(PLUGIN_DIR)
+# The following targets are necessary to trigger a rebuild when $(PLUGIN_DIR_TRACEEVENT)
 # and $(PYTHON_DIR) change. Without them, a full clean build would necessary
 # in order to get the binaries updated.
 
-- 
2.21.0

