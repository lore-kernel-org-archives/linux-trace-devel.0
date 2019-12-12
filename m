Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B199BC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878D12464B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s8zn7b6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbfLLJDH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:03:07 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:46184 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbfLLJDH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 04:03:07 -0500
Received: by mail-lf1-f50.google.com with SMTP id f15so1057197lfl.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 01:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qDwePEGln2rZJFTcfkO11fGvFsmIaTgTUWpXtppzZdw=;
        b=s8zn7b6H3ijz4U2YInQbfaPrJt8TxOfZzpRTLEPtFiyL7xf/7iFfMWsxtlFz1rX85B
         RlvTCrU+uLYxYyeF5ZKwHuV/GEnwLpu3MJr/J5sR5d/LxQnpAMkQXmlD1F3sDi4HVlHS
         20Oj3TOE8o4xPS0ZHTHrXGxu8hnduyKzoaq0ANoGxP5UenWe3Sf2OB7BQ9zsnFge+UJE
         jnA64BTsP0k7nubLVVIqW8a1vGRNI9WBbRFlHRBIVKDOa5DBwqmrA8gEVE35dzhKc8Dv
         HD+L/O6fc5jrVzC5SYJTl9vboch7KsQS6I7kZyPLeELMGMruvAf3XE4d6sQdtF2eXUp+
         3lLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDwePEGln2rZJFTcfkO11fGvFsmIaTgTUWpXtppzZdw=;
        b=rlswwIClsbI6u+VgMzdoaLI5bHMUSpeO+zuhm5U8XQ/bCJCSvHko7y0//FVuBjyCtU
         L+0zkSkGVt0VOrG0S2AFa+EeqykxhCAQ0t50iFP4FAYaPx6X6DuvOHCgpFnUHzHvqUUR
         BfK2kOJ1BV8kslhgVUM9NALJFZ8eyW5vpHh5d9QS4NgR+yDYCyHUA3MdvdEhVpUYnSwK
         zxUpwWytuhUEAX52enWSXedEGrOnihGb7dOKzJGzDs7ntYy+zl0+7rKKCDD0h+VsjMYD
         Cb3/1sPmewU85ixOfnP3hhNObgbUu7nW/V4OWLUU8O2PaijXc3qtXjVavvam/hC9IYk5
         gMNw==
X-Gm-Message-State: APjAAAWiaiCNNVNDsGFYTgJ8du3h174TqYCnCvLuT4knLHtIPzOI897J
        /YvO71VJrL7nE6/vT6q8eKsBvIlx
X-Google-Smtp-Source: APXvYqwkOi8uEK18UNFkxtBQ2Un7ZABPVybLCYQaacVN6ugn6NJE7N1RKaLjwYmxK0QzjwVA45/08w==
X-Received: by 2002:a19:6455:: with SMTP id b21mr4681359lfj.45.1576141384628;
        Thu, 12 Dec 2019 01:03:04 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u16sm2849908lfi.36.2019.12.12.01.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 01:03:04 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Valentin.Schneider@arm.com,
        douglas.raillard@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/5] Add "utils"
Date:   Thu, 12 Dec 2019 11:02:31 +0200
Message-Id: <20191212090232.24236-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212090232.24236-1-y.karadz@gmail.com>
References: <20191212090232.24236-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Place the rest of the code, that is pure Python in tracecrunche/utils.py

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/utils.py | 54 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 tracecruncher/utils.py

diff --git a/tracecruncher/utils.py b/tracecruncher/utils.py
new file mode 100644
index 0000000..f785c01
--- /dev/null
+++ b/tracecruncher/utils.py
@@ -0,0 +1,54 @@
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import json
+
+from . import datawrapper as dw
+from . import ksharkpy as ks
+
+def size(data):
+    """ Get the number of trace records.
+    """
+    for key in dw.data_column_types:
+        if data[key] is not None:
+            return data[key].size
+
+    raise Exception('Data size is unknown.')
+
+def save_session(session, s):
+    """ Save a KernelShark session description of a JSON file.
+    """
+    s.seek(0)
+    json.dump(session, s, indent=4)
+    s.truncate()
+
+
+def new_gui_session(fname, sname):
+    """ Generate and save a default KernelShark session description
+        file (JSON).
+    """
+    ks.new_session_file(fname, sname)
+
+    with open(sname, 'r+') as s:
+        session = json.load(s)
+
+        session['Filters']['filter mask'] = 7
+        session['CPUPlots'] = []
+        session['TaskPlots'] = []
+        session['Splitter'] = [1, 1]
+        session['MainWindow'] = [1200, 800]
+        session['ViewTop'] = 0
+        session['ColorScheme'] = 0.75
+        session['Model']['bins'] = 1000
+
+        session['Markers']['markA'] = {}
+        session['Markers']['markA']['isSet'] = False
+        session['Markers']['markB'] = {}
+        session['Markers']['markB']['isSet'] = False
+        session['Markers']['Active'] = 'A'
+
+        save_session(session, s)
+
-- 
2.20.1

