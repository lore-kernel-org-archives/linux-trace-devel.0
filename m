Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14586C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2EEF610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhJHE3K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbhJHE3I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:08 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C20C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r18so31330321edv.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84CJPvhzlFAC7i9Uo9LZqs10p/gs28x2Da/5/NO4GPU=;
        b=YjOLZ5Z9y1RW/TcZebhrdwCUhN6VVTya9mnxk5PuqYmwwff79NCVnrEf+nfFZI+LVB
         ZcrUhhPQ8SUow8v0VARjpr6F+FtShB/UdZBYxXasmKQa1vjNr+w9C8EzZv6zzs2MvPxr
         7xucg7s7DkyM2zQJFRy/b/x4BOUlZ3sa9ATHKvFM62PQDIx+a6Ra61USjKtGbe8PhWgg
         YfTYNKgF1IO6TVeMdLDgiw7jfJpx2bm5LiFpwGnAQW/HdRIwHWXVcIP0bDiP5EQPK1pU
         FHm4TOTUixGlIyawRYCvRXmOZyyrh7VSIaATGC8QUT7q/TMsg38yPZtwNBcB5mPzzCRy
         m2bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84CJPvhzlFAC7i9Uo9LZqs10p/gs28x2Da/5/NO4GPU=;
        b=Od9zYSwJHaY8qtb03XPJSFsEQU8fh+L28DcULlaNuuGdXwc54HsvLlYBzaPUUYjRLw
         cNCz59S1AG9POKtv3DAX0jIM2Kwy1aVMMsGBeJtgKXwnn/qZ0kg9OuzqHDLkpjtdWizJ
         bgeM4FQXFJwgqKi/cCAXLJu5dUk6o+q9/OqJGynFYO6m3f3Mqj5Rp4qWVxNRAVLWvztd
         Ympzaa4gBadjsNDIzIUHoFqVjUEKEU1kfLj0tnCyqImrtG34+99HUOtidRW/zDAMQT4k
         q8iMJvvnPz4NUpwvbCNkDhRi9E7uUX3qyKiUPlUfJWSxckkba4NHjsn/8XFNvdu+4KqF
         Iz3g==
X-Gm-Message-State: AOAM530xcoaKbD6jm6ubfMKu9dz7QkSojLxpltSNVvJIxpPHNm7HE7ab
        hxlwu0s4nvuyCRtb0n94D7eHyI3i3b4/Ng==
X-Google-Smtp-Source: ABdhPJzr2LgSG1rAj7WVe0YY5OD621noVA7SpHkzWj0AFpOT2+RuhoyMrs3FNX2Qap5WGTkBvcyfaA==
X-Received: by 2002:a05:6402:1057:: with SMTP id e23mr12160396edu.352.1633667232114;
        Thu, 07 Oct 2021 21:27:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 08/10] trace-cmd dump: Dump sections content
Date:   Fri,  8 Oct 2021 07:26:59 +0300
Message-Id: <20211008042701.979075-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
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
index 44f103d8..c222cd66 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -686,6 +686,46 @@ static void dump_option_section(int fd, unsigned int size,
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
@@ -907,6 +947,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.31.1

