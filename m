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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0875C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC143613F1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFKLnL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:43:11 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52139 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFKLnL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:43:11 -0400
Received: by mail-wm1-f52.google.com with SMTP id l9so7937656wms.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eH7SA48qCyeRzhStQca5HuvsVbQH6zltweLF7QI7bhI=;
        b=lWjxWi0BO+5ToDzTTm9ciW0VgNwictH4LQphIDSlNA8TEyMlP2eHnlzUmaVRjd7MkO
         IahGrQpYn7uh7iBoEJgCSqU93kuYWIIiCi7n/xMoV6Zdo0KcVwNppTKwPm2M/MYT77df
         FdUZ20k7KmkJHbfy5WSsRJDOmM9LyWVO5iMLnXVfTN0UUMZfC7pAY5b7UNpTXBTrojDt
         VbIBVHmxXGzJyMs+QN61eJcKvFN9IQwuoT1DCppkoaoEkmgkDPmVX6zRGYFQeEI68Vtv
         XBGV84RPw3FkDMa79MObXIA+ZLOstcm4u3YwPf+zFBNsI61P6sFICD/EOSg42s3TYqlZ
         aOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eH7SA48qCyeRzhStQca5HuvsVbQH6zltweLF7QI7bhI=;
        b=cvFowk+fDT21F9udnpNfLT0NLvdobaH4UMdKPxDdsZqndRkbh1b9I1uE9d+XsMOsqI
         ZGZWrxqSHpw363HXgmgGXL7wCbwujl2i7wmvT8UoxGB8wtnk3pq+AJZy+sIa3xkUuN1g
         ws5mmCw0GXCBSz5aekLiI4De1V2tnhmONL5BjLz4D1QqRC18d8jZ9yZxDREJMnEzZ5q/
         qQEPxgp0AsocB9vSfdfAL7afX947UMMrA0WevrwpZlblRH8sguptDtCsCLc2UonNX4Rc
         CxF+7pWGExF5SxbQMN2RPeM2CjPx/UNF9ASnyhUWoulYM8NIJObLTyXNxSq306rK6QZq
         M/EQ==
X-Gm-Message-State: AOAM531zp0RE/GBrsmxW6r3XxtXsn/x7v1nFMh7dmORQ+eS3uHKQp5i/
        BQzV6G7bhxKRk2A+6IQ+s6UilVD0nEU=
X-Google-Smtp-Source: ABdhPJwnv60VeTxRJr8RkilK4qRv2XMIUD2sJwAWA7LkNJNNmfsVdWTDi1E8YnPKjvmBCTn7+JlzpA==
X-Received: by 2002:a1c:4b12:: with SMTP id y18mr3533774wma.70.1623411612442;
        Fri, 11 Jun 2021 04:40:12 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id c7sm6856464wrs.23.2021.06.11.04.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:40:11 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/9] trace-cruncher: Add "utils"
Date:   Fri, 11 Jun 2021 14:39:52 +0300
Message-Id: <20210611113958.38142-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611113958.38142-1-y.karadz@gmail.com>
References: <20210611113958.38142-1-y.karadz@gmail.com>
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

