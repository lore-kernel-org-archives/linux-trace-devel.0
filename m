Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990BCC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C72F21927
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389253AbfBNOIi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:08:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53834 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbfBNOHi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:07:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id d15so6436352wmb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:07:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wX6Tb5dK6vOJarWEgtra+dhFLMjvVO6pzuwP6dVDh8M=;
        b=PcENor2ukB/D+MCxDLbuaNI3URHerp2dfYlNVo3EGhj0dxOBn0KXC53bq+UDvneawH
         DZN37fQ92CvygL4RTKGiKW6gptaQZC06+jol95kTqwAq6sP3vyY4FUBkXWmZ67Rh4dKk
         Ge6NvN6Lkd+eKgUXqwM6xfK0A3sAuouVnN5jcBEc9yPfhd+9CZ65uJDwIoDiQ5sFVmyK
         /TNsaat6K4KdWS+3fD05yJn0NczC7zqtoq9Xaugq6rC28brHmdENQUOI8m3joBVbXIoe
         67bJWr0EXvVbodGjWcXTA7IlHgMM60vx80vdgiNngxyWBGhMK9XMejcE4l8IFftZ9ryq
         2cCw==
X-Gm-Message-State: AHQUAuYeOiOOdm7D+m7rHzLnLluyA8g8B0H4kvOAfZWkqaMf7P3WFugT
        cpEc5MECilQE/4CN6fGvrw==
X-Google-Smtp-Source: AHgI3IazbQp5y1DHmvPh/OV7iHnnnQZihwf8jz+IR/dBDG8I4WPTmsrCI9MaZu9uKovx1Qdnh368lQ==
X-Received: by 2002:a7b:c777:: with SMTP id x23mr2989689wmk.71.1550153256790;
        Thu, 14 Feb 2019 06:07:36 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id c9sm2067220wrs.84.2019.02.14.06.07.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:07:36 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH 3/3] trace-cmd: Removed some unused #includes
Date:   Thu, 14 Feb 2019 16:07:23 +0200
Message-Id: <20190214140723.27804-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214140723.27804-1-kaslevs@vmware.com>
References: <20190214140723.27804-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch removes several unused #include directives.

No changes in behaviour intended.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-input.c    | 9 ---------
 lib/trace-cmd/trace-recorder.c | 9 +--------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b628570..34a8301 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4,22 +4,13 @@
  *
  */
 #define _LARGEFILE64_SOURCE
-#include <dirent.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <string.h>
-#include <getopt.h>
-#include <stdarg.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/wait.h>
 #include <sys/mman.h>
-#include <pthread.h>
 #include <regex.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include <ctype.h>
 #include <errno.h>
 
 #include <linux/time64.h>
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 1b6a995..0b8d98a 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -4,18 +4,11 @@
  *
  */
 #define _LARGEFILE64_SOURCE
-#include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <string.h>
-#include <stdarg.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/wait.h>
-#include <pthread.h>
 #include <fcntl.h>
+#include <time.h>
 #include <unistd.h>
-#include <ctype.h>
 #include <errno.h>
 
 #include "trace-cmd.h"
-- 
2.19.1

