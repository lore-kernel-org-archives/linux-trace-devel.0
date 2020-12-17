Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308B7C2BB9A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F304A238E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgLQJrO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbgLQJrN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:13 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304BDC0611C5
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:33 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g185so5109815wmf.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N48y4S6J5pzX7y2q8ngaSZvSJdDoFqsjVlLTD+/lKmc=;
        b=i7ugzBGGovHzrMIpXRpyrpdj+bVTj9h15d2lUQelOpPJwsE4tf7O8jKbLF4SUobKWS
         jPRRK3J9AlgzhmWkW3y2LUpEES2t1w7ATu7gK0dMyJuUGP5Vgv982XDvt31e03hft4Mx
         7AAcyHQDmlp153DMVqlfXJ7CyVLqsLpLFf1ofIq5weSqEqKOKk2BQlCupQswuWrQybuR
         eOhPEvM1RoLdx991c8njCm+/tH6EuDrAJ49Ta/QL9eCyQdDId9NJ8GE6dZHjqcC3Mc71
         AoDoM1+1S9+2hx3rcsEY8S5kOOm+1sPnz07bdh3N8Mu2eZ4vQrqoVKnkZbmQj8ZJQ14T
         bAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N48y4S6J5pzX7y2q8ngaSZvSJdDoFqsjVlLTD+/lKmc=;
        b=Inlf0b8B0MGKdZKew0ESknBOzxHUKXeGBS4c6DhXwXd+aARtAd0d4qJy1ZH34lspT5
         9HeHWKGhqx3DfBrNAb5W9F+cu1YMHdS1qdYY8bCQV4rb4zYuPFa6g+LXiJYAD35vE6F/
         lY188eq+fJHQOoPWsWM+jcM4DzKeENvqZL05CNzdspqMCu/1D0tOJKkwtwiuRp1HH6KM
         CVp27NfE6/AlwkUTKTc66T4s3GIr748VrhFWjsZ1d6UCpFjwBkQ/iWuKq++xNnO0odaC
         4dmsMm+S81na3Y7QuWyRfym2BxW69rT6aJBcSFbFpfgc3yyQyvcmDH5GJJqXIJElqlCa
         Lw+w==
X-Gm-Message-State: AOAM533IS02d2DXpOcKPAdKVzQvQo/GF75ugZ/vPvE8AyjAq7q1dVDhj
        4GZdlmi+zb4cZNT7PeSgzhQ=
X-Google-Smtp-Source: ABdhPJwzCpvtJibQQuN9gZf+y3+8JsQlCmrt+xcnKSx7XOVFPyrUrKGaRkrS5TsV3+FnF0rp+oSY4Q==
X-Received: by 2002:a1c:9dd8:: with SMTP id g207mr7587209wme.15.1608198391858;
        Thu, 17 Dec 2020 01:46:31 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/9] libtracefs man pages: APIs for locating trace directory and files.
Date:   Thu, 17 Dec 2020 11:46:20 +0200
Message-Id: <20201217094626.1402191-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_get_tracing_file()
tracefs_put_tracing_file()
tracefs_get_tracing_dir()
tracefs_find_tracing_dir()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-files.txt | 111 +++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)
 create mode 100644 Documentation/libtracefs-files.txt

diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
new file mode 100644
index 0000000..b288892
--- /dev/null
+++ b/Documentation/libtracefs-files.txt
@@ -0,0 +1,111 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_get_tracing_dir,
+tracefs_find_tracing_dir - Find locations of trace directory and files.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
+void *tracefs_put_tracing_file*(char pass:[*]_name_);
+const char pass:[*]*tracefs_get_tracing_dir*(void);
+char pass:[*]*tracefs_find_tracing_dir*(void);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to find the full path of the trace file
+system mount point and trace files in it.
+
+The _tracefs_get_tracing_file()_ function returns the full path of the
+file with given _name_ in the trace file system. The function works
+only with files in the trasefs main directory, it is not trace instance
+aware. It is recommended to use _tracefs_instance_get_file()_ and
+_tracefs_instance_get_dir()_ instead. The returned string must be freed
+with _tracefs_put_tracing_file()_.
+
+The _tracefs_put_tracing_file()_ function frees trace file name,
+returned by _tracefs_get_tracing_file()_.
+
+The _tracefs_find_tracing_dir()_ function finds the mount point of the
+trace file system and returns a full path to it. If the file system is
+not mounted, it will mount it. The returned string must be freed.
+
+The _tracefs_get_tracing_dir()_ function returns the full path to the
+trace file system. In the first function call, the mount point of the
+tracing file system is located, cached and returned. It will mount it,
+if it is not minted. On any subsequent call the cached path is returned.
+The return string must _not_ be freed.
+
+RETURN VALUE
+------------
+The _tracefs_get_tracing_file()_ function returns a string or NULL in case
+of an error. The returned string must be freed with _tracefs_put_tracing_file()_.
+
+The _tracefs_find_tracing_dir()_ function returns a string or NULL in case
+of an error. The returned string must be freed.
+
+The _tracefs_get_tracing_dir()_ function returns a constant string or NULL
+in case of an error. The returned string must _not_ be freed.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+...
+char *trace_on = tracefs_get_tracing_file("tracing_on");
+	if (trace_on) {
+		...
+		tracefs_put_tracing_file(trace_on);
+	}
+...
+char *trace_dir = tracefs_find_tracing_dir();
+	if (trace_dir) {
+		...
+		free(trace_dir);
+	}
+...
+const char *trace_dir = tracefs_get_tracing_dir();
+
+--
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
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
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
-- 
2.28.0

