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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14C3C11F68
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAEE661C5B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhGGNY6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhGGNY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:57 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF8AC06175F
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:17 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m17so3333615edc.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=N/L88KNZebxqv/Nrb7ilF/3NKbn+BJT5I34WF0PNQFLrkwxtlr5hmgZxrx4cmXcBoI
         ZbA9NBrNk5p5E7FYJt+3v6Rkn/KFDViyurxMPmCRcZCBHW1Q7n6Rp1RJKSadg49hYPW5
         nj1ts9yBp1GFgDxxIzOXz/O5Bl+u49famUT+X2SaS1vJZSXi9/NxlQq39WixLb5Qzuq0
         BNr8I5NegwaabfjHTOLfbFBiXjx2W/wA5VzXMvd/8F2ceFQLqatqBPn3qbm+5T6JkRYx
         0lB3AeO7I7YRgDEtY5AGJfv9XMLO6lydD7PdKa5rzut66tdgfJb9h8Do/i+r5vvdLn0g
         wKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=Sxz4DGcaCwjhhA6MfgMVVMP4ZUIPS/Dj9WE6cYNw1QeIHKzm5bJy10Eai7R+ycJfC7
         y9c9+p0Gv7I9xD556DVJ431O53HDImCe5JGBO2bsQnKivjLE1x1dAOYbmTFtSpME/GgS
         JA2vOSMJ9vl1rPgGGWL2Ax8Pcp7jCrCC0AcbVecoov4l0LTDp5fP7tB2i2kO5JEyrBMS
         SFvpuiT5wuE/St1SNWe3wT5n9AEFm+D+ReYSn+cedLBYINq91lPTCY79EvEGS5WKKh9p
         fRU6SIZJ2bgyYN2lVOU7yngt+hRypFAxnB3suOhuUgVrkxu77ZiCbk1XLuKq9nPy7eMO
         ZDkQ==
X-Gm-Message-State: AOAM530wQfgPA9WtWNe7Tczyu5lN+Rucv8WUP4LRsoFarjKALE501Y1f
        wCr5tK9Vla+UWYOh8D4zZIyJ81QXGdE=
X-Google-Smtp-Source: ABdhPJzID+cWn6m/5UBpMrF+z6BoIAaJgQ4bqYXwDuuq0j/XEzaBRTAh5Gq4+0NzQwmFbVHV+6Yikw==
X-Received: by 2002:aa7:dbc8:: with SMTP id v8mr29490849edt.242.1625664135980;
        Wed, 07 Jul 2021 06:22:15 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 07/11] trace-cruncher: Add Makefile
Date:   Wed,  7 Jul 2021 16:21:54 +0300
Message-Id: <20210707132158.68520-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210707132158.68520-1-y.karadz@gmail.com>
References: <20210707132158.68520-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This will simplify the building procedure and will make it more intuitive.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Makefile

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..a509811
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,33 @@
+#
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+#
+
+UID := $(shell id -u)
+
+CYAN	:= '\e[36m'
+PURPLE	:= '\e[35m'
+NC	:= '\e[0m'
+
+all:
+	@ echo ${CYAN}Buildinging trace-cruncher:${NC};
+	python3 setup.py build
+
+clean:
+	rm -f src/npdatawrapper.c
+	rm -rf build
+
+install:
+	@ echo ${CYAN}Installing trace-cruncher:${NC};
+	python3 setup.py install --record install_manifest.txt
+
+uninstall:
+	@ if [ $(UID) -ne 0 ]; then \
+	echo ${PURPLE}Permission denied${NC} 1>&2; \
+	else \
+	echo ${CYAN}Uninstalling trace-cruncher:${NC}; \
+	xargs rm -v < install_manifest.txt; \
+	rm -rfv dist tracecruncher.egg-info; \
+	rm -fv install_manifest.txt; \
+	fi
-- 
2.27.0

