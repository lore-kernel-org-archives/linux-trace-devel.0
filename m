Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA30BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B78226101B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhIMMwF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhIMMwE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:52:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g128so2136600wma.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w07ei+vuellAhsrpRQKM7ECaOSyrjL1xjJLvVhkLfpg=;
        b=DbK3ASlCFry+hUXZoMIhP7+tgDeyZakbIVWsPTvOui/HYKd3o+z9YDLQzWXsRLs+C3
         IRB3mJ9c+RYTAEKZcvOxHO/mLaBAeO/k4Vp38RCQDDlnfgplcs2LpLvhgHdYe1Cjdgtm
         2WYrgwzeIPFfxAdlUIOdiG+xp/fIG3FtA5PxYR6TuM0NTzM1rI1BrdJENFxh1MMqbKAv
         LPsKqpx97L2jm27ZaSv6Ib4n/whFPYVUKuHBxkzg6BR8K6to/KEUhkyASZQlMor3ynEN
         a0zKbjZDtPlH35T703NX7pmMPhaLfW8Z5mg+QuEC5X+jxsJCtX3epBMnc8R9wkqJ7m7s
         Nm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w07ei+vuellAhsrpRQKM7ECaOSyrjL1xjJLvVhkLfpg=;
        b=Mh7ASr5jWA0Oo5ASPaO8u8+3ykIP8tefKQzHLA6JB1AqOj2f4U8RVUimNXRudMzJQC
         BFtUE7WqGZJiS3Ari/z74p4hZ16baofdVhSTNip/ofjDA7sjHCe3UuAgc5z3WyjFcSBT
         T7OirE/e1mMiJH9+xqE23Vcf1WqB09zCPeGgSW+ckofEdzLd5COjj3EWdQS2E2sunPPT
         yFErTE20UI3xoR5xPyDm9V1G/S3Ix/fMVnYPKnLXwwnFtuNCXw3DhAT5SUybu+rvmQZ8
         IbCEc6Z/VTLbBjBKlJYMYPF4tzWypxYXBap5VLYLxa9XrB1Xf/9qWuLqFORenC4CyGLC
         Mh8Q==
X-Gm-Message-State: AOAM530Mrqwtr7n8mU8FMz4qhVD0YHe2k4JtNpzILP8gfxu8jQN6lBl4
        A6oepwZtB/UR1aqZBU8ve6du22OWioA=
X-Google-Smtp-Source: ABdhPJwzP2m6cR3GYvo08lFITUYQRQ6FO4oooVEW4FTPOdn+hkm0gAel5xTCI3PNDZoNzes6yI0TNg==
X-Received: by 2002:a05:600c:4f85:: with SMTP id n5mr10858464wmq.1.1631537446901;
        Mon, 13 Sep 2021 05:50:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/10] trace-cmd dump: Dump sections
Date:   Mon, 13 Sep 2021 15:50:35 +0300
Message-Id: <20210913125039.3680986-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
References: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, headers are stored as sections. This allows
their position in the file not to be fixed. Pointers to these sections are
stored as trace options. Add logic to handle these new options:
 HEADER_INFO
 FTRACE_EVENTS
 EVENT_FORMATS
 KALLSYM
 PRINTK
 CMDLINES

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index c44870c4..3394847c 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -668,6 +668,24 @@ void dump_option_tsc2nsec(int fd, int size)
 	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
 }
 
+static void dump_option_section(int fd, unsigned int size,
+				unsigned short id, char *desc, enum dump_items v)
+{
+	struct file_section *sec;
+
+	sec = calloc(1, sizeof(struct file_section));
+	if (!sec)
+		die("cannot allocate new section");
+	sec->next = sections;
+	sections = sec;
+	sec->id = id;
+	sec->verbosity = v;
+	if (read_file_number(fd, &sec->offset, 8))
+		die("cannot read the option %d offset", id);
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes]\n", desc, size);
+	do_print(OPTIONS, "%lld\n", sec->offset);
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -756,6 +774,25 @@ static int dump_options_read(int fd)
 		case TRACECMD_OPTION_TSC2NSEC:
 			dump_option_tsc2nsec(fd, size);
 			break;
+		case TRACECMD_OPTION_HEADER_INFO:
+			dump_option_section(fd, size, option, "HEADERS", HEAD_PAGE | HEAD_EVENT);
+			break;
+		case TRACECMD_OPTION_FTRACE_EVENTS:
+			dump_option_section(fd, size, option, "FTRACE EVENTS", FTRACE_FORMAT);
+			break;
+		case TRACECMD_OPTION_EVENT_FORMATS:
+			dump_option_section(fd, size, option,
+					    "EVENT FORMATS", EVENT_SYSTEMS | EVENT_FORMAT);
+			break;
+		case TRACECMD_OPTION_KALLSYMS:
+			dump_option_section(fd, size, option, "KALLSYMS", KALLSYMS);
+			break;
+		case TRACECMD_OPTION_PRINTK:
+			dump_option_section(fd, size, option, "PRINTK", TRACE_PRINTK);
+			break;
+		case TRACECMD_OPTION_CMDLINES:
+			dump_option_section(fd, size, option, "CMDLINES", CMDLINES);
+			break;
 		case TRACECMD_OPTION_DONE:
 			uncompress_reset();
 			count += dump_option_done(fd, size);
-- 
2.31.1

