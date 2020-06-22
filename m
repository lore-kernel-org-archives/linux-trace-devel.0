Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A077C433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 285F620738
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlHhyOdD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgFVOg6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729349AbgFVOg5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:36:57 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6553BC061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:56 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g1so13836194edv.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A6l75NK06Izb8yX1WXCambthpJ+ICPJQYoIL3HRlq9Q=;
        b=mlHhyOdDq2drU/PuzLsmujRmhWN76NpxJHY6oHrgTFq+4idsAJjRn0SwL1RAXf1yCm
         Whl6Y202CletL1is/I0CAuAbGanZSHRN++mP8JaERaskMrEf6TGzZeanI1D32gzk+z83
         QkVgM/v3v36aa618SvucDlslPb56PaWauK5BQ+9TP71Pc+30t6Zjfo6X6Q28sXI782Ln
         lzl/isiZXFlGJv31oUy1Z9l5jfho/BXPGdtS4xPosD91DFJDVEo4VWuIcuaM3rSMi8cN
         qPSXD/n2JWNxnaT83qdj59PZ8BWjpNCwN1vmgng0Mnxk9zjQCAMpHNLnbKnP9V4FE17B
         BtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A6l75NK06Izb8yX1WXCambthpJ+ICPJQYoIL3HRlq9Q=;
        b=V0HECXVhlBgKqMUCFgY3IT6zvorWJ87pnU4MURdRm95Lpiw+1u+WKW/ryNY3JuLHJy
         cknqUpb4UpM3SgNR/rcw8Uvcljh3tBUK70QwvYWQzfw/q9CbU8nYrZsDoagkDX991hWA
         SIe9iUCE7PwBMEDmmSw9g4pXkMxy34jcoSG2YTb1iWasPMvX7rlRNVHNtmoDCUItZd3F
         p1z0DjxzAmb/iPXoVlQBSC/zyCY2iuq1QdMtWz0huD8anyYVRPqppKjhPJ19uuL2ZW+3
         MC0t3XY9Eh/E8IiOvPZORDTiw91O0vwkEW1JJyxU9V65ki8EYiWaq+i3MoGOpYnwzYX5
         0pEg==
X-Gm-Message-State: AOAM530R5X350zUw5QQY1dYPj9KHbHaE7sv4/WX/BO/70D9dxiC8b4Gd
        6ZWw4s2IB7F+aNYDJuFcu5vc0olG3CA=
X-Google-Smtp-Source: ABdhPJz4Ff0mzmslhBIvBK0egxI+AUi7mKgqtG2FhXvsWmNjtwTGzEdQOOWEjEqmMqW5VD1pe7okCw==
X-Received: by 2002:a05:6402:642:: with SMTP id u2mr17149483edx.230.1592836615118;
        Mon, 22 Jun 2020 07:36:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z1sm11810259eji.92.2020.06.22.07.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 07:36:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/4] trace-cmd libtraceevent: Remove unneeded semicolon
Date:   Mon, 22 Jun 2020 17:36:48 +0300
Message-Id: <20200622143651.179674-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622143651.179674-1-tz.stoyanov@gmail.com>
References: <20200622143651.179674-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

Fixes coccicheck warning:

 tools/lib/traceevent/kbuffer-parse.c:441:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: http://lore.kernel.org/lkml/1588065121-71236-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/kbuffer-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/kbuffer-parse.c b/lib/traceevent/kbuffer-parse.c
index b18dedc4..2c5f00a9 100644
--- a/lib/traceevent/kbuffer-parse.c
+++ b/lib/traceevent/kbuffer-parse.c
@@ -439,7 +439,7 @@ void *kbuffer_translate_data(int swap, void *data, unsigned int *size)
 	case KBUFFER_TYPE_TIME_EXTEND:
 	case KBUFFER_TYPE_TIME_STAMP:
 		return NULL;
-	};
+	}
 
 	*size = length;
 
-- 
2.26.2

