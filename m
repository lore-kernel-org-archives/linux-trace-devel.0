Return-Path: <SRS0=JQUT=5S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD4CC43331
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 15:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 676602074D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 15:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCEBcCeg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389080AbgDBPGV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:06:21 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:33529 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389046AbgDBPGV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 11:06:21 -0400
Received: by mail-lj1-f181.google.com with SMTP id f20so3637516ljm.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Apr 2020 08:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iVseORiyqSOgXFnz0G/dikuyk0GRxB8PoUJYXtsZYK4=;
        b=NCEBcCeg6o2/kVyE8h044d41EAuS1bu4aWJoTuZ0YcYYP4D3IE1Gw3KNE4w6k5HE6n
         PAbHV9wYGYBSaJHH7zn6QrvThWTHZkv0pASU/mn2wAwfWJgfB3T7yKwHh385MdaoCnNR
         ag6qgBUl3Kkwo84IHJsAmtyhq5KjHT5FxR+f1Gz/mB+nVmewDCP7CyIlxx86DUkHfr4X
         jKxT+cImoStjxFmq9gAZNIQ5+3PrR2hgPipFra0ay8hq8NLvFk6lcxVxTJ1khuDs6eBj
         tzYLMlInFaT3Ku7k5R16eEilb/xqd4DGsqhQ+VMjWlfHm6GfkOZEN6iYdCugMrxpM5zB
         Di9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iVseORiyqSOgXFnz0G/dikuyk0GRxB8PoUJYXtsZYK4=;
        b=nL+GXCwmZK8mnnKTSJilvGG7+WA8ZyCSXxd5dDDThWq/WJQVNp1rfVtwQX17IKDCIr
         WV8NeBJzc1K3VfAcRvFJ+qlkYVMFqsUlqnjTDikLnVL68Rk51NNK3kgAJTzFN445Zr/A
         TycIO14Z9sNfQOUPYCl0RWeixC4mCxpLVQ4AKjdchK5pXinpAmh/BkqYy4neHwFJ40yI
         CJJT0UKi5l8+KXt7743wuWQkiyTlMTLSHTWXSdRNE2cca9qEu/uf16bxGi6vIFqGXAMn
         hR2nd74pNg53xIznEsuuWFkLUZL2Guea4RBb1Ro9hvr0gvjrQaXZ6o9oR45xh3cAq0hb
         7H4w==
X-Gm-Message-State: AGi0PuYi20F4O6qsm7T+jlUb+TgHj3r7CIYRsaMj6Xl9OqIbJlIQz1pP
        P45plZhlyCMlc1vQFMZnjdo=
X-Google-Smtp-Source: APiQypIk4G/vRpD7L6q7ZIEM+TvH4fZvjTEmwt8UTSWgS1+HRwpG6MJDrSwOI9Cn3oJHsOJWqgvVpg==
X-Received: by 2002:a2e:9a05:: with SMTP id o5mr2360771lji.45.1585839976470;
        Thu, 02 Apr 2020 08:06:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v9sm3489562ljj.31.2020.04.02.08.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:06:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v23 2/2] trace-cmd: Debug scripts for PTP-like algorithm for host - guest timestamp synchronization
Date:   Thu,  2 Apr 2020 18:06:10 +0300
Message-Id: <20200402150610.290703-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402150610.290703-1-tz.stoyanov@gmail.com>
References: <20200402150610.290703-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These scripts can be used to visualise debug files, written when the PTP-like algorithm
is compiled with TSYNC_DEBUG defined. The files are located in the guest machine:
    s-cid*.txt - For each offset calculation: host and guest clocks and calculated offset.
    res-cid*.txt - For each tracing session: all calculated clock offsets.

tsync_hist.py plots a histogram, using data from a s-cid*.txt file:
	"python tsync_hist.py s-cid2_1.txt"
tsync_res.py plots a line, using data from res-cid*.txt file:
	"python tsync_res.py res-cid2.txt"

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 scripts/debug/tsync_hist.py | 57 +++++++++++++++++++++++++++++++++++++
 scripts/debug/tsync_readme  | 12 ++++++++
 scripts/debug/tsync_res.py  | 46 ++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+)
 create mode 100644 scripts/debug/tsync_hist.py
 create mode 100644 scripts/debug/tsync_readme
 create mode 100644 scripts/debug/tsync_res.py

diff --git a/scripts/debug/tsync_hist.py b/scripts/debug/tsync_hist.py
new file mode 100644
index 00000000..819d1e8f
--- /dev/null
+++ b/scripts/debug/tsync_hist.py
@@ -0,0 +1,57 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2019, VMware Inc, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+# Copyright (C) 2019, VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+
+
+import matplotlib.pyplot as plt
+import matplotlib.lines as mlines
+import numpy as np
+import sys
+
+def newline(p1, p2):
+    ax = plt.gca()
+    xmin, xmax = ax.get_xbound()
+
+    if(p2[0] == p1[0]):
+        xmin = xmax = p1[0]
+        ymin, ymax = ax.get_ybound()
+    else:
+        ymax = p1[1]+(p2[1]-p1[1])/(p2[0]-p1[0])*(xmax-p1[0])
+        ymin = p1[1]+(p2[1]-p1[1])/(p2[0]-p1[0])*(xmin-p1[0])
+
+    l = mlines.Line2D([xmin,xmax], [ymin,ymax], color='red')
+    ax.add_line(l)
+    return l
+
+
+data = np.loadtxt(fname = sys.argv[1])
+selected_ts  = data[-1, 1]
+selected_ofs = data[-1, 0]
+data = data[:-1,:]
+
+x = data[:, 1] - data[:, 0]
+
+mean = x.mean()
+std = x.std()
+
+num_bins = 500
+min = x.min() #+ .4 * (x.max() - x.min())
+max = x.max() #- .4 * (x.max() - x.min())
+bins = np.linspace(min, max, num_bins, endpoint = False, dtype=int)
+
+fig, ax = plt.subplots()
+
+# the histogram of the data
+n, bins, patches = ax.hist(x, bins, histtype=u'step');
+
+ax.set_xlabel('clock offset [$\mu$s]')
+ax.set_ylabel('entries')
+ax.set_title("$\sigma$=%i" % std)
+
+x1, y1 = [selected_ofs, min], [selected_ofs, max]
+newline(x1, y1)
+
+# Tweak spacing to prevent clipping of ylabel
+fig.tight_layout()
+plt.show()
diff --git a/scripts/debug/tsync_readme b/scripts/debug/tsync_readme
new file mode 100644
index 00000000..f3ebb25d
--- /dev/null
+++ b/scripts/debug/tsync_readme
@@ -0,0 +1,12 @@
+PTP-like algorithm debug
+========================
+
+tsync_*.py scripts can be used to visualise debug files, written when the PTP-like algorithm
+is compiled with TSYNC_DEBUG defined. The files are located in the guest machine:
+    s-cid*.txt - For each offset calculation: host and guest clocks and calculated offset.
+    res-cid*.txt - For each tracing session: all calculated clock offsets.
+
+tsync_hist.py plots a histogram, using data from a s-cid*.txt file:
+	"python tsync_hist.py s-cid2_1.txt"
+tsync_res.py plots a line, using data from res-cid*.txt file:
+	"python tsync_res.py res-cid2.txt"
diff --git a/scripts/debug/tsync_res.py b/scripts/debug/tsync_res.py
new file mode 100644
index 00000000..7d109863
--- /dev/null
+++ b/scripts/debug/tsync_res.py
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2019, VMware Inc, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+# Copyright (C) 2019, VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+
+
+import matplotlib.pyplot as plt
+import matplotlib.lines as mlines
+import numpy as np
+import sys
+
+def newline(p1, p2):
+    ax = plt.gca()
+    xmin, xmax = ax.get_xbound()
+
+    if(p2[0] == p1[0]):
+        xmin = xmax = p1[0]
+        ymin, ymax = ax.get_ybound()
+    else:
+        ymax = p1[1]+(p2[1]-p1[1])/(p2[0]-p1[0])*(xmax-p1[0])
+        ymin = p1[1]+(p2[1]-p1[1])/(p2[0]-p1[0])*(xmin-p1[0])
+
+    l = mlines.Line2D([xmin,xmax], [ymin,ymax], color='red')
+    ax.add_line(l)
+    return l
+
+data = np.loadtxt(fname = sys.argv[1])
+x = data[:, 0]
+y = data[:, 1]
+
+fig, ax = plt.subplots()
+
+ax.set_xlabel('samples (t)')
+ax.set_ylabel('clock offset')
+ax.set_title("$\delta$=%i ns" % (max(y) - min(y)))
+
+l = mlines.Line2D(x, y)
+ax.add_line(l)
+ax.set_xlim(min(x), max(x))
+ax.set_ylim(min(y), max(y) )
+
+print(min(y), max(y), max(y) - min(y))
+
+# Tweak spacing to prevent clipping of ylabel
+fig.tight_layout()
+plt.show()
-- 
2.25.1

