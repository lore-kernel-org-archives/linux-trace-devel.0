Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067BEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E40A1603E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhKKPP6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbhKKPP4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:56 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14246C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:07 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v11so25491688edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y1DZI9vkFNa4Z9XGNeMzOagH15AKNe1aTIBjcQnDKcg=;
        b=a5tVrNuuxY2olvDpVi9vDEqPdv9JKhRM+dP/X1xvp0XuTafocuwpYqzGcyYYbfySGX
         wxiK7SKF3gRnm+XwJ0iEQy79RkB7/AYz8AL+9JOQjgcpz+rGmqZWlW4f94g/3ZZjMCAw
         z2luxPeCReLTc0jVFopAKoiHFqUrgH8vKG4VixYleUHxFLN4ycMauaCF4uQH0JgD7Cfa
         Zdcd9IV62Go15VQIZOjiIX8atq+ilninvSRd9YUp43Ml8w0tCsVvInWRdwmnEd9NcomB
         6WSow9TVL33IoyJ32rziqqcx765+AqflgZzFBRcLZ4lzK5afUB2w4uspn0OwSSRwFx9j
         CIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y1DZI9vkFNa4Z9XGNeMzOagH15AKNe1aTIBjcQnDKcg=;
        b=yniJM0LwnotLsCz+iFEtPQIcDdKn0zo3JGWpWGNcsjXCyDancZhBEJlrUvOX1pvt64
         DuS/I1SSfBSPW3uaNcGNqte7Y216bdo5qRk7RpY/Yq0NIfIzB0ujLo/lv2chE/OVSWLb
         xdIEW84VmAl6f9kDWt0lJwvmP5srwhLE2d1l700iprgLhJbrc4MlE2GNXpjpc51IUArv
         2bLF+43K+R/T10qEOezUL7TIgDEUcLCT8JFCV8me3XqAOo7/U4dd90/zFQGT1da6dBE1
         fk39/cKlj/atWUZROIPECw1QRXpTt9rhMeFxGaVBd7mdnchOChzItihdFBzdn5KDsUy+
         6l9g==
X-Gm-Message-State: AOAM532WwuIkxDP68ImEnozEml9oCCuSQ23yck+TIswEOM7epxBRU+hc
        9EglT26VsQZ8WhHqL1UE9jfp23e/+H+2Zw==
X-Google-Smtp-Source: ABdhPJzBxhCpqqV0qXwPs0WvTBL6pq+yJ/yugb3eSVFo7RxuQjaDHrebI+/r40aWAO5er8oz8h+RZw==
X-Received: by 2002:a50:e089:: with SMTP id f9mr10991244edl.290.1636643585635;
        Thu, 11 Nov 2021 07:13:05 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 10/10] trace-cmd dump: Align better the output of flyrecord dump
Date:   Thu, 11 Nov 2021 17:12:50 +0200
Message-Id: <20211111151250.87023-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
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
index 8986f9b0..9013f8b5 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -943,7 +943,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.33.1

