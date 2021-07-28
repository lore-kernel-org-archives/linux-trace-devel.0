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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93781C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB4560FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhG1Ndm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbhG1Ndl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:41 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02471C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:40 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id v21so4688087ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kwQhywDVKGuBuCqFGCnC12JPO5tJCL5s5JdvLUVT/5U=;
        b=s/HA9KYJO2Mk7Y+O1GbvdLTfcDCr5Wauuodqadzovppw9i3PgW7P+ksTnzHzxQkhZg
         k8CfMEH9wiIVGcSKYANdq7n00MnZQGREIrLRmQcnXv96PbMqiYVGdinCsQLJDqLbNrly
         s3Hmbh1+E73W1VR4TAtq0P3DhEAcl6djY041PKojW8Nhs8Ss0xQZr/aL2k6CU/EmhWzx
         xuGEtNHdH1sblEIQ9SPA7EM01JSjMzvQt/6kF8Iko8nhRBVSdt2PbeWw/qPHc5jP61n0
         TCOl5Usc3a5BEIWzJVvPif4GuFKzaMX+aK4ZSBBj3CB3cbVJzrU8p0Y1n2h53VDLYQCG
         63Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kwQhywDVKGuBuCqFGCnC12JPO5tJCL5s5JdvLUVT/5U=;
        b=a4O4R77q3y61m59mCGj98vKENbJ3upl8frkrb54hn0atSq4Yb1+5XLmxg6xAZRaILE
         AINJDnAD5NTBKwuqUbA6vg1dxL8E5NCbAP2+Da50shKlkL86VJloRcjLQAYEjVjLB+h+
         oG+80lUcQ3ZssUbB2Fli0UO3te4oglu6Xd3G5U75Y+hZ4gwhRdyOWQKUHK1RS+TjS5sK
         +DNfe26mEfi9sWfPzXtEl+zg2ngwRFejvciQFl0wTX3FaPsFnuJykLn/IWrtKcAtm09Q
         YZMK6pSpKuXlW9AJYENhgxWbfX6di4ueHmpECEnaG4mMuDFa6jMmmErKZSUkkbmX8lQn
         92FQ==
X-Gm-Message-State: AOAM533pxJM2ktHDWY3Gp/AR9YVg35WSGy9APu3inn7es6Fqsr6d9m8I
        6fPPpoSgPU0dAMt7tKMTcg4=
X-Google-Smtp-Source: ABdhPJx6xCBmxKzwLaCAZVg4PxaVcx/MTpr1WY+fS8FmR7P8qSg19yXHg1oduEWxBpwE0hHAclo0LA==
X-Received: by 2002:a17:906:dfdb:: with SMTP id jt27mr27839406ejc.138.1627479218647;
        Wed, 28 Jul 2021 06:33:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 46/87] tarce-cmd library: Do not use local variables when reading CPU stat option
Date:   Wed, 28 Jul 2021 16:32:09 +0300
Message-Id: <20210728133250.234140-47-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 can have more than one options section. Assuming
that all CPUSTAT options are in a single options section could be wrong,
that's why using local variable to track the CPUSTAT size is not
correct. Use input handler context instead.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e288c55f..2bab3208 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -150,6 +150,7 @@ struct tracecmd_input {
 
 	struct host_trace_info	host;
 	double			ts2secs;
+	unsigned int		cpustats_size;
 	char *			cpustats;
 	char *			uname;
 	char *			version;
@@ -2910,7 +2911,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	unsigned int cpustats_size = 0;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
@@ -2988,12 +2988,16 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
-			cpustats = realloc(cpustats, cpustats_size + size + 1);
-			if (!cpustats)
-				return -ENOMEM;
-			memcpy(cpustats + cpustats_size, buf, size);
-			cpustats_size += size;
-			cpustats[cpustats_size] = 0;
+			cpustats = realloc(handle->cpustats,
+					   handle->cpustats_size + size + 1);
+			if (!cpustats) {
+				ret = -ENOMEM;
+				return ret;
+			}
+			memcpy(cpustats + handle->cpustats_size, buf, size);
+			handle->cpustats_size += size;
+			cpustats[handle->cpustats_size] = 0;
+			handle->cpustats = cpustats;
 			break;
 		case TRACECMD_OPTION_BUFFER:
 			/* A buffer instance is saved at the end of the file */
-- 
2.31.1

