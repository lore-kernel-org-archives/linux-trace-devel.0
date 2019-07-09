Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B7EC73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 14:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9899D20844
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 14:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z6z/Y39T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfGIO0E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 10:26:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40907 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfGIO0E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 10:26:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so14929486wrl.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 07:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SnyLsSkJaJrkRakxgv2ddlfre8PauNYheui+OSBvfPM=;
        b=Z6z/Y39TfA2BFpwAz6Y+1GKgyowzQDX8NQIa02xC0qUHJqqkAD9SUso8Dscq2kv92o
         iF6tdobP/8uKjOM2WTrsxvUznUQJi2E3e0guq4ggN4XtCx8LP1PjwxhwPE9916yP8UBB
         1R2HUvXNfkaNx8o3T8Jn1hbemXYx4KwcYFTXJM+Vr/WT+ah45fx2Op0AmJoHeE0C79qO
         vwoAU5i+1bRpU1xWnvCbcL9caB34ZoB366np0B2ZspM+Vp1c2Fw9zPe+Dh5rtWs0aiIT
         U+5uxBckTY7KbG08gqFLlGtYCr1CAeuYSfBbCu7IkNzOeaT7RcAcNvULDNTRu/5Y5w+i
         +aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SnyLsSkJaJrkRakxgv2ddlfre8PauNYheui+OSBvfPM=;
        b=lfOCalKwLDd7EwCc2SYNjyOjuMqGSKbvRXwYB/XWmr37dc5BtJJ8Q+v3vwskAc0d25
         BXqAH3WZ4vDwPZpKU6H2p8bwOO1UEXDk2OTCEolmuAlcobMVvGV8iC6LGdQOfdNGYIvY
         x4jz/8VKg7XqKfMvwqBiBAolOs/9efMre5BPgFjHxXJxXuzjsw7MSoIWRw89V7TVSXHa
         58Oil51lkYFskKg2XW8FKKNLfevC62osaoF/ibutHIEoS6g5/p17dFeayW+pLWk1l2Vd
         zAy/UmPL2nk0m1DuHqyWzvpT8cu8V+QF24t8Ckc5/V0rRyrpCRHU5mVayaY0z4S02j7O
         0sJA==
X-Gm-Message-State: APjAAAVWg5xIlUN4vFoAoP9Znn2uJzWWk5khoaXAZ1wJrTC84457DS6f
        w24QyN7v0MAabfKqT6erjW9DeQ/H
X-Google-Smtp-Source: APXvYqwXkzVv33LtKy4C97RXZX3kcQRG4GLeefv/ITm8Yg90Y4ly+pj05/RSIrcb4pApO+tVbGQMYQ==
X-Received: by 2002:a5d:498a:: with SMTP id r10mr25900905wrq.28.1562682362229;
        Tue, 09 Jul 2019 07:26:02 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c1sm37671969wrh.1.2019.07.09.07.26.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 07:26:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Clean up python plugin warnings
Date:   Tue,  9 Jul 2019 17:26:00 +0300
Message-Id: <20190709142600.13348-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All trace-cmd APIs (functions, declared in trace-cmd.h) are exposed
automatically at build time as python bindings, using trace-cmd python
plugin. Implementation of those functions is supposed to be in libtracecmd
library. Not all functions, declared in trace-cmd.h are APIs, some of them
are internal and should not be exposed:
 tracecmd_enable_events() is removed from trace-cmd.h, as it heavily depends on
  trace-cmd internals. It is no more exposed as python binding.
Others are implemented in trace-cmd application and cannot be used outside it:
 trace-output.c file is moved from trace-cmd to libtracecmd. All functions
  implemented there are now part of the library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h              |  1 -
 lib/trace-cmd/Makefile                     | 11 ++++++++++-
 {tracecmd => lib/trace-cmd}/trace-output.c |  0
 tracecmd/Makefile                          |  1 -
 4 files changed, 10 insertions(+), 3 deletions(-)
 rename {tracecmd => lib/trace-cmd}/trace-output.c (100%)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6f62ab9..1f2f5bf 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -292,7 +292,6 @@ void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 void tracecmd_filter_pid(int pid, int exclude);
 int tracecmd_add_event(const char *event_str, int stack);
-void tracecmd_enable_events(void);
 void tracecmd_disable_all_tracing(int disable_tracer);
 void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 44c1332..9086eb6 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -4,12 +4,15 @@ include $(src)/scripts/utils.mk
 
 bdir:=$(obj)/lib/trace-cmd
 
-DEFAULT_TARGET = $(bdir)/libtracecmd.a
+TC_VERSION := $(bdir)/include/tc_version.h
+
+DEFAULT_TARGET = $(bdir)/libtracecmd.a $(TC_VERSION)
 
 OBJS =
 OBJS += trace-hash.o
 OBJS += trace-hooks.o
 OBJS += trace-input.o
+OBJS += trace-output.o
 OBJS += trace-recorder.o
 OBJS += trace-util.o
 OBJS += trace-filter-hash.o
@@ -29,6 +32,9 @@ $(bdir):
 $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
+$(TC_VERSION): force | $(bdir)/include
+	$(Q)$(call update_version.h)
+
 $(bdir)/libtracecmd.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
@@ -43,6 +49,8 @@ $(bdir)/trace-util.o: $(obj)/plugins/trace_plugin_dir
 $(DEPS): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
+$(DEPS): $(TC_VERSION)
+
 $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
 dep_includes := $(wildcard $(DEPS))
@@ -54,4 +62,5 @@ endif
 clean:
 	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
 
+force:
 .PHONY: clean
diff --git a/tracecmd/trace-output.c b/lib/trace-cmd/trace-output.c
similarity index 100%
rename from tracecmd/trace-output.c
rename to lib/trace-cmd/trace-output.c
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index bcd437a..6968f83 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -29,7 +29,6 @@ TRACE_CMD_OBJS += trace-restore.o
 TRACE_CMD_OBJS += trace-check-events.o
 TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
-TRACE_CMD_OBJS += trace-output.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-msg.o
 
-- 
2.21.0

