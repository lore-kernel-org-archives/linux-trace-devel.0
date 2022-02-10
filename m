Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C617AC43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbiBJPX6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:23:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiBJPX6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:58 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B542DF06
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:58 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id q198-20020a1ca7cf000000b0037bb52545c6so5427795wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QbwmWpbdbGymAuZ4t2yYtThkZekM2SgyGGt94j6RaYA=;
        b=YaORhDk1rA6RMqyBOnnIgeqpvRiPW6kS/3JkKHck5cXxM9llcU5Z3DfW/L5SxHai8V
         R3aLVlOiolPcL+5a94LlaRGfTrFd5ToUwRjE5HLJXPNSv3BRbePAnaxIKfZ5d3Hl+9nK
         EfbBxkdur5LgaM9dVITLRNkJhFarcIR8tF/nOf1wuHGO7uPPKBJfCI4CRgsfQ1afnNCQ
         t7uu3w//9CjdoRjQvRqUQKtpVhzIbPc9d1APJnsugu1qY2WcZKWU2jNawBKxkm+c191S
         fuKTZ4SaeajWi0E5NtsW8UNtazeGGwcqgT3N6/rdwYb1sr5Ii/89/yE4QAtBRuXd4lYz
         z99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QbwmWpbdbGymAuZ4t2yYtThkZekM2SgyGGt94j6RaYA=;
        b=YctDa3ESeNlFkk0TlLzKCXe+ZDiNlEOmarkmO7D6qiwnwQ9gLQUO129zozYii9EEEO
         RTB6zfg2p21QnMyqyrL9bcHqjulBSO6ZM+At388N9nlm4yJh7ykIdn3Z0o2adh3ObzTQ
         B54KNRP5BhPQAbIulMzeGlDVKerI6VkwX7D7/tmUDoppKBsrETq1jFfS6N5ycLQDfHGK
         IEzotAzhqfa8nNIWZ7u9gCaTrE+QrMFiloOrDO2B0l40WKgZ7nN4FsGzTHdYOGrD9Gq2
         lPjaOjHbB6MMbb4vBRBCUE/95jjgcMSiYCUMA9ow6t5fOolsHl2LRCKGlMWX4AXl1GE1
         oIWQ==
X-Gm-Message-State: AOAM532izDAv+YvXSclhnLrsMYEPgWxqCUBrfHT0O8dEaa/aRFKLQ+jj
        Duag6XPvYZR3bv5qe39bqC8h031/lQk=
X-Google-Smtp-Source: ABdhPJz8LK3n1kmIvOKRcu0BCO6DGIOihdIW8iVCKSRdV9jbDThDIGDy3rmlxb7JB11hf1O8ETT26Q==
X-Received: by 2002:a05:600c:3795:: with SMTP id o21mr1995947wmr.86.1644506637137;
        Thu, 10 Feb 2022 07:23:57 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/8] trace-cruncher: Rename python function argument in PyFtrace_eprobe
Date:   Thu, 10 Feb 2022 17:23:36 +0200
Message-Id: <20220210152339.363943-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The keyword (named) argument of the eprobe constrictor is renamed from
'fetchargs' to 'fetch_fields'. This is done because the old name can be
confusing, since the probe is supposed to fetch a field of event (not a
function argument). The new name also makes a better match with the
'snake case' naming convention used in trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/syscall_trace.py                           | 2 +-
 src/ftracepy-utils.c                                | 2 +-
 tracecruncher/tests/1_unit/test_01_ftracepy_unit.py | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/examples/syscall_trace.py b/examples/syscall_trace.py
index 7d6f399..bfa56ed 100755
--- a/examples/syscall_trace.py
+++ b/examples/syscall_trace.py
@@ -24,7 +24,7 @@ args = 'file=+0($file):ustring delta_T=$delta_T:s64'
 
 eprobe = ft.eprobe(event=eprobe_evt,
                    target_system='synthetic', target_event=synth_evt,
-                   fetchargs=args)
+                   fetch_fields=args)
 
 synth = ft.synth(name=synth_evt,
                  start_sys='syscalls', start_evt='sys_enter_' + syscall,
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index b262c19..20f0cd9 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2366,7 +2366,7 @@ struct tep_event *dynevent_get_event(PyDynevent *event,
 
 PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = {"event", "target_system", "target_event", "fetchargs", NULL};
+	static char *kwlist[] = {"event", "target_system", "target_event", "fetch_fields", NULL};
 	const char *event, *target_system, *target_event, *fetchargs;
 	struct tracefs_dynevent *eprobe;
 	PyObject *py_dyn;
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index f942b6b..6fdd053 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -473,13 +473,13 @@ class EprobeTestCase(unittest.TestCase):
         evt2_args = 'res=$ret:u64'
 
         ep1 = ft.eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
-                        fetchargs=evt1_args)
+                        fetch_fields=evt1_args)
         self.assertEqual(evt1, ep1.event())
         self.assertEqual("{}.{}".format(evt1_tsys, evt1_tevent), ep1.address())
         self.assertEqual(evt1_args, ep1.probe())
 
         ep2 = ft.eprobe(event=evt2, target_system=evt2_tsys, target_event=evt2_tevent,
-                        fetchargs=evt2_args)
+                        fetch_fields=evt2_args)
         self.assertEqual(evt2, ep2.event())
         self.assertEqual("{}.{}".format(evt2_tsys, evt2_tevent), ep2.address())
         self.assertEqual(evt2_args, ep2.probe())
@@ -496,7 +496,7 @@ class EprobeTestCase(unittest.TestCase):
         evt1_args = 'res=$ret:u64'
 
         ep1 = ft.eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
-                        fetchargs=evt1_args)
+                        fetch_fields=evt1_args)
         ep1.register()
         inst = ft.create_instance(instance_name)
         ep1.enable(instance=inst)
-- 
2.32.0

