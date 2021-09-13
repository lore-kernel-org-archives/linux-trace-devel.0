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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEECC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9122060FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbhIMM3V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:21 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0ABC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:05 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso691311wmd.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=ULrrbclgz9oorj2mMmgYlEAF+g6T2b6eT7r26V8hlcuoBLDIR/O/hrLgkjFVwm8tyu
         sMAWNDclfcYTcAYOXM4RueAq5huXHfqoiX1fIOszDWXdDcwo3YwW6dme3qreCd0Xad0F
         AtwkrOZI0AS3kS7tJyFrUJqVb91oa75RjiHLXo/Sfk9wT/fnn7+g/DYvjQjKchDWo21y
         mkGcD4xbSJheditpGMUXQ5DETLuS/s+Q7ZPjk4DocogpuT5hVHN1ENisFjQu6lmmMqMu
         4toAU5HbiUBxJrliB2tpVCfSDuk9++Yrdw6I3cbtzVymkb8YihnMDOGM3lQva4upv+uD
         PZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=0OaxxLscvF69ZCImo2ZdEmeK5XafWK+F1WmGqOi5LZT7eXK4gY+xdAs0sUi/wOhA5S
         VGe6eG2sYVFC3sqcBZEFxsm988Z9yHvDwBO4KD0pbjgVAU+dNJ4WGJ6d1W5ZDp0hRQEq
         HY23Vm3DtEjh5s0H/HQGvGhWoMMdBrWKjVskglzZexD+2+H141ia2dXMP1nf9JOG+oas
         3jIEqfBbsbeT47ACcu5f8Pp1xNkQASj7gqZCjnanqGqC0KoZTrq2iskc4DF4di62PRpn
         l3cNXsuZzp6U1y1IPJ2CwkvntWY0BSIeGTUbYGwq3iGLK/vMobtxjatkY2ZGK/coXb1g
         iJLw==
X-Gm-Message-State: AOAM531b2+u9YMEvTiGZXw6DLLOk+vQbu0+mTfcZrDdYFT19bBKPQoXl
        Bg7k2yDWj39rmvi7fE9PZIeOBSuFs9c=
X-Google-Smtp-Source: ABdhPJzkpS1u7dyK0GMTHQWuFHn8DRE5866SFpxF1G32ViG5DwjbZP2/4gvsXdB9RaX4doPaw8H7kw==
X-Received: by 2002:a05:600c:ac9:: with SMTP id c9mr10742955wmr.14.1631536083784;
        Mon, 13 Sep 2021 05:28:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/21] trace-cmd report: Fix typos in error messages
Date:   Mon, 13 Sep 2021 15:27:40 +0300
Message-Id: <20210913122759.3672494-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

