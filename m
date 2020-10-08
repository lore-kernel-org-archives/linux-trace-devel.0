Return-Path: <SRS0=gEc1=DP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2FEC43467
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 07:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735C42184D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 07:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZmzeiNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgJHHTL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 03:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgJHHTK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 03:19:10 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D31C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Oct 2020 00:19:10 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b19so2338324pld.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Oct 2020 00:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Ss0sw8GDovY1a+zYdvLzwBLK0RhwrVb4WKYg5TdC2A=;
        b=SZmzeiNqZzv2D7FbKjSUAYbY+1XCfIXJ0E+mGvvQeBZeyOKbdzQxXSFAmJJT5F5EYe
         KZtyCaRTWr8DDntZrhzOTHD60vqQLZrEsx1+4aui228p1dHlW/Tj5TqfknluWcYcp7T5
         5DKJJMYcz88xhYU8Pgwmq9Ct7tuDItZbFWbt4FQJANaCaZPuLBlJ32EHwc9z/JA4iLVS
         /dKXQhjP0YEVMce+RoU1ArwSN5I34PaMIMwkSyMGIPCRKi//4fUPx5QuULzRJ3F2umHr
         /BvKQ/A5E4ZcFZP4X+gDnvqS44v6wz9tD/PAicyISNcbZzMyI8FgLmvX7+JfK84+fzBy
         X0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Ss0sw8GDovY1a+zYdvLzwBLK0RhwrVb4WKYg5TdC2A=;
        b=Lqy2uLH+BbTbuPZ25gIs/AmR+NNvnQe70qj8Q/y6mpq7ez1FcyPpOM+cuJhk611B6Z
         uwcuk2IhRABWbinNSWozIOTWdwth9jGxbE9nKmh7WE8RtJi//p+kJvS8gC2bBgD9Lgaf
         KYmGtm7r1Q/u7T1+PLxABKAUtJRQ8QfqvO/vOmMpxTAkVmB307md4sYX25QhOj2b7j/E
         bVVVriyeGQ/XTRfUeEcm/3TWsh7E5cckcp0UFDWhZ5R3oYJUINzqeUyZwd5B4h9Bkp2o
         lHEEWHJ0L9pPRjPrVCx8YV+wRbEwzL5aB2sAj+kvfd634rXpw0BrhEaTomvqAs26tL90
         356g==
X-Gm-Message-State: AOAM5335qokH0b+9JeHqAW2MqDE9Faoer+KTizchbI+GAghJ3f0zY2H1
        Ct5grm1xcitZITks7EzAYWW6WKVHw9kOWA==
X-Google-Smtp-Source: ABdhPJzKWAdAWG61cqJXoS+GDgM6ObvEp9FEVT/9C9tfbJ/TAFjGmlI+NkcBU3WOHKrQG+ggf6gV6w==
X-Received: by 2002:a17:902:aa90:b029:d3:b2d3:44ef with SMTP id d16-20020a170902aa90b02900d3b2d344efmr6339150plr.60.1602141550467;
        Thu, 08 Oct 2020 00:19:10 -0700 (PDT)
Received: from i7.lan (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id v3sm5414090pju.44.2020.10.08.00.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 00:19:09 -0700 (PDT)
From:   sztsian@gmail.com
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     sztsian@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH] Documentation: Fix include level of Makefile scripts
Date:   Thu,  8 Oct 2020 15:18:58 +0800
Message-Id: <20201008071858.96786-1-sztsian@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>

Compiling the docs with `make doc` will result in

Makefile:2: ../../../scripts/utilities.mak: No such file or directory

This is caused by:
* The reference should be two level up, rather than three
* The utilities.mak is missing when fork the library out

This patch fixes the first issue by adjusting the include level. And I
think the porting of utilities.mak is better to be done separately.

Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
---
 Documentation/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index aa72ab9..edb8623 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1,5 +1,5 @@
-include ../../../scripts/Makefile.include
-include ../../../scripts/utilities.mak
+include ../scripts/Makefile.include
+include ../scripts/utilities.mak
 
 # This Makefile and manpage XSL files were taken from tools/perf/Documentation
 # and modified for libtraceevent.
-- 
2.26.2

