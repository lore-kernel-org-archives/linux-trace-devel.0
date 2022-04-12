Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B389C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Apr 2022 12:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346176AbiDLMeH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 08:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352896AbiDLMd1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 08:33:27 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA44A5BE68
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:52:22 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h126-20020a1c2184000000b0038eb17fb7d6so1605379wmh.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D12TEA3p6xz0GBcdV2BRXBHFHZ6IAacldSWd/fT0Fok=;
        b=iMwmDU3sxwnvtRmM/Ftu7btfnpsikacbMGQ4taN3THNHHlG5iq7HMb2Hf7IUfmfYPF
         ewvlIBqg3o/thgCp3ID3x3m0zEnymEF6aXVQwiQ0qscwdyf8EZGeHtio50yyuyfWiD3Q
         4djGckCjOmyFhcn9n71n1Tb+EO3cQgcaQyFIrrKnAkdJ9Cs+LpWVNU0Ovba7WSDLzlgr
         T62sceJhOpsfTaM9xTwfkqXHP/flUr5IkuH+5gyLcIY1VtVyKWZwVx8nD0p8gigw5zSu
         YspC74NK/lic57SLBH0NjowgYcTQQwmebhwmqTM2sJmu7WTCEzuveKb1K3hJBdq3NP6K
         SU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D12TEA3p6xz0GBcdV2BRXBHFHZ6IAacldSWd/fT0Fok=;
        b=ZRTG9Uuz3O/v3oE9T19daOpWaT+csmjLfVz78A0PrToRYdqPYDHwz0lyBPMvQwEiMV
         EDrG5KRloFjGUCQXX0oxFS1lBydw313dgPkMNpVst+lplFFyr+exFP0ub07hTwlSBQkP
         p5GIhYeo3MjH4PP+vHDOI285NbWUWGMm/5r+T9aOZZwnQUpzvxJE09+nVFQZetN455le
         1wKIrHahAQxJ2g7pZlKNdY1ZzDv/zXRd3yIYion4KTZCARn0Mnog20ncmYy8aNMzznq6
         kAefy01DD2HoT2guXYr6tdJMY1sdts/eQmUEdw96N2ovBgDCXphz6eJrDrUE1Kuw4OfI
         lQsA==
X-Gm-Message-State: AOAM5324pwc/bV3QJyh2l+UBwnklwe4OjmbZOdI8Dizja04uSNanigZc
        SVNVT6o10hSfWunNtJS8RfG39frpDMA=
X-Google-Smtp-Source: ABdhPJxczrb8jRJrR045fVyKwOaJlTtNt7yNAzy/KA/EnlN+BRjAAaCTukBJbU0OZXpyskZ/3KuiNw==
X-Received: by 2002:a05:600c:34c4:b0:38e:b628:da95 with SMTP id d4-20020a05600c34c400b0038eb628da95mr3759773wmq.150.1649764339005;
        Tue, 12 Apr 2022 04:52:19 -0700 (PDT)
Received: from crow.. (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d6d0e000000b002078ea4f6bdsm14148750wrq.75.2022.04.12.04.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 04:52:18 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Add documentation for tracecruncher.ftracepy
Date:   Tue, 12 Apr 2022 14:51:49 +0300
Message-Id: <20220412115150.513744-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Python style documentation for the 'ftracepy' submodule, based on pydocs,
is added. To build the type 'sudo make doc'. Documentation for all other
submodules of trace-cruncher will be added in following patches.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile            |   11 +
 README.md           |    2 +-
 docs/setup.py       |   36 ++
 src/ftracepy-docs.h | 1416 +++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy.c      |  182 +++---
 5 files changed, 1556 insertions(+), 91 deletions(-)
 create mode 100644 docs/setup.py
 create mode 100644 src/ftracepy-docs.h

diff --git a/Makefile b/Makefile
index a509811..ff9979b 100644
--- a/Makefile
+++ b/Makefile
@@ -5,11 +5,14 @@
 #
 
 UID := $(shell id -u)
+GID := $(shell id -g)
 
 CYAN	:= '\e[36m'
 PURPLE	:= '\e[35m'
 NC	:= '\e[0m'
 
+DOCDIR = ./docs
+
 all:
 	@ echo ${CYAN}Buildinging trace-cruncher:${NC};
 	python3 setup.py build
@@ -31,3 +34,11 @@ uninstall:
 	rm -rfv dist tracecruncher.egg-info; \
 	rm -fv install_manifest.txt; \
 	fi
+
+doc:
+	@ echo ${CYAN}Buildinging trace-cruncher documentation:${NC};
+	@ python3 $(DOCDIR)/setup.py builtins
+	@ sudo python3 $(DOCDIR)/setup.py tracecruncher.ftracepy $(UID) $(GID)
+
+clean_doc:
+	@ rm -f $(DOCDIR)/*.html
diff --git a/README.md b/README.md
index 740d60b..95cbd8e 100644
--- a/README.md
+++ b/README.md
@@ -6,7 +6,7 @@
 
 The Trace-Cruncher project aims to provide an interface between the existing instrumentation for collection and visualization of tracing data from the Linux kernel and the broad and very well developed ecosystem of instruments for data analysis available in Python.
 
-The Trace-Cruncher allows for sophisticated analysis of kernel tracing data via scripts, but it also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the [libtraceevent](https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git), [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/) and [KernelShark](https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/) projects and is build on top of the C API of this librearies.
+The Trace-Cruncher allows for sophisticated analysis of kernel tracing data via scripts, but it also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the [libtraceevent](https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git), [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/) and [KernelShark](https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/) projects and is build on top of the C API of these librearies.
 
 ## Try it out
 
diff --git a/docs/setup.py b/docs/setup.py
new file mode 100644
index 0000000..c136eee
--- /dev/null
+++ b/docs/setup.py
@@ -0,0 +1,36 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2022 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import pydoc
+import sys
+import os
+
+def main():
+    path = os.path.abspath(sys.argv[0])
+    d = os.path.dirname(path)
+    os.chdir(d)
+
+    module = sys.argv[1]
+    pydoc.writedoc(module)
+
+    doc_file = './' + module + '.html'
+    with open(doc_file, 'rt') as f:
+        data = f.read()
+        data = data.replace('#ee77aa', '#5577aa')
+        data = data.replace('#ffc8d8', '66c8d8')
+        data = data.replace('#eeaa77', '55aa77')
+
+    with open(doc_file, 'wt') as f:
+        f.write(data)
+
+    if len(sys.argv) == 4:
+        os.chown(doc_file, int(sys.argv[2]), int(sys.argv[3]))
+
+
+if __name__ == '__main__':
+    main()
diff --git a/src/ftracepy-docs.h b/src/ftracepy-docs.h
new file mode 100644
index 0000000..64b025e
--- /dev/null
+++ b/src/ftracepy-docs.h
@@ -0,0 +1,1416 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright 2022 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+#ifndef _TC_FTRACE_PY_DOCS
+#define _TC_FTRACE_PY_DOCS
+
+PyDoc_STRVAR(PyTepRecord_time_doc,
+	     "time()\n"
+	     "--\n\n"
+	     "Get the time of the record.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "t : int\n"
+	     "    Timestamp in nanoseconds"
+);
+
+PyDoc_STRVAR(PyTepRecord_CPU_doc,
+	     "CPU()\n"
+	     "--\n\n"
+	     "Get the CPU Id number of the record.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "cpu : int\n"
+	     "    CPU Id number."
+);
+
+PyDoc_STRVAR(PyTepEvent_name_doc,
+	     "name()\n"
+	     "--\n\n"
+	     "Get the name of the event.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "name : string\n"
+	     "    Event name"
+);
+
+PyDoc_STRVAR(PyTepEvent_id_doc,
+	     "id()\n"
+	     "--\n\n"
+	     "Get the unique Id number of the event.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "id : int\n"
+	     "    Id number."
+);
+
+PyDoc_STRVAR(PyTepEvent_field_names_doc,
+	     "field_names()\n"
+	     "--\n\n"
+	     "Get the names of all fields of a given event.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "list of strings\n"
+	     "    All fields of the event"
+);
+
+PyDoc_STRVAR(PyTepEvent_parse_record_field_doc,
+	     "parse_record_field(record, field)\n"
+	     "--\n\n"
+	     "Get the content of a record field.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "record : PyTepRecord\n"
+	     "    Event record to derive the field value from.\n"
+	     "\n"
+	     "field : string\n"
+	     "    The name of the field.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "fld : int or string \n"
+	     "    The value of the field."
+);
+
+PyDoc_STRVAR(PyTepEvent_get_pid_doc,
+	     "get_pid(record)\n"
+	     "--\n\n"
+	     "Get the Process Id of the record.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "record : PyTepRecord\n"
+	     "    Event record to derive the PID from.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "pid : int\n"
+	     "    PID value."
+);
+
+PyDoc_STRVAR(PyTep_init_local_doc,
+	     "init_local(dir)\n"
+	     "--\n\n"
+	     "Initialize tep from the local events\n"
+	     "\n"
+	     "Create Trace Events Parser (tep) from a trace instance path.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "dir : string\n"
+	     "    The instance directory that contains the events.\n"
+	     "\n"
+	     "system : string or list of strings (optional)\n"
+	     "    One or more system names, to load the events from. This argument is optional.\n"
+);
+
+PyDoc_STRVAR(PyTep_get_event_doc,
+	     "get_event(system, name)\n"
+	     "--\n\n"
+	     "Get a Tep Event for a given trace event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "system : string\n"
+	     "    The system of the event.\n"
+	     "\n"
+	     "name : string\n"
+	     "    The name of the event.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "evt : PyTepEvent\n"
+	     "    A Tep Event corresponding to the given trace event."
+);
+
+PyDoc_STRVAR(PyTep_event_record_doc,
+	     "event_record(event, record)\n"
+	     "--\n\n"
+	     "Generic print of a recorded trace event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "event : PyTepEvent\n"
+	     "    The event descriptor.\n"
+	     "\n"
+	     "record : PyTepRecord\n"
+	     "    The record.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "rec : string\n"
+	     "    The recorded tracing data in a human-readable form."
+);
+
+PyDoc_STRVAR(PyTep_process_doc,
+	     "process(event, record)\n"
+	     "--\n\n"
+	     "Generic print of the process that generated the trace event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "event : PyTepEvent\n"
+	     "    The event descriptor.\n"
+	     "\n"
+	     "record : PyTepRecord\n"
+	     "    The record.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "proc : string\n"
+	     "    The name of the process and its PID number."
+);
+
+PyDoc_STRVAR(PyTep_info_doc,
+	     "info(event, record)\n"
+	     "--\n\n"
+	     "Generic print of a trace event information.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "event : PyTepEvent\n"
+	     "    The event descriptor.\n"
+	     "\n"
+	     "record : PyTepRecord\n"
+	     "    The record.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "dir : string\n"
+	     "    The recorded values of the event fields in a human-readable form."
+);
+
+PyDoc_STRVAR(PyTep_short_kprobe_print_doc,
+	     "short_kprobe_print(system, event, id)\n"
+	     "--\n\n"
+	     "Do not print the address of the probe.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "system : string\n"
+	     "    The system of the event.\n"
+	     "\n"
+	     "event : string\n"
+	     "    The name of the event.\n"
+	     "\n"
+	     "id : int (optional)\n"
+	     "    The Id number of the event. This argument is optional."
+);
+
+PyDoc_STRVAR(PyTfsInstance_dir_doc,
+	     "dir()\n"
+	     "--\n\n"
+	     "Get the absolute path to the Ftrace instance directory.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "dir : string\n"
+	     "    Ftrace instance directory.\n"
+	     "\n"
+);
+
+PyDoc_STRVAR(PyDynevent_event_doc,
+	     "event()\n"
+	     "--\n\n"
+	     "Get the name of the dynamic event.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "name : string\n"
+	     "    The unique name of the event."
+);
+
+PyDoc_STRVAR(PyDynevent_system_doc,
+	     "system()\n"
+	     "--\n\n"
+	     "Get the system name of the dynamic event.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "system : string\n"
+	     "    The unique name of the event's system."
+);
+
+PyDoc_STRVAR(PyDynevent_address_doc,
+	     "address()\n"
+	     "--\n\n"
+	     "Get the address / function name of the dynamic event.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "address : string\n"
+	     "    The address / function name."
+);
+
+PyDoc_STRVAR(PyDynevent_probe_doc,
+	     "probe()\n"
+	     "--\n\n"
+	     "Get the event definition.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "probe : string\n"
+	     "    The descriptor of the probe."
+);
+
+PyDoc_STRVAR(PyDynevent_register_doc,
+	     "register()\n"
+	     "--\n\n"
+	     "Register dynamic event.\n"
+);
+
+PyDoc_STRVAR(PyDynevent_unregister_doc,
+	     "unregister()\n"
+	     "--\n\n"
+	     "Unregister dynamic event.\n"
+);
+
+PyDoc_STRVAR(PyDynevent_set_filter_doc,
+	     "set_filter(filter, instance)\n"
+	     "--\n\n"
+	     "Define a filter for a dynamic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "filter : string\n"
+	     "    The filter descriptor.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyDynevent_get_filter_doc,
+	     "get_filter(instance)\n"
+	     "--\n\n"
+	     "Get the filter of a dynamic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "filter : string\n"
+	     "    The filter descriptor."
+);
+
+PyDoc_STRVAR(PyDynevent_clearfilter_doc,
+	     "clear_filter(instance)\n"
+	     "--\n\n"
+	     "Clear the filter of a dynamic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "filter : string\n"
+	     "    The filter descriptor."
+);
+
+PyDoc_STRVAR(PyDynevent_enable_doc,
+	     "enable(instance)\n"
+	     "--\n\n"
+	     "Enable dynamic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyDynevent_disable_doc,
+	     "disable(instance)\n"
+	     "--\n\n"
+	     "Disable dynamic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyDynevent_is_enabled_doc,
+	     "is_enabled(instance)\n"
+	     "--\n\n"
+	     "Check if dynamic event is enabled.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "bool : enb\n"
+	     "    True if the event is enable."
+);
+
+PyDoc_STRVAR(PyTraceHist_add_value_doc,
+	     "add_value(value)\n"
+	     "--\n\n"
+	     "Add value field to be used as a weight of the individual histogram entries.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "value : string\n"
+	     "    The key name of the value field.\n"
+);
+
+PyDoc_STRVAR(PyTraceHist_sort_keys_doc,
+	     "sork_keys()\n"
+	     "--\n\n"
+	     "Set key felds or values to sort on.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "keys : string or list of strings\n"
+	     "    The keys to sort.\n"
+);
+
+PyDoc_STRVAR(PyTraceHist_sort_key_direction_doc,
+	     "sort_key_direction(sort_key, direction)\n"
+	     "--\n\n"
+	     "Set the direction of a sort for key field.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "sort_key : string\n"
+	     "    The key to set sort direction.\n"
+	     "\n"
+	     "direction : int or string\n"
+	     "    Use 0, 'a', 'asc' or 'ascending' for ascending direction.\n"
+	     "    Use 1, 'd', 'desc' or 'descending' for descending direction.\n"
+);
+
+PyDoc_STRVAR(PyTraceHist_start_doc,
+	     "start(instance)\n"
+	     "--\n\n"
+	     "Start acquiring data.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyTraceHist_stop_doc,
+	     "stop(instance)\n"
+	     "--\n\n"
+	     "Stop (pause) acquiring data.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyTraceHist_resume_doc,
+	     "resume(instance)\n"
+	     "--\n\n"
+	     "Resune (continue) acquiring data.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyTraceHist_clear_doc,
+	     "clear(instance)\n"
+	     "--\n\n"
+	     "Clear (reset) the histogram.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyTraceHist_read_doc,
+	     "read(instance)\n"
+	     "--\n\n"
+	     "Read the content of the histogram."
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "data : string\n"
+	     "    Summary of the data being acquired."
+);
+
+PyDoc_STRVAR(PyTraceHist_close_doc,
+	     "close(instance)\n"
+	     "--\n\n"
+	     "Close (destroy) the histogram..\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_add_start_fields_doc,
+	     "add_start_fields(fields, names)\n"
+	     "--\n\n"
+	     "Add fields from the start event to save.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "fields : List of strings\n"
+	     "    Names of the fields from the start event to be saved.\n"
+	     "\n"
+	     "names : List of strings (optional)\n"
+	     "    Can be used to rename the saved fields. The order of the new names,\n"
+	     "    provided here corresponds to the order of original names provided in\n"
+	     "    @fields. If an element of the list is 'None', the original name will\n"
+	     "    be used for the corresponding field."
+	     "    This argument is optional. If not provided, the original names are used.\n"
+	     "\n"
+	     "Example\n"
+	     "-------\n"
+	     "    evt.add_start_fields(fields=['target_cpu', 'prio'],\n"
+             "                         names=['cpu', None])"
+);
+
+PyDoc_STRVAR(PySynthEvent_add_end_fields_doc,
+	     "add_end_fields(fields, names)\n"
+	     "--\n\n"
+	     "Add fields from the end event to save.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "fields : List of strings\n"
+	     "    Names of the fields from the end event to be saved.\n"
+	     "\n"
+	     "names : List of strings (optional)\n"
+	     "    Can be used to rename the saved fields. The order of the new names,\n"
+	     "    provided here corresponds to the order of original names provided in\n"
+	     "    @fields. If an element of the list is 'None', the original name will\n"
+	     "    be used for the corresponding field."
+	     "    This argument is optional. If not provided, the original names are used.\n"
+	     "\n"
+	     "Example\n"
+	     "-------\n"
+	     "    evt.add_end_fields(fields=['target_cpu', 'prio'],\n"
+             "                       names=['cpu', None])"
+);
+
+PyDoc_STRVAR(PySynthEvent_add_delta_start_doc,
+	     "add_delta_start(name, start_field, end_field)\n"
+	     "--\n\n"
+	     "Add arithmetic 'start - end' field to save.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "name : string"
+	     "    Name for the new arithmetic field."
+	     "start_field : string\n"
+	     "    The field from the start event to be used for the arithmetic calculation.\n"
+	     "\n"
+	     "end_field : string\n"
+	     "    The field from the end event to be used for the arithmetic calculation.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_add_delta_end_doc,
+	     "add_delta_end(name, start_field, end_field)\n"
+	     "--\n\n"
+	     "Add arithmetic 'end - start' field to save.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "name : string"
+	     "    Name for the new arithmetic field."
+	     "start_field : string\n"
+	     "    The field from the start event to be used for the arithmetic calculation.\n"
+	     "\n"
+	     "end_field : string\n"
+	     "    The field from the end event to be used for the arithmetic calculation.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_add_delta_T_doc,
+	     "add_delta_T(name, hd)\n"
+	     "--\n\n"
+	     "Add time-difference (end - start) field.\n"
+	     "The default time resolution is in microseconds.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "name : string"
+	     "    Name for the new arithmetic field."
+	     "hd : bool\n"
+	     "    If True, use 'hd' time resolution (nanoseconds).\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_add_sum_doc,
+	     "add_sum(name, start_field, end_field)\n"
+	     "--\n\n"
+	     "Add arithmetic 'start + end' field to save.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "name : string"
+	     "    Name for the new arithmetic field."
+	     "start_field : string\n"
+	     "    The field from the start event to be used for the arithmetic calculation.\n"
+	     "\n"
+	     "end_field : string\n"
+	     "    The field from the end event to be used for the arithmetic calculation.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_register_doc,
+	     "register()\n"
+	     "--\n\n"
+	     "Register synthetic event.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_unregister_doc,
+	     "unregister()\n"
+	     "--\n\n"
+	     "Unregister synthetic event.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_enable_doc,
+	     "enable(instance)\n"
+	     "--\n\n"
+	     "Enable synthetic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_disable_doc,
+	     "disable(instance)\n"
+	     "--\n\n"
+	     "Disable synthetic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_is_enabled_doc,
+	     "is_enabled(instance)\n"
+	     "--\n\n"
+	     "Check if synthetic event is enabled.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance to be used. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "bool : enb\n"
+	     "    True if the event is enable."
+);
+
+PyDoc_STRVAR(PySynthEvent_set_filter_doc,
+	     "set_filter(filter, instance)\n"
+	     "--\n\n"
+	     "Define a filter for a synthetic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "filter : string\n"
+	     "    The filter descriptor.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PySynthEvent_get_filter_doc,
+	     "get_filter(instance)\n"
+	     "--\n\n"
+	     "Get the filter of a synthetic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "filter : string\n"
+	     "    The filter descriptor."
+);
+
+PyDoc_STRVAR(PySynthEvent_clearfilter_doc,
+	     "clear_filter(instance)\n"
+	     "--\n\n"
+	     "Clear the filter of a synthetic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "filter : string\n"
+	     "    The filter descriptor."
+);
+
+PyDoc_STRVAR(PySynthEvent_repr_doc,
+	     "repr(event=True, hist_start=True, hist_end=True)\n"
+	     "--\n\n"
+	     "Show a representative descriptor of the synth. event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "event : bool (optional)\n"
+	     "    Show the descriptor of the event.\n"
+	     "\n"
+	     "hist_start : bool (optional)\n"
+	     "    Show the descriptor of the 'start' histogram.\n"
+	     "\n"
+	     "hist_end : bool (optional)\n"
+	     "    Show the descriptor of the 'end' histogram.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "evt : string\n"
+	     "    The format configuration string of the synthetic event that is passed to the kernel."
+);
+
+PyDoc_STRVAR(PyFtrace_dir_doc,
+	     "dir()\n"
+	     "--\n\n"
+	     "Get the absolute path to the 'tracefs' directory.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "dir : string\n"
+	     "    Path to 'tracefs' directory.\n"
+	     "\n"
+);
+
+PyDoc_STRVAR(PyFtrace_detach_doc,
+	     "detach(object)\n"
+	     "--\n\n"
+	     "Detach object from the \'ftracepy\' module.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "object : PyTep/PyTfsInstance/PyTepRecord/PyTepEvent/PyDynevent/PyTraceHist/PySynthEvent\n"
+	     "    The object to be detached.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_attach_doc,
+	     "attach(object)\n"
+	     "--\n\n"
+	     "Attach object from the \'ftracepy\' module.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "object : PyTep/PyTfsInstance/PyTepRecord/PyTepEvent/PyDynevent/PyTraceHist/PySynthEvent\n"
+	     "    The object to be attached.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_is_attached_doc,
+	     "is_attached(object)\n"
+	     "--\n\n"
+	     "Check if the object is attached to the \'ftracepy\' module.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "object : PyTep/PyTfsInstance/PyTepRecord/PyTepEvent/PyDynevent/PyTraceHist/PySynthEvent\n"
+	     "    The object to check.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_create_instance_doc,
+	     "create_instance(name, tracing_on=True)\n"
+	     "--\n\n"
+	     "Create new tracefs instance.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "name : string (optional)\n"
+	     "    The name of the new Ftrace instance. This argument is optional. If not provided, a pseudo-random name is used.\n"
+	     "\n"
+	     "tracing_on : bool (optional)\n"
+	     "    Specifies if the tracing is 'on' or 'off' in the Ftrace new instance.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "instance : PyTfsInstance\n"
+	     "    New tracefs instance descriptor object."
+);
+
+PyDoc_STRVAR(PyFtrace_find_instance_doc,
+	     "find_instance(name)\n"
+	     "--\n\n"
+	     "Find an existing ftrace instance.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "name : string (optional)\n"
+	     "    The name of the new Ftrace instance. This argument is optional. If not provided, a pseudo-random name is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "instance : PyTfsInstance\n"
+	     "    New tracefs instance object, describing an already existing tracefs instance.\n"
+	     "    The returned objects is detached from the 'ftracepy' module."
+);
+
+PyDoc_STRVAR(PyFtrace_available_tracers_doc,
+	     "available_tracers()\n"
+	     "--\n\n"
+	     "Get a list of all tracers available on the system.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "tracers : List of strings\n"
+	     "    List of all available tracers."
+);
+
+PyDoc_STRVAR(PyFtrace_set_current_tracer_doc,
+	     "set_current(tracer, instance)\n"
+	     "--\n\n"
+	     "Enable a tracer.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "tracer : string\n"
+	     "    The tracer to be enabled.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_get_current_tracer_doc,
+	     "get_current(instance)\n"
+	     "--\n\n"
+	     "Check the enabled tracer.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "tracer : string\n"
+	     "    The name of the currently enabled tracer. 'nop' if no tracer is enabled."
+);
+
+PyDoc_STRVAR(PyFtrace_available_event_systems_doc,
+	     "available_event_systems(instance, sort=False)\n"
+	     "--\n\n"
+	     "Get a list of available trace event systems.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "sort : bool (optional)\n"
+	     "    Show in sorted order.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "systems : listo of strings\n"
+	     "    Available trace event systems."
+);
+
+PyDoc_STRVAR(PyFtrace_available_system_events_doc,
+	     "available_system_events(system, instance, sort=False)\n"
+	     "--\n\n"
+	     "Get a list of available trace event for a given system.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "system : string\n"
+	     "    The system of the events to be listed.\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "sort : bool (optional)\n"
+	     "    Show in sorted order.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "evelts : listo of strings\n"
+	     "    Available trace events."
+);
+
+PyDoc_STRVAR(PyFtrace_enable_event_doc,
+	     "enable_event(instance, system, event)\n"
+	     "--\n\n"
+	     "Enable static trece event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "system : string (optional)\n"
+	     "    The system of the event. This argument is optional.\n"
+	     "    If not provided, all systems will be searched for events having the names provided.\n"
+	     "\n"
+	     "event : string (optional)\n"
+	     "    The event's name. This argument is optional. If not provided, all events will be enabled. The same will happen if the argument is 'all'.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_disable_event_doc,
+	     "disable_event(instance, system, event)\n"
+	     "--\n\n"
+	     "Disable static trece event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "system : string (optional)\n"
+	     "    The system of the event. This argument is optional.\n"
+	     "    If not provided, all systems will be searched for events having the names provided.\n"
+	     "\n"
+	     "event : string (optional)\n"
+	     "    The event's name. This argument is optional. If not provided, all events will be disabled. The same will happen if the argument is 'all'.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_enable_events_doc,
+	     "enable_events(event, instance)\n"
+	     "--\n\n"
+	     "Enable multiple static trece events.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "events : dictionary (string : list of strings)"
+	     "    Key - system, value - list of events from this system. Use 'all' to enable all evelts from this system.\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Example\n"
+	     "-------\n"
+	     "    ft.enable_events(events={'sched': ['sched_switch', 'sched_waking'],\n"
+	     "                             'irq':   ['all']})"
+);
+
+PyDoc_STRVAR(PyFtrace_disable_events_doc,
+	     "disable_events(event, instance)\n"
+	     "--\n\n"
+	     "Disable multiple static trece events.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "events : dictionary (string : list of strings)"
+	     "    Key - system, value - list of events from this system. Use 'all' to disable all evelts from this system.\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Example\n"
+	     "-------\n"
+	     "    ft.enable_events(events={'sched': ['sched_switch', 'sched_waking'],\n"
+	     "                             'irq':   ['all']})"
+);
+
+PyDoc_STRVAR(PyFtrace_event_is_enabled_doc,
+	     "event_is_enabled(instance, system, event)\n"
+	     "--\n\n"
+	     "Check if a static trece event is enabled.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "system : string (optional)\n"
+	     "    The system of the event. Can be 'all'.\n"
+	     "\n"
+	     "event : string (optional)\n"
+	     "    The event's name. Can be 'all'.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_set_event_filter_doc,
+	     "set_event_filter(system, event, filter, instance)\n"
+	     "--\n\n"
+	     "Define filter for static event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "system : string (optional)\n"
+	     "    The system of the event. Can be 'all'.\n"
+	     "\n"
+	     "event : string (optional)\n"
+	     "    The event's name. Can be 'all'.\n"
+	     "\n"
+	     "filter : string\n"
+	     "    The filter descriptor.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_clear_event_filter_doc,
+	     "clear_event_filter(system, event, filter, instance)\n"
+	     "--\n\n"
+	     "Clear the filter for static event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "system : string (optional)\n"
+	     "    The system of the event. Can be 'all'.\n"
+	     "\n"
+	     "event : string (optional)\n"
+	     "    The event's name. Can be 'all'.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_tracing_ON_doc,
+	     "tracing_ON(instance)\n"
+	     "--\n\n"
+	     "Start tracing.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_tracing_OFF_doc,
+	     "tracing_OFF(instance)\n"
+	     "--\n\n"
+	     "Stop tracing.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_is_tracing_ON_doc,
+	     "is_tracing_ON(instance)\n"
+	     "--\n\n"
+	     "Check if tracing is ON."
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_set_event_pid_doc,
+	     "set_event_pid(pid, instance)\n"
+	     "--\n\n"
+	     "Have Ftrace events only trace the tasks with PID values listed.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "pid : int or list of ints.\n"
+	     "    PID values of the tasks to be traced.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_set_ftrace_pid_doc,
+	     "set_ftrace_pid(pid, instance)\n"
+	     "--\n\n"
+	     "Have Ftrace function tracer only trace the tasks with PID values listed.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "pid : int or list of ints.\n"
+	     "    PID values of the tasks to be traced.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_enable_option_doc,
+	     "enable_option(option, instance)\n"
+	     "--\n\n"
+	     "Enable trecing option.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "option : string\n"
+	     "    The name of a Ftrace option.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_disable_option_doc,
+	     "disable_option(option, instance)\n"
+	     "--\n\n"
+	     "Disable trecing option.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "option : string\n"
+	     "    The name of a Ftrace option.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_option_is_set_doc,
+	     "option_is_set(option, instance)\n"
+	     "--\n\n"
+	     "Check if trece option is enabled.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "option : string\n"
+	     "    The name of a Ftrace option.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "is_set : bool\n"
+	     "    True if the option is enabled.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_supported_options_doc,
+	     "supported_options(instance)\n"
+	     "--\n\n"
+	     "Gat a list of all supported tracing options.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "options : list of strings\n"
+	     "    The names of all supported options."
+);
+
+PyDoc_STRVAR(PyFtrace_enabled_options_doc,
+	     "enabled_options(instance)\n"
+	     "--\n\n"
+	     "Gat a list of all currently enabled tracing options.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "options : list of strings\n"
+	     "    The names of all enabled options."
+);
+
+PyDoc_STRVAR(PyFtrace_kprobe_doc,
+	     "kprobe(event, function, probe)\n"
+	     "--\n\n"
+	     "Define a kprobe.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "event : string\n"
+	     "    The name of the kprobe.\n"
+	     "\n"
+	     "function : string\n"
+	     "    Name of a function or address.\n"
+	     "\n"
+	     "probe : string\n"
+	     "    Definition of the probe.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "object : PyDynevent\n"
+	     "   New kprobe descriptor object."
+);
+
+PyDoc_STRVAR(PyFtrace_kretprobe_doc,
+	     "kretprobe(event, function, probe='$retval')\n"
+	     "--\n\n"
+	     "Define a kretprobe.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "event : string\n"
+	     "    The name of the kprobe.\n"
+	     "\n"
+	     "function : string\n"
+	     "    Name of a function or address.\n"
+	     "\n"
+	     "probe : string (option)\n"
+	     "    Definition of the probe.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "object : PyDynevent\n"
+	     "   New kretprobe descriptor object."
+);
+
+PyDoc_STRVAR(PyFtrace_eprobe_doc,
+	     "eprobe(event, target_system, target_event, fetch_fields)\n"
+	     "--\n\n"
+	     "Define an eprobe.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "event : string\n"
+	     "    The name of the kprobe.\n"
+	     "\n"
+	     "target_system : string\n"
+	     "    The system of the event the probe to be attached to.\n"
+	     "\n"
+	     "target_event : string\n"
+	     "    The name of the event the probe to be attached to.\n"
+	     "\n"
+	     "fetch_fields : string\n"
+	     "    Definition of the probe.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "object : PyDynevent\n"
+	     "   New eprobe descriptor object."
+);
+
+PyDoc_STRVAR(PyFtrace_hist_doc,
+	     "hist(system, event, key, type, axes, name)\n"
+	     "--\n\n"
+	     "Define a kernel histogram.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "system : string\n"
+	     "    The system of the event the histogram to be attached to.\n"
+	     "\n"
+	     "event : string\n"
+	     "    The name of the event the histogram to be attached to.\n"
+	     "\n"
+	     "key : string (optional)\n"
+	     "    Name of a field from the histogram's event, to be used as a key.\n"
+	     "\n"
+	     "type : string or int (optional)\n"
+	     "    Definition of the type of the probe. The following types are supported:\n"
+	     "        'normal', 'n' or 0 for displaying a number;\n"
+	     "        'hex', 'h' or 1 for displaying a number as a hex value;\n"
+	     "        'sym' or 2 for displaying an address as a symbol;\n"
+	     "        'sym_offset', 'so' or 3 for displaying an address as a symbol and offset;\n"
+	     "        'syscall', 'sc' or 4 for displaying a syscall id as a system call name;\n"
+	     "        'execname', 'e' or 5 for displaying a common_pid as a program name;\n"
+	     "        'log', 'l' or 6 for displaying log2 value rather than raw number;\n"
+	     "\n"
+	     "axes : dictionary (string : string or int) (optional)\n"
+	     "    Definition of the N dimentional histogram.\n"
+	     "name : string (optional)\n"
+	     "    The name of the histogram.\n"
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "object : PyTraceHist\n"
+	     "   New histogram descriptor object.\n"
+	     "\n"
+	     "Examples\n"
+	     "-------\n"
+	     "hist = ft.hist(name='h1',\n"
+             "               system='kmem',\n"
+             "               event='kmalloc',\n"
+             "               key='bytes_req')\n"
+	     "\n"
+	     "hist = ft.hist(name='h1',\n"
+             "               system='kmem',\n"
+             "               event='kmalloc',\n"
+             "               axes={'call_site': 'sym',\n"
+             "                     'bytes_req': 'n'})"
+);
+
+PyDoc_STRVAR(PyFtrace_synth_doc,
+	     "synth(name, start_sys, start_evt, end_sys, end_evt, start_match, end_match, match_name)\n"
+	     "--\n\n"
+	     "Define a synthetic event.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "name : string\n"
+	     "    The name of the synthetic event.\n"
+	     "\n"
+	     "start_sys : string\n"
+	     "    The system of the start event.\n"
+	     "\n"
+	     "start_evt : string\n"
+	     "    The name of the start event.\n"
+	     "\n"
+	     "end_sys : string\n"
+	     "    The system of the end event.\n"
+	     "\n"
+	     "end_evt : string\n"
+	     "    The name of the end event.\n"
+	     "\n"
+	     "start_match : string\n"
+	     "    The name of the field from the start event that needs to match.\n"
+	     "\n"
+	     "end_match : string\n"
+	     "    The name of the field from the end event that needs to match.\n"
+	     "\n"
+	     "match_name : string (optional)"
+	     "    If used, the match value will be recorded as a field, using the name provided."
+	     "\n"
+	     "Returns\n"
+	     "-------\n"
+	     "object : PySynthEvent\n"
+	     "   New synthetic event descriptor object.\n"
+	     "\n"
+	     "Example\n"
+	     "-------\n"
+	     "synth = ft.synth(name='synth_wakeup',\n"
+	     "                 start_sys='sched', start_evt='sched_waking',\n"
+	     "                 end_sys='sched',   end_evt='sched_switch',\n"
+	     "                 start_match='pid', end_match='next_pid',\n"
+	     "                 match_name='pid')"
+);
+
+PyDoc_STRVAR(PyFtrace_set_ftrace_loglevel_doc,
+	     "set_ftrace_loglevel(level)\n"
+	     "--\n\n"
+	     "Set the verbose level of the ftrace libraries.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "level : int\n"
+	     "    The following log levels are supported:\n"
+	     "     <= 0 - none;\n"
+	     "        1 - critical;\n"
+	     "        2 - error;\n"
+	     "        3 - nwarning;\n"
+	     "        4 - info;\n"
+	     "        5 - debug;\n"
+	     "     >= 6 - all;\n"
+);
+
+PyDoc_STRVAR(PyFtrace_trace_process_doc,
+	     "trace_process(argv, plugin='__main__', callback='callback', instance)\n"
+	     "--\n\n"
+	     "Trace a process.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "argv : list of strings \n"
+	     "    The argument list of the program to execute. The first argument should  the file being executed.\n"
+	     "\n"
+	     "plugin : string (optional)\n"
+	     "    Location to search for definition of a callback function.\n"
+	     "\n"
+	     "callback : string (optional)\n"
+	     "    A callback function to be processed on every trace event.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_trace_shell_process_doc,
+	     "trace_shell_process(argv, plugin='__main__', callback='callback', instance)\n"
+	     "--\n\n"
+	     "Trace a process executed within a shell.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "argv : list of strings \n"
+	     "    The argument list of the program to execute. The first argument should  the file being executed.\n"
+	     "\n"
+	     "plugin : string (optional)\n"
+	     "    Location to search for definition of a callback function.\n"
+	     "\n"
+	     "callback : string (optional)\n"
+	     "    A callback function to be processed on every trace event.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     );
+
+PyDoc_STRVAR(PyFtrace_read_trace_doc,
+	     "read_trace(instance)\n"
+	     "--\n\n"
+	     "Redirect the trace data stream to stdout. Use 'Ctrl+c' to stop.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     );
+
+PyDoc_STRVAR(PyFtrace_iterate_trace_doc,
+	     "iterate_trace(plugin='__main__', callback='callback', instance)\n"
+	     "--\n\n"
+	     "User provided processing (via callback) of every trace event. Use 'Ctrl+c' to stop.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "plugin : string (optional)\n"
+	     "    Location to search for definition of a callback function.\n"
+	     "\n"
+	     "callback : string (optional)\n"
+	     "    A callback function to be processed on every trace event.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     );
+
+PyDoc_STRVAR(PyFtrace_hook2pid_doc,
+	     "hook2pid(pid, fork, instance)\n"
+	     "--\n\n"
+	     "Trace only particular process (or processes).\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "pid : int or list of ints\n"
+	     "    The process (or processes) to trace.\n"
+	     "\n"
+	     "fork : bool (optional)\n"
+	     "    If trrace all child processes.\n"
+	     "\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+);
+
+PyDoc_STRVAR(PyFtrace_error_log_doc,
+	     "error_log(instance)\n"
+	     "--\n\n"
+	     "Get the content of the error log.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     );
+
+PyDoc_STRVAR(PyFtrace_clear_error_log_doc,
+	     "clear_error_log(instance)\n"
+	     "--\n\n"
+	     "Clear the content of the error log.\n"
+	     "\n"
+	     "Parameters\n"
+	     "----------\n"
+	     "instance : PyTfsInstance (optional)\n"
+	     "    The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.\n"
+	     );
+
+#endif // _TC_FTRACE_PY_DOCS
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 574bf38..2819da2 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -6,6 +6,7 @@
 
 // trace-cruncher
 #include "ftracepy-utils.h"
+#include "ftracepy-docs.h"
 
 extern PyObject *TFS_ERROR;
 extern PyObject *TEP_ERROR;
@@ -15,12 +16,12 @@ static PyMethodDef PyTepRecord_methods[] = {
 	{"time",
 	 (PyCFunction) PyTepRecord_time,
 	 METH_NOARGS,
-	 "Get the time of the record."
+	 PyTepRecord_time_doc,
 	},
 	{"CPU",
 	 (PyCFunction) PyTepRecord_cpu,
 	 METH_NOARGS,
-	 "Get the CPU Id of the record."
+	 PyTepRecord_CPU_doc,
 	},
 	{NULL}
 };
@@ -31,26 +32,27 @@ static PyMethodDef PyTepEvent_methods[] = {
 	{"name",
 	 (PyCFunction) PyTepEvent_name,
 	 METH_NOARGS,
-	 "Get the name of the event."
+	 PyTepEvent_name_doc,
 	},
 	{"id",
 	 (PyCFunction) PyTepEvent_id,
 	 METH_NOARGS,
-	 "Get the unique identifier of the event."
+	 PyTepEvent_id_doc,
 	},
 	{"field_names",
 	 (PyCFunction) PyTepEvent_field_names,
 	 METH_NOARGS,
-	 "Get the names of all fields."
+	 PyTepEvent_field_names_doc,
 	},
 	{"parse_record_field",
 	 (PyCFunction) PyTepEvent_parse_record_field,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get the content of a record field."
+	 PyTepEvent_parse_record_field_doc,
 	},
 	{"get_pid",
 	 (PyCFunction) PyTepEvent_get_pid,
 	 METH_VARARGS | METH_KEYWORDS,
+	 PyTepEvent_get_pid_doc,
 	},
 	{NULL}
 };
@@ -61,32 +63,32 @@ static PyMethodDef PyTep_methods[] = {
 	{"init_local",
 	 (PyCFunction) PyTep_init_local,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Initialize from local instance."
+	 PyTep_init_local_doc,
 	},
 	{"get_event",
 	 (PyCFunction) PyTep_get_event,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get a PyTepEvent object."
+	 PyTep_get_event_doc,
 	},
 	{"event_record",
 	 (PyCFunction) PyTep_event_record,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Generic print of a trace event."
+	 PyTep_event_record_doc,
 	},
 	{"process",
 	 (PyCFunction) PyTep_process,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Generic print of the process that generated the trace event."
+	 PyTep_process_doc,
 	},
 	{"info",
 	 (PyCFunction) PyTep_info,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Generic print of a trace event info."
+	 PyTep_info_doc,
 	},
 	{"short_kprobe_print",
 	 (PyCFunction) PyTep_short_kprobe_print,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Do not print the address of the probe."
+	 PyTep_short_kprobe_print_doc,
 	},
 	{NULL}
 };
@@ -97,7 +99,7 @@ static PyMethodDef PyTfsInstance_methods[] = {
 	{"dir",
 	 (PyCFunction) PyTfsInstance_dir,
 	 METH_NOARGS,
-	 "Get the absolute path to the instance directory."
+	 PyTfsInstance_dir_doc,
 	},
 	{NULL, NULL, 0, NULL}
 };
@@ -110,62 +112,62 @@ static PyMethodDef PyDynevent_methods[] = {
 	{"event",
 	 (PyCFunction) PyDynevent_event,
 	 METH_NOARGS,
-	 "Get the name of the dynamic event."
+	 PyDynevent_event_doc,
 	},
 	{"system",
 	 (PyCFunction) PyDynevent_system,
 	 METH_NOARGS,
-	 "Get the system name of the dynamic event."
+	 PyDynevent_system_doc,
 	},
 	{"address",
 	 (PyCFunction) PyDynevent_address,
 	 METH_NOARGS,
-	 "Get the address / function name of the dynamic event."
+	 PyDynevent_address_doc,
 	},
 	{"probe",
 	 (PyCFunction) PyDynevent_probe,
 	 METH_NOARGS,
-	 "Get the event definition."
+	 PyDynevent_probe_doc,
 	},
 	{"register",
 	 (PyCFunction) PyDynevent_register,
 	 METH_NOARGS,
-	 "Register dynamic event."
+	 PyDynevent_register_doc,
 	},
 	{"unregister",
 	 (PyCFunction) PyDynevent_unregister,
 	 METH_NOARGS,
-	 "Unregister dynamic event."
+	 PyDynevent_unregister_doc,
 	},
 	{"set_filter",
 	 (PyCFunction) PyDynevent_set_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a filter for a dynamic event."
+	 PyDynevent_set_filter_doc,
 	},
 	{"get_filter",
 	 (PyCFunction) PyDynevent_get_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get the filter of a dynamic event."
+	 PyDynevent_get_filter_doc,
 	},
 	{"clear_filter",
 	 (PyCFunction) PyDynevent_clear_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Clear the filter of a dynamic event."
+	 PyDynevent_clearfilter_doc,
 	},
 	{"enable",
 	 (PyCFunction) PyDynevent_enable,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable dynamic event."
+	 PyDynevent_enable_doc,
 	},
 	{"disable",
 	 (PyCFunction) PyDynevent_disable,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Disable dynamic event."
+	 PyDynevent_disable_doc
 	},
 	{"is_enabled",
 	 (PyCFunction) PyDynevent_is_enabled,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if dynamic event is enabled."
+	 PyDynevent_is_enabled_doc,
 	},
 	{NULL, NULL, 0, NULL}
 };
@@ -183,47 +185,47 @@ static PyMethodDef PyTraceHist_methods[] = {
 	{"add_value",
 	 (PyCFunction) PyTraceHist_add_value,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Add value field."
+	 PyTraceHist_add_value_doc,
 	},
 	{"sort_keys",
 	 (PyCFunction) PyTraceHist_sort_keys,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Set key felds or values to sort on."
+	 PyTraceHist_sort_keys_doc,
 	},
 	{"sort_key_direction",
 	 (PyCFunction) PyTraceHist_sort_key_direction,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Set the direction of a sort key field."
+	 PyTraceHist_sort_key_direction_doc,
 	},
 	{"start",
 	 (PyCFunction) PyTraceHist_start,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Start acquiring data."
+	 PyTraceHist_start_doc,
 	},
 	{"stop",
 	 (PyCFunction) PyTraceHist_stop,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Pause acquiring data."
+	 PyTraceHist_stop_doc,
 	},
 	{"resume",
 	 (PyCFunction) PyTraceHist_resume,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Continue acquiring data."
+	 PyTraceHist_resume_doc,
 	},
 	{"clear",
 	 (PyCFunction) PyTraceHist_clear,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Reset the histogram."
+	 PyTraceHist_clear_doc,
 	},
 	{"read",
 	 (PyCFunction) PyTraceHist_read,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Read the content of the histogram."
+	 PyTraceHist_read_doc,
 	},
 	{"close",
 	 (PyCFunction) PyTraceHist_close,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Destroy the histogram."
+	 PyTraceHist_close_doc
 	},
 	{NULL, NULL, 0, NULL}
 };
@@ -236,77 +238,77 @@ static PyMethodDef PySynthEvent_methods[] = {
 	{"add_start_fields",
 	 (PyCFunction) PySynthEvent_add_start_fields,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Add fields from the start event to save."
+	 PySynthEvent_add_start_fields_doc,
 	},
 	{"add_end_fields",
 	 (PyCFunction) PySynthEvent_add_end_fields,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Add fields from the end event to save."
+	 PySynthEvent_add_end_fields_doc,
 	},
 	{"add_delta_start",
 	 (PyCFunction) PySynthEvent_add_delta_start,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Add 'start - end' field."
+	 PySynthEvent_add_delta_start_doc,
 	},
 	{"add_delta_end",
 	 (PyCFunction) PySynthEvent_add_delta_end,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Add 'end - start' field."
+	 PySynthEvent_add_delta_start_doc,
 	},
 	{"add_delta_T",
 	 (PyCFunction) PySynthEvent_add_delta_T,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Add time-difference field."
+	 PySynthEvent_add_delta_T_doc,
 	},
 	{"add_sum",
 	 (PyCFunction) PySynthEvent_add_delta_T,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Add 'start + end' field."
+	 PySynthEvent_add_sum_doc,
 	},
 	{"register",
 	 (PyCFunction) PySynthEvent_register,
 	 METH_NOARGS,
-	 "Register synth. event."
+	 PySynthEvent_register_doc,
 	},
 	{"unregister",
 	 (PyCFunction) PySynthEvent_unregister,
 	 METH_NOARGS,
-	 "Unregister synth. event."
+	 PySynthEvent_unregister_doc,
 	},
 	{"enable",
 	 (PyCFunction) PySynthEvent_enable,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable synth. event."
+	 PySynthEvent_enable_doc,
 	},
 	{"disable",
 	 (PyCFunction) PySynthEvent_disable,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Disable synth. event."
+	 PySynthEvent_disable_doc,
 	},
 	{"is_enabled",
 	 (PyCFunction) PySynthEvent_is_enabled,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if synth. event is enabled."
+	 PyDynevent_is_enabled_doc,
 	},
 	{"set_filter",
 	 (PyCFunction) PySynthEvent_set_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a filter for a synthetic event."
+	 PySynthEvent_set_filter_doc,
 	},
 	{"get_filter",
 	 (PyCFunction) PySynthEvent_get_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get the filter of a synthetic event."
+	 PySynthEvent_get_filter_doc,
 	},
 	{"clear_filter",
 	 (PyCFunction) PySynthEvent_clear_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Clear the filter of a synthetic event."
+	 PySynthEvent_clearfilter_doc,
 	},
 	{"repr",
 	 (PyCFunction) PySynthEvent_repr,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Show a representative descriptor of the synth. event."
+	 PySynthEvent_repr_doc,
 	},
 	{NULL, NULL, 0, NULL}
 };
@@ -319,142 +321,142 @@ static PyMethodDef ftracepy_methods[] = {
 	{"dir",
 	 (PyCFunction) PyFtrace_dir,
 	 METH_NOARGS,
-	 "Get the absolute path to the tracefs directory."
+	 PyFtrace_dir_doc,
 	},
 	{"detach",
 	 (PyCFunction) PyFtrace_detach,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Detach object from the \'ftracepy\' module."
+	 PyFtrace_detach_doc,
 	},
 	{"attach",
 	 (PyCFunction) PyFtrace_attach,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Attach object to the \'ftracepy\' module."
+	 PyFtrace_attach_doc,
 	},
 	{"is_attached",
 	 (PyCFunction) PyFtrace_is_attached,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if the object is attached to the \'ftracepy\' module."
+	 PyFtrace_is_attached_doc,
 	},
 	{"create_instance",
 	 (PyCFunction) PyFtrace_create_instance,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Create new tracefs instance."
+	 PyFtrace_create_instance_doc,
 	},
 	{"find_instance",
 	 (PyCFunction) PyFtrace_find_instance,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Find an existing ftrace instance."
+	 PyFtrace_find_instance_doc,
 	},
 	{"available_tracers",
 	 (PyCFunction) PyFtrace_available_tracers,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get a list of available tracers."
+	 PyFtrace_available_tracers_doc,
 	},
 	{"set_current_tracer",
 	 (PyCFunction) PyFtrace_set_current_tracer,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable a tracer."
+	 PyFtrace_set_current_tracer_doc,
 	},
 	{"get_current_tracer",
 	 (PyCFunction) PyFtrace_get_current_tracer,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check the enabled tracer."
+	 PyFtrace_get_current_tracer_doc,
 	},
 	{"available_event_systems",
 	 (PyCFunction) PyFtrace_available_event_systems,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get a list of available trace event systems."
+	 PyFtrace_available_event_systems_doc,
 	},
 	{"available_system_events",
 	 (PyCFunction) PyFtrace_available_system_events,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get a list of available trace event for a given system."
+	 PyFtrace_available_event_systems_doc,
 	},
 	{"enable_event",
 	 (PyCFunction) PyFtrace_enable_event,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable trece event."
+	 PyFtrace_enable_event_doc,
 	},
 	{"disable_event",
 	 (PyCFunction) PyFtrace_disable_event,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Disable trece event."
+	 PyFtrace_disable_event_doc,
 	},
 	{"enable_events",
 	 (PyCFunction) PyFtrace_enable_events,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable multiple trece event."
+	 PyFtrace_enable_events_doc,
 	},
 	{"disable_events",
 	 (PyCFunction) PyFtrace_disable_events,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Disable multiple trece event."
+	 PyFtrace_disable_events_doc,
 	},
 	{"event_is_enabled",
 	 (PyCFunction) PyFtrace_event_is_enabled,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if event is enabled."
+	 PyFtrace_event_is_enabled_doc,
 	},
 	{"set_event_filter",
 	 (PyCFunction) PyFtrace_set_event_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define event filter."
+	 PyFtrace_set_event_filter_doc,
 	},
 	{"clear_event_filter",
 	 (PyCFunction) PyFtrace_clear_event_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Clear event filter."
+	 PyFtrace_clear_event_filter_doc,
 	},
 	{"tracing_ON",
 	 (PyCFunction) PyFtrace_tracing_ON,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Start tracing."
+	 PyFtrace_tracing_ON_doc
 	},
 	{"tracing_OFF",
 	 (PyCFunction) PyFtrace_tracing_OFF,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Stop tracing."
+	 PyFtrace_tracing_OFF_doc
 	},
 	{"is_tracing_ON",
 	 (PyCFunction) PyFtrace_is_tracing_ON,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if tracing is ON."
+	 PyFtrace_is_tracing_ON_doc,
 	},
 	{"set_event_pid",
 	 (PyCFunction) PyFtrace_set_event_pid,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "."
+	 PyFtrace_set_event_pid_doc,
 	},
 	{"set_ftrace_pid",
 	 (PyCFunction) PyFtrace_set_ftrace_pid,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "."
+	 PyFtrace_set_ftrace_pid_doc,
 	},
 	{"enable_option",
 	 (PyCFunction) PyFtrace_enable_option,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable trece option."
+	 PyFtrace_enable_option_doc
 	},
 	{"disable_option",
 	 (PyCFunction) PyFtrace_disable_option,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Disable trece option."
+	 PyFtrace_disable_option_doc
 	},
 	{"option_is_set",
 	 (PyCFunction) PyFtrace_option_is_set,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if trece option is enabled."
+	 PyFtrace_option_is_set_doc,
 	},
 	{"supported_options",
 	 (PyCFunction) PyFtrace_supported_options,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Gat a list of all supported options."
+	 PyFtrace_supported_options_doc,
 	},
 	{"enabled_options",
 	 (PyCFunction) PyFtrace_enabled_options,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Gat a list of all supported options."
+	 PyFtrace_enabled_options_doc
 	},
 	{"tc_event_system",
 	 (PyCFunction) PyFtrace_tc_event_system,
@@ -469,67 +471,67 @@ static PyMethodDef ftracepy_methods[] = {
 	{"kprobe",
 	 (PyCFunction) PyFtrace_kprobe,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a kprobe."
+	 PyFtrace_kprobe_doc,
 	},
 	{"kretprobe",
 	 (PyCFunction) PyFtrace_kretprobe,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a kretprobe."
+	 PyFtrace_kretprobe_doc,
 	},
 	{"eprobe",
 	 (PyCFunction) PyFtrace_eprobe,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define an eprobe."
+	 PyFtrace_eprobe_doc,
 	},
 	{"hist",
 	 (PyCFunction) PyFtrace_hist,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a histogram."
+	 PyFtrace_hist_doc,
 	},
 	{"synth",
 	 (PyCFunction) PyFtrace_synth,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a synthetic event."
+	 PyFtrace_synth_doc,
 	},
 	{"set_ftrace_loglevel",
 	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Set the verbose level of the ftrace libraries."
+	 PyFtrace_set_ftrace_loglevel_doc,
 	},
 	{"trace_process",
 	 (PyCFunction) PyFtrace_trace_process,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Trace a process."
+	 PyFtrace_trace_process_doc,
 	},
 	{"trace_shell_process",
 	 (PyCFunction) PyFtrace_trace_shell_process,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Trace a process executed within a shell."
+	 PyFtrace_trace_shell_process_doc,
 	},
 	{"read_trace",
 	 (PyCFunction) PyFtrace_read_trace,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Trace a shell process."
+	 PyFtrace_read_trace_doc,
 	},
 	{"iterate_trace",
 	 (PyCFunction) PyFtrace_iterate_trace,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Trace a shell process."
+	 PyFtrace_iterate_trace_doc,
 	},
 	{"hook2pid",
 	 (PyCFunction) PyFtrace_hook2pid,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Trace only particular process."
+	 PyFtrace_hook2pid_doc,
 	},
 	{"error_log",
 	 (PyCFunction) PyFtrace_error_log,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Get the content of the error log."
+	 PyFtrace_error_log_doc,
 	},
 	{"clear_error_log",
 	 (PyCFunction) PyFtrace_clear_error_log,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Clear the content of the error log."
+	 PyFtrace_clear_error_log_doc,
 	},
 	{NULL, NULL, 0, NULL}
 };
-- 
2.32.0

