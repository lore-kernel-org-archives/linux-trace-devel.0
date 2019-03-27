Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CAFC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E24D20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfC0QD4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:03:56 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:41303 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfC0QDz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 12:03:55 -0400
Received: by mail-pl1-f179.google.com with SMTP id y5so3518585plk.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 09:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QZrbwSiXW/iuRzMjIVeyxRnny31c5JnD9Xwt8Sn+1Lg=;
        b=XA/2U6CJ2BB1cf6jC6C9+2H0XV9UfcAMMoXVnLu16VmyKu5c1gcC5EoiqQYSKb7dZ7
         lIMvyPtqldkqGuir0HjTkTHgVynzYyMQXipN2Gc0D2CCuUmEzHZCYVQlX/o5VQOIyyWa
         4p4aFAf0RPFGjjAXjohu3dO5WVIYpKC8qC+TlBBeR67vDRUbpZAhUL2vtKGvUbs7mm4p
         HsgGyVxi4oTregqSJYSwiuAfPPg1ALZ1GtirmQZwl7CLVw7QFmRKviezmX68EIq73bV/
         UNGkmO5Q7v0Yyi0ORIewp8sKHhybrRlDNulD6vrNxIcBcwAyXxE5p+06g7HxlWQyL+wk
         NXQw==
X-Gm-Message-State: APjAAAXjtaceJNLywefvuuIK2NSqeejSiFMv12FgLzTPkc+irrhvpfoY
        Jl2DdV2rPOWRD8YVPNav3Z0=
X-Google-Smtp-Source: APXvYqyiTul8erKR3tUsXfTTx0PNUGIevF2OSYyHcgA4PVwX5S7WDgcF6p06xbfcZNc2weHE6Kl+zA==
X-Received: by 2002:a17:902:a5c3:: with SMTP id t3mr38095033plq.293.1553702635302;
        Wed, 27 Mar 2019 09:03:55 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p88sm36150806pfa.80.2019.03.27.09.03.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:03:54 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [RFC 6/7] kernel-shark: Add automatic building of the NumPy interface
Date:   Wed, 27 Mar 2019 18:03:22 +0200
Message-Id: <20190327160323.31654-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327160323.31654-1-ykaradzhov@vmware.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
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
 kernel-shark/build/py/pybuild.sh | 26 ++++++++++++++++++++++++++
 kernel-shark/src/CMakeLists.txt  | 20 ++++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100755 kernel-shark/build/py/pybuild.sh

diff --git a/kernel-shark/build/py/pybuild.sh b/kernel-shark/build/py/pybuild.sh
new file mode 100755
index 0000000..978085c
--- /dev/null
+++ b/kernel-shark/build/py/pybuild.sh
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+python np_setup.py --pykslibdir=$1 \
+                   --trlibdir=$2 \
+                   --trincdir=$3 \
+                   --evlibdir=$4 \
+                   --evincdir=$5 \
+                   --jsnincdir=$6 \
+                   build_ext -i &> pybuild.log
+
+if grep -q 'error:' pybuild.log; then
+   cat pybuild.log
+fi
+
+if grep -q 'Error:' pybuild.log; then
+   cat pybuild.log
+fi
+
+WC=$(grep 'warning' pybuild.log | wc -l)
+if ((WC > 2)); then
+   cat pybuild.log
+fi
+
+if grep -q 'usage:' pybuild.log; then
+   cat pybuild.log
+fi
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index a3c6743..886ddad 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -45,6 +45,26 @@ if (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
                                    ${CMAKE_DL_LIBS}
                                    ${JSONC_LIBRARIES})
 
+
+    add_custom_target(kshark_wrapper ALL DEPENDS pykshark libkshark-py.c
+                                     COMMENT "Generating libkshark_wrapper.c")
+
+    add_custom_command(TARGET kshark_wrapper
+                       PRE_BUILD
+                       COMMAND ./pybuild.sh ${KS_DIR}/lib/
+                                            ${TRACECMD_LIBRARY_DIR}   ${TRACECMD_INCLUDE_DIR}
+                                            ${TRACEEVENT_LIBRARY_DIR} ${TRACEEVENT_INCLUDE_DIR}
+                                            ${JSONC_INCLUDE_DIR}
+                       COMMAND cp libkshark_wrapper.so  ${KS_DIR}/bin
+                       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/py
+                       DEPENDS ${KS_DIR}/build/py/np_setup.py ${KS_DIR}/src/libkshark-py.c
+                       )
+
+    set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
+                                           "${KS_DIR}/bin/libkshark_wrapper.so"
+                                           "${KS_DIR}/build/py/libkshark_wrapper.so"
+                                           "${KS_DIR}/build/py/libkshark_wrapper.c")
+
 endif (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
-- 
2.19.1

