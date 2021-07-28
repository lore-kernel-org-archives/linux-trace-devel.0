Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E8EC04FE3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE9560FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhG1NeJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbhG1NeI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:08 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC028C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:06 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hp25so4597016ejc.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qoEjd4kpECpwm4kWQBTFWKqptq8l7VI7OTfY1a0jtfE=;
        b=u7C0AzlTKzLAgUgJch8HWn2pRBpMhn+U3/Rxxh/fpdWNe+cHNoCHHLMdD2eFzwgMgd
         D4JFrY/Hgpx6mIgy/p/DsV1O099X4YVK6bC+SnHfv/xAGLcvnxGuL2kgE5Nv588gtcyu
         GE3ah6+IfbGCmtGRPCR5vc+MXFS7NGd89U9995F3lTPkj1nraVVSBbHBdzuFHpsonf3Q
         B0jKXt6XLZ8lY01vkQ3sls2zqRDmrf18b4LSj2aUs64p15fKe1zBTUU2yUiYr7lHAxou
         6j2a0EtZzLB+dKEuiR97wqJSa0yO/IUFotQDT7v+aIXLF62eu78dqAIq/V3GJBYF1JQy
         zx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qoEjd4kpECpwm4kWQBTFWKqptq8l7VI7OTfY1a0jtfE=;
        b=SVhUdcA97yF72R9Hgf8nVOkD99p/io3Rbu337E9QtNihZ1wGHmA/HflzhB3iIevrDk
         OxmoW8nzVPLOK9PlhavDBNmsT7kRJE4GcJpmZRGcVuIgRbC5Kv9IPOSD3Oge8VbVDR6w
         hJe1n/8i6kjR2s6Xhg40zDc7OANaVCdzC5luZdlrnWV9uOffOCba9/WrW4AGVqEuvHGw
         JesUOkNTFSWQjcbRV221c304HcC/srrwqbQmMUv9O5OX4/nmSbBqHv+xjNLm3N7XdDC3
         AX4yN31peu0YW30GoY1iYwTSCotBOS+pVu/Ep8MjLHVfvA9ncpfAJynbZ9188VhFLBEd
         dpuw==
X-Gm-Message-State: AOAM530JtszXNTOcKh/LBnly7WftXr0Csgi/OPPtqwfuXwgnctFtOqoL
        NLR4N8K46nVSb+uFTpsNtZ0=
X-Google-Smtp-Source: ABdhPJwmnRjRWtj7mfsyJVu8SXrXjDedD0EfeXknFQX+MGZV22uQJyLPqGZiZpAT38Gmy+Ns40OPqg==
X-Received: by 2002:a17:906:14c8:: with SMTP id y8mr21011364ejc.475.1627479245513;
        Wed, 28 Jul 2021 06:34:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 67/87] trace-cmd dump: Dump sections
Date:   Wed, 28 Jul 2021 16:32:30 +0300
Message-Id: <20210728133250.234140-68-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, headers are stored as sections. This allows
their position in the file not to be fixed. Poters to these sections are
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
index 6a779d82..8e95e884 100644
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
@@ -755,6 +773,25 @@ static int dump_options_read(int fd)
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

