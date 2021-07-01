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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9323C11F67
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55106140B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhGALRH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhGALRH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 07:17:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4507C061756
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jul 2021 04:14:35 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id p8so7737746wrr.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Jul 2021 04:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lbFuiktozormt+l7fLXg8wLHR1wkrO1VPXW4/tWtIbY=;
        b=CEJxnS2XrvmeToZfwxss/0xLy5ITJaw9pU15DdmnsKT6T+IfKlP+0dLxNU5f9xm69y
         CPEnnpP4rgItMj6ze+81yBn0+gxH2Fec9a0jkdG8Z2Yq7clqjALPbTyJpPMAboJ++wm/
         bh+oU3GliJzRR2DP3am2WLRVbdqDY4GS99le3IkRntuOYK3x93Bk3CUbg9lqzdu/9Ry2
         y6uWoqx3cy8N8hXBcvPcAlAmZ19782g3Xec93uV/qvVjzkmR1MNU7dh+P+wge/Q7HimI
         AJTZ1v244wJezJAPnp1FPAvHGEE/9RN6HHwRYvPVGRExS9Bsgo2E0vt5NUBU0nOiVE2E
         UOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lbFuiktozormt+l7fLXg8wLHR1wkrO1VPXW4/tWtIbY=;
        b=sIHqVR1Ihza0LJmg/4/7J7Eq4GCd4Ovyqe/evD8gVTSAGZeP5PWRfZprl7/iJjuS/d
         KEWDpth0dUTIy53hXiVU37E+/a6PwSJDn92x0pTlFjFqgqu/bbQ9CWu9e4q3haLxjPHU
         fl1zfTPXXmOGK8nfPnnGZaqaSmA0VeJXvEt36f1CWwXeAwpHZbsHq/9p5fzV9dMuAKLe
         cAJB9qzRuGFj3q6Zzk3k3QCLyyq327fC5rlTR4s+8FbtCDqqZ522XjCT26qpVWNSAhKA
         /rY6EvFiNpq6alWvLIYJtUsjXjl0zTJJ6nl0WH9TgJhucrzxnnuXvp/zObQxvxK1OYAh
         gunw==
X-Gm-Message-State: AOAM530aY1VCoG2P9DmP35vz2G88Q/uTRMygAJ+KpKL3hzgHQj1wdRrU
        cPq6ikReeQWRVZqkhq7miPsFCxDAKpU=
X-Google-Smtp-Source: ABdhPJwrkWai5t99pgiOPfab+pA3bpccJDYyXAx5RZUVudofvQafQm/ADFzH+AhQ4Pa/kkgcU9E0qw==
X-Received: by 2002:a05:6000:10:: with SMTP id h16mr11602971wrx.367.1625138074127;
        Thu, 01 Jul 2021 04:14:34 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id o17sm9223009wmh.19.2021.07.01.04.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 04:14:33 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 04/11] trace-cruncher: Add "utils"
Date:   Thu,  1 Jul 2021 14:14:11 +0300
Message-Id: <20210701111418.18386-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210701111418.18386-1-y.karadz@gmail.com>
References: <20210701111418.18386-1-y.karadz@gmail.com>
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
 tracecruncher/ft_utils.py |  19 ++++
 tracecruncher/ks_utils.py | 227 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 246 insertions(+)
 create mode 100644 tracecruncher/__init__.py
 create mode 100644 tracecruncher/ft_utils.py
 create mode 100644 tracecruncher/ks_utils.py

diff --git a/tracecruncher/__init__.py b/tracecruncher/__init__.py
new file mode 100644
index 0000000..e69de29
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
new file mode 100644
index 0000000..eae161c
--- /dev/null
+++ b/tracecruncher/ft_utils.py
@@ -0,0 +1,19 @@
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import sys
+import time
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

