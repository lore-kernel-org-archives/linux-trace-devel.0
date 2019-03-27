Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAEBC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F6FF20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfC0QD6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:03:58 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38841 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfC0QD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 12:03:57 -0400
Received: by mail-pl1-f196.google.com with SMTP id g37so3524473plb.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 09:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bzWrH+isx16ZgTWNl9NjPHRJcn9B+m5UVfnnt3zY+Qc=;
        b=A54I/py5o9Hk/zQVhFXYNuA3a6xPeZpCkPch0ZUwOhVIPiRXyiTkT0TqR8pAdfDaW8
         G2EIZZRw2j2c92Jl3r0rHdV9vhMhPCJZvrjPWaucz+Ii5aJK5AtD38lpmJPhBYPJ8011
         KaAZAgGAiJ3676AyqdeOcsrqpbGgqsCwqp5o0aLSiRbN1QaNRKUDBAyvHTbwLHjP4UpU
         YPNXomANX2wHK5R6qaalUP6BLTtyXGaObAJDtxc14XFprWc9FfofvG6FnwwAndU7dcQq
         xSi3ktJp4hJwGah+0hBVoMgigyn3+Rspz7jQpeVD+/F8pYCgeKFmNtrLzu0gPC7xUIh1
         r93g==
X-Gm-Message-State: APjAAAVqhaloVvlnGo9voi2pADGgGL3JmfPjnZYMVLVNGT0FAxLE6WFX
        +bwVpLEe4p3YTPET4RNUIbU=
X-Google-Smtp-Source: APXvYqxE1tTSZmrbdAPDrd5ZUTgcSJQH47DnzghuI7kZlR9dgaIu3/E1jLk7U37P2AycUTc7tWtVjA==
X-Received: by 2002:a17:902:7590:: with SMTP id j16mr3177289pll.98.1553702637271;
        Wed, 27 Mar 2019 09:03:57 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p88sm36150806pfa.80.2019.03.27.09.03.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:03:56 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [RFC 7/7] kernel-shark: Add basic example demonstrating the NumPy interface
Date:   Wed, 27 Mar 2019 18:03:23 +0200
Message-Id: <20190327160323.31654-8-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327160323.31654-1-ykaradzhov@vmware.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The example script plots the distribution (histogram) of the pulseaudio
wake-up times and finds the biggest latency. The script also generates
a KernelShark session descriptor file (JSON). The session descriptor file
can be used by the KernelSherk GUI to open a session which will directly
visualize the largest wake-up latency.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/bin/sched_wakeup.py | 96 ++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100755 kernel-shark/bin/sched_wakeup.py

diff --git a/kernel-shark/bin/sched_wakeup.py b/kernel-shark/bin/sched_wakeup.py
new file mode 100755
index 0000000..79dbedd
--- /dev/null
+++ b/kernel-shark/bin/sched_wakeup.py
@@ -0,0 +1,96 @@
+#!/usr/bin/env python2
+
+import matplotlib.pyplot as plt
+import libkshark_wrapper as ks
+import scipy.stats as st
+import numpy as np
+import array
+import json
+import sys
+
+fname = str(sys.argv[1])
+
+ks.open_file(fname)
+ofst, cpu, evt, pid, ts = ks.load_data()
+tasks = ks.get_tasks()
+task_pid = tasks["pulseaudio"]
+
+ss_eid = ks.event_id("sched", "sched_switch");
+w_eid = ks.event_id("sched", "sched_waking");
+
+i = evt.size - 1
+dt = []
+delta_max = i_ss_max = i_sw_max = 0
+
+while (i >= 0):
+  if (evt[i] == ss_eid):
+    next_pid = ks.read_event_field(offset=ofst[i],
+                                   sys="sched",
+                                   event="sched_switch",
+                                   field="next_pid")
+
+    if (next_pid == task_pid):
+      time_ss = ts[i]
+      index_ss = i
+
+      while(i >= 0):
+        i = i - 1
+        if (evt[i] == w_eid):
+          waking_pid = ks.read_event_field(offset=ofst[i],
+                                           sys="sched",
+                                           event="sched_waking",
+                                           field="pid")
+
+          if (waking_pid == task_pid):
+            delta = (time_ss - ts[i]) / 1000.
+            #print delta
+            dt.append(delta);
+            if (delta > delta_max):
+              print "lat. max: ", delta
+              i_ss_max = index_ss
+              i_sw_max = i
+              delta_max = delta
+
+            break
+
+  i = i - 1
+
+desc = st.describe(np.array(dt))
+print desc
+
+fig, ax = plt.subplots(nrows=1, ncols=1)
+fig.set_figheight(6)
+fig.set_figwidth(7)
+
+rect = fig.patch
+rect.set_facecolor('white')
+
+ax.set_xlabel('latency [$\mu$s]')
+plt.yscale('log')
+ax.hist(dt, bins=(200), histtype=u'step');
+plt.show()
+
+sname = 'sched.json'
+ks.new_session(fname, sname)
+
+with open(sname, "r+") as s:
+  session = json.load(s)
+  session['TaskPlots'] = [task_pid]
+  session['CPUPlots'] = [int(cpu[i_sw_max]), int(cpu[i_ss_max])]
+
+  delta = ts[i_ss_max] - ts[i_sw_max]
+  tmin = int(ts[i_sw_max] - delta)
+  tmax = int(ts[i_ss_max] + delta)
+  session['Model']['range'] = [tmin, tmax]
+
+  session['Markers']['markA']['isSet'] = True
+  session['Markers']['markA']['row'] = int(i_sw_max)
+
+  session['Markers']['markB']['isSet'] = True
+  session['Markers']['markB']['row'] = int(i_ss_max)
+
+  session['ViewTop'] = int(i_sw_max) - 5
+
+  ks.save_session(session, s)
+
+ks.close()
-- 
2.19.1

