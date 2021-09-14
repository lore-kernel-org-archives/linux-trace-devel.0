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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748D2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6033D610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhINNOL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNOK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:10 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD11C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b21-20020a1c8015000000b003049690d882so2033610wmd.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MyWIX5tRJya1zLsqCa6QH1jp9vXldsg4aBN46KmC+xg=;
        b=B9puQ+YAXQw31PFzPNclvEXF4whsQfRjIRhaplZgv9YTEB062kKNR1J1mXxWhh/4s6
         /xMrZ+CxkO2L2rh1jr5YpHmBU4OEH1+wVJFTwu9hl9fl15AJdD98EFGyr1RtCE3cXYOW
         2RDJhzT4Ho2MSPXbc8oatoz9XyDzTG6izpqeQyr+pWipqci74YUk/b8ubvyKQ24uEzUm
         vF0JCLXUjytX4ZnaJf6s3aDvJ57CVQEYniFFO3uVqOZjMYHkQmO9aehAJtGwjh02PLtC
         1DsozRHRAxPYsUmamOqKITfmXPOzvHEnQj3VMUEFU0KLQYJVGQvs942KzeBIGF6GXp5t
         +04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MyWIX5tRJya1zLsqCa6QH1jp9vXldsg4aBN46KmC+xg=;
        b=xNHDjqocZh/0fd2xfP+sxfLjqbchTm2EyQ3O3ztpSqQadstFMIRZJlXHHJ2F6ffEuI
         beum1R9BQy9+UsOINr6zc2MK/8dREJgZlJy5RxYKbab5gkFPE+msGa5phHqjuvArF1J2
         s1xNqq1P25sCYbco4IMq1lXWVUqd+epRL6VrNDvIEFEkj1bxcGmnhxFKOs7Rc0dLQSbi
         akTJoHtdlctDTsmqG5eRoI54qWXIwQJw0S4jjTGPZoEz5RuB58wFUgrAgGujP65Pe2se
         1lF70dhHZ1CIJh6lpqKOHUfn3nsIv06wp3JdOOOvkhzFimT8IM7CXNCcfZ4gMZSramkP
         AwIA==
X-Gm-Message-State: AOAM5321gqjRReCi4MHolWmVfjcTvhAW1TBIJUNSoYw8+ErBU+cigh3i
        BXv91zBFvTdk9DibJBeQWIK1RNReN74=
X-Google-Smtp-Source: ABdhPJxzrBGJs7qnolFMfUaWdO9ZsNpwpDEfy3Hx9UYxAvmlMyvh2xik8AKvEKt7heaNMJDGw1ajww==
X-Received: by 2002:a05:600c:3656:: with SMTP id y22mr2183459wmq.58.1631625171886;
        Tue, 14 Sep 2021 06:12:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 15/21] trace-cmd library: Track maximum CPUs count in input handler
Date:   Tue, 14 Sep 2021 16:12:26 +0300
Message-Id: <20210914131232.3964615-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next trace file version,
where only CPUs with trace data could be stored in the file. Each trace
instance may have its own CPU count, depending on collected traces.
As the main input handler is used by the top trace instance, the
CPU count there is for the top trace instance and may differ with cpu
counts of the other instances. Added a new "max_cpu" member of the input
handler, that tracks the maximum CPU count of all instances, recorded in
the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index cb8b9f14..dc82d3ea 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -125,6 +125,7 @@ struct tracecmd_input {
 	int			long_size;
 	int			page_size;
 	int			page_map_size;
+	int			max_cpu;
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
@@ -838,6 +839,7 @@ static int read_cpus(struct tracecmd_input *handle)
 		return -1;
 
 	handle->cpus = cpus;
+	handle->max_cpu = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
@@ -2794,6 +2796,8 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
+			handle->max_cpu = handle->cpus;
+			tep_set_cpus(handle->pevent, handle->cpus);
 			break;
 		case TRACECMD_OPTION_PROCMAPS:
 			if (buf[size-1] == '\0')
@@ -4074,7 +4078,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
 {
-	return handle->cpus;
+	return handle->max_cpu;
 }
 
 /**
-- 
2.31.1

