Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87283C56202
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F482173E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qyBlJncR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgKZH1M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgKZH1M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 02:27:12 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ACFC0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:10 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id s8so981601wrw.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Llu2Skm02HiDX4FSNXvE4g1GDhZi4n3F9/6+Mqhmm6k=;
        b=qyBlJncRLgHzHLG3n3wn6OJ2Z2U5sjXQHXtPY/IrSGx9hxelw6cx6y923H4UoqqCiM
         6XGMGdos1rivrUyXMuvDhftLHwN3JEPiPpurNDiqyK1qhzvba8njeVUb0DxQdxGvo7Yr
         y3yd+SNgYznnbwdFdIZwOmcw7V5xAAaivc0o/SqRdCu+7CJ/4k9CPDE3rpwJo+mnBWq1
         KcGnT2wViOQqo1p4u8SSa6cWG9dEh+KjVXAE2yzN3+jBwDo6OvVgIX1c1ASYMaVrJHnP
         IivmlXbAgJBN0oMw2npQsoUaD8ur+4PM8dnCRIKaImd1h06fKM/21CznJT+rguUifSya
         D3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Llu2Skm02HiDX4FSNXvE4g1GDhZi4n3F9/6+Mqhmm6k=;
        b=mc51YZqIHFUo+0f/vhGt62aH6AmdhCyMV1xi8vhPZC2z5Nb9HU0fgjd2zcG+eJZLCj
         sXGR69ILt4UGXVQ+WQNSHISxOj5ujALf5VaZXyqY/F8f6U7DP7IZ0HAT7Cemebd7I3gl
         HlPfddNra3Sv0umRQUjvsWw982msG7XJTZ1IDdGW3HtZu6Yt3lQuuOJ9gdJm4E6GToXc
         pgp9SWVy0cANN1esLMLx+GHx0JMh9WfM9DIV8tFWCm6tl4mVwvlR+78DlHLN85UrJIhq
         /o4pCmyDyDBVK7rnj/RBHBE3I5ZNPqVPGp3jXS44eyllAeTHhusDCzROFq6yfR4Drkps
         h9kg==
X-Gm-Message-State: AOAM532HYq/t8pdY5C+m73VtS5a9UWJhLEcN0EkzoKJwCb/SRJvHAxQ5
        Ros2PxOUGHTmGNuXmUlXzh+i3gRzCKstk7hU
X-Google-Smtp-Source: ABdhPJx/dKwJhhie7sIbkRXm00YfFw0mtmITZvM0XpaGsktzi0i7vjnFsFsQqWlW2UotilnKRfaYQA==
X-Received: by 2002:a5d:4b09:: with SMTP id v9mr2089925wrq.394.1606375629680;
        Wed, 25 Nov 2020 23:27:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n10sm7468481wrv.77.2020.11.25.23.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 23:27:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Use system trace libraries, if available
Date:   Thu, 26 Nov 2020 09:27:07 +0200
Message-Id: <20201126072707.906347-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Check if libtraceevent and libtracefs are installed in the system and
use them, otherwise build and use the local implementations.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                | 40 ++++++++++++++++++++++++++++------------
 lib/traceevent/Makefile |  2 ++
 lib/tracefs/Makefile    |  2 ++
 tracecmd/Makefile       |  6 ++++--
 4 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 8626b91b..c6cdeeae 100644
--- a/Makefile
+++ b/Makefile
@@ -191,6 +191,8 @@ export prefix bindir src obj kshark-dir
 
 LIBS = -ldl
 
+
+LIBTRACEEVENT=libtraceevent
 LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
 LIBTRACEEVENT_STATIC = $(LIBTRACEEVENT_DIR)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
@@ -199,35 +201,48 @@ LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
 LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
 LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
 
+LIBTRACEFS=libtracefs
 LIBTRACEFS_DIR = $(obj)/lib/tracefs
 LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
 LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so
 
-TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd		\
-	     -L$(LIBTRACEEVENT_DIR) -ltraceevent	\
-	     -L$(LIBTRACEFS_DIR) -ltracefs
+ifeq ($(shell sh -c "pkg-config --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y"), y)
+LIBTRACEEVENT_CFLAGS = $(shell sh -c "pkg-config --cflags $(LIBTRACEEVENT)")
+LIBTRACEEVENT_LDLAGS = $(shell sh -c "pkg-config --libs $(LIBTRACEEVENT)")
+else
+LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
+LIBTRACEEVENT_LDLAGS = -L$(LIBTRACEEVENT_DIR) -ltraceevent
+LIBTRACEEVENT_STATIC_BUILD = $(LIBTRACEEVENT_STATIC)
+endif
+
+ifeq ($(shell sh -c "pkg-config --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y"), y)
+LIBTRACEFS_CFLAGS = $(shell sh -c "pkg-config --cflags $(LIBTRACEFS)")
+LIBTRACEFS_LDLAGS = $(shell sh -c "pkg-config --libs $(LIBTRACEFS)")
+else
+LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs
+LIBTRACEFS_LDLAGS = -L$(LIBTRACEFS_DIR) -ltracefs
+LIBTRACEFS_STATIC_BUILD = $(LIBTRACEFS_STATIC)
+endif
+
+
+TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd	\
+	     $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
 
 export LIBS TRACE_LIBS
 export LIBTRACEEVENT_DIR LIBTRACECMD_DIR LIBTRACEFS_DIR
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
-export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
-export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
-
 export Q SILENT VERBOSE EXT
 
 # Include the utils
 include scripts/utils.mk
 
 INCLUDES = -I$(src)/include -I$(src)/../../include
-INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
-INCLUDES += -I$(src)/include/tracefs
-INCLUDES += -I$(src)/lib/traceevent/include
 INCLUDES += -I$(src)/lib/trace-cmd/include
 INCLUDES += -I$(src)/lib/trace-cmd/include/private
-INCLUDES += -I$(src)/lib/tracefs/include
 INCLUDES += -I$(src)/tracecmd/include
-INCLUDES += -I$(obj)/tracecmd/include
+INCLUDES += $(LIBTRACEEVENT_CFLAGS)
+INCLUDES += $(LIBTRACEFS_CFLAGS)
 
 include $(src)/features.mk
 
@@ -288,6 +303,7 @@ CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 #    Default we just build trace-cmd
 #
 #    If you want kernelshark, then do:  make gui
+#    If you want all libraries, then do: make libs
 ###
 
 all: all_cmd plugins show_gui_make
@@ -309,7 +325,7 @@ gui: force
 	@echo "gui build complete"
 	@echo "  kernelshark located at $(kshark-dir)/bin"
 
-trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC) \
+trace-cmd: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC_BUILD) \
 	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index d0666911..c7f7cda0 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -6,6 +6,8 @@ bdir:=$(obj)/lib/traceevent
 
 DEFAULT_TARGET = $(bdir)/libtraceevent.a
 
+CFLAGS += -I$(bdir)/include
+
 OBJS =
 OBJS += event-parse.o
 OBJS += event-plugin.o
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index cbcce362..89519517 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -6,6 +6,8 @@ bdir:=$(obj)/lib/tracefs
 
 DEFAULT_TARGET = $(bdir)/libtracefs.a
 
+CFLAGS += -I$(bdir)/include
+
 OBJS =
 OBJS += tracefs-utils.o
 OBJS += tracefs-instance.o
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 01f36c61..de14176e 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -11,6 +11,8 @@ TARGETS = $(bdir)/trace-cmd $(TC_VERSION)
 BUILDGUI := 0
 include $(src)/scripts/utils.mk
 
+CFLAGS += -I$(bdir)/include
+
 TRACE_CMD_OBJS =
 TRACE_CMD_OBJS += trace-cmd.o
 TRACE_CMD_OBJS += trace-record.o
@@ -47,7 +49,7 @@ all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
-CONFIG_LIBS	= -lrt -lpthread
+CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS)
 CONFIG_FLAGS	=
 
 all: $(TARGETS)
@@ -67,7 +69,7 @@ $(all_objs): | $(bdir)
 $(bdir)/trace-cmd: $(ALL_OBJS)
 	$(Q)$(do_app_build)
 
-$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC)
+$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC)
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
-- 
2.28.0

