Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66297C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 13:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiBWNLJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 08:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiBWNLI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 08:11:08 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD35B985B2
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 05:10:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g20so2236040edw.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 05:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WtagkF8zj8/n87pPUfLdAIWdCWMOC7pJgW9DIbBOjqI=;
        b=ZL6sWEr8ZtXcbRcBKe5yUBG8BvoLzT/nhtUsbZCQkkxbw/gofhYDGoSzs/MNzKhOe1
         qgiiolkUwFlFMiJvcSR6J0w6eHiXkXUGdkxhy//kmavPIVNPTKBpvZE32ww7Zs3CamuY
         xnjt+t2NsF5PggE7yghJcPqEJbB2LAvDPBjiRbey4wwFRYkT1ZqvRcDDZtLIWZIZrx+/
         SFJCKKVTOAJmsfbcng0yB1wD6+9giklXMFXsX3nnVmcpCj+sc0lY/zI36CDJuGOhIYrG
         QeaEKvAJWNCFceYJwSfQ+yDjkqhY3GFXYh4qOxG0TZHQfNQJxE1qaMni5I6Psyj3utLs
         vryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtagkF8zj8/n87pPUfLdAIWdCWMOC7pJgW9DIbBOjqI=;
        b=lxgwSPIrGAOHCHnr65/2awLeasOSM1yY6SSkgdGlUxuzgfB/nE0Udg08kHVeuvz0w3
         +0Zz3L4Bns0n29wwEKy30E38nhVb6w4KF7hL7Zw5F9o6n/k3accVcYdBK8qXKmfbJQvh
         XW/q5pUEPB7ksiXBcwJyxntUq/e6+4XdG5aK2+P5LWCm2OPSXe+NcrdncnA5dgtA9YoH
         yvnMJs6xCAYO3WULwdZ2enLISUEMbzXBbC9I0xbhhAz5C1KE5Hw/meJzb2vGE+F2+XX2
         ruYvbDn4EXThnKIFd8iw9USE7nPJF+9K6eNj8LnWgoYQ+9nfyTlplVK8VbuqXAwYxBgC
         Ucig==
X-Gm-Message-State: AOAM532VtzEySQfQvo7g+n/caarr1HDIWTXB93lVT+Y3YkhxxqcTx0SK
        ouFkTKbelu+J9UyTmNvx9YsmqTPnKsA=
X-Google-Smtp-Source: ABdhPJyzNOqDeX/hw4QPg2Krq390kt0F4KfTchLMueAkGokQsgjsoACjPFaCfR46eMlAKigYMYH62Q==
X-Received: by 2002:a05:6402:128d:b0:410:f204:6ec2 with SMTP id w13-20020a056402128d00b00410f2046ec2mr31729803edv.104.1645621837044;
        Wed, 23 Feb 2022 05:10:37 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id qo12sm7420402ejb.79.2022.02.23.05.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 05:10:36 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Moving tests outside of tracecruncher/
Date:   Wed, 23 Feb 2022 15:10:24 +0200
Message-Id: <20220223131024.62332-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223131024.62332-1-y.karadz@gmail.com>
References: <20220223131024.62332-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch is a partial revert of commit:
086f784 (Moving tests under tracecruncher/)

The problem that the reverted commit tries to address is that tests have
been installed in the top level of the python version namespace which is
not where it's expected. Here we solve this problem by making sure the
tests are not installed at all. This is done by moving the 'tests'
directory back to the trunk of the repository and in the same time
removing the unnecessary '__init__.py' file from the top-level directory
of the tests (./tests/__init__.py). Note that we keep '__init__.py' files
in the sub-directories of 'tests'.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CONTRIBUTING.md                                                 | 2 +-
 {tracecruncher/tests => tests}/0_get_data/__init__.py           | 0
 {tracecruncher/tests => tests}/0_get_data/test_get_data.py      | 0
 {tracecruncher/tests => tests}/1_unit/__init__.py               | 0
 {tracecruncher/tests => tests}/1_unit/test_01_ftracepy_unit.py  | 0
 .../tests => tests}/1_unit/test_02_datawrapper_unit.py          | 0
 {tracecruncher/tests => tests}/1_unit/test_03_ksharkpy_unit.py  | 0
 {tracecruncher/tests => tests}/2_integration/__init__.py        | 0
 .../2_integration/test_01_ftracepy_integration.py               | 0
 .../2_integration/test_03_ksharkpy_integration.py               | 0
 tracecruncher/tests/__init__.py                                 | 0
 11 files changed, 1 insertion(+), 1 deletion(-)
 rename {tracecruncher/tests => tests}/0_get_data/__init__.py (100%)
 rename {tracecruncher/tests => tests}/0_get_data/test_get_data.py (100%)
 rename {tracecruncher/tests => tests}/1_unit/__init__.py (100%)
 rename {tracecruncher/tests => tests}/1_unit/test_01_ftracepy_unit.py (100%)
 rename {tracecruncher/tests => tests}/1_unit/test_02_datawrapper_unit.py (100%)
 rename {tracecruncher/tests => tests}/1_unit/test_03_ksharkpy_unit.py (100%)
 rename {tracecruncher/tests => tests}/2_integration/__init__.py (100%)
 rename {tracecruncher/tests => tests}/2_integration/test_01_ftracepy_integration.py (100%)
 rename {tracecruncher/tests => tests}/2_integration/test_03_ksharkpy_integration.py (100%)
 delete mode 100644 tracecruncher/tests/__init__.py

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 0eb9f85..865fcc8 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -25,7 +25,7 @@ as described by the Linux kernel.
 Make sure that all your changes are covered by the tests. Before submitting your patch, check if everything works at 100% by running the tests in **tracecruncher/tests**. Compile your changes and install trace-cruncher (`sudo make install`), to make sure that your code is used in the tests. As trace-cruncher interacts with the Linux kernel tracing infrastructure, the tests must be run with root privileges:
 
 ``` shell
-cd tracecruncher/tests
+cd tests
 sudo python3 -m unittest discover .
 ```
 
diff --git a/tracecruncher/tests/0_get_data/__init__.py b/tests/0_get_data/__init__.py
similarity index 100%
rename from tracecruncher/tests/0_get_data/__init__.py
rename to tests/0_get_data/__init__.py
diff --git a/tracecruncher/tests/0_get_data/test_get_data.py b/tests/0_get_data/test_get_data.py
similarity index 100%
rename from tracecruncher/tests/0_get_data/test_get_data.py
rename to tests/0_get_data/test_get_data.py
diff --git a/tracecruncher/tests/1_unit/__init__.py b/tests/1_unit/__init__.py
similarity index 100%
rename from tracecruncher/tests/1_unit/__init__.py
rename to tests/1_unit/__init__.py
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tests/1_unit/test_01_ftracepy_unit.py
similarity index 100%
rename from tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
rename to tests/1_unit/test_01_ftracepy_unit.py
diff --git a/tracecruncher/tests/1_unit/test_02_datawrapper_unit.py b/tests/1_unit/test_02_datawrapper_unit.py
similarity index 100%
rename from tracecruncher/tests/1_unit/test_02_datawrapper_unit.py
rename to tests/1_unit/test_02_datawrapper_unit.py
diff --git a/tracecruncher/tests/1_unit/test_03_ksharkpy_unit.py b/tests/1_unit/test_03_ksharkpy_unit.py
similarity index 100%
rename from tracecruncher/tests/1_unit/test_03_ksharkpy_unit.py
rename to tests/1_unit/test_03_ksharkpy_unit.py
diff --git a/tracecruncher/tests/2_integration/__init__.py b/tests/2_integration/__init__.py
similarity index 100%
rename from tracecruncher/tests/2_integration/__init__.py
rename to tests/2_integration/__init__.py
diff --git a/tracecruncher/tests/2_integration/test_01_ftracepy_integration.py b/tests/2_integration/test_01_ftracepy_integration.py
similarity index 100%
rename from tracecruncher/tests/2_integration/test_01_ftracepy_integration.py
rename to tests/2_integration/test_01_ftracepy_integration.py
diff --git a/tracecruncher/tests/2_integration/test_03_ksharkpy_integration.py b/tests/2_integration/test_03_ksharkpy_integration.py
similarity index 100%
rename from tracecruncher/tests/2_integration/test_03_ksharkpy_integration.py
rename to tests/2_integration/test_03_ksharkpy_integration.py
diff --git a/tracecruncher/tests/__init__.py b/tracecruncher/tests/__init__.py
deleted file mode 100644
index e69de29..0000000
-- 
2.32.0

