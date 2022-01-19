Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF3BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351821AbiASIad (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352486AbiASIa3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:29 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5622C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:28 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 30so7670755edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQMIDjD2/QGpKhk9TPq2R3csc66HguJmNb11OAUHbpM=;
        b=H8iF9HKArKYlb50sUIZDg1pIpqRz3Fi+8xNtDlXjH4WMS3C9dzCoMd0o3PRwIEU8Ak
         +esY6xws8Vp2m45tHt3oSO9Q03Wavc9DQELFKxosyTsDbDoL7i2Ro6SrW/LHb9iDvspL
         E73GmRQSjtKSYsMuT4KRLWHdaMV4L8aDPdFDpzGu3wlFxX4BeUCqmTWjhA2jIuUKYDAy
         lHbmqtezldWkkcAQOoNDuRdhQEQdMnCPkbWM4XLbBdcor1tgcU3KJ7ugN2S2msMvDTQA
         LrlRK00f2OQcnN08YtPVfgQSdpU8a6G/G1uZ+UPnIB6GUWtG+UwD4ViBF7f6k1O2uZAT
         r4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQMIDjD2/QGpKhk9TPq2R3csc66HguJmNb11OAUHbpM=;
        b=7Gg7F92Hlb6s9ttZFNpmPTBR0sWFrvHUw7DqZd9AT3pkJ5FOYq/CjOdGEqYk7xnVS0
         kxbw4xg8IdVafdoGW43qwP/YrYJPHUKLsoTae15z4VE6YT2L4Y6zJrEAxsghoU33xpUU
         h04b5dWX91JLAIdcRVJeiq3rkEtD91j6VGqEEOuxZbHJAGOaIA6gSj+Ay/1p28SsKQ7X
         NUKXq1PHHJEjQRebU525okTGqwGlNGr8MGREhqRUtz5MnPjVjZZWIudoWCRwmfmSAEeU
         obL1JiPm2HrU9TPGwyz0BXwb6redtEkEYkuJopSz1m6xaGHX4AjL28NiCuIsfhWh6H5+
         eKLg==
X-Gm-Message-State: AOAM533qhRsBMNasJTVi5mIEKHxbrnNiHCUSt+ALqeFsSN7wr4pO8JH+
        CUTj9YUzzFezbqnRcwck6qrty2eCbHk=
X-Google-Smtp-Source: ABdhPJyUt40bM2IzhXssAPmeBu55P4SCU9SJp6CqZBLy7p2+JrhoqB2ALmjdJADG64gmICphZbFG6Q==
X-Received: by 2002:a17:906:4782:: with SMTP id cw2mr24069756ejc.337.1642581027310;
        Wed, 19 Jan 2022 00:30:27 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 06/11] trace-cmd dump: Dump sections
Date:   Wed, 19 Jan 2022 10:30:14 +0200
Message-Id: <20220119083019.246153-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 8f81ddb5..2ae53885 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -712,6 +712,23 @@ void dump_option_tsc2nsec(int fd, int size)
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
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes] @ %lld\n", desc, size, sec->offset);
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -803,6 +820,25 @@ static int dump_options_read(int fd)
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
2.34.1

