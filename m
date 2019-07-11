Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6D6C74A35
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA78C21019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Viv7bHl1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfGKNDN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36161 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbfGKNDN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so1515999wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LK2U2YDdZFckjZU9BnI9sjrX0+qRsuPGUOo9brKWGok=;
        b=Viv7bHl1KSxOblGUl7yXrEohmrLChG5bPL/3jPcnSM/Q4JUNq4CdOdiSSZ2XlH5w4l
         cirZ0I44CAQnQbl40yGUyWWInlMmDg5c3iVOwcH898+b2yH7yBZeT8kFkntKi+D54Aaa
         dhxs0I2qbrFVT0kVv+IsF9Pmz3Jt3fcTyGHYbiBKgNzuv/jEMLzMsfl15MZQAzxwPuB/
         EJZCovw0MomAD6q+zPCWp2MIVGnOWWQT0DJQTkUnQ7dNXxPLEGqm6C1hBgskzj2v0jy9
         eHAdmgKW8LpTJwF1XxUQ8k53Uv22ga29xlFxj5B5+lD0bvk+uwsYoET7C0E49LCW/Fh3
         Jgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LK2U2YDdZFckjZU9BnI9sjrX0+qRsuPGUOo9brKWGok=;
        b=UHkE63f1M137Z4SqcJ3LAOOJorCCJJpvRwP615CngfGCOYGA+0nbJnAAPRa/MAt+NJ
         2zbRN3CWrwOIEBkYbNmClH+yaetmDR+aVZUznN/XXIDpFALibM3n0Gce8l7lAb8L/h7C
         tLztJAF2oHH8JrPZnrRqX5xn7IwkRA/Djy9zDHtIY+D5xa9yJd4AF5EAefRRk331UVbw
         8M9G2cz8Hx64PiXFfnCroROmS5HDjrOyQ0+iNKkf4v8EFB/UaJ18MjO7+ORIFgUj233I
         euHvCB4gqG3t1soW6ywsYUMYrbXl7bq8orV8HnCdaHrM4W4XG36cVVMphOUicZsvnC13
         hzaQ==
X-Gm-Message-State: APjAAAVTQcPnG0F55zbCzgSxVQ5amWBF2ZweInaexRpjAXgDuR1LXxBb
        5ADlP9ImBVcdDr0M0X4MM2cwu99e
X-Google-Smtp-Source: APXvYqzbG2PY95jFuI8K3SDqrwu6zQtXS/+SE3REiFXAuN6Sf+gzGFruUYmSaf0nlpYTecJUi23vsA==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr4327943wmb.15.1562850191663;
        Thu, 11 Jul 2019 06:03:11 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/7] trace-cmd: Move trace-output.c into the library code
Date:   Thu, 11 Jul 2019 16:03:01 +0300
Message-Id: <20190711130307.25041-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711130307.25041-1-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Functions, implemented in trace-output.c file, do not depend on
trace-cmd application context and can be used standalone. The file
is moved from trace-cmd to libtracecmd. It also fixes a warning
while loading python modules from kernelshark:
ImportError: ctracecmd.so: undefined symbol: tracecmd_append_cpu_data

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                     | 11 ++++++++++-
 {tracecmd => lib/trace-cmd}/trace-output.c |  0
 tracecmd/Makefile                          |  1 -
 3 files changed, 10 insertions(+), 2 deletions(-)
 rename {tracecmd => lib/trace-cmd}/trace-output.c (100%)

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

