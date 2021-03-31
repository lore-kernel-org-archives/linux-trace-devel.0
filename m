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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80530C433E3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55526619D9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhCaH3j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbhCaH3K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 03:29:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9816C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 00:29:09 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j3so21037930edp.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 00:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s/wYTd27b2A1EJhLKQ1KtM3Ao7q7OdGdfUq/Zly0vtY=;
        b=MkVeGKfwROfdacIBLD2x/1Jb9FUfPoun4b79mC/23Ccc6VDAsMM0KQCJ0ThALfZIID
         CM3HF1EuxsmdPrzNzRngYUXADZqprRmmJCd5eK2r0sayfXfvxL+wkiN91P9ui10vN+u6
         nmvgIRwl5wad9gJv55gJizxeCKVrfNQPjWo+ry4rUrBSAonMWgNNMUmc176e6s6maiRV
         iTf0EBPVQ+fThMRJAb//M1ejsTbaPZi6TNeRP5ozY+vy2g0kFQBgwg0tZZ+WPEpqIC7p
         +sMtFL3foLo6ZvmRHObiS2Z3byzdIIYFDnVcfT/d2vEGNyWwUHnHZjpu+ZLC2AGB9lsF
         s4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s/wYTd27b2A1EJhLKQ1KtM3Ao7q7OdGdfUq/Zly0vtY=;
        b=lDx0wcytKCl6EAIqHGTYP6iEoaDI1ZDLqrpB4tkscvxFlmDUBu8FEkoJzKa5v4ozXp
         QHOqqlPu2s5a9LjpLlJGZ5hlm5thBqIm2RLZZ1oXEv6f10ssmE9ClRnfAMywytFw/GY6
         tPSiwfoqkLAHi4/2JJ+7UwemIP/dskEiOw0JK3N9tHkqQJWGgvoVcyIz1WUkCIU3r8qB
         8FVYSB9gX927tgZUd2ljQNj2lr1dQnXThTKI7mPcpgeSb8fr66P46SKAFJe9byhSYJ1s
         gXu5d0fa3AenkXikP+Fjtr6ffyVMpzquMqOa+2F9tfhgwMJ07aiF+67w8OOXE8Hv2r4S
         Hflg==
X-Gm-Message-State: AOAM531x0W995QksQ4NaB24PmwZcUvCZQ5t8fJM8363WtKFT9jSS0VFm
        8JodzUucpTduPTA1RvSpOi+pivLzLq4v8Q==
X-Google-Smtp-Source: ABdhPJxstzCxPByIL6y/vqtMTJK2vQhYaseAQcALjo2JDqIzndfdRIA6G2ZczcnvQTwIlpQmpZZerg==
X-Received: by 2002:a05:6402:1393:: with SMTP id b19mr1960428edv.333.1617175748635;
        Wed, 31 Mar 2021 00:29:08 -0700 (PDT)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ho11sm587469ejc.112.2021.03.31.00.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 00:29:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v34 4/5] trace-cmd: Debug scripts for PTP-like algorithm for host - guest timestamp synchronization
Date:   Wed, 31 Mar 2021 10:29:00 +0300
Message-Id: <20210331072901.152880-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331072901.152880-1-tz.stoyanov@gmail.com>
References: <20210331072901.152880-1-tz.stoyanov@gmail.com>
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

