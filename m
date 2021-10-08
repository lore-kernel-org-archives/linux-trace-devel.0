Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DA4C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CCBA61073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhJHE3I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbhJHE3F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:05 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14227C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:11 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z20so30961388edc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w07ei+vuellAhsrpRQKM7ECaOSyrjL1xjJLvVhkLfpg=;
        b=SrsqerFf1zqTbTupf4S35TH33cxQ5hh/FwdM3Mq7zcgndr2k3OFRMAx4Lfp5edLCoi
         PiMIJZ8qDepFg7C5VE0ZL1jH+EFxHtu6FpnYJ+yuwtodkQYjgaDo0MdsRIRpi1kiFm2T
         qfR/prKZ/3u3m8fbxrtSBSXvAyCAS25GVyfrezkocHeZsehmI2qo1mpyHORI6LgdvQFi
         bdfeSm8PbOZ05u9ON6sy7gqqmYT6yEWZerBBuXeL/SL5N3flDm1KeosPHq1WbSeZGPpb
         vUkLUyr7sySY+omVzsM7hqZencackst0fpYMtcDK1D1mUIyZHp+e/cKMv8mDnRTCrezR
         uC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w07ei+vuellAhsrpRQKM7ECaOSyrjL1xjJLvVhkLfpg=;
        b=GZadYQp/Ga4hNblY1Nm4elyP/Hz5ZC+NY4GGYKlVmt/mfjmrS6RlI7OQ18MUZAoo3T
         qu28Vj4w7dksXcsmLdurjIZ71lmNU9i0GTPnKpk6q3NI/3MmTobBXtQpc/n+nh+8x9DZ
         D2nDuGrtSdXr6viIu8f/NePHdLNk/ENPDBaewEdAaVKf6df+soc5QWUDq5thmtXkdAfM
         QI+YQOzcsQ/l3uAJ8XJco8hb6a0XH7FDd7zxbwf+5ABUXwetca6QeZq6NCfjMzkhtrjv
         js4U3a8dRLBbrrdSk7FG7VJ8J90t2x8ByBQFF2QUlV4CdT+Vn/GinS4IbMnbfQFgW2XD
         OP1Q==
X-Gm-Message-State: AOAM531Gygkuwfr6V9Uos6nRePqP4BlQTnfcIFu78RsKJcKIRGpTjZaU
        XsBpddt/tZOzoLex3WhHdOyiEdZwhRokDw==
X-Google-Smtp-Source: ABdhPJwCbZvWXZkc0l2Ebi3z6FLjTitczCof7iRmMW8WeV4rTubd3yIUgmSqf4Uz06KMq0LC0Ltpig==
X-Received: by 2002:a05:6402:485:: with SMTP id k5mr11669761edv.257.1633667229740;
        Thu, 07 Oct 2021 21:27:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 06/10] trace-cmd dump: Dump sections
Date:   Fri,  8 Oct 2021 07:26:57 +0300
Message-Id: <20211008042701.979075-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
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

