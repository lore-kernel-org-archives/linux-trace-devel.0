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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AABC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802716101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbhG1Nd4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236707AbhG1Nd4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72083C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:54 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y7so1013284eda.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eo6zLuLkzcRbuJ7O8IqPRDekMMHxRWVRTqEW4ihh2nc=;
        b=Twc/AhRIGbkGp+0EvcY5sHEc9t7fl6xvXCMrMJiQBaW94rJO4IP2SALgzSekbR0jcc
         w8VIkmnPggMHsTFuIbDwdyu+VYAP7Aj9MWE8CD0hnZIhD/UOOCDjEtMP2lidUtbVNn92
         63QSFmAAMxO1+9T8zMTBpMTFE+Sf1cpGYtjA40I8308KzAVLME0geC3LVHlIaQtNnnnH
         ML9vKoqYw62f76uqtA16tPQXAo2lBKXWtTN3GazN+/aUyh55gt0bMUketSdFI2rVpwQT
         YaoToBzpRmptVDP/d3I06OKp06NFHrKEJGwrCOi4lx0XytcpcpqY+uoOM4ofxj0iAfEX
         +4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eo6zLuLkzcRbuJ7O8IqPRDekMMHxRWVRTqEW4ihh2nc=;
        b=Z6LnLld+JsV5yXAdvKxGWRQ7m2TZnNZ3uFpvPMdiZLMl8Cg/n6Wq50pfceHlmfy7UN
         ZhSboFKyH9xkj7r1AcXta+6zkdTLOr6PsIe06iUy/iovRd42P0y+KakpX3FlJwGbfrF+
         zLVrOEFpIQaol/LLA+bUs0OcarCaQursXtzu2P66b4SfDuxs2yiLclBY+ovXx8q6e+O3
         RMmv8AtcUcF49iO/qVv+bXDzwDzecD8y26RGD7oYPmeGW3C+2hoS5rak7VCljCoAiCCy
         BVcVut0x9EOpBu2ngMPufIflDfdjjdnst57Y6+l14wqImkP8D1X0A5V7Km/8OqhmSQ7M
         OwBA==
X-Gm-Message-State: AOAM533PyoObC7P5Cw4NS9yVgYHoLztImWLbO28Qzmw4C2kHhSghKta9
        uOovHPM7m/iHejCE9G1WS08otKbCGdeNSA==
X-Google-Smtp-Source: ABdhPJy3R+rGYFKNPKouVwnJ9oDIvU1pj0+EaBf3x5oq5xmGubSrqq2VCo8VcRVfvuhiZeMTCVUUPA==
X-Received: by 2002:aa7:dbc8:: with SMTP id v8mr33391999edt.242.1627479232833;
        Wed, 28 Jul 2021 06:33:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 60/87] trace-cmd report: Init the top trace instance earlier
Date:   Wed, 28 Jul 2021 16:32:23 +0300
Message-Id: <20210728133250.234140-61-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The instance must be initialized before calling the tracecmd_cpus() API,
as in trace files version 7, CPU count is set when the trace data are
initialized.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 3ebf580a..8f535d1d 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1217,6 +1217,11 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
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
@@ -1227,9 +1232,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
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

