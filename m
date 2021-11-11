Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFD6C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDFB961108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhKKPOH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhKKPOG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:06 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC9FC061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:17 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id f8so25636761edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrlXUlSZ5wVZqbKe/8Rwq0VH5FrWsOGk7IpQZ2t42kM=;
        b=Bml6PkdO1UdMIjvV/tRa+JdUzCm9M0Z4HgZDxJiCOoj0dIfwpaEu0/mDarKSQZFkwX
         x3OS0wyks2crPpuYUZ/dmVUifGt4/RKR5cIhgb053X291GLoAOTb2qffv7dPDu3aFkvF
         dMWLV2XrozBG6rb1/0Eb+3/FOGeAJ9r0b/a83rI7n6A6nDg6zqVNPPSSCq/jrCJZ0FQE
         SWDRtCPJmgOmgOSUNmiohQOmcxRzOI2Ziwr0v76KcIDj5Ked1xI7Dy4Ox5sQTaEqrw81
         XE5p+TcMv/ErjOJAowG8kCxwjJhvL3u9lmPHaZ1ObgFRBH0UE8dwWecUC3W/JLZx3XAK
         ZU4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrlXUlSZ5wVZqbKe/8Rwq0VH5FrWsOGk7IpQZ2t42kM=;
        b=SyM4SdT5lIV1gaDsgHZjkmcjaDIz9n0WlwCQbvL2YpUGRUTbQNORQEj2h6wK0+CElv
         rIB4MCIB9SXLAMIIyRWJsFT8nga9OWlkrFZl5VVbAuSgu5V5X2nh0MxFcs+QDdN3Vekr
         2Vca7SOydwrsFuH87TAMjuk5J1A6JK9bVQxe2YCVLOsQENC3sBMQZibmwXsDPpVVGcZu
         6G7BHfAOkT8Ve2Gc8gAmy7gDwRxFwRXVLKnqIrGPf6Y8jgQikI3C1boeTc/kFDfo9saa
         ZKmHBTnWI7UDMH2rKaGvi8LALsUnBd282msfrrXxvv/X8dJ2spX97saTuixoOcTJR7aw
         /qdg==
X-Gm-Message-State: AOAM532KCrJrVUwGheP0Gk0nAFPaPh4xsmKsPpHv6RHlRYGdqM2VR985
        AL1GKqNAZTjyqIg1xvBHOKW/xFc8kL9lZQ==
X-Google-Smtp-Source: ABdhPJxVD2ZiI3TkYgmwYfzYHK2f6JeRLoSco9F2BWL4lcu8+5KORCTeW0PItCRp+qejNYkpixE17g==
X-Received: by 2002:a17:907:7215:: with SMTP id dr21mr10087360ejc.505.1636643475723;
        Thu, 11 Nov 2021 07:11:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nc30sm1648803ejc.35.2021.11.11.07.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 12/25] trace-cmd library: Do not write CPUs with empty trace data
Date:   Thu, 11 Nov 2021 17:11:05 +0200
Message-Id: <20211111151112.86751-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151112.86751-1-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has more flexible design, which allows to write only
CPUs with trace data in the file. If a CPU has no recorded trace data,
do not put it in the trace file version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 028ad580..2ed7155b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2079,8 +2079,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	if (i < cpus)
 		ret = -1;
-	else
+	else if (size || !HAS_SECTIONS(handle))
 		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+	else
+		ret = 0;
 
 	for (i--; i >= 0; i--)
 		close(data[i].fd);
-- 
2.33.1

