Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F62CC28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbiAZJx5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJx5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:57 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15E2C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:56 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jx6so37828752ejb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=agcjCdY91hsZPtY3OJa43Tz/ThqoZkahTKUJIAC9Q5c=;
        b=DBdZTWHhfSD2UVLPTRThEB7h+Woz2zQz6mEDkjlE4rek94B3f/WmFVT4JwPFKFIAEl
         RhgKQx0jfbDwKfjmisxAwPFJBDVIq3X1Sus5qmEhhYchqZxaXKxhT6S8KxXvyP1KtNHv
         XIM0Dyuw2mB4Fbu5euRMTJFWtrKm1tk8ghjSDRGixR3Iy/oHx0M9Lury5rn75xMn4AOH
         ZqCx4pNGFapkpJQ2f82A6INBxMzLay0G4i1JOV3peUQucIbOzP8o14fYHGXVcarePqXm
         BRwCyaSGUC4GlSKlhona+nsu79Es+q6bdO6DANzQ3ugXtHA2bU//NUDLiLusislsh67k
         Z7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=agcjCdY91hsZPtY3OJa43Tz/ThqoZkahTKUJIAC9Q5c=;
        b=I1hfvh0dlBCp28W8YV3EdiXv1oSljb1n0u4pfZDtVsO2ZtXoge/2T03vCOEGusmf1h
         b72taskgGOSstWqBPKD0OQHLFMm2dc2yO/SOD52i7jINWtLqB6C/dTWIHJkYvXJgyD4Z
         TBywdC3AegjIienjLWbERPnF4EotnNUvAt8wbA2C05p/ACK6Yzaci/vaZd9Aeqorh38p
         g3XTatjPjWlIlkNXCRXHQTLg+hj41JKED7oIcOLu/PyYDPP4StTkZJxed0KORnfrbAqd
         9k5d1PuUsQMZ3QxSAAVIAegYiA39Z7lpbtXqYmICeBi+rk/8n2JA07q4Lgm9twvQ+3JW
         grxQ==
X-Gm-Message-State: AOAM531pXutN9ebl6iqNJEQbMecix63PX2RmFStKawU6u/YIE70+803X
        CaEkVTpPPFtnVWVS3aOb7pA5KTdj8fE=
X-Google-Smtp-Source: ABdhPJyrsETWB/GONJW246Ks6xl3l9BYqcRqdBbafHIj3SyOnsw3WqUQREWATIg6KW37ytdpTUmyyQ==
X-Received: by 2002:a17:907:7ea8:: with SMTP id qb40mr12499990ejc.541.1643190835522;
        Wed, 26 Jan 2022 01:53:55 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 11/11] trace-cmd dump: Align better the output of flyrecord dump
Date:   Wed, 26 Jan 2022 11:53:37 +0200
Message-Id: <20220126095337.570867-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The flyrecord dump prints various file offsets and sizes, that can be
huge numbers. Add format arguments to align better the output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index d6efa425..7ed86f61 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -980,7 +980,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.34.1

