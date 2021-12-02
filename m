Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C12FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346827AbhLBMcl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbhLBMck (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299B6C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id t5so115494825edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5tO/vriOUpiSa2W8k4G1fuBKcjRtAbnryAqq55gN4qY=;
        b=H1DjLbyrjPrlIG7oRTT1l52jsTGC/U5wgwNeAy5qOt5P5toO09s/uvEqEKgglfWjW+
         KLCPK1WDL10tSiL5QV6OQvpwkaohnBJ+HhEI/4DDND1KLpXLganXyi25asEYaMmoICPx
         kWA90xdSCh6mBWGXl1dn6gDps5bC0rxIQ0iHfZyFSDghopYf51fk+bOVFjf9XcFGb/dZ
         8YfdtrQ/dhy6I1sXu1tjoP5NUPGrk++GGrcm2iWIYTaQoji//LDnxW8pOozjtBnLDDs4
         c0NhrNjuayoYji7nH8/k25Dm7qD1liZFfcmUEw7IB2bzcKG063oONotn5jJLHQz0v0dS
         ueKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5tO/vriOUpiSa2W8k4G1fuBKcjRtAbnryAqq55gN4qY=;
        b=162Uuqlq8rOlCSRLebLhbDLjJVNPy4uonL8da45YdjmbfMSxZ/MEOoEC0X4YD0b73s
         xsp8E+pyLrnr0k/RhSQkQYNAHW4220nwUWnwT6cn+q/2T7VPaK8cqUIzU8NcZFPnElWO
         VY0nnAgSRftatId7jDjOdadKZvDZVKhYJKW4ZpcmQ5awIv8tMSJKg+H92W2C2dU+ZNHU
         vvC6DcHQXagCeJssjqY7SoD8n72UJrr/XkK1W+dSxN6T+kFEXA80K/RiRAGPVFEFmUPX
         FyjG4DjP2bo4n2i76YyvQ4uTtL7o3LiGs2qaLROApnOHhY2YpKBYbn8PxV0UW3XlGK+R
         z4Jw==
X-Gm-Message-State: AOAM533t97DqBG0EQn2mEBoagxkjUI84Skr7MxisgTwfEZTg67eXmSAc
        J0r8pld/pXkpH7FykD+rOMB/QDKv4aY9qg==
X-Google-Smtp-Source: ABdhPJxW33jWmBE+r3iWm3oqPTTRTLNTPdbvgGxbkyY7uUCX1+eTTjVvQAhlZyjUSkIPELL5tNNBCw==
X-Received: by 2002:a05:6402:60c:: with SMTP id n12mr17791386edv.17.1638448156738;
        Thu, 02 Dec 2021 04:29:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 08/10] trace-cmd dump: Dump sections content
Date:   Thu,  2 Dec 2021 14:29:05 +0200
Message-Id: <20211202122907.44008-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, dump the content of the headers content, that
are stored as sections. Added logic to dump these headers:
 HEADER_INFO
 FTRACE_EVENTS
 EVENT_FORMATS
 KALLSYM
 PRINTK
 CMDLINES

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 11a6e1df..b2670744 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -731,6 +731,46 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "%lld\n", sec->offset);
 }
 
+static void dump_sections(int fd)
+{
+	struct file_section *sec = sections;
+	unsigned short flags;
+
+	while (sec) {
+		if (lseek64(fd, sec->offset, SEEK_SET) == (off_t)-1)
+			die("cannot goto option offset %lld", sec->offset);
+
+		dump_section_header(fd, sec->verbosity, &flags);
+
+		if ((flags & TRACECMD_SEC_FL_COMPRESS) && uncompress_block())
+			die("cannot uncompress section block");
+
+		switch (sec->id) {
+		case TRACECMD_OPTION_HEADER_INFO:
+			dump_header_page(fd);
+			dump_header_event(fd);
+			break;
+		case TRACECMD_OPTION_FTRACE_EVENTS:
+			dump_ftrace_events_format(fd);
+			break;
+		case TRACECMD_OPTION_EVENT_FORMATS:
+			dump_events_format(fd);
+			break;
+		case TRACECMD_OPTION_KALLSYMS:
+			dump_kallsyms(fd);
+			break;
+		case TRACECMD_OPTION_PRINTK:
+			dump_printk(fd);
+			break;
+		case TRACECMD_OPTION_CMDLINES:
+			dump_cmdlines(fd);
+			break;
+		}
+		uncompress_reset();
+		sec = sec->next;
+	}
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -952,6 +992,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.33.1

