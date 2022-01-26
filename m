Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89660C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbiAZJxz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0D5C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:54 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id h7so37753706ejf.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3QDeFnfuoF/bRZaQA4Qex16ZXM38q819ZL/YpY7Ys1o=;
        b=fMNFz+lH78I2pUFV91jPCqzbsp/rISmk+KmDZxI4K52xeudOtT/OKy7FIqrG0Ezkt1
         nl5AIKXkLHSXDn+5AHEcShyt5eTulyX6r5HXwW3tP1I8324VT/mqtxuKawNNo44Xg9/S
         +yFmE7UQnyXwgJfeP4dpgs/r7pv0PNn3mpdLjZnEXwQEN8z/8vTmtCuMcz/fKlslEWRG
         G4/WXbqB5tnjwiLOEcyEmVKUXiyDIxZJluL0hx7uD/ZXk8rGz/F+p44/iHYsQwIvqGn2
         rrRSMLvzFOhh1Qr7IKA2CQIpqFnd+5dMWvKbTyUaXqJWSXuRiU7JlJGfAsYwJ9h9EvmU
         5JiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3QDeFnfuoF/bRZaQA4Qex16ZXM38q819ZL/YpY7Ys1o=;
        b=4cWIuOffeBQo/hTHu5XyvyIFChg0vtwQ8S6M5GWZiXQxXYoPpxmgCWKRuOfRuPkxo1
         TR49BdNTl6Qg0qT4F2THepc+YHaIONaynUDqkVex0CLGvTjflHGdu9oz6GCUOZVdCtmU
         KZUnFxHgAL93rd46A9LPyp7oGOhRQEB3XP9ozKAiPMlKGDZP11y5Q3i1cgwATtEVMSc/
         0ZEKtg7Bab5SvXuBjsNRirmBDi4xaYAJrZYjPD/5pl/Kd1DOL7QFCLu8XSwQMAzfNUmT
         6HfUvc+NzS5Ed/6JDMMzcTT+/PA9c6nqMjGyaUZcncPHteSRrcMez4FuFQbS6Fcj69tD
         xu6w==
X-Gm-Message-State: AOAM532NIQjHpol9kSGVvb11L+EDmVAbRkIZG07g37ebftYXpNhkmnJ3
        f4vAw9pT6JsxjtZ4xkwW6IJZtH2kGJ8=
X-Google-Smtp-Source: ABdhPJzF4bFuHvzyPAs7PBLL+Z9xhMyPCafmJCt486icdiqRcrCZqKsLyZhYdL4vh6TOvoKgwzaitA==
X-Received: by 2002:a17:907:7204:: with SMTP id dr4mr7048726ejc.195.1643190832827;
        Wed, 26 Jan 2022 01:53:52 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 09/11] trace-cmd dump: Dump sections content
Date:   Wed, 26 Jan 2022 11:53:35 +0200
Message-Id: <20220126095337.570867-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
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
index 13e79002..19f77687 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -762,6 +762,46 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "\t\t[Option %s, %d bytes] @ %lld\n", desc, size, sec->offset);
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
@@ -1059,6 +1099,7 @@ static void dump_v7_file(int fd)
 		die("cannot goto options offset %lld", offset);
 
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.34.1

