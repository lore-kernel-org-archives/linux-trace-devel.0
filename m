Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5064C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 16:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355919AbiASQTH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 11:19:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355602AbiASQTG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 11:19:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F75B81A3A
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 16:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3DAC004E1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 16:19:03 +0000 (UTC)
Date:   Wed, 19 Jan 2022 11:19:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix libtracefs-instance-affinity.txt document
Message-ID: <20220119111901.0a18aa2c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The building of the Documentation directory errors with:

  DESCEND            Documentation all
  ASCIIDOC libtracefs-instances-affinity.html
asciidoc: ERROR: libtracefs-instances-affinity.txt: line 8: malformed name section body
asciidoc: FAILED: libtracefs-instances-affinity.txt: line 8: unexpected error:
asciidoc: ------------------------------------------------------------
Traceback (most recent call last):
  File "/usr/lib/python3/dist-packages/asciidoc/asciidoc.py", line 6081, in asciidoc
    document.translate(has_header)  # Generate the output.
  File "/usr/lib/python3/dist-packages/asciidoc/asciidoc.py", line 1380, in translate
    self.attributes['manname'] = mo.group('manname').strip()
AttributeError: 'NoneType' object has no attribute 'group'
make[1]: *** [Makefile:237: libtracefs-instances-affinity.html] Error 1
make: *** [Makefile:286: doc] Error 2

This was due to a cut and paste error and the first line did not have a
hyphen for the description of the man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-affinity.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index 107334dd1298..385d65035ece 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -4,8 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw,
-tracefs_instance_get_affinity, tracefs_instance_get_affinity_set, tracefs_get_affinity_raw,
-Sets or retrieves the affinity for an instance or top level for what CPUs enable tracing.
+tracefs_instance_get_affinity, tracefs_instance_get_affinity_set, tracefs_get_affinity_raw
+- Sets or retrieves the affinity for an instance or top level for what CPUs enable tracing.
 
 SYNOPSIS
 --------
-- 
2.33.0

