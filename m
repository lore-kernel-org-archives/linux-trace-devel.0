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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A177C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6057960FBF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbhIMMwG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhIMMwF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:52:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14483C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:50 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x6so14492210wrv.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84CJPvhzlFAC7i9Uo9LZqs10p/gs28x2Da/5/NO4GPU=;
        b=COCxXX7ANE+opzglp2j+ihn+V0x5ZJHIeRNqd7WXPgxj14zh0P2Q0Vq1OKLepiU/+v
         Jgz69Fy41Ql5jens563nJpsGWvS7n1ZWORSXJsRqvWT62aN+ntHAxMKCsggL15fkJCj9
         e1Nkt4mCKTgJN5U5pA4iKc9Ms+ep4yp+lbVTxnMEYs+Vkt1g+IfJ9P4Otlc2+pw9lJhy
         RNsUPPHyEPVjEQk7QcqYQvgOJcWCQPpJGW0kWRm/sdB7PE2zDsREHRO7czoH/tw5Nv1d
         Wmk2oLeSXUzOAWtEyao2uMG0XtWFCEjMHqcxJCCjJPweCZHunjS7sMThCKn+e+wQEQoQ
         ZLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84CJPvhzlFAC7i9Uo9LZqs10p/gs28x2Da/5/NO4GPU=;
        b=jtjuprVC9Shj/Yj9oporpi7MRniuAckVPoR4EDI6LjvBDSY9gXW8E0fq6v3t8KL1wq
         ocSdL/jVD8F0TT2oWjbJh0UsqWG2YsyGl1+sP+TgCLIUvRPpBMSSLzbM+2NWmqCmaXcu
         wWOBj/3QVkXrV5cQhaLGWxIOmY8NJh5EcUlOpIkGY7l4GeHBhfQFsIvOxB0aerawHW1S
         LJ4XpVooHXDGqfooBHOoRF218u0rN4L5brSJKpBKarcy4cNi5Yn2Jc1ehESyQy0PRfaj
         9IJtXXo5oP9xjUrcwJYAlLih1/Ow0PYjOSrPK5koAbK5tL4ymoHRHmrISu4CvgC0g0iT
         ixFQ==
X-Gm-Message-State: AOAM532RBxRbvtMEXVhWFRFejCa6X6+6JtvsDQRLyrINHI6z8xN/3eLI
        KW7GrpC6rA9wnRspY84pLJ4EaPXagK0=
X-Google-Smtp-Source: ABdhPJwgHJ5jg++VQ/yNtaTFAiO8pCcVReRkVp/9VybI6xQgpvYpyrINHg/m2qzibdDvLMu19Mo2fQ==
X-Received: by 2002:adf:90d0:: with SMTP id i74mr12557463wri.185.1631537448735;
        Mon, 13 Sep 2021 05:50:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/10] trace-cmd dump: Dump sections content
Date:   Mon, 13 Sep 2021 15:50:37 +0300
Message-Id: <20210913125039.3680986-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
References: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
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

