Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0121FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2CA861107
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbhDSNCc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239349AbhDSNC2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 09:02:28 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD3BC06174A
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:57 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o9-20020a1c41090000b029012c8dac9d47so11129438wma.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eH7SA48qCyeRzhStQca5HuvsVbQH6zltweLF7QI7bhI=;
        b=jt9Swlq3m4FfunZhI39hvjfnrav8+QemH+xQrlRHoeZ3w2GHQH1mLjNnDXYCY9F7Ff
         g2A2J37duT0bZsi9oORKepiQzjoC1llk6gPkLlc6IazYtKxDzZnCBoU48yW5hJF+pQbI
         buAbxaq5ydxAZR3EKhNV9vExVqmHM8p0KC6MatDoLPutjP990BLjqOWqe3w0eQgE6yNN
         teiKArjWaGnbkv0TRw7Ftvuh7/kKpZNunMcTDTkdIRXfiG1YDh/ZKjyNttaDedR5LngW
         IwSvxZoCRvAiFnC4efBSZsdGThixUwNr28/RWPNCi7SrXGHwa7R3yE3LvY2lb2fSI/K/
         ggwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eH7SA48qCyeRzhStQca5HuvsVbQH6zltweLF7QI7bhI=;
        b=JcaD8oRY98hv54rlmqQyq83uhZPtzR8EnfnAq9mM0uMf3GLMs+0Ke0dwSQDduRh+Nm
         QHGVJx+rn+OQUTMcOJSDtxiXWcvCqXazIERctvVFT2Tdd54myYRuYMA0Mlr8X0Nnkeke
         H+tBjdVle8WiMPlMqMTAaSI+8MX6LncUYJa4vql65oKQpstA4Zv6Vif+9d4n1OuyS2VN
         r7XvKTZOIxI1Prkdlp6FQI+5t5amgbS2ci+10GWVikMnXfyb0qWTHohDJ8b2uRVF/67c
         M0dgApKlmOQh4F5hGJg4ttGWJNtKViodSv1wyogSJUUfbjBgd1a6y/zuaH2CsSWKEN/Q
         yjoA==
X-Gm-Message-State: AOAM530DpRwIXbaMjqDykplTSaDj86xfpuJxQXD0wz5RismB2O/0fZM7
        HLIBcHDWY3waMG3yEVAjRNkLKahRyws=
X-Google-Smtp-Source: ABdhPJx+zun2sG/hbxNrQ1pfOBmHragm9RhU57VcahheygjLhmHPG1MO3B4fNTrpkSoX6IvzTaQiqg==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr7123455wmq.111.1618837315974;
        Mon, 19 Apr 2021 06:01:55 -0700 (PDT)
Received: from bucy.vmware.com ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id v7sm23164196wrs.2.2021.04.19.06.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 06:01:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/9] trace-cruncher: Add "utils"
Date:   Mon, 19 Apr 2021 16:01:34 +0300
Message-Id: <20210419130140.59140-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210419130140.59140-1-y.karadz@gmail.com>
References: <20210419130140.59140-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Place all the code, that is pure Python, in
tracecrunche/ks_utils.py and tracecrunche/ft_utils.py

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/__init__.py |   0
 tracecruncher/ft_utils.py |  28 +++++
 tracecruncher/ks_utils.py | 227 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+)
 create mode 100644 tracecruncher/__init__.py
 create mode 100644 tracecruncher/ft_utils.py
 create mode 100644 tracecruncher/ks_utils.py

diff --git a/tracecruncher/__init__.py b/tracecruncher/__init__.py
new file mode 100644
index 0000000..e69de29
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
new file mode 100644
index 0000000..4e99547
--- /dev/null
+++ b/tracecruncher/ft_utils.py
@@ -0,0 +1,28 @@
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import sys
+import time
+import hashlib
+
+from . import ftracepy as ft
+
+
+def find_event_id(system, event):
+    """ Get the unique identifier of a trace event.
+    """
+    tep = ft.tep_handle();
+    tep.init_local(dir=ft.dir(), systems=[system]);
+
+    return tep.get_event(system=system, name=event).id()
+
+def instance_autoname():
+    """ Generates a quasi-random (unique) name for a trace instance.
+    """
+    unique = ''.join(sys.argv) + str(time.time())
+    hash = hashlib.sha1()
+    hash.update(unique.encode('utf-8'))
+    return hash.hexdigest()
diff --git a/tracecruncher/ks_utils.py b/tracecruncher/ks_utils.py
new file mode 100644
index 0000000..15c7835
--- /dev/null
+++ b/tracecruncher/ks_utils.py
@@ -0,0 +1,227 @@
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import os
+import json
+
+from . import npdatawrapper as dw
+from . import ksharkpy as ks
+
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
+
+class trace_file_stream:
+    def __init__(self, file_name='', buffer_name='top'):
+        """ Constructor.
+        """
+        self.file_name = file_name
+        self.buffer_name = buffer_name
+        self.stream_id = -1
+
+        if file_name:
+            self.open(file_name)
+
+    def open(self, file_name):
+        """ Open a trace file for reading.
+        """
+        self.file_name = file_name
+        self.stream_id = ks.open(self.file_name)
+
+    def open_buffer(self, file_name, buffer_name):
+        """ Open a aprticular buffer in a trace file for reading.
+        """
+        self.file_name = file_name
+        self.buffer_name = buffer_name
+        self.stream_id = ks.open_buffer(self.file_name, buffer_name)
+
+    def close(self):
+        """ Close this trace data stream.
+        """
+        if self.stream_id >= 0:
+            ks.close(self.stream_id)
+            self.stream_id = -1
+
+    def set_clock_offset(self, offset):
+        """ Set the clock offset to be append to the timestamps of this trace
+            data stream.
+        """
+        ks.set_clock_offset(stream_id=self.stream_id, offset=offset)
+
+    def load(self, cpu_data=True, pid_data=True, evt_data=True,
+             ofst_data=True, ts_data=True):
+        """ Load the trace data.
+        """
+        return dw.load(stream_id=self.stream_id,
+                       ofst_data=ofst_data,
+                       cpu_data=cpu_data,
+                       ts_data=ts_data,
+                       pid_data=pid_data,
+                       evt_data=evt_data)
+
+    def get_tasks(self):
+        """ Get a dictionary (name and PID) of all tasks presented in the
+            tracing data.
+        """
+        return ks.get_tasks(stream_id=self.stream_id)
+
+    def event_id(self, name):
+        """ Retrieve the unique ID of the event from its name.
+        """
+        return ks.event_id(stream_id=self.stream_id, name=name)
+
+    def event_name(self, event_id):
+        """ Retrieve the name of the event from its unique ID.
+        """
+        return ks.event_name(stream_id=self.stream_id, event_id=event_id)
+
+    def read_event_field(self, offset, event_id, field):
+        """ Retrieve the value of a trace event field.
+        """
+        return ks.read_event_field(stream_id=self.stream_id,
+                                   offset=offset,
+                                   event_id=event_id,
+                                   field=field)
+
+    def __enter__(self):
+        """
+        """
+        self.open(self.file_name)
+        return self
+
+    def __exit__(self,
+                 exception_type,
+                 exception_value,
+                 traceback):
+        """
+        """
+        self.close()
+
+    def __del__(self):
+        """
+        """
+        self.close()
+
+
+class ks_session:
+    def __init__(self, session_name):
+        """ Constructor.
+        """
+        self.gui_session(session_name)
+
+    def gui_session(self, session_name):
+        """ Generate a default KernelShark session description
+            file (JSON).
+        """
+        self.name, extension = os.path.splitext(session_name)
+        json_file = session_name
+        if extension != '.json':
+            json_file += '.json'
+
+        ks.new_session_file(session_file=json_file)
+
+        self.session_file = open(json_file, 'r+')
+        self.session_doc = json.load(self.session_file)
+
+        self.session_doc['Splitter'] = [1, 1]
+        self.session_doc['MainWindow'] = [1200, 800]
+        self.session_doc['ViewTop'] = 0
+        self.session_doc['ColorScheme'] = 0.75
+        self.session_doc['Model']['bins'] = 1000
+
+        self.session_doc['Markers']['markA'] = {}
+        self.session_doc['Markers']['markA']['isSet'] = False
+        self.session_doc['Markers']['markB'] = {}
+        self.session_doc['Markers']['markB']['isSet'] = False
+        self.session_doc['Markers']['Active'] = 'A'
+
+        for stream_doc in self.session_doc["data streams"]:
+            stream_doc['CPUPlots'] = []
+            stream_doc['TaskPlots'] = []
+
+        self.session_doc['ComboPlots'] = []
+
+    def set_cpu_plots(self, stream, plots):
+        """ Add a list of CPU plots to the KernelShark session description
+            file.
+        """
+        for stream_doc in self.session_doc['data streams']:
+            if stream_doc['stream id'] == stream.stream_id:
+                stream_doc['CPUPlots'] = list(map(int, plots))
+
+    def set_task_plots(self, stream, plots):
+        """ Add a list of Task plots to the KernelShark session description
+            file.
+        """
+        for stream_doc in self.session_doc['data streams']:
+            if stream_doc['stream id'] == stream.stream_id:
+                stream_doc['TaskPlots'] = list(map(int, plots))
+
+    def set_time_range(self, tmin, tmax):
+        """ Set the time range of the KernelShark visualization model.
+        """
+        self.session_doc['Model']['range'] = [int(tmin), int(tmax)]
+
+    def set_marker_a(self, row):
+        """ Set the position of Marker A.
+        """
+        self.session_doc['Markers']['markA']['isSet'] = True
+        self.session_doc['Markers']['markA']['row'] = int(row)
+
+    def set_marker_b(self, row):
+        """ Set the position of Marker B.
+        """
+        self.session_doc['Markers']['markB']['isSet'] = True
+        self.session_doc['Markers']['markB']['row'] = int(row)
+
+    def set_first_visible_row(self, row):
+        """ Set the number of the first visible row in the text data viewer.
+        """
+        self.session_doc['ViewTop'] = int(row)
+
+    def add_plugin(self, stream, plugin):
+        """ In the KernelShark session description file, add a plugin to be
+            registered to a given trace data stream.
+        """
+        for stream_doc in self.session_doc["data streams"]:
+            if stream_doc['stream id'] == stream.stream_id:
+                stream_doc['plugins']['registered'].append([plugin, True])
+
+    def add_event_filter(self, stream, events):
+        """ In the KernelShark session description file, add a list of
+            event IDs to be filtered out.
+        """
+        for stream_doc in self.session_doc["data streams"]:
+            if stream_doc['stream id'] == stream.stream_id:
+                stream_doc['filters']['hide event filter'] = events
+
+    def save(self):
+        """ Save a KernelShark session description of a JSON file.
+        """
+        self.session_file.seek(0)
+        json.dump(self.session_doc, self.session_file, indent=4)
+        self.session_file.truncate()
+
+
+def open_file(file_name):
+    """ Open a trace file for reading.
+    """
+    return trace_file_stream(file_name)
+
+
+def open_buffer(file_name, buffer_name):
+    """ Open a aprticular buffer in a trace file for reading.
+    """
+    s = trace_file_stream()
+    s.open_buffer(file_name, buffer_name)
+    return s
-- 
2.27.0

