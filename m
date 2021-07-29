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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A22C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D15A61019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhG2FKJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhG2FKI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:08 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E64C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:05 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qk33so8384967ejc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=GlRHrB86tPTtt04xkGdqGyNcpHDEE8IM3snaWVu3pbpzM2XoK+ql8n1DqSfnUiruSZ
         YZnczuhWu7d52NbVAQQlK+hwlk+TuWL7wxDswUoOPlZJTljp5snd1KrDQmVSD3UhboVP
         XEjMjh3jjk9uq6vgHLjJpCTwUaW7/cQZGGWq81Zj4zV4ItVL5i7s4e3xeiy0aCl72QlY
         Tc2eXiyjuoGlquz6z0PRkq6nDNF/+T7PNub+jp+KMXGwuw7aQHNP9zQ7SDTO4GM1o8m0
         IqXDUDofmzJjSm40KBWdkvu3EYEGbA2DhJHs1iKBpWPLt6ajkdesif+gKNQE3han64DQ
         j8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=XiR678I47KHhHnlwm+UKo3tjL1Z/ct4Nz1+xcY7EOBNLtBlraNfWI24TNzWp8PhOvz
         5hn1m3ag5GFGFpzI1pa+520xNQA+tzKEk2/7BjWdO5D4VwVaXAxJk8ajDiruGB6eoyrH
         JZdnxPwHUCAqsbH00rz4uhUuljqeRXrOSsdU77v9pxGJGpdxTfjdka6g/fwtkpbRl7vP
         JY9nXuX2fKhidBqF/ix/iwJrkPnocE3ouk0okH33RzfHMunuo/wJ8PMCA5pGDHHP5ixb
         b6SnzEZPGV0S5vJrTV05jZLXfK3hDu2IBOZ0O/6r+eJHBaZvu2lYAai7fwjQaY8WncJu
         9M7Q==
X-Gm-Message-State: AOAM530/QKdf3VxTTPu3QvSXUb7b1cNdNAhShpQ0Ix87pzMbQpyIzwCv
        iBWmSWOaU5UPUbYDFTkyzpA=
X-Google-Smtp-Source: ABdhPJzpRo5rG+bfYcLhmJ/lCAWKgtZLBEdW34iYKD2Ad+90jnBHrJnAX12UedvsibI8PDNn3on0rw==
X-Received: by 2002:a17:907:c08:: with SMTP id ga8mr2923027ejc.318.1627535403726;
        Wed, 28 Jul 2021 22:10:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/87] trace-cmd report: Fix typos in error messages
Date:   Thu, 29 Jul 2021 08:08:34 +0300
Message-Id: <20210729050959.12263-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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

