Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC5DEB64D9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbjFNH2c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243325AbjFNH2R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Jun 2023 03:28:17 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC27C2690
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Jun 2023 00:28:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b3f66dda65so9606195ad.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Jun 2023 00:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686727682; x=1689319682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FPOhwAo+NWTTOYPCJ+QkIDXC4vSx57EXIruSIr21QKw=;
        b=gjjz+Wng46Swi48UgOi0NEa1BvaWaSgHdraVFLEH4489/n7DNko0vLLhnFPQrYbbXz
         jP0NN0DcYphC4bX9efeHz6p8ntK2nO3qRp6pGfGQT3aOX5HkXleVzNhEj+FooItwnqv7
         /H5SNCYYagJibCbrHLoHUBW8LcsJB5afnCJtQPRazImyFa5/inaI5b7d0Tj8Otz60EQQ
         OgahjGEC+aTaJePJwJU8HA/6JT7YyouT4mKvDt137LjChVhzkMFCqWttaNGpOTqLE7vg
         4qxMdGjMMzL5jtLFZw1G6FRwxLeJG3M5LJbFyMUZLiHtwwG5GSQ9dAz84TjMm0BSOdWv
         M2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727682; x=1689319682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FPOhwAo+NWTTOYPCJ+QkIDXC4vSx57EXIruSIr21QKw=;
        b=WbX4kdqlQ8W4vNPYb04eDqFT1mmm5Rhcwp3Bg8gdgtolmbKkOnF2cnR6p0AE5UoTBd
         KaoR4MLjRvWEs3+u27JX/L542O5EZl2Mu/fLYfxhbvyRS+5nM3brnMRGWIhKlZoiL5P5
         EFOr2uTQeJzspZ/+Jf4GsebrChfgMx0ZpU072CBHhzyT9YeLEnjyZOITMaqex4NKjob3
         HP0niTst2/wO17GYDDsngX70UU4PVo1pAsbhDdT8sXHR5bSgv/AIhlP9vBeX/SUFVnGA
         dzkCioy2xqwVAQC07v9+XUg2XsK4ATGOjBEJAVF4LKp9MPciO8JE0GoMk0AbyU/wVUpX
         ZTEg==
X-Gm-Message-State: AC+VfDzMgSq+cOiwbcNAfxLYBnYtaU9oDGijbGBiA0PLmD3mqn/NxCBB
        +Vz9e79cpKP8yV14j5YcRzRRCQbDbog=
X-Google-Smtp-Source: ACHHUZ4R6JwX+cuymN3gKoxHIxyU+n3Lw/Ge1MCrYXPCjQyY8xerIOIvv8DtgubNxA4FPoc5pbiZrQ==
X-Received: by 2002:a17:903:2447:b0:1b3:bb30:d8ec with SMTP id l7-20020a170903244700b001b3bb30d8ecmr12253495pls.58.1686727681716;
        Wed, 14 Jun 2023 00:28:01 -0700 (PDT)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9181:d380::eb87])
        by smtp.gmail.com with ESMTPSA id l12-20020a170903120c00b001ae6fe84244sm11430521plh.243.2023.06.14.00.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 00:28:01 -0700 (PDT)
From:   Khem Raj <raj.khem@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] tracefs-perf: Add missing headers for syscall() and SYS_* defines
Date:   Wed, 14 Jun 2023 00:27:59 -0700
Message-ID: <20230614072759.316154-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These headers are needed to provide prototype definitions for functions
e.g. close(), syscall(), getpagesize(), getpid()

The issue is observed with clang-16+ compiler on musl systems

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 src/tracefs-perf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-perf.c b/src/tracefs-perf.c
index 96d12cd..62c1508 100644
--- a/src/tracefs-perf.c
+++ b/src/tracefs-perf.c
@@ -1,4 +1,5 @@
-#include <asm/unistd.h>
+#include <unistd.h>
+#include <sys/syscall.h>
 #include <sys/mman.h>
 #include <signal.h>
 #include <linux/perf_event.h>
-- 
2.41.0

