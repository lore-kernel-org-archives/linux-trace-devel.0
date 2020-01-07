Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB08C47409
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B72C208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mtrEvaJ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgAGREA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:00 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43179 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgAGRD7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:03:59 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so296874ljm.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qDwePEGln2rZJFTcfkO11fGvFsmIaTgTUWpXtppzZdw=;
        b=mtrEvaJ43PJCPtezlAWcSLrIQsANDEd5F6IdS43z9zFCLhObtsa53wyaO9GGR+Yz4+
         nH4AlWNqlQftrqSmVkMN817aDE95vQaJsqksbUe2u9PPRKSn9BdJGG//MFAPUIYiUpMb
         FfkTFx1TSXx/pMgE1PI/h4Gm+lrT6LzLtmcQ+X2H9shtvApr90g0INn7rHpUw7LqGN19
         Mr/yJw/J1gcjfv40XbCb8MXrJILzp/s9RhFcXyBZiQ2XvuC30/QAsHW4ZphyV/00CIKw
         fCRd8zRBE1HDNZNQVwXYAS01DS9Y1otnhFUJBUOtzPkwdmVIx4w8HI9bdf+NbNX6lFG9
         sFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDwePEGln2rZJFTcfkO11fGvFsmIaTgTUWpXtppzZdw=;
        b=sycD1rnGYFWZBOYqC09Hf51GvnbLdVylGEwDoUU2vkCdbaSl/g1GsKG3hzLcb1bcue
         tGHckmiLDdvB3Pw6AwYsPfqxKzkCsfPt3AMHsROTxKxDXPyyZEYtxO1fJsNZsjljXv8P
         XcgkZ/gOEmG6FAu8jGd8Tv0sIxXFtgSWxzoe0h2wdNGwZSJRBGA5X/tndo0CJKp9IHVi
         pgJaj0Q83DaSk7P9oiT9Hdw/qVKSDQ1lb9enQjbeU0yGT8eZcU7hyczqmV4gDRi2hI0d
         z/zvXuAkV8+VHxgThi0gBlG1CZIzPpxfgIvzHP2nDdWwMOGXfUUpxcMHr70/mAGSbWOM
         WYCg==
X-Gm-Message-State: APjAAAVDoYlNQ3WHlqTjCH7Jvw9FxpzOYNIxI8zNpWd+hXxU1GFThQ8s
        BlErtEfWNCEsorMCqQyC+8v5HYHN
X-Google-Smtp-Source: APXvYqzDcS7zYKXltubmMr/+Yq1tmQEtgaeWRJ/5KDGs1FLESvhiKFOJQpxtgfinDzU1CULThcos3w==
X-Received: by 2002:a2e:a402:: with SMTP id p2mr271032ljn.143.1578416636725;
        Tue, 07 Jan 2020 09:03:56 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:03:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 04/12] trace-cruncher: Add "utils"
Date:   Tue,  7 Jan 2020 19:03:04 +0200
Message-Id: <20200107170312.27116-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
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

