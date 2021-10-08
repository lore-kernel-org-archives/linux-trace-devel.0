Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516B6C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F5660F35
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbhJHE3M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbhJHE3K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:10 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E8FC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g8so31293604edt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84YBfQkP8YMHELb1tKO3NWhuSj1uaCA+g4kG3U3Va6g=;
        b=GCI3cQ1gG0DFNwnk6gkU7l4o4bDtp/vM6bcQ47osWiEqstsdBEaxOp+k43WKMh3TXg
         vLynBomj75GV2xmYvOpb5G6bmOHA6CajjvFjaXjrcJ8EuToyA1QpyyYxFvSBHne095g1
         Gy1K+ZVswyl2XSnNV4DIoqaVxgGobp8of+WpgbC44yyQa7D6ridSRF6RZXHZdkCoNUUn
         faeg1rr4Ilo+3b09Oso2sGVzmSISOBqsu4tv3F1McWWH7pk+DOfOQukyY8yDmb3ED8fF
         6u9F/L2lw64QKC9be8RwYRCa0AbmaG3AO1iYo24nyEbQBBd+jjgNY148d48R2WVdVFS0
         NA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84YBfQkP8YMHELb1tKO3NWhuSj1uaCA+g4kG3U3Va6g=;
        b=d9tyzRvLzJIReCmo/0OX+g9vlPHiGZ5vE5PLvTwXKc7fvbH9wjntpNIiz4m7jszsZi
         mUKxnm+uLsmzA1yfnDLj83AkxlkRlPCeg+Z4oO524sZV+GmpYHPNP8RBSERf1XG6QZa2
         mk86W2DGdRi450O0kPmoLWQWDe2DAsQtrfRnlLn7ZmNFDgGFbV6SdoPNcq8N6X1h2zv+
         XdkqYaGxcoo4vtoQ+e8GrTl4rFnzJfq7UWs01DPSWp+EAU8tlFuWS1dDvjAmscNFXJLv
         lGcEHXWFKb45m07EAgJWPc+QH5cpON6FEHsawnRP4j5isMTLLHgrjbEvvg9wN7OXHIQ3
         1OCg==
X-Gm-Message-State: AOAM5307XmEapPBVikiU/DTNMZyywGswW35HtBSSuH43ZUrcgg/9CulU
        QmL0H5GAVShPt5F4uC1daIYv8a4/O2VUTw==
X-Google-Smtp-Source: ABdhPJxV3O3TmjhOt98YmaTceDFzZrgWFdtW1hwBR6tg9oQ3uqWO50zk9Uyc4TsivZsiUh9XZ8dhbg==
X-Received: by 2002:a05:6402:4304:: with SMTP id m4mr12119546edc.326.1633667234521;
        Thu, 07 Oct 2021 21:27:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 10/10] trace-cmd dump: Align better the output of flyrecord dump
Date:   Fri,  8 Oct 2021 07:27:01 +0300
Message-Id: <20211008042701.979075-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The flyrecord dump prints various file offsets and sizes, that can be
huge numbers. Add format arguments to align better the output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index ab2fa2e5..6a148cae 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -898,7 +898,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.31.1

