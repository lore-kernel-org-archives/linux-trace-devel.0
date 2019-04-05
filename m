Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56610C10F0F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3133420651
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfDEKO1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:14:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42274 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbfDEKO0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:14:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id g3so7266864wrx.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cbo98OGECtDOdbjU1D4IGLQXzptCaKoNOZXLvDcbwhU=;
        b=FKjBhVOllm0DQvOoKQ7gKb+30l03SKQsIqe9bQFW6zz16RII6ugSL4/RVcRxN4xNzi
         yJeNB1o4RCe2eWvCAfWkcLClMecSXkZPmXAKo0ZqteZydt/u5R1RqsXnGk+7mbs4wKfk
         23wSDodFXbgm6a9jzOvEejJ66C/3B+sRMCCsTRO14HDfxfBQX63RNbcfj+ysh+a01Dqa
         Zh5IxUVzbsg+nbMxqn8K9sTR1/awKFKFbYTg348hegGq3C0kB/tKWxXp9OmU78nJP26V
         em8/4xTygLi9xD7r0gDesumsx897yegJNqEETXe52r7oEdEKWv/K+DcSMXUxMEItk5p8
         OGvQ==
X-Gm-Message-State: APjAAAU2Ot3ohtDV2apSkjwW3TDPiPaOe7Ttx4YhbxLiclK2njNbsR6s
        m7HDjyGCiDUEjIk1W/GugXU=
X-Google-Smtp-Source: APXvYqx4bHjxf3G3hwC0s7NGaGV8Dv1S4hpBcWl+tXK7wiuxHb3YzIjsNt6rTJTVmEqmANba82bRLw==
X-Received: by 2002:adf:ba81:: with SMTP id p1mr8170642wrg.192.1554459265097;
        Fri, 05 Apr 2019 03:14:25 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a187sm1851124wma.32.2019.04.05.03.14.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:14:24 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC v2 6/6] kernel-shark: Add basic example demonstrating the NumPy interface
Date:   Fri,  5 Apr 2019 13:14:11 +0300
Message-Id: <20190405101411.25466-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405101411.25466-1-ykaradzhov@vmware.com>
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
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
 kernel-shark/bin/sched_wakeup.py | 106 +++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100755 kernel-shark/bin/sched_wakeup.py

diff --git a/kernel-shark/bin/sched_wakeup.py b/kernel-shark/bin/sched_wakeup.py
new file mode 100755
index 0000000..8e2cfc1
--- /dev/null
+++ b/kernel-shark/bin/sched_wakeup.py
@@ -0,0 +1,106 @@
+#!/usr/bin/env python3
+
+""" The license to be determined !!!!
+"""
+
+import json
+import sys
+
+import matplotlib.pyplot as plt
+import scipy.stats as st
+import numpy as np
+
+import ksharkpy as ks
+
+fname = str(sys.argv[1])
+
+ks.open_file(fname)
+
+# We do not need the Process Ids of the records.
+# Do not load the "pid" data.
+data = ks.load_data(pid_data=False)
+
+tasks = ks.get_tasks()
+task_pid = tasks['pulseaudio']
+
+# Get the Event Ids of the sched_switch and sched_waking events.
+ss_eid = ks.event_id('sched', 'sched_switch')
+w_eid = ks.event_id('sched', 'sched_waking')
+
+# Gey the size of the data.
+i = data['offset'].size
+
+dt = []
+delta_max = i_ss_max = i_sw_max = 0
+
+while i > 0:
+    i = i - 1
+    if data['event'][i] == ss_eid:
+        next_pid = ks.read_event_field(offset=data['offset'][i],
+                                       event_id=ss_eid,
+                                       field='next_pid')
+
+        if next_pid == task_pid:
+            time_ss = data['time'][i]
+            index_ss = i
+
+            while i > 0:
+                i = i - 1
+                if (data['event'][i] == w_eid):
+                    waking_pid = ks.read_event_field(offset=data['offset'][i],
+                                                     event_id=w_eid,
+                                                     field='pid')
+
+                    if waking_pid == task_pid:
+                        delta = (time_ss - data['time'][i]) / 1000.
+                        # print(delta)
+                        dt.append(delta)
+                        if delta > delta_max:
+                            print('lat. max: ', delta)
+                            i_ss_max = index_ss
+                            i_sw_max = i
+                            delta_max = delta
+
+                        break
+
+desc = st.describe(np.array(dt))
+print(desc)
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
+ax.hist(dt, bins=(200), histtype='step')
+plt.show()
+
+sname = 'sched.json'
+ks.new_session(fname, sname)
+
+with open(sname, 'r+') as s:
+    session = json.load(s)
+    session['TaskPlots'] = [task_pid]
+    session['CPUPlots'] = [
+        int(data['cpu'][i_sw_max]),
+        int(data['cpu'][i_ss_max])]
+
+    delta = data['time'][i_ss_max] - data['time'][i_sw_max]
+    tmin = int(data['time'][i_sw_max] - delta)
+    tmax = int(data['time'][i_ss_max] + delta)
+    session['Model']['range'] = [tmin, tmax]
+
+    session['Markers']['markA']['isSet'] = True
+    session['Markers']['markA']['row'] = int(i_sw_max)
+
+    session['Markers']['markB']['isSet'] = True
+    session['Markers']['markB']['row'] = int(i_ss_max)
+
+    session['ViewTop'] = int(i_sw_max) - 5
+
+    ks.save_session(session, s)
+
+ks.close()
-- 
2.19.1

