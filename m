Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8912EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhLBMXS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357749AbhLBMXR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:23:17 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A757DC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:19:54 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r11so115160079edd.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUURCaGEjddxuJgQH+dVuRGuZ4vzCzBHUHJV3elCtsk=;
        b=gcRF6e/SddvnnW9Gq1kGx67oZ+XBGrPR1v7vvIbqZtUQd6eCwYUEePuzJh8w/j5IRm
         sAqXDB829e33kQIw94ATibhk7NChsqGg2SPVjH8IaiyWVNyeS5Dk9yOOHiC2I+wkBB6Y
         K3hEanhInLBN7RFNcH3ZBj58r8jSdb17T2h6xwpVi3XxSOXMh2PwCVLPcIJemwshyqVb
         0kG8ihY3bf7NFacOhkPePJcIVzrpuj9qYJzGoZ+zpr/YwEQc2SzGOppsg+M6AOpiJSNq
         aUrT6P5TN3mGoYg7/NZEnd+MeGhRJwLRGLwGyZJd3yWFXLIKz5kzTW+wDLkfq3WiIwD2
         iwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUURCaGEjddxuJgQH+dVuRGuZ4vzCzBHUHJV3elCtsk=;
        b=Z5SjZKbicmhOKIyvQTES3X/cFd7kQYbiYuXtCHkKGxMaZjiN+X/ezamsDgLo9zxK5S
         42YDWN7SzpV3mGHu39QEHJFBzovMtGPUPFXguOV0qbceW517uetFUBcRLeS3ZySbys/+
         QExaO+4DnUAZe8Gh6A3f1vKCD75lr+f8q7macx9hlO8sKrKIGlFaBiZY1LUTpiIMJIco
         EmMHr3CDP3Uy0vq3REc0wcq732b2jgp1iB7OkeIdt4cYJtNd8rWnIjBCSLCMWtiP4h6L
         Le1Hc52MR+sHUF0msIIL523kUn5EkzFJ3PgcgvlA4y9Km5Py5CB5zrE4eG8BTeJtYHkX
         SmmQ==
X-Gm-Message-State: AOAM531qsjdTHbCo04AeTJGmEAPHZTiw+MXMoIDDcMrdQhQtKeBMKIDQ
        jWanC+JaYIlkCiC83+5jFScvTnezQ1R73g==
X-Google-Smtp-Source: ABdhPJyR3vgORLiiV16WX8W0xb2zIFXabOUpk62tDLtae16B3XoQ10CYbEkhlPJX0SROERvFum8cGg==
X-Received: by 2002:a17:906:794f:: with SMTP id l15mr15666075ejo.324.1638447592263;
        Thu, 02 Dec 2021 04:19:52 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm2229019eda.13.2021.12.02.04.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:19:51 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] trace-cmd library: Fix typo in tracecmd_output_set_msg()
Date:   Thu,  2 Dec 2021 14:19:45 +0200
Message-Id: <20211202121949.43084-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202121949.43084-1-tz.stoyanov@gmail.com>
References: <20211202121949.43084-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed typo in the description of tracecmd_output_set_msg() function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3eaca3e4..31f08751 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -941,7 +941,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
  * All subsequent calls to @handle will send data over the network using @msg_handle
  * instead of writing to a file.
  *
- * This mut be called after the handle file version is set and before calling
+ * This must be called after the handle file version is set and before calling
  * tracecmd_output_write_init().
  *
  * Returns 0 on success, or -1 if the output file handle is not allocated or not
-- 
2.33.1

