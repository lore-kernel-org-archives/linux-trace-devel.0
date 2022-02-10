Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DFDC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243011AbiBJPX5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:23:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiBJPX4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:56 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8A2EB8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:56 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id f17so10270042wrx.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uCrJd0Ws/m8jmTH6qFiWfjrFrrTs7xzsnGMHn5kmPvI=;
        b=peYFBZucnjgUXxsD2a15Rw1PBC+/uFXA0lyBWv+vAfnRmoA/BKQXXQN0CPrR5yQ85m
         B9hEovJ3BBP0eNkwoxlk5jetAlpoSGMn1fosuUbkySnxSJU80/8YZNX9S9X9Li5De+o7
         A5vsFnNKSchUZxEJmq7T+dICXHzKbKHRRj6FzyFqvjX0cOlds3S+6iqiScl/SeezQFWw
         9kUXeVUQCQKkg8oH81OLcJnupZqEIG+/eClgPPuGsnpZVxpAn9X1Kyo34DVLeBJVg9Ki
         vIEiFvXuh2hfFnbeQ6O+B7qgjP3+T3IL2ymbXnQGqLsxQcgsaNGOvQetO10SAI7/sWGt
         W3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uCrJd0Ws/m8jmTH6qFiWfjrFrrTs7xzsnGMHn5kmPvI=;
        b=WqPQ8DWU8MsFzKpMhMIOXK4O0YnwaGjRjPOO/w3Bf9ikL05SznaEcbhGNfLf/XWmI5
         jiUdEDlAli3LguCOYyeevVAI8KdMDdiqfYiyHiGZ8HfXaiYfnVHEq1icjhkWSbufZcZQ
         qI/oNvn2c5X/nPZSBaAsrWNRr9g1uIP4wF0QdHKyhXcyUD/WUhN0a+Rut+Qf79EsxAhC
         +JYvjgWvRZMufcItiY9UhjK0CIj1O0gxemUSBWDgd0f82GuwNDLTrHTiZ0vZ+qeSsOwB
         Dsgy4+oTuGPRFXEAq3f2yDrZV1wOgtG31HSF6Im8HcSqr0E0iKO+EnZDUoCcn08GzHJN
         6XCw==
X-Gm-Message-State: AOAM530ZayLK3+8sZHEh/0Xh8RjSpqpZefxwEPhOMToqGaa+jQyww+n4
        6Y3iQJywHmd3pueVCZiS22pJn0w28ss=
X-Google-Smtp-Source: ABdhPJznXhHSL9psgUIjIyv7VT5Jb8Vipa3gczxDu2mPJZ2FayuC2v9D5P5jCfUB/HJa9jLcMpaHFw==
X-Received: by 2002:a5d:64ce:: with SMTP id f14mr6645475wri.208.1644506634595;
        Thu, 10 Feb 2022 07:23:54 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:54 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/8] trace-cruncher: Fix bug in the constructor if tc_synth class
Date:   Thu, 10 Feb 2022 17:23:33 +0200
Message-Id: <20220210152339.363943-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is a missing argument when calling one of the low-level APIs for
synthetic events (add_sum()). In the patch we also add comments, in order
to make this part of the code more readable.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index f4d1f05..7e0e642 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -357,6 +357,8 @@ class tc_synth(tc_event):
             for f in synth_fields:
                 args = f.split(' ')
                 if args[0] == 'delta_t' and len(args) < 4:
+                    # The expected format is: 'delta_t [name] hd'.
+                    # Arguments 1 and 2 are optional.
                     if len(args) == 1:
                         self.synth.add_delta_T()
                     elif len(args) == 3 and args[2] == 'hd':
@@ -366,15 +368,26 @@ class tc_synth(tc_event):
                     else:
                         self.synth.add_delta_T(name=args[1])
                 elif args[0] == 'delta_start' and len(args) == 4:
+                    # The expected format is:
+                    # 'delta_start [name] [start_field] [end_field]'.
                     self.synth.add_delta_start(name=args[1],
                                                start_field=args[2],
                                                end_field=args[3])
+
                 elif args[0] == 'delta_end' and len(args) == 4:
+                    # The expected format is:
+                    # 'delta_end [name] [start_field] [end_field]'.
                     self.synth.add_delta_end(name=args[1],
                                              start_field=args[2],
                                              end_field=args[3])
-                elif args[0] == 'delta_start' and len(args) == 3:
-                    self.synth.add_sum(start_field=args[1], end_field=args[2])
+
+                elif args[0] == 'sun' and len(args) == 4:
+                    # The expected format is:
+                    # 'sum [name] [start_field] [end_field]'.
+                    self.synth.add_sum(name=args[1],
+                                       start_field=args[2],
+                                       end_field=args[3])
+
                 else:
                     raise ValueError('Invalid synth. field \'{0}\''.format(f))
 
-- 
2.32.0

