Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74FCC3F2D8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9517B20870
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OK0X+AMz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgCBKO0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:26 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:35273 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgCBKO0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:26 -0500
Received: by mail-lf1-f50.google.com with SMTP id z9so7569721lfa.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqBpWvbrJyq23NGDhIETAtAQlSqS0Rq6mOlw7HCZ6Cs=;
        b=OK0X+AMzYh6jLqb905hUJTKSAuOvxJFGR9QkOzIh2W9lVr7RR6aV/o3tUTemTo8zKK
         IkxzQeNXB26ACIUMqMAfFA+8bZV+e/9IryMe1fRToB+lfobgU0RdQVXTwOscWvgoC0U1
         Lclij+RYDOprYrz71oPZq+8Mbs8ej1JFqsjTHD+PInvczPawC+2w3d1kt1BRt6IjYsSs
         hIxDbrzQpRffAmlExXsm7NYHp3eo3Bu4seIfCloUsMq6D54m6U8Bf7p8ZosYfYHXqYY4
         jBiaSKlo5Rpr7fM+6o9pu2eg26v2na4XQQ7M0E6FdWQGbgjHJo5exnJGD3Z7F3CeAV/i
         PXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqBpWvbrJyq23NGDhIETAtAQlSqS0Rq6mOlw7HCZ6Cs=;
        b=E2bJ1yS2Kedg9DQl2uyiXviv6+w00SOqc4gX1m+QyA9RTMt0EPXY40XrAtOKbI8DJX
         H0dafOcudkV38dg//QqosUl2XuxdWgutJLHIWaF/HsIaqu8SeeWp/W6FHUMP9d5DIJ7U
         L36LjV/11rBpuXGzPH631QC9k6wAnBQtqHDQcbmxsrBWZixHn+zEtdtINfaeiB/4Dywv
         wwS+7tVR2TPNkkDHUBKMgBFLIYdbpWA+R+HsmCluYYnNhG79WORRmBwRytyk72CaqzMo
         TUieX45M15hgwJ52LqaP79IbNXr2W5kvEYK6BHxVVwWTL83L0/Vfe92hGk+Yld/2CNmf
         AFkQ==
X-Gm-Message-State: ANhLgQ2cUmD3/cbM07gykMjSf1He0mNb8c+krTqifn8h/ym+U3S56lyP
        RWRo+EpLCozUpI7ImhXQWwk=
X-Google-Smtp-Source: ADFU+vu9qyaMaIjA7pBdQwM9CdGn9X2Qsw9dRW9rtiHRJ5y6xY+naRtpGLGtDSf+fc8FB5O9ys2PFg==
X-Received: by 2002:a19:be92:: with SMTP id o140mr10117152lff.216.1583144063489;
        Mon, 02 Mar 2020 02:14:23 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 13/13] trace-cmd: Debug scripts for PTP-like algorithm for host - guest timestamp synchronization
Date:   Mon,  2 Mar 2020 12:14:04 +0200
Message-Id: <20200302101404.150035-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302101404.150035-1-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
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
2.24.1

