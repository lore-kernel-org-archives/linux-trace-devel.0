Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4BDC28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 12:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbiAZMb1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 07:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiAZMb0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 07:31:26 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63696C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 04:31:26 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id p15so38674274ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 04:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jz08dxnwMrlPAGxWpBGb6n4dnX7dafT5OlBTjmCfWVI=;
        b=PFx2W0nDHbWoumMHbFKpIZnzKV+VVlMD+bEECjnxrSH2z+QW2es64ykn5bgK/RIhmV
         qj4j6sagz9h1qydQP/gbEjB2Rt/ldR7djLIeaF2kI8FTlyLg+0xoyqgCah+zTit5MkYf
         u047rQrsSFrYboh+OTwU///QIBLGErR4bxfm1klcax2Z+B3VWK4gmXQJJAqAn5DlWrhx
         ssPeVfIhyxNKDQDWShnMGT4IG130DU3YV+ljRrnnsyG5G/K+eI+zQwOJK3UjiZ1s7lPZ
         o61LKJ0J/8Z5Fbb/FfLmWLvDQkPPwWlmdgQ+9xKABLCDWG8V25QDbK44HDh8apKZwh1K
         0H0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jz08dxnwMrlPAGxWpBGb6n4dnX7dafT5OlBTjmCfWVI=;
        b=3YsKh0O5jSCm7UNr+PC9Ehv/agVgIsxvhSc9CQjqJgSa2TK+VH73EPwlX3EpiaR9XN
         CXwoIDapu9GiA/H27O8S/km8WOdytFOzwqx0x8lYy5yI/s1CM8bcK3E438bxzFEwq/jc
         ljCfsMdItQPtl5E3y7kXF6RsYpkRRyxzYGFjTfFadpw7dNTF7uBoj+ZEnhnAVRotzaB9
         gzOeMKOTTn3E9mruIg/R4Hh5oY55grgmmg2Pf297C9pMwKl9cG3TaWJiu5Laq7YYbP8B
         Bo7NgSaAj4H3ujmON7E9OCqQVWVNRxKF+W0aAQfE/0cRLNxGpLuG/IE8XEYpWZsFV9U3
         ZLKA==
X-Gm-Message-State: AOAM530Y1UpDoX0k3fbtWjdbjHWYH3L6JeM3wJATedmVgBpi8lJJGkKR
        uroGf/ht0crNNdVZdzpSICvqYp6lQz0=
X-Google-Smtp-Source: ABdhPJxmM7LdfRDlvhRcNTpJlCQQRT3KE3842yMGSpDxjpKxe10MIKKuIiPAXj/2Vj62+osCUJNEVQ==
X-Received: by 2002:a17:906:7e19:: with SMTP id e25mr19660859ejr.642.1643200284730;
        Wed, 26 Jan 2022 04:31:24 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id cz6sm4315611edb.4.2022.01.26.04.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 04:31:24 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Add no_arg()
Date:   Wed, 26 Jan 2022 14:31:14 +0200
Message-Id: <20220126123114.214956-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220126123114.214956-1-y.karadz@gmail.com>
References: <20220126123114.214956-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the implementation of the low-level APIs wrapping libtracefs,
a special string is used as a default value of the optional function
arguments. Here we make this string available for the high-level
APIs. This simplifies the implementation of the cases when optional
arguments are used.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c      |  5 +++++
 src/ftracepy-utils.h      |  2 ++
 src/ftracepy.c            |  5 +++++
 tracecruncher/ft_utils.py | 41 +++++++++++++--------------------------
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 8c46590..8ff6601 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2178,6 +2178,11 @@ PyObject *PyFtrace_tc_event_system(PyObject *self)
 	return PyUnicode_FromString(TC_SYS);
 }
 
+PyObject *PyFtrace_no_arg(PyObject *self)
+{
+	return PyUnicode_FromString(NO_ARG);
+}
+
 static PyObject *dynevent_info2py(char *buff, int type)
 {
 	PyObject *ret;
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 7612df6..29a7312 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -245,6 +245,8 @@ PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
 
 PyObject *PyFtrace_tc_event_system(PyObject *self);
 
+PyObject *PyFtrace_no_arg(PyObject *self);
+
 PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 3f71b5e..82057ed 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -450,6 +450,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_NOARGS,
 	 "Get the name of the event system used by trace-cruncher."
 	},
+	{"no_arg",
+	 (PyCFunction) PyFtrace_no_arg,
+	 METH_NOARGS,
+	 "Returns a default value for an optional function argument."
+	},
 	{"register_kprobe",
 	 (PyCFunction) PyFtrace_register_kprobe,
 	 METH_VARARGS | METH_KEYWORDS,
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index e1126ad..39faaed 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -55,45 +55,30 @@ class event:
         """
         return int(self.evt_id)
 
-    def enable(self, instance=None):
+    def enable(self, instance=ft.no_arg()):
         """ Enable this event.
         """
-        if instance is None:
-            ft.enable_event(system=self.system, event=self.name)
-        else:
-            ft.enable_event(instance=instance, system=self.system, event=self.name)
+        ft.enable_event(instance=instance, system=self.system, event=self.name)
 
-    def disable(self, instance=None):
+    def disable(self, instance=ft.no_arg()):
         """ Disable this event.
         """
-        if instance is None:
-            ft.disable_event(system=self.system, event=self.name)
-        else:
-            ft.disable_event(instance=instance,system=self.system, event=self.name)
+        ft.disable_event(instance=instance,system=self.system, event=self.name)
 
-    def set_filter(self, filter, instance=None):
+    def set_filter(self, filter, instance=ft.no_arg()):
         """ Define a filter for this event.
         """
-        if instance is None:
-            ft.set_event_filter(system=self.system,
-                                event=self.name,
-                                filter=filter)
-        else:
-            ft.set_event_filter(instance=instance,
-                                system=self.system,
-                                event=self.name,
-                                filter=filter)
+        ft.set_event_filter(instance=instance,
+                            system=self.system,
+                            event=self.name,
+                            filter=filter)
 
-    def clear_filter(self, instance=None):
+    def clear_filter(self, instance=ft.no_arg()):
         """ Define the filter for this event.
         """
-        if instance is None:
-            ft.clear_event_filter(system=self.system,
-                                  event=self.name)
-        else:
-            ft.clear_event_filter(instance=instance,
-                                  system=self.system,
-                                  event=self.name)
+        ft.clear_event_filter(instance=instance,
+                              system=self.system,
+                              event=self.name)
 
 
 class kprobe_base(event):
-- 
2.32.0

