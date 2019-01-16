Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E798CC43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9FE620866
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbfAPTSr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36691 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730804AbfAPTSr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id u4so8285083wrp.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 11:18:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MA62gIjQNLySULg2VplxrgxMDTF40MfOh9U+JIPInzM=;
        b=GiPPuAeYWFZLQfY55o6Jy324ZV/+04F/NnkV1ncLjdwmHJQTJ1rG4BD7HEFSHrPP9T
         f8BRS3E9LAbLYRXiFaHfKZsQIgWUs9h6M2uPC35MZGkVB7HIiGLTTs5vHlVN8TRum63E
         14Wqu/NHhr/zo0tf+rSvdCGtNSg6B9VKHBPOvBvv0EPYtZkJ0QPScfBMR0BgdpnJxp4H
         E3WKj4id96kyekeuTELbvhCJX9FdsIZ8WLv+njOh7pkNlCWGXV2r1AXw6CmY9pJzwb2m
         lQYnO5wftHH4I73Z36g1cvI5a5EHtX2DZaSeAU0InOXGXn4X7jiVF/mgMLB0ppcvzaJK
         7/Gw==
X-Gm-Message-State: AJcUukcrsnW46qdilu+PddBII58+uvlqwUbPjXafGmh6s94YZmom/hGk
        2eTYTWVgKNgPF7n6o8a/A40=
X-Google-Smtp-Source: ALg8bN4P/8Hyu1vEizFN/fiB4kASVAs0ATs3zASHFx/6hIdL0DqP5iZ6VCil8gPvWhCDJo9kt2sR1Q==
X-Received: by 2002:a5d:678b:: with SMTP id v11mr9468843wru.245.1547666325757;
        Wed, 16 Jan 2019 11:18:45 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm98393345wrx.50.2019.01.16.11.18.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 11:18:45 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/7] trace-cmd: Added user configured clock to the record context
Date:   Wed, 16 Jan 2019 21:18:36 +0200
Message-Id: <20190116191838.32127-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116191838.32127-1-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Store the user configured clock (if any) in the record context,
struct common_record_context. The clock is going to be used when
synchronizing timestamps with remote tracing machine.
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f7349eb..900d0d4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -227,6 +227,7 @@ struct common_record_context {
 	int topt;
 	int do_child;
 	int run_command;
+	char *clock;
 };
 
 static void add_reset_file(const char *file, const char *val, int prio)
@@ -5183,6 +5184,7 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
+			ctx->clock = optarg;
 			break;
 		case 'v':
 			neg_event = 1;
-- 
2.20.1

