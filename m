Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6010C4332B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 11:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED4364FA3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 11:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhBELPv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 06:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhBELNg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 06:13:36 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D740DC061786
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Feb 2021 03:12:45 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id f14so11306966ejc.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Feb 2021 03:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0wWA1h09kJdMvbiDKPmRr+sxLF4/yBeI5bX8gZNc81A=;
        b=hrCoYduUE3GSybjHiTSQvvFAyDRXm0B59klNKfod4d5+QYEjrQlkZaIBHXhvHFX+WG
         VvomBdi8ZqDsAMN4CyAvO+iQRG1CNSoVp0/CBuSYkQA6oGWwyHlb9BBo0Wtp2vYa3cTV
         HalTfmNy12/8cJQF91aFXb8lSJ4AloMcIjU3QNgsaXux8Awt/jSk/hUHz9rYzR0wrm5Z
         JRBii0hgzatGvyr+yq7ZbKEimkaWiUQi7X6E7GZyXXcYF/ouWzWpPDHi6tO55gxbJ9Om
         1hbWz54MYFg8n8uYTRYk31PLh1ZzTaMQgxefBfUc8yaQw+0/EhixDvOq7rbQYG/3dgCm
         iPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0wWA1h09kJdMvbiDKPmRr+sxLF4/yBeI5bX8gZNc81A=;
        b=k6ZDcUHinJeqfEiTFjlbMZNxAnF1nPqDc/jZHcgrQ32GxcyAGWpGEjNQL+fNYQFCUA
         ZN0hcWA4wGvZHbrTepufqs8eQUtDgHdllcjsTnyb0UO4jEyNwCI0MSix+78fj/IIHi6A
         Vr5GqioJlgF+MrYMuEfMUVtQAx4v25J5mOymBJpLN5IAX2oNri2teK5mv7V15VPtClsr
         9OfvNZvHa6d06+y+gWmtG36kJjzOmf0GhnEoXWDEj/C0IvrRNQrPuW/rcaV0tuByKbGB
         l2EYhT5FsOQL0wBA/r2fiDbuZvV6xGF0260yS+DrzEAL0WtUyNylGMYcqML68pWrmQAc
         T36A==
X-Gm-Message-State: AOAM532C2EOJWi8zTCBlsQ6Mh7RF4dhwmkEYesnoRw3fp86ClKS7tMs2
        0UFNzRm+5MmiM5lxgkLJfdo=
X-Google-Smtp-Source: ABdhPJxSui/MV0S3GSS3SHOqfcxz9lOdDKxI2IvGu7P+zXj2hjY5Bnft5bkqUHuPRBlY87sv/bI4sA==
X-Received: by 2002:a17:906:f102:: with SMTP id gv2mr3496917ejb.47.1612523564564;
        Fri, 05 Feb 2021 03:12:44 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k4sm3801581eji.82.2021.02.05.03.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 03:12:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] =?UTF-8?q?kernel-shark:=20Fix=20compile=20error:=20?= =?UTF-8?q?=E2=80=98string=E2=80=99=20in=20namespace=20=E2=80=98std?= =?UTF-8?q?=E2=80=99=20does=20not=20name=20a=20type?=
Date:   Fri,  5 Feb 2021 13:12:42 +0200
Message-Id: <20210205111242.57557-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

There is a compilation error when compiling KernelShark on Fedora 33
with c++ (GCC) 10.2.1:

  src/KsPlotTools.hpp:349:37: error: ‘string’ in namespace ‘std’ does not name a type

"string" should be included in that header file, as it is a direct
dependency.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/KsPlotTools.hpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 1725926..68bd6f7 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -15,6 +15,7 @@
 // C++
 #include <forward_list>
 #include <unordered_map>
+#include <string>
 
 // KernelShark
 #include "libkshark.h"
-- 
2.29.2

