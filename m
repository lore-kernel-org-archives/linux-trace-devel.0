Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA3DC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D25D8611F0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239355AbhDSNCg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbhDSNCa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 09:02:30 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E646C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:59 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso8172973wmq.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=fYKq3ejMrO5VgAQWeuN2WN/NH/05pekZOCUQVS5UnQ83njI3EC3xHORcA5J2b3vyQ0
         LSphMeH5Qcwz0lvdJi/RUGtxoED+DG0Xbr/ETHs/rg1XvyQK4WTFHf6bU3jLvqJfdM81
         7OYcvpvD/nVuzuu02+uabliqr6zjdRRZEkQKHyF0yNt6iBv1cj33YOx2BPqzBE6R9sKB
         8rAangyTOH396DrLnrMA2L5TXspYc06fFs6v+TrVE6DWyaparPq899VrdNTWJ5VHFlo8
         VDwIk+Ps+9/1IwdM/i8U9zGgfvu7zDTG+Rm7MdcKs9U92gc2RfCjaUYFaOwj0vQOxday
         5H6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=MLK/xqLfXkHR6kjnAZ/JxcZYwrbQI7Lvfkz3Uec+hGU0N1WYgk1B9Z5fLO+9NT0Gbo
         BcjPOvWZpgSbfv6gW0GQnRnENtzOax2DlLR62689hUV0aOx++g9+/NAgX6tAbKeyf61y
         Vme7BV4FbCt9ZmzwrNZpBgd5O6hkZ0WI8KjNa4S1uUJUsDhJnjx9gblwgRYUQ06drdeV
         c2HjnPx7qiIEb7DDAzi1f74VZH3gbkyYhTlP0/5KP5mmwMIIEwRL075utHTdXYQCbfww
         a96uNGAdCMOlLL5MQ/e6ZGz5ccR5GrqnrJZ0GS3q0w7gDckkEilBIZXPpqS1kZzVqnhp
         bjzw==
X-Gm-Message-State: AOAM533uDb4dmAFGgILAfcJOCLJ/PTuhuETfNSpzTHHFtGixC7o7b+2+
        W5pY34LYT9SLFUnTMPWjs9FR3aS7qCU=
X-Google-Smtp-Source: ABdhPJxdzlwbz2s8O/wdsF+AC7Ub5TpYFFvfuHLqO6WxANQqZbm8HLE+3hWhgCGzts+PainyOTC3ug==
X-Received: by 2002:a1c:f60a:: with SMTP id w10mr11013431wmc.5.1618837317676;
        Mon, 19 Apr 2021 06:01:57 -0700 (PDT)
Received: from bucy.vmware.com ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id v7sm23164196wrs.2.2021.04.19.06.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 06:01:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/9] trace-cruncher: Add Makefile
Date:   Mon, 19 Apr 2021 16:01:36 +0300
Message-Id: <20210419130140.59140-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210419130140.59140-1-y.karadz@gmail.com>
References: <20210419130140.59140-1-y.karadz@gmail.com>
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

