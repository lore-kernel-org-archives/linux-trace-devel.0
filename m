Return-Path: <SRS0=8sQt=C3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DE1C43464
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Sep 2020 07:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A57120872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Sep 2020 07:16:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rEp8f2L3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgIRHQI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgIRHQI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Sep 2020 03:16:08 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF97FC06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Sep 2020 00:16:07 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z1so4509157wrt.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Sep 2020 00:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GPgX2cIvWMQ2HZ1qSSQbo1WvupYZwVXdf3kh1+9tuJA=;
        b=rEp8f2L36nXEQDIvEz0jOqUzEmt9tvkvXnetEVFmi1hYIiBly0V0k/wJSW9sihpHji
         iu/GJajeu0C5l8EtnyVRpaMg3Gus47aneOtoTmRRr8JaoYF6Vq2vdbj6b2vi4/5mLJgm
         FP3lE7M84qU//CJ2WZi4LLwOWLzO5kGOzCPB09P+uyFJgvezujywq22gSugGKRJV+bNx
         hXv+XKIX+tYeXT2SbtKgbu6z87FtxPBSlLC2J36jjk5ZybtWFswq7VbA3cYPkQlBW3cr
         4dMUw8gWlEM+R8Zul/BQs2FAId7EHkDCWlnh0Q92zZuftrZDtCgJQrGgzWnYIViO54kn
         2Mmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GPgX2cIvWMQ2HZ1qSSQbo1WvupYZwVXdf3kh1+9tuJA=;
        b=Ugc4sJ4bMEibK3HD/5PKOfCuxoRPOEFkxFtSQAehQs++DeIX7fB4uAcmPKZxOu6q0g
         N0/5ILqkBhiSGOBwm32eK6fuzq8ZjaOkb7gYU7Xzn2klzlrp+xUV3/PDojFEeLco4ns4
         7Ys6oj+riWR/Y+fD/pf2kUIe5RL4x56L6z09uPA78fvcDhuEbTFWosf7pTsstlBskYgZ
         w1MtpXcNXcWZ2+BpkaKkYjRZI2qY6KECEakI061b5l9K7GkFdIBGnNB7QK6kfWDC6j2/
         87q6u6qHdoQ6uo1D1ktKPwGEkwhzwwPZJH5t8PntZiRgFBxLIxewAQh+I9KQ9FyVNWBG
         ZTPw==
X-Gm-Message-State: AOAM5311GQs4611gasDOOOfjR9y8pNXMo5LG2wQu2gRcUT6nc6fnUlgy
        FrmOJGdb7QdVAA7rMHPa5Wcx7oKip4z+Vg==
X-Google-Smtp-Source: ABdhPJx6xEbdCrHlQuWyIjjRbhd0GN1uV2DeEIv+LBuMP90BbqnqGGHXXrHC4V+JJpT50LPVTTB65Q==
X-Received: by 2002:adf:e601:: with SMTP id p1mr38949495wrm.172.1600413366280;
        Fri, 18 Sep 2020 00:16:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j14sm3769488wrr.66.2020.09.18.00.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 00:16:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Change tracefs.h include path
Date:   Fri, 18 Sep 2020 10:16:02 +0300
Message-Id: <20200918071603.597501-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs.h file is installed in
	<install_prefix>/include/tracefs/tracefs.h.
However, in trace-cmd.h it is inluded just as "tracefs.h".
When trace-cmd.h is used in trace-cmd build context that include is not
a problem, as all local header paths are described in the Makefiles. But
when other application uses trace-cmd.h and tracefs.h, installed in the
system, the compilation fails due to this broken include.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f3c95f30..3c2b4745 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -7,6 +7,7 @@
 #define _TRACE_CMD_H
 
 #include "traceevent/event-parse.h"
+#include "tracefs/tracefs.h"
 
 #define TRACECMD_MAGIC { 23, 8, 68 }
 
-- 
2.26.2

