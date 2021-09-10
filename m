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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DC2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A5CC611EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhIJNtY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbhIJNtT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8EDC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:08 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g8so2587237edt.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X2Kqqc0Y/KLYPqbk6FuL8+pOWJtHC4qePmje4ffdblI=;
        b=iNHOSwim4WYgybGVmDk6w3S+xlPT+eZj2aHLz0CXa0SzuMhhEYJBaFl21q094mNSHS
         YAqlveBsNRuRlMBsWSSg0mjzAg23jeZLmQCkqwM8xT/QpJZjXKCBh56Mi47VcxoF0oji
         F6rpjp97I+AZXCIGetPdqK7LKIGepeQYgZdxr+zpbgiULlBkRqLOrOwAuj7MSBq3HN0v
         scrhtj2eNImMuosqOMEc0m2Z0pGbBpTYqxsTCJeHWC+rS2Snga0Q2IZnG20IBLQa/KzX
         1V94ZqKEZKSygO+1w9RGYKW1PAFlq3P2ZyVPqQ42M3J5h/F3oNZ4DkuZldtqavyMfPa9
         kXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X2Kqqc0Y/KLYPqbk6FuL8+pOWJtHC4qePmje4ffdblI=;
        b=7kRKBLXFbM/u8tX9LElQgq6zA+qQ8IYVmm1nR7RwD9L3Za+tSQfLBTXQLapKeBfo2v
         P5D9cTnwm47XV2QMu8wV416fj4rgFFpGMZK7mTpvGHDTTUMsi8wkRw5mGdTLxmNoSukH
         v/odsWAB/BSK6mddeM+e3+eWWL2s50xtCLUWzom1op/xg59nbjP2WO4QeFfKVkR33/3c
         6GdiNynAj2sdlkwlYtU/QjsRSMrU0Ek/mKnX91VtSrVpLG2/TsOC2yPmC4iaSVIqcqFY
         54dSnmDuW8NSRrB9kh8qJ0f5DiEGkBKbtIBcensTY4AUYqK+/82zrbbm8fq98EjnCMd+
         F/QA==
X-Gm-Message-State: AOAM530ZbyFKHLqvJg3qIWDXT5QFBlS06A3gXQpCmVeMvNl8r894uvcm
        BsFlrd6VggnMOnQuEQxNWcvC0ZjXDew=
X-Google-Smtp-Source: ABdhPJxXBdJGKGG50iP93/cjFGcuXcp3NrbTn6qdrb5cXHxGvm+tLf/jDVBaPzRRf2otbMXXhR3urQ==
X-Received: by 2002:a50:d713:: with SMTP id t19mr9087842edi.2.1631281687031;
        Fri, 10 Sep 2021 06:48:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/21] trace-cmd library: Do not use local variables when reading CPU stat option
Date:   Fri, 10 Sep 2021 16:47:43 +0300
Message-Id: <20210910134757.2863982-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using a local variable to read all CPUSTAT options assumes that all of
them are in a single option section. While this is true for the current
trace file version format, this assumption limits the design of a more
flexible format with multiple options sections. Use input handler context
instead of the local variable.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3d7f1c48..dd7689a3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -138,6 +138,7 @@ struct tracecmd_input {
 
 	struct host_trace_info	host;
 	double			ts2secs;
+	unsigned int		cpustats_size;
 	char *			cpustats;
 	char *			uname;
 	char *			version;
@@ -2658,7 +2659,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	unsigned int cpustats_size = 0;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
@@ -2738,12 +2738,16 @@ static int handle_options(struct tracecmd_input *handle)
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

