Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6FEC10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E6320651
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfDEKO0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:14:26 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:37658 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730610AbfDEKO0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:14:26 -0400
Received: by mail-wr1-f54.google.com with SMTP id w10so7314355wrm.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IUCdOC2OBkP/pA6Fpzd7brizdRS1yPH4zCFWN1ENVXw=;
        b=Cbq9vklV2Qj75ARemdHUYFwwRiy0PfTgmjSgn/mKsoQGH5hUGACydA532vGafxgcxl
         BghKSY3pT8IkCQJApzSlo0eqs9KxavOdws4AZrMW6TScH16bHJjnIFyhqb4olGFCM7Un
         TX7K46Z4SG+q9AxFnmMyYOWsYACm7vqPtJ2sn8y8OjhfAsbwfkdhxGbiAQKxhl4kgHzZ
         9UxBc3NtaMmlpkCnMUUylBIuNlDXKTsyCho8o5sKp7aDuEKPg5pp1HCWDeIJe6bX/CP2
         N+O0X7d0GQQX+K6SZVkwKkrxqyfN0eu9jFkftLX6uPm7iuw3q/c8EyaXYrLKAKQAIhbm
         /aBg==
X-Gm-Message-State: APjAAAUbJef9Bqz0TmfbkL5Vy9qp6PK8L7dsuR1bzqiPHppHRsMxMiEx
        La6caaTQ2n+Rk2VK9/aQ5YAAodEPGPI=
X-Google-Smtp-Source: APXvYqydq5hTSri+eMLMjeIAENKnow2dsgtwzWvuNLv4GRE3eWxG8lhjLdOF0iMUfqbebeYisTatWQ==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr8253656wru.266.1554459264432;
        Fri, 05 Apr 2019 03:14:24 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a187sm1851124wma.32.2019.04.05.03.14.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:14:24 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC v2 5/6] kernel-shark: Add automatic building of the NumPy interface
Date:   Fri,  5 Apr 2019 13:14:10 +0300
Message-Id: <20190405101411.25466-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405101411.25466-1-ykaradzhov@vmware.com>
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

CMAKE will call the python script that build the NumPy interface.
It will also takes care about cleaning.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/py/pybuild.sh | 29 +++++++++++++++++++++++++++++
 kernel-shark/src/CMakeLists.txt  | 22 ++++++++++++++++++++++
 2 files changed, 51 insertions(+)
 create mode 100755 kernel-shark/build/py/pybuild.sh

diff --git a/kernel-shark/build/py/pybuild.sh b/kernel-shark/build/py/pybuild.sh
new file mode 100755
index 0000000..fc07711
--- /dev/null
+++ b/kernel-shark/build/py/pybuild.sh
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# SPDX-License-Identifier: GPL-2.0
+
+python3 np_setup.py --kslibdir=$1 \
+                    --trlibdir=$2 \
+                    --trincdir=$3 \
+                    --evlibdir=$4 \
+                    --evincdir=$5 \
+                    --jsnincdir=$6 \
+                    build_ext -i &> pybuild.log
+
+WC=$(grep 'error' pybuild.log | wc -l)
+if ((WC > 2)); then
+   cat pybuild.log
+fi
+
+if grep -q 'Error' pybuild.log; then
+   cat pybuild.log
+fi
+
+WC=$(grep 'warning' pybuild.log | wc -l)
+if ((WC > 3)); then
+   cat pybuild.log
+fi
+
+if grep -q 'usage' pybuild.log; then
+   cat pybuild.log
+fi
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index b9a05e1..ba97c42 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -45,6 +45,28 @@ if (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
 
     target_link_libraries(kshark-static ${LIBKSHARK_LINK_LIBS})
 
+
+    add_custom_target(kshark_wrapper ALL DEPENDS kshark-static libkshark-py.c
+                                     COMMENT "Generating libkshark_wrapper.c")
+
+    add_custom_command(TARGET kshark_wrapper
+                       PRE_BUILD
+                       COMMAND rm -rf build
+                       COMMAND ./pybuild.sh ${KS_DIR}/lib/
+                                            ${TRACECMD_LIBRARY_DIR}   ${TRACECMD_INCLUDE_DIR}
+                                            ${TRACEEVENT_LIBRARY_DIR} ${TRACEEVENT_INCLUDE_DIR}
+                                            ${JSONC_INCLUDE_DIR}
+                       COMMAND mv ksharkpy.cpython-*.so ksharkpy.so
+                       COMMAND cp ksharkpy.so  ${KS_DIR}/bin
+                       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/py
+                       DEPENDS ${KS_DIR}/build/py/np_setup.py ${KS_DIR}/src/libkshark-py.c)
+
+    set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
+                                           "${KS_DIR}/bin/ksharkpy.so"
+                                           "${KS_DIR}/build/py/ksharkpy.so"
+                                           "${KS_DIR}/build/py/libkshark_wrapper.c"
+                                           "${KS_DIR}/build/py/build")
+
 endif (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
-- 
2.19.1

