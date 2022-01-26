Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C43C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbiAZJxv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:50 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2C8C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:50 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a8so37614543ejc.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pq/SuCVC9YOPJ5WW7ivQsm2xNQAEbJ/v3B/pLUr1wcE=;
        b=fD5r+pSoY7Wa8jng9EB7uUMQAEEjRCE2RYW4QQq5eHnTPep1VTv9UL46h7U74kTXu4
         /iKzpCef5mMaJoKuQe0bj1Yai5510Umtm2XBOfuPVeqPSSZob9A4mxhYr7BxG7BiGZMo
         D9qhbfwEMUAM4MSitk+J99rPz5ARNzeqqjxoGzOM435Bug0iFCDPZPARpO5FGefyk7tg
         bASf6xOqZIUQfV83xXKgZt/gGcrXMGVLsI84142+yjZXEIRpXt/e9GVnHnb18cEeOuTm
         4F2AMgzQFroo4mGGstnSGeScyxNlHtxLKLBhWZ28m6f4zCT3l58Qfi3n16AsMLrB4qLJ
         jTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pq/SuCVC9YOPJ5WW7ivQsm2xNQAEbJ/v3B/pLUr1wcE=;
        b=wg+av6rZ2OHpqFbuwlEsR4EPs+fpVuDo295YyE3FDgs4oHrL99O4vGkkJMfxx5q43P
         T56DfLsZQJmu4th0M/kbbs4dWG94U7a1cvpiIdAuoxkY3HW7/mCKlRjY8dzxbB/K6you
         it4p8F8wKeoxyb3zzKzoeRIJKM9VphVgq5qWtwW+CU4CJe06P1P3aLhOrsZIlmeZshPW
         B0YZ2qdAoctr4ybLPI0iSklmBkSute3gKBxAudlO9H0Yq6nqK1aBFMoo5EvpGLiRgkjQ
         G7LbjywK7EdMYHclNl/Mmww+L3GY1wfnJGORKN5E/R59/BXi/lkSsFvQ5jqy6OgN0oaR
         6LRw==
X-Gm-Message-State: AOAM530prnsZVrBJi0thkF0X0hbn41Y09mUfj07JQdXw5XwdQVM6Vf75
        KTrYZQWJumaEQGSKp39nT49IpzT42dk=
X-Google-Smtp-Source: ABdhPJw2rjuIeO20dh7Ris7MTllEyJ7jFLxyY9RfUncvS1JSLhsg22JKZIy+ZxOzqBNbwWwjTC+VNQ==
X-Received: by 2002:a17:907:96ac:: with SMTP id hd44mr10771543ejc.88.1643190829255;
        Wed, 26 Jan 2022 01:53:49 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 06/11] trace-cmd dump: Dump sections
Date:   Wed, 26 Jan 2022 11:53:32 +0200
Message-Id: <20220126095337.570867-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e88fe033..bb168370 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -727,6 +727,25 @@ void dump_option_tsc2nsec(int fd, int size)
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
+
+	sec->next = sections;
+	sections = sec;
+	sec->id = id;
+	sec->verbosity = v;
+	if (read_file_number(fd, &sec->offset, 8))
+		die("cannot read the option %d offset", id);
+
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes] @ %lld\n", desc, size, sec->offset);
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -821,6 +840,25 @@ static int dump_options_read(int fd)
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

