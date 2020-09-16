Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C84CC43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED50820771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UuIizSc3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIPGup (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgIPGup (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 02:50:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25928C061788
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so5653982wrn.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xljRxOswziSj96hf/7PT4i2JmxBjSbGMgID4XBhpHfw=;
        b=UuIizSc3fpnyUevOMpcR7oVHcWASVmpnmlCmxOik6dC3K9+AKiy3ifUuugZebvbwe/
         4lkfwu3cJAYylx/wiYb7jw9qNmLGZjvofFdhS5EUwLS4jPWvE7t6q7cljR8krn6TPhh5
         MB0FmhYwKJBYJzom0NlsP+bnswVx43C5QPtA0fs4H2dNsTYtKHC/1A9uHUMDeKgCKBeZ
         VBDYnqO+1eVl+Pmgy8gB0v1OJNW9x9DidFt5Xcqwr3mqjU2KfkfGddxiE5KIfan4QRFn
         Md1o2OWBd+jPkNpeHlXG3qdRt6t1xYTGCM5U4N0H1NJC/8X89IYHtwv42FTAo5+hYyRg
         mJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xljRxOswziSj96hf/7PT4i2JmxBjSbGMgID4XBhpHfw=;
        b=b1616lHWxbiH0xPZQ1yT19SGsnIRh6cfGmGHqw41BN+D7seDuQvJD6VPVvS9B3YoJJ
         7mgyaDgJesv2qdEiSV83+CEGqQVli4dcickOhyhzP5YbC9aCpG23mxirGHnbWxEcRb3z
         4siF0mNaL8IX720MPHVGa2MeLsOdpGuAsB4VV66A2mN2k/fBU038EjcuG4KaWqCyCW3u
         Y434jjEHnoYRfUcs3YjRhgD/mYGr9zc7pLjIVKnX+E/+6acDG5hqb4ULg46qmxTZRlsa
         qhJbMyAuP6+/6B/g0ch3Dte5H34ixt1YIG5nrKQhiuDkfzAkMJsNffIjeH+FpMJBxgR7
         /dUA==
X-Gm-Message-State: AOAM530sCfKF+0ERnh8zJXzfzJDhIv8lEtChEUxPzvZT3E/SFDfIG87I
        UzIZNJI0JEGP7gqvg1etrGabJ/6eLaw=
X-Google-Smtp-Source: ABdhPJxubOFyNCnd+fy9pZn9g5t2Agc+D7Qk+GfrKesLV/eAPGvfZWg2Af1sdp4ymaYwTZfw6hArnQ==
X-Received: by 2002:a5d:51c5:: with SMTP id n5mr988868wrv.265.1600239043634;
        Tue, 15 Sep 2020 23:50:43 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id u126sm4229028wmu.9.2020.09.15.23.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 23:50:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Ziqian SUN <sztsian@gmail.com>
Subject: [PATCH 4/4] kernel-shark: Fix dependency (symbol resolving) issue
Date:   Wed, 16 Sep 2020 09:50:07 +0300
Message-Id: <20200916065007.9755-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916065007.9755-1-y.karadz@gmail.com>
References: <20200916065007.9755-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When linking KernelShark libraries we must take into account the
intrinsic dependency hierarchy of the trace-cmd libraries.
"libtraceevent" is the most basic one. "libtracefs" depends on
"libtraceevent" and "libtracecmd" depends on both "libtraceevent"
and "libtracefs". In order to guarantee a correct symbol resolution
during linking, those libraries must be listed in a reverse order
(the most basic comes last).

Reported-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/CMakeLists.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 9666b18..0627783 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -7,10 +7,10 @@ add_library(kshark SHARED libkshark.c
                           libkshark-configio.c
                           libkshark-collection.c)
 
-target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
-                             ${TRACECMD_LIBRARY}
+target_link_libraries(kshark ${TRACECMD_LIBRARY}
                              ${TRACEFS_LIBRARY}
-                             ${JSONC_LIBRARY}
+                             ${TRACEEVENT_LIBRARY}
+			     ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
-- 
2.26.2

