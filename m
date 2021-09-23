Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6515CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 08:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E02D60EE7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 08:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbhIWI1P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 04:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbhIWI1L (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 04:27:11 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35BAC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 01:25:40 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v10so15912686edj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 01:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nk5YUxl5ePVQFo0HdRS4yBWtqwA/3OFa1SCTFH5WyNM=;
        b=VwUidgG1fyVAPb1I2N0dZWCPWpJP0k05yIEYxiLxRcVp74F9sNAnSPPRHbBnP2xwVq
         07VveXGFoSbFvsiEDXClX6C1piAXaUFUIhXZLOUdrg2szBCg07EUZcrNS9hUOLvRZKRN
         HeDvXQG4NSELq7lfLuc+vvhGNy12oKHCcUWwOdlHa/4X0ffAhHn95DA3mWEQt5UE0AVT
         8Wa40hlNqPZlNSiICfsnjIjHgYqibZL+LyBV4r1PsZIRDCfu7qdryugYmiAD8n5gXdwT
         YyeNBqA4OV8hhTnb6AcLGD37XXYfnXcHmE3nEvj/RCoSCUw3/qDM+eYkUQarxkTdsTWK
         +tIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nk5YUxl5ePVQFo0HdRS4yBWtqwA/3OFa1SCTFH5WyNM=;
        b=b6GOk+yJa4VU1KQPnuYyjGBtIUcP39tBcR0kaDl0lAOXyWvQNBeKUK+R8OY1jugAlj
         PWO5H6D1ewMpE88Kzf/0XU2fx2AR/qcto/mudafrFXZ0Oq+pRwy3FeT8wqjHK1HxM0k4
         pthRfQU6KYqwx4ZPrqdQXVnmJFRc0r10gvjTTFbdzU0eJ4CozoVjAKOd0Ec4Poc87qh0
         lHcLgen9zjyb70enlHwIpUy3MC4MSCs0snTV/GTEY4rPB/wx3ve0I2b+u/dIwQ6YPmf3
         zTOHDDbGb3TUoi9YZ3TEEuJlxqQfAaTVvDb5fDXB98XZ6KOGpUI8cdYg2Fxb9lYoHMRE
         u95g==
X-Gm-Message-State: AOAM530cVhT844nt5OH0yTj7y9LoIvWw8630WbSBuuqBllZImDJVua3Y
        GLXlCYbzUGOK/MEXWeTgHytxh7+qoWI=
X-Google-Smtp-Source: ABdhPJyGJ9n4wwd7L43rNwR2UHmXJvEFiJ8CWqvWIp1BPEYz9qMFMT8AyU6TUDWPOTLXhm2CzKI/YQ==
X-Received: by 2002:a05:6402:493:: with SMTP id k19mr4069581edv.386.1632385539082;
        Thu, 23 Sep 2021 01:25:39 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id by26sm2858688edb.69.2021.09.23.01.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 01:25:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Fix the class 'event' constructor
Date:   Thu, 23 Sep 2021 11:25:27 +0300
Message-Id: <20210923082527.81075-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The constructor must fail in the case when the event is not found
on the system.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 1fc0648..b5f031a 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -46,6 +46,8 @@ class event:
         self.instance_list = []
         if static:
             self.evt_id = find_event_id(system, name)
+            if self.evt_id < 0:
+                raise ValueError('Faild to find event {0}/{1}'.format(system, name))
         else:
             self.evt_id = -1
 
-- 
2.30.2

