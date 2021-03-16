Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1615C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 17:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9217F6511D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 17:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhCPRjx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 13:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbhCPRjo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 13:39:44 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B797C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 10:39:42 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id f12so10892761wrx.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=697wIE5VCZx9el31tE6oxlPqOMIdwAQRuWuo7kQSl54=;
        b=vb+zsiXhAnW6dZo0iEIzqDckWoY4hFhKI+GkVioMbpVYnHoFvY9VUYdWQOZdtU1O8q
         F+A1Ds3Cu40nuJtMFByAMxm3kxZFlsbQOU88XzwGk02y29Xn1cMRYP0uE2qPbiD0bNcK
         Ro5GARlvzeFnekYnxQPr7UewrV8YfY4CSgEjaN4Rg9TX+z5ZqeDzjJqRHzHPehyrmLzf
         CRw2D+zN+VjpGhkqOb3qF5OYUweeglSzGiUeuOWokoJB56ZVFxDwmizVfihj3bAexSe7
         74g9+5MeWztPgN0SJ9mF4y73pt1tHA43Fnw2nCFYkjESA3QbIoD68HJPPdhwG6ZahOCQ
         QvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=697wIE5VCZx9el31tE6oxlPqOMIdwAQRuWuo7kQSl54=;
        b=VkTdyakNiOsGKNNDEUirYv9SmiMZGQkL2ac3BXjVYC4sg3k9rcCrlzvHzFngyj35tO
         Dvz5WgSKuhM4teiNOxeOx5NfmsaCRYNuNe4kn3tEGSNBYlZ0i9UZ9gqldcCOoapD/kWm
         Dwr4Igzm1ucVz+7Fsu6bs1wN4VHpF+brGZvTr9fKOIlBWrb8FbD/7C5BRyRC2XVwT3/I
         8hwEg8RDbfRCeyjLkuuyALNXcg8BGMC1fQzznoCP6Y6hLJSnro1bklkGFLtZ5z5vuaYj
         tM+b8VPCA/B0QiGrs17rO8+PQlHlqmoH30yBlO0sksedmnNzsEcFAKP+C5R0W/5KXOhQ
         UPjQ==
X-Gm-Message-State: AOAM530aChPEc+1Tv+nTfAh4NUJLsZjvCN1rsS7veO/1msqGSeGDPrNl
        8QJTyHpGHLj9tn9s9IFHInhxD15c3Px84w==
X-Google-Smtp-Source: ABdhPJx/OXspOOfvuNu+pYCi6+XDWVkWTB8BryP0G3vwLtU0s7IyL7jnpgO29yKY+Qq+gPY79bCRrw==
X-Received: by 2002:adf:f8cd:: with SMTP id f13mr144480wrq.27.1615916381019;
        Tue, 16 Mar 2021 10:39:41 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.162])
        by smtp.gmail.com with ESMTPSA id a12sm21890191wrx.5.2021.03.16.10.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:39:40 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] kernel-shark: Build the plugins together with the GUI.
Date:   Tue, 16 Mar 2021 19:39:20 +0200
Message-Id: <20210316173922.657865-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is no need the compile the plugins in the case when
not all third party dependencies are available and the
KernelShark GUI is not compiled. In fact this even causes
the build to fail because the plugins can include headers
from the third party packages.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 1e86e9c..5942e91 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -140,9 +140,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
             DESTINATION ${PKG_CONGIG_DIR}
                 COMPONENT                 libkshark-devel)
 
-endif (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
+    add_subdirectory(plugins)
+    set(PLUGINS ${PLUGINS} PARENT_SCOPE)
 
-add_subdirectory(plugins)
-set(PLUGINS ${PLUGINS} PARENT_SCOPE)
+    find_program(DO_AS_ROOT pkexec)
 
-find_program(DO_AS_ROOT pkexec)
+endif (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
-- 
2.25.1

