Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA97AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352474AbiASIae (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiASIac (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:32 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147E6C06173F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:32 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id q25so7705729edb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7xyD6vR4ZlbFS2gg5k4coi2AQeLmNQhzFxkWHZCXl80=;
        b=OB1/YVnFQkkJYyugfT7sn1pxWfoKOkBYhwT/YlgBDWaTebdI4fM2ObFAC8tSBaUG72
         BNuSaIQOTBH/u6L8ZiPnDHb10lzHh3qljx3CEKsy2bJSaQX65HDmhWH59LvEVXBQDCaN
         pGLpZgmoxIHqUIOLHinPAzbEVV+5QwU3X3KM4w074XiPLCzt5ZqtNN6YD0E0TUk6qJUU
         WHDkFyiuFNsx2HKfDnh2ayDbbG549Lv56fwktV6f/TgrGyFJmucEseQvO1lWx8/+Js2x
         Xbn4whZ2Z+KpYtWvsg/NJi/JmbkZ3+/vRDlPfvyzukhB4d9hsFwRC9al0nwGNvq47zWq
         3p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7xyD6vR4ZlbFS2gg5k4coi2AQeLmNQhzFxkWHZCXl80=;
        b=x3qPNz3AOtdw6vhqHP1KVXyLL3PQEY5AL7XDmH10e0vNNHnNywkxwJwoSMbSa1q6Zo
         pj4DNMcvC/D880RsXmzzolXVAurcymn9yB3UnoKDXyTcoRTn8/2j2EGLB4Lq4Ezwvws8
         AzQmixzNmfU4sLI+ZG2KY4bX6iX6Ss8BkiNn6IlGMaSyb+bvIT5Gn9iS2tERMZ+8NyYg
         7dEcd/QG7LVhBVzEKk14RWyNsWdOcJWZ12FVE3N15iVWxCII82QLztaAgwASN1TSvbEp
         tE9tDsO+K/5IJVDldSIoYlT8mD/Ok1IPHEoZS9iVJg7lyk4wOvlmUecNW92zrICRNzaW
         zb6A==
X-Gm-Message-State: AOAM5328brnsxS8KgaT8XKZpna4/Y6f24ItPDzjhiViPjqX9jHpkzc4d
        Rl6V5FqIKio4VM7nW3U/wFI=
X-Google-Smtp-Source: ABdhPJy7fiuSAOyQPxHfDHB4vAulw/utyE0pVFAfkXrsgNS1MV+crvhhSoD+g0bB+J6QZTKn8T/gYw==
X-Received: by 2002:aa7:c448:: with SMTP id n8mr27329706edr.378.1642581030711;
        Wed, 19 Jan 2022 00:30:30 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 09/11] trace-cmd dump: Dump sections content
Date:   Wed, 19 Jan 2022 10:30:17 +0200
Message-Id: <20220119083019.246153-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
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
index a765d1cc..fd54ee5c 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -744,6 +744,46 @@ static void dump_option_section(int fd, unsigned int size,
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
@@ -1037,6 +1077,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.34.1

