Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9133EC433E3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 728CB61A2C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYHOg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhCYHOX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 03:14:23 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AF0C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:22 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo543339wmq.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s/wYTd27b2A1EJhLKQ1KtM3Ao7q7OdGdfUq/Zly0vtY=;
        b=bfUqKO0Ass318CveSiyUR5+3y4Go39wsf0+VJIA5wlcn/AtaGbHISwxwY/ljaabzJv
         97l7LAhJ1GHRl//z6i8pd3yPpFF2Nt24SOyxKQpRHPxUcwChFMR3MRw6vOEhaRqhPB0A
         19zLIZgMvAKRm0TH2W6iYsykNF1JZTmAxpE/PK3nJGjdHYmP5G+sdrwqbXqfkgpV6Ra5
         IhnC1KMnLbpNwZKRhQ630foSO/bdmxNn9z/fsghfLbmlwqT7qvIeY8I6fkpQhrjijo1b
         d3FCa5DciAvuJXew2EkUVjVBJdv8fbmvQDTxQTqK5ldonXQRnYGZ3xiVTDR21QPAoOKi
         cHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s/wYTd27b2A1EJhLKQ1KtM3Ao7q7OdGdfUq/Zly0vtY=;
        b=sFJe7wWl1Urz3qCn8B43JLE/bT5aMXfU004evibVSlFRrLGPbQhedcvueMhWM8Dsvp
         SiMtSCjF2FjM5Nb7o0E9qyb4e1CP16vVRbl9DTAcMxoalwsj+tEjrUtHYZq/6mh+MQ/t
         yoZlzz0h7nxdAmL8T1DN3G/HCxXF1zFjbEHEz0Zch0jOOElKhkCis8wOl6+kUUDaWrov
         8QAA5l9XBx8uQl0X63qhM8u0ZwPzbSZdSi9mRc4Vk7PlInd+md42KGu9rW0/w95Oa+db
         /eDno+krqhrqljkgVqy9XWFWdik5z0Y8mOQfFCnBAcL51pcXKET1I5hwClZyJAUYA0Xq
         WY7w==
X-Gm-Message-State: AOAM531tVVCkmHMTRZjnAu7Mz7daM4W+kd2VIdtooGGS+/MuA8yVNfsb
        DZCHPpHHQ5PKlJjcOgkS1e3ucDW70JtT0g==
X-Google-Smtp-Source: ABdhPJzI7bw1fiE1XaTr/OhBs8P9uOSslY9y0pgqwhkGjuXfEkEVnEwT31vaLQ8MfxziKMsFPT5xew==
X-Received: by 2002:a1c:c20a:: with SMTP id s10mr6343878wmf.144.1616656460870;
        Thu, 25 Mar 2021 00:14:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q4sm5177487wma.20.2021.03.25.00.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 00:14:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stefano.devenuto99@gmail.com
Subject: [PATCH v33 4/5] trace-cmd: Debug scripts for PTP-like algorithm for host - guest timestamp synchronization
Date:   Thu, 25 Mar 2021 09:14:12 +0200
Message-Id: <20210325071413.543640-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325071413.543640-1-tz.stoyanov@gmail.com>
References: <20210325071413.543640-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.30.2

