Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBD2C433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE6120936
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgLWEfR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgLWEfR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:35:17 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34236C06179C
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:37 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r7so17324045wrc.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CaRcTEAnNWGAxloB4vhh3lunl1bHioPlNW9EEp0sJWk=;
        b=eZCD/m2mHBK9ZKWzw3IKN33aRIZf2LGQ+zvE6uZq8gCIhxWEjbOfVErPWCb2Jh5MYH
         Oa4q1u0QRTiDuIRjZlcFu9+XHQiDcHrUDjLa77f+/UtTahLuk1it+xeNcQFnAr4C63jj
         QQMPBQ9Y0PS7fNp4aA55Ym8FLXWGqqYGsayjsupOF6ULC1sN7y+Qy4jghNdt15FQcNgO
         S5sUq+qWAoE5yUwyJTCKiPEmDBbdi7lPFMEJw48dGTZpg89cZxzW2P3FmwOdvSm1hsBt
         OBQm2AphQk/PRfiCysBG0UTO7xu8W/OnHNsTBJXHbD03LMPC2BNADpECLl5C5r/0Qocm
         eLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CaRcTEAnNWGAxloB4vhh3lunl1bHioPlNW9EEp0sJWk=;
        b=IdZor7mU+z36cRcNRMHUM7RKKpKV1Yic2Rvx3Hj1IyRutq7k3Rfy17o6Sx8d9cg14V
         0uVDmmuw8tAiMDkwXLgpOrBiVIjaXzpqr6Zyejdb7CpBE5KZMhicKy0hxbC0fpACNKX3
         moJKXdd0NjsNF53H/y81GpPvs4z3LQLdeWxp/K8Dvyf/TFF1m7w2wZcDQb5/UlgHNog8
         IiRR2b3f7NsRbfqcLHVSqSm6LKuhMac2WnKWPZeVkTkSO9nSuJ7JUvyajCXlFHEw66SG
         sYlnVHntg11ASGSbyPY50LGXFAa3Tl02gfVRhSqjOv3l9ferTmBesCnpxPIh+nG8nyTM
         fImQ==
X-Gm-Message-State: AOAM530JWK0SP2Y7rfv+EnoO0sc0OYECuPalm1PFjrS2cUVJtwDkpsBT
        PDeT7Bv4bFbkh5X6qXX1Sl6k7t2R1xNJYrIK
X-Google-Smtp-Source: ABdhPJx24iDdmAFP1U/lxKrpiBrD37OqqVIZlQg1wmk6HpGJZj+jpapbcOZAHwt5lr/K7zdXTOZcTA==
X-Received: by 2002:a5d:4104:: with SMTP id l4mr27757645wrp.340.1608698075935;
        Tue, 22 Dec 2020 20:34:35 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm28909095wmj.28.2020.12.22.20.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:34:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/6] trace-cmd library man pages: Open and close trace file.
Date:   Wed, 23 Dec 2020 06:34:27 +0200
Message-Id: <20201223043429.586162-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201223043429.586162-1-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
 tracecmd_open_head()
 tracecmd_close()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-files.3.txt       | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/libtracecmd/libtracecmd-files.3.txt

diff --git a/Documentation/libtracecmd/libtracecmd-files.3.txt b/Documentation/libtracecmd/libtracecmd-files.3.txt
new file mode 100644
index 00000000..7cf12ea4
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd-files.3.txt
@@ -0,0 +1,92 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+tracecmd_open_head, tracecmd_close - Open and close trace file.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_);
+void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to open and close a trace file recorded by
+_trace-cmd(1)_ and containing tracing information from ftrace, the official
+Linux kernel tracer. The opened file is represented by a _tracecmd_input_
+structure, all other library APIs that work with the file require a pointer
+to the structure.
+
+The _tracecmd_open_head()_ function opens a given trace _file_, parses the
+headers from the file, allocates and initializes _tracecmd_input_ structure
+representing the file.
+
+The _tracecmd_close()_ function frees a _handle_, pointer to tracecmd_input
+structure, previously allocated with _tracecmd_open_head()_.
+
+RETURN VALUE
+------------
+The _tracecmd_open_head()_ function returns a pointer to tracecmd_input
+structure or NULL in case of an error. The returned structure must be free
+with _tracecmd_close()_.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <trace-cmd.h>
+...
+struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
+	if (!handle) {
+		/* Failed to open trace.dat file */
+	}
+...
+	tracecmd_close(hadle);
+
+--
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-libtracecmd*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+_trace-cmd.dat(5)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracecmd is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.28.0

