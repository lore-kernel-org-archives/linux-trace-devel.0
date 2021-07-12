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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01052C07E99
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC7D60FF3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhGLMfp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 08:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbhGLMfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 08:35:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AA4C0613E5
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id o5so34290260ejy.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20o7DKK/6J3aD1OcuBjqhh3bybqLXvXGgkH4+mDh/R4=;
        b=hE8gECMCvXi7Tqt2+jILfBuJ1jYHAbjX6/zFyq6WCMXyG4KBs/u0E87do2IKrv4K5X
         W0LjG7dVG32JTz36CnGsMEKWt/WuaZ2NGzfJNzPWnnJrsdsUQVb65k7uOXes1FLx3vtm
         HG2uDc/+m0MXzS9ASxlJHyq0YcO+cqxJccFHymmz7FouagRtJSgGsrdaXcPsKfvJXuCS
         kWomBjA0YwLGh97Cdr5hUCb3BAE7Vg1FsyV7CM9hhohpC3BhnsxsOXy1HQ0HV9VashvX
         CJvn2eLNix27fwHk9+DEn9Ko8tlVa4IfRs6pFNjDtMOJL6ZHlVgIjpnJvAydU1vM9pXk
         8KMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20o7DKK/6J3aD1OcuBjqhh3bybqLXvXGgkH4+mDh/R4=;
        b=YzAZEXtbxctL96tib0yiFpjeqrrH50hea3HSURu54dUXtg+VqmC5WUyG74Y/Uy2Ac8
         i635WXQ6DJ3PmgdEJ5DJZ4fWXurqUGz9Ob8KHPnqfdSU6uLk89yc9+kBuN9VnDLKXJlP
         9xy5Ni0HlIdOGdYWshAnveSCcEqGkb9XWat6ZdsLUjRS693o9rY8VUwS9DEBiAYEk+Eh
         xWCTSlNO12p4uAgFqc61izKlzB/vky7tN7BbwvbH4M9kM9sw0/eQxe9pH1GNgEZz9k38
         aGa5HmS2ew9RmAJCOqxTrIOmEJbVJAyUf4slvdwCRSQF1P2Fh9tdTR5LEhQ6ZyP3HIxg
         Ri2Q==
X-Gm-Message-State: AOAM5308j7E5lqGxWa1/aVvGUNv8sJSevzSf3wxU44N9awLstQJ3lzRH
        Uci+Y7O8eJ9derteiNtxNuDqZJBMeP4=
X-Google-Smtp-Source: ABdhPJzTz8DuZgS9ggHmAtErt3mmAJ+KUHuOt3YJTYhaHFfLyLaTBkpzBm5bBkkfXLa3gXRJoDYdUA==
X-Received: by 2002:a17:906:fad5:: with SMTP id lu21mr53369759ejb.469.1626093173794;
        Mon, 12 Jul 2021 05:32:53 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.98])
        by smtp.gmail.com with ESMTPSA id z5sm6477473ejn.65.2021.07.12.05.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:32:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] trace-cruncher: Add local_tep() to utils
Date:   Mon, 12 Jul 2021 15:32:40 +0300
Message-Id: <20210712123242.223500-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210712123242.223500-1-y.karadz@gmail.com>
References: <20210712123242.223500-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The function can be used to retrieve the "tep" event of the
current (local) system.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 5b4f2f2..8c245b1 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -11,6 +11,15 @@ import ctypes
 from . import ftracepy as ft
 
 
+def local_tep():
+    """ Get the "tep" event of the current system (local).
+    """
+    tep = ft.tep_handle();
+    tep.init_local(dir=ft.dir());
+
+    return tep
+
+
 def find_event_id(system, event):
     """ Get the unique identifier of a trace event.
     """
-- 
2.27.0

