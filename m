Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E528DC2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 12:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiAZMb0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 07:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiAZMb0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 07:31:26 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A17C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 04:31:25 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id s5so38610103ejx.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 04:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCxDvsK6oc+9L4sgNfgtCrTWxyTRN7lIZF/ZMGj4Ug8=;
        b=HnEJzRbt7UkWTzPcgaVzDsl93H81FzGGHeG41yL8z1pGxnpn2AvM2Qm7IC0UyrZXZk
         4tDYTJtQkcYxvYf2bcrBRuwrIYQTzJ668ljuDlkAGsA0ZvvSFzsIaxVOML5CaWcfGsMf
         4ARX1iLekC3tC7WhtHhfmKLjY9LdH4lRhBRYbv/Q2gXeGnxOzQCblLjIEwiMjtZlLaCR
         YZZWJz55oYnZA7Nbb6rTGK5KXE2l8oDzp43ZDi7Xc43UT4K4vIj52CqIBMvuUdOMm649
         Q+IvT6MTz0zj6bQ/Tkhdr4LPnKHCu7nAUNN1/PV0zLinoVwhLTu7ZuWmzO5P10XTmJJC
         n8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCxDvsK6oc+9L4sgNfgtCrTWxyTRN7lIZF/ZMGj4Ug8=;
        b=Th9sqP/Kqab8+mO8/KTTy2XAO8wTx6wOqjjbHgzLAEuwlUyMZhQVY/FZqmYk2RNv0A
         8mguOxXxrYqFGRO8slhFG8iD0+uGtl8wVjWra2ii1gROiInBJA8FoQtpDrhwQPRfR09d
         4X0luonhPim9znrRlXCdKcCF9BYiQxr/4JGnJ1zghQbG6QEJcCh/ow6RGseMe7fbea40
         xZrWhWSRlZRsfeLkINLZDjmJz3ReR08QUXQHIhsUd1rW/ps/tljZnUI30ltdeIDaUX3i
         mIMvMOdCzkGOKLBuOvZLbcJkJMxYg9t5KC33s+usSJb2ztN2K4K9HMsik07JmyyU6lZJ
         8wIQ==
X-Gm-Message-State: AOAM530Lj58r1i5j3m4sxT9OSVbhTgxjp99nqhVVy6KKZLwTSR5gbN5R
        7v6EGkD8B4RkbP5JzYakNoESRpVaeW8=
X-Google-Smtp-Source: ABdhPJxq0/sk2V1Obtp3YitHnI6KbhKbru+EYjvRhhqiXKpRCq5fLr6DPNpr1lp2pIyuOigpEtcxRQ==
X-Received: by 2002:a17:907:86ab:: with SMTP id qa43mr13058601ejc.215.1643200283770;
        Wed, 26 Jan 2022 04:31:23 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id cz6sm4315611edb.4.2022.01.26.04.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 04:31:23 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Cleanup in class event
Date:   Wed, 26 Jan 2022 14:31:13 +0200
Message-Id: <20220126123114.214956-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The 'instance_list' field of the class event is a legacy from an old
implementation of the cleanup that was done in the destructor of the
class. Currently this field is useless and has to be removed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index ed4bdcd..e1126ad 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -43,7 +43,6 @@ class event:
         """
         self.system = system
         self.name = name
-        self.instance_list = []
         if static:
             self.evt_id = find_event_id(system, name)
             if self.evt_id < 0:
@@ -61,22 +60,16 @@ class event:
         """
         if instance is None:
             ft.enable_event(system=self.system, event=self.name)
-            self.instance_list.append('top')
         else:
             ft.enable_event(instance=instance, system=self.system, event=self.name)
-            self.instance_list.append(instance)
-
-        self.instance_list = list(set(self.instance_list))
 
     def disable(self, instance=None):
         """ Disable this event.
         """
         if instance is None:
             ft.disable_event(system=self.system, event=self.name)
-            self.instance_list.remove('top')
         else:
             ft.disable_event(instance=instance,system=self.system, event=self.name)
-            self.instance_list.remove(instance)
 
     def set_filter(self, filter, instance=None):
         """ Define a filter for this event.
-- 
2.32.0

