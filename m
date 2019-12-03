Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545C1C432C0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26EDE20684
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YFiSYFor"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbfLCKfv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:35:51 -0500
Received: from mail-lf1-f53.google.com ([209.85.167.53]:40300 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfLCKfu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 05:35:50 -0500
Received: by mail-lf1-f53.google.com with SMTP id y5so2507731lfy.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Dec 2019 02:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nY5ircyGmJVBcwcMrvZaPID8lurhvLRNnjjwQUGl8j4=;
        b=YFiSYForcORnOtrpM2oVBqGdBMQ1ALSnL8vhLU8zEtOdtl0JQICS6mD7EVZQVwYFN3
         o+XLxwsTP+kkOuhmMMD2ywqo6gewohbd7yTh9wSyQbTADJl+LQcVRps8P4KJlZf9yPis
         gE0EkyupAZR31tIAkbESaMKPf/p+1lB3GTV8Dp8A1a4B/Z3YB/aF9T1ueKNdVFL+5sKy
         kgG6rzAGhPNC01/ZuJWPGTU/GFlOnOWdpveUp/aJIg811TJuuXnFIrRcH84k9O0X1kS/
         vmCJUqUID52G67bwpfZdQVtRjaNeV8B4hyZwEZC27ZjB9xHlCs8PMWb6Pv8advMqFvuo
         55uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nY5ircyGmJVBcwcMrvZaPID8lurhvLRNnjjwQUGl8j4=;
        b=OvJYQyd4wjr/9PoDVzcGgO/S/I8eb4T84uFUGoXTfP89LQZkpJRPYdx+G7twsnxAou
         40nFr4S8lwKrc3mockVZMowsHb4dSZp7OcMM89en1O7JTxF6M6YjQWHecX0hiIAuLIif
         dDSS1M04bqrCSFpzF86dbpe7zeJmVMhmZagXrdOVmtwjpNKZDCQmkoUawPJYDahYJL2Y
         PzTO7l5XxCP4vRU7ZrgGXNYGvX41EtHQ76//WM4CRrp14vGuy3etCW7S+33otV4fY8LU
         IM7AZSo2BAapxxPku4JI6rTc+dINjoLztTc36Oh81MEx99IayVYWJDUTEvjvTAv5l7Fr
         Q0aQ==
X-Gm-Message-State: APjAAAXrKNsbsxgYnbQdv74CpKh+LZgP6ggyNQWuxgAiHkVawI4EkySy
        wxalEwcDePJqT5P5t2GjfFcEGossV94=
X-Google-Smtp-Source: APXvYqxLZmjuULKqruNUdM2/FcehZseO4UhrW/+W70PNaS6uo2J6m8CiPZQCkW407kz704Vs341xUw==
X-Received: by 2002:ac2:4422:: with SMTP id w2mr2302781lfl.178.1575369347762;
        Tue, 03 Dec 2019 02:35:47 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t9sm1053023lfl.51.2019.12.03.02.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:35:47 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v17 18/18] trace-cmd: Debug scripts for PTP-like algorithm for host - guest timestamp synchronization
Date:   Tue,  3 Dec 2019 12:35:22 +0200
Message-Id: <20191203103522.482684-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191203103522.482684-1-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
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
index 0000000..819d1e8
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
index 0000000..f3ebb25
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
index 0000000..7d10986
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
2.23.0

