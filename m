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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C587C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56007610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhINNOY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhINNOW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:22 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CF1C061760
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id e26so9243951wmk.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rgKSGpz75JPloOaC/1DcOk+gg+XSb9yeocHeU0wjVV0=;
        b=cTvlKt9f01Pb2dzxB7s0hJ7ArSj2AjPscGpP+TFjag34soAoUNbsuIusL0i5InLenE
         g6LpYji2PU1RcRel7se7urdLV8IlmmDO2UqQaAX5alNxRpUsahPyByg2locNXPLsQpc/
         k34MuKTKbXd4AOGMmUr7ULvhXP6amYKl24O6TkBI2bFUmDN82RPz6Mz6Tp/nz19wYKLl
         gG3BABuLii6VuJRX/GGxxiW/nqM0nb/v4kb4uNGyeoPGLTWt71PPUE/veGJ6sUlY5xBP
         6pl6pAIpVecJ4t4/6GrCAXFvuCi0/d4XTv6bbnZfL/FQEBME1jjM3TUGHriVapu/6f5c
         XG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rgKSGpz75JPloOaC/1DcOk+gg+XSb9yeocHeU0wjVV0=;
        b=zBHv919F16VpyUq3P6nKjTkQRrP7POakVL+MLW+Htd7XR4lncOxas+dpc3x6No5ufI
         V9ks5GEpu9neGY9m2vYreUHahrDOAWT8LY2Ze1l8Zq5Ziw0X1yCae7wh3Tw6omBZmp6Z
         uzEXqJn86MlV25W/MWlYTs6IhytRnr8m9snmK1MISu5glqi6ueSZ1RgA+Qf+a+4otp/D
         cUr7byaH9JP2MFDiT5PQPMSkzMDnlwussPU0ND8cJz5YiVITu6avZsOMCpXwxxyrC0YU
         ngyzHbCWV9LqVDE7sxttQ6Ztx3z7WfRh9NIFQD/TEwNp7Jk9wp7MET8PgwB7t7LXWSiF
         zMHQ==
X-Gm-Message-State: AOAM532FKRMYl0M4kllaMsfdaiX0Qu8bldNfj6I4DUgydkTMIygC0p+t
        QcyZ7rEavhaXJUQLE/e4+lc=
X-Google-Smtp-Source: ABdhPJyLx8+gwlE8yt89sd70EIE8eQbmRIoYzHxTVw0lawRIyawktEqqdWIZyhis4fbfVzBsB4jFJw==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr2140837wmh.61.1631625184200;
        Tue, 14 Sep 2021 06:13:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:13:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 21/21] trace-cmd report: Init the top trace instance earlier
Date:   Tue, 14 Sep 2021 16:12:32 +0300
Message-Id: <20210914131232.3964615-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moved initialization of the instance before call to the tracecmd_cpus()
API. This change is required for the upcoming trace file changes, where
CPU count is set when the trace data are initialized.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 02f75cb9..f7ffb89e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1215,6 +1215,11 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	list_for_each_entry(handles, handle_list, list) {
 		int cpus;
 
+		if (!tracecmd_is_buffer_instance(handles->handle)) {
+			ret = tracecmd_init_data(handles->handle);
+			if (ret < 0)
+				die("failed to init data");
+		}
 		cpus = tracecmd_cpus(handles->handle);
 		handles->cpus = cpus;
 		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
@@ -1225,9 +1230,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (tracecmd_is_buffer_instance(handles->handle))
 			continue;
 
-		ret = tracecmd_init_data(handles->handle);
-		if (ret < 0)
-			die("failed to init data");
 		if (align_ts) {
 			ts = tracecmd_get_first_ts(handles->handle);
 			if (first || first_ts > ts)
-- 
2.31.1

