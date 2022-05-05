Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2709C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 May 2022 20:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbiEEUYc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 May 2022 16:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiEEUYb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 May 2022 16:24:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8824D4BB8C
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 May 2022 13:20:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id m20so10777832ejj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 May 2022 13:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zqs6dOTavXrbebpquQbCfejC4BxNMMXYB3uSuaQw0/8=;
        b=dPVfmgnq2/7acDqouUV1SceE4/U/Sl0AwtyUXLlhGh90UUerRwWC7a6InTUxPandBe
         rq2zH0kjGfNVQSeJUDpmZ5VeNlo0cbKnlQFq/LmnUbP42ABhL8Y8s191MWHV2oMq+YyA
         b3uoacqO6rtnZ1r6cADwIpHnyDFRD6yLfsc2dcyHXB8gpD56F6t7G8lQJnryPB+sjyYQ
         4JOWy1LEVBd6+3odti9Hmwf3eQgIDAzpSgD1h14a21M4dl02SZpaLJcXZMUpo1TcGK1V
         RRD5USSg9ZdZd0Tc87pxNHRdTKgwxZCP9yc1cHdQYa224o/48uNlf1peTCzNM6RFfuP8
         iuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zqs6dOTavXrbebpquQbCfejC4BxNMMXYB3uSuaQw0/8=;
        b=e6OHRrmM8xf6gdBok3I/Hc/F8lwguPpQPQHAIzO9mnE1H1j6bDVheoCbP1m3hNGffx
         7ORW7D5/ntgFuWvtG/sluHHH1qT7Jtv/T12UXz/ca0qxaPvqQtsi89QLBcbdRRRlO4jq
         0kfQby5bxp94f4upDdtJcOdiWexbe9cl/QjPe2uebfSLzaU0hnLOHmvsOGWgv3ZzWMA1
         oVFTEvtB/J/JDlgH4GJJ26ZKaYcm+aUkPgMi5HPxu9O/aLqoVBR4OoUIyxCeSG+i9sey
         8yJNPBjJsF0kbMhxuDSV+7xwjH/BcU/FRzjOFBsTQpcGeI0aEmjVRhY/ojiJqdHuyzKr
         WtkQ==
X-Gm-Message-State: AOAM5324wBa8aYeJ5K3sPKVSwdR6f32sgdTzRWwcxcgTUAivMpAktMYx
        9wvW1KgGDDAWFztrUAmKWPSaPhjHm+9mGw==
X-Google-Smtp-Source: ABdhPJxYhcJFMVnGHgiwDTe8WneWOkHJjgC+8eiKDTCbdxuk2gJ6WBiAxNHpShR9gtzdIxf1JylCrw==
X-Received: by 2002:a17:907:a0c9:b0:6f4:bbdf:8081 with SMTP id hw9-20020a170907a0c900b006f4bbdf8081mr10547970ejc.257.1651782048928;
        Thu, 05 May 2022 13:20:48 -0700 (PDT)
Received: from linux.. (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.gmail.com with ESMTPSA id k11-20020a056402048b00b0042617ba6383sm1259052edv.13.2022.05.05.13.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 13:20:48 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org,
        tz.stoyanov@gmail.com
Cc:     Bean Huo <beanhuo@micron.com>
Subject: [PATCH] libtracefs: Remove one unnecessary quotation mark
Date:   Thu,  5 May 2022 22:20:40 +0200
Message-Id: <20220505202040.45805-1-huobean@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Remove one unnecessary quotation mark since this quotation mark splits the
whole example code two parts, and looks weird.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 Documentation/libtracefs-traceon.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-traceon.txt b/Documentation/libtracefs-traceon.txt
index 8f64928e3b60..28c79edb9e90 100644
--- a/Documentation/libtracefs-traceon.txt
+++ b/Documentation/libtracefs-traceon.txt
@@ -62,7 +62,7 @@ EXAMPLE
 	ret = tracefs_trace_is_on(NULL);
 	if (ret == 0) {
 		/* Tracing is disabled in the top instance */
-	} else if (ret == 1) {"
+	} else if (ret == 1) {
 		/* Tracing is enabled in the top instance */
 	} else {
 		/* Error getting tracing state of the top instance */
-- 
2.34.1

