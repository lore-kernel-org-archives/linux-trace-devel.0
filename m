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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8229EC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC8860FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhG1NeN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbhG1NeM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C356C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:10 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f13so3187993edq.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WBfIn9AeJ5/CLS5y5rDIU/7xqkL7SLVpg5VC9GJiThI=;
        b=pJ7d5Y7Vtw1EMwkxEIRUN0liYozFYXAgO9E/+FoVVsz54nKQCktWaeclIMN28BQfDl
         BqowCI4PqaqgGgyhHjUQm438eJHZIrfoKcq002E0BavJxcQmO9sDbezIJpk0HOJkyQE0
         v6/MC8zTiTLoo9Pze7KvhxBLNpf8wyOG0bWWxxUTlsRew2i2SZ2HUIPNHXYTXSW8RcCz
         ygHqggGw/H8gvCJzbWHcHpnJY4ifDnVKKvhX4nXF2/vEtDy6OehixxVsjk+bzjnh5BwN
         U107XSgnSGDeLN5gyTyuggtl13NrA+IR6l4i4zFr+rLQdyQ40pl7wRcWCCziFBqOKxD6
         GU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBfIn9AeJ5/CLS5y5rDIU/7xqkL7SLVpg5VC9GJiThI=;
        b=ThiJ1jhWtlH9IkSm27yulSiDD93ZOOSk3gLLfQ0yyM6BbuTHrMwiXGIbJV5TslxGc8
         5zcili3o3szFwfd6EZacCEioSN3UR7uMR77oioegBCIZ0HYXiAbDAzssW50C8rFUZ1fY
         MlbOfYYs+wWdTMin5ypl3mL4t49253tXq1WhACH3mbFsr6v7bKdUp+ChCwLf1nWuiNzD
         1Ta6A74TL0gNF7dQkB7BYVFfGLeJuLOO8piByVIT3GAvbkeM+PQ4qzr8RqEL1XtWl1hN
         likm30hou52fctAc9xhwkeoxV9C/9rBlF4MC7z7gdV9gZbHF3vJ2yua33kMez/8bLjIe
         RFnw==
X-Gm-Message-State: AOAM533wzbnJole9LAjOLlWvGUD+HMkbUlDuWfGApDjDJCjxOVgOtpsN
        p3UM/+ZuodIXsMwZ9l5k1TrIXZTZmtsUNA==
X-Google-Smtp-Source: ABdhPJxM56z+6AzTX5GfZQEIt3Z6UkIbLg/ehTAg5j4FgIv791VXJ/OzbJfxC4LfJ18QV7lKWFRFNA==
X-Received: by 2002:a05:6402:7d3:: with SMTP id u19mr17310508edy.188.1627479249248;
        Wed, 28 Jul 2021 06:34:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 71/87] trace-cmd dump: Align better the output of flyrecord dump
Date:   Wed, 28 Jul 2021 16:32:34 +0300
Message-Id: <20210728133250.234140-72-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The flyrecord dump prints various file offsets and sizes, that can be
huge numbers. Add format arguments to align better the output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 57132c52..0267834d 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -897,7 +897,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
@@ -1154,6 +1154,7 @@ void trace_dump(int argc, char **argv)
 		case OPT_verbose:
 			if (trace_set_verbose(optarg) < 0)
 				die("invalid verbose level %s", optarg);
+			break;
 		case OPT_sections:
 			verbosity |= SECTIONS;
 			break;
-- 
2.31.1

