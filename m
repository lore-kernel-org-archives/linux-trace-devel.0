Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A8AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 11:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiAXLLK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 06:11:10 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36808
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237224AbiAXLLJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 06:11:09 -0500
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C656D3F17B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 11:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643022668;
        bh=DHpIcoEUoGMTQAFiq560qyLxOyJB9OnIk8nQrCKZwJI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=t6QZV3IuWkpZR5P6jvL5B4XLXXqHPpBqfM22r/Z0krUxYpBMUTqU76nv/0qVmAgYi
         YaHFN9FXDwNbsRiN1zSFC7b30jSaY9PEVcuHStfX57focvu8ZhZU+jmtjpfzqkihEB
         ICruboOMot9VLojjo+2IPT9kn4WXXxXRkXrgZPJRX8cNmHcgW3+ISSYUFAPUu1u9Sa
         Nz/Tqex0bDv7kEZhXz93lmOe+AdUKeiarTUXoxfmuu/+hDauizzR1iF9Hi9DzYuPMa
         av/lJzbSgSWecu3Zd5y/j214F2H/hg/IVM5MrwvEAPY6w6O03N9KZMjhj1Pbnw2rS4
         Fn+28ZXjSlk6A==
Received: by mail-wm1-f71.google.com with SMTP id z2-20020a05600c220200b0034d2eb95f27so10571847wml.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 03:11:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DHpIcoEUoGMTQAFiq560qyLxOyJB9OnIk8nQrCKZwJI=;
        b=PEXy+FxSezzWdz8aGxjscA3YGMqxG6RDwPjdF/ryDBJe/S7EvOLV+F7SAnatw+ZpKt
         YlTnpNOREdIda0TWPcrwKa/u5j4BhBRmUHRzIN6kYGsFTPppaC2A7xvZCZNmMFUhrm70
         rgKZnZ678yZ/RA1izHl+DJ7vWbRTYTc/4+fFcz85Hy8+60Ig6ifs8dx9RoH6c7Rd4qKw
         qNs9a2EzZCbgz6hRI5yNkL2p92bbY4ny4qmj7IWdbEL2/8ix4OrJNMrLRptjQJcTGoqE
         ki9h+JN8oMjq/a2kGrM/ssxzYSQ5j2D8xJDn6GXVhebpjPiaT3pv+JuJ+TV5j597bcAZ
         HoJQ==
X-Gm-Message-State: AOAM533GZzCO1YN1vZ+rIjddaQ+XZ6JkA2s1wg6FZksT6SJKThPyYD0y
        JR9LWsnqQ3Gk7b2E3OJ7SzaB0wKg3FFpkrkGtoaNrWEQsXPZKQAVYTYZHAwVBTB7ca4fKgHMqW5
        JgTgg9ah9HP/xe8BWEsuKcCwAiJd7qddcnXZbhhyHjwmJ7RWz
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr14136244wrg.710.1643022668374;
        Mon, 24 Jan 2022 03:11:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKmfKHZ9LU5I1128oOOqpIiI8ufYxZYYlh82NSGGWYP3u6qMNDBMRpiZ2kog0nrsBkNMG8Uw==
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr14136237wrg.710.1643022668236;
        Mon, 24 Jan 2022 03:11:08 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id z1sm17338139wma.20.2022.01.24.03.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 03:11:07 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH] libtracefs: fix cleaning of sqlhist.txt.html
Date:   Mon, 24 Jan 2022 12:10:31 +0100
Message-Id: <20220124111031.84108-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The man-1 HTML pages also has to be cleaned up.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 Documentation/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 92a67aa1760c..afcb6a53ccd0 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -197,6 +197,7 @@ endif
 CLEAN_FILES =					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
+	$(MAN1_HTML) $(addsuffix +,$(MAN1_HTML))	\
 	$(filter-out $(MAN1_TEXT),$(wildcard *.1)) \
 	$(DOC_MAN3) *.3 *.m
 
-- 
2.32.0

