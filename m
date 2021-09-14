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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA70C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A4BB610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhINNN4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNN4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:13:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE92CC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b6so20123524wrh.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=OPvzY51obHJtQwvUDDHVLC10GRJ/141WN/VijQQoHQsO3rHYHw2HQvz//JdUXRvNU5
         u57A30wUO3oV+NU21wP4TVeCeYikIWzBa33UvypWtpexDoarqNSVMcyyaCtJpGLtLeps
         xnyh/QdPiAxRucrkg3B+DOihuIG99C4OIi1XEu9iGD3O+hVDUsyNJamIgSt5dpFGPsO+
         lC+NlO/mSSr5mMyy+hKYFDTaguFwu21CrckRKdl4zFLMPBG0hjdQtSUE9TVR2TkhPXUi
         LegQl7/1M4KEthOFGpSXGu3NX+ifWYTLeRS+tRAccjldS3HmKgUipLp5Fx/iLtHK5NQj
         Hg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=MEYm38CdO2Zu5zTF+ouRHglMs5/n46g6jg9axFF+nABzNMwtGoYcO2TdLqb5S6c3xy
         QIGvAODlf3oYi8sm7vrgDhnXQeUd1AHYS/6XjN+++LuY3eQ/6Y9Bp6lrMZJ4fTDfnUx2
         MlNVBWWpgcpcIG8o6zQAh/NkpYY/EvbbxkUYoFN0BAih7apo26w16HGYWzvhAn5Cw0OG
         TNHm3F4zuMEe0E7EoQzXjdYMr2vWL/ddRFTIWd+GvZA3DVqp/jQ4QHh8njmA3coiJs2r
         4bXIEtsTSx4mpxNUWSSZcu/kPeCW+vOWHTbUfNUdLBObKAvy7Evif9XP7kG42jydpP0l
         qKHw==
X-Gm-Message-State: AOAM533H8pvHvRnKz7LE88R19JXNUZ2amdhX55CrhZPU8NYESR3wOkM6
        +JnoTWY5B33GxhKPT1ROcIU=
X-Google-Smtp-Source: ABdhPJzJQM6MT6y3Or5W1WG7aAmwoQk8yymm4K5HtfpZmj3ecDd0ZhstL7Hlfr7nM16RStvwr98rJA==
X-Received: by 2002:adf:f789:: with SMTP id q9mr18757848wrp.367.1631625157314;
        Tue, 14 Sep 2021 06:12:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 02/21] trace-cmd report: Fix typos in error messages
Date:   Tue, 14 Sep 2021 16:12:13 +0300
Message-Id: <20210914131232.3964615-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed typos in "trace-cmd report" messages that report reading and
parsing errors.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6f43c1d2..31724b09 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1290,7 +1290,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 					die("error in reading buffer instance");
 				new_handle = tracecmd_buffer_instance_handle(handles->handle, i);
 				if (!new_handle) {
-					warning("could not retreive handle %s", name);
+					warning("could not retrieve handle %s", name);
 					continue;
 				}
 				add_handle(new_handle, name);
@@ -1324,7 +1324,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (last_record) {
 			int cpu = last_record->cpu;
 			if (cpu >= last_handle->cpus)
-				die("cpu %d creater than %d\n", cpu, last_handle->cpus);
+				die("cpu %d greater than %d\n", cpu, last_handle->cpus);
 			if (tscheck &&
 			    last_handle->last_timestamp[cpu] > last_record->ts) {
 				errno = 0;
-- 
2.31.1

