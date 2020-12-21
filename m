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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B61DC433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307D522B2A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgLUGD6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0735C0611CA
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:58 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j16so8504392edr.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JNU1XUFo7bjZBFqse0EpQDDMCTQQR1xGfjDNxFxj3eM=;
        b=IbFQPpcv/wch8GXXONbdKZmyboG8pegCSaUyJJSO0NBzm7DEgwcGdHWcUyXSguOlaG
         dC9tapfJSLmLBcP6GELGIRoExpqhIB+FVunHPpdJl3GNZJyl0FrT+vngnXHm7PyTn2Ux
         nXTlkbLesk94S8VX/dW5TV6qf8372jC2v94+zxwvVHt1b/265M2VLgyXCRftQY2vRmq1
         C8A9ZxtLHAwRocYPqWIPLFQ/AiNGFjF+yAAjmCn4frmZ3Sg68ojqa/zQMy5/x071d+nk
         xfYJv0Wnr6H9nMDw0Fd8q7EyZ3MMunvI0HT6URsVhDXCBGyoO3dQWWOWDKReoxHQVAek
         3l+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNU1XUFo7bjZBFqse0EpQDDMCTQQR1xGfjDNxFxj3eM=;
        b=oE/07lIXgv8Rm9M3xHTHd/DZeI1Sxa+0q4/ULfw7HqYfPuzTZpKSjXMvIt/4o4F/MM
         eIX+70LQUREjHrijTWgU3fiC6xLb4AdfYQmejI9Qd66AqZyXyNhOD6e88VJis6osMOOA
         eV2t7E22U3R5VrONgVGMJCC2/y4kr/Cj1PhvQT7tlz/5+/90VQXof3dQTx7//jJKdxDA
         wmJGYJ66jE2mGrwPbTjQ2zC0V5m9/9w4o1r26S10GfPt1ojKQAtdsl+fqfcPY7DuG1+1
         qHYvap8G4SI0NMOcT1W8PJ+jltaJ1Z+ar6zb1jBw/88AAVpT9kKFTYBch0KozkE79cnA
         9PaQ==
X-Gm-Message-State: AOAM53087aTI/94YrQB/YPKDABHf4ijej05CKzkh8eHLjzz0aGzE32ax
        kDVTsBYBwM8lt7AJyoc3DNQ=
X-Google-Smtp-Source: ABdhPJxses2puSu0SaGcUI9yRahwdztjAhct4VYAR/iAQZcb9H0c4309VpueGcYZo9ozzjqZq5u7Lg==
X-Received: by 2002:aa7:d608:: with SMTP id c8mr14405498edr.260.1608530577619;
        Sun, 20 Dec 2020 22:02:57 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z10sm8560885ejl.30.2020.12.20.22.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/8] libtracefs man pages: APIs for locating trace directory and files.
Date:   Mon, 21 Dec 2020 08:02:46 +0200
Message-Id: <20201221060252.177890-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060252.177890-1-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
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
 Documentation/libtracefs-files.txt | 97 ++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)
 create mode 100644 Documentation/libtracefs-files.txt

diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
new file mode 100644
index 0000000..8bf9d75
--- /dev/null
+++ b/Documentation/libtracefs-files.txt
@@ -0,0 +1,97 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_tracing_dir -
+Find locations of trace directory and files.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
+void *tracefs_put_tracing_file*(char pass:[*]_name_);
+const char pass:[*]*tracefs_tracing_dir*(void);
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
+The _tracefs_tracing_dir()_ function returns the full path to the
+trace file system. In the first function call, the mount point of the
+tracing file system is located, cached and returned. It will mount it,
+if it is not mounted. On any subsequent call the cached path is returned.
+The return string must _not_ be freed.
+
+RETURN VALUE
+------------
+The _tracefs_get_tracing_file()_ function returns a string or NULL in case
+of an error. The returned string must be freed with _tracefs_put_tracing_file()_.
+
+The _tracefs_tracing_dir()_ function returns a constant string or NULL
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
+const char *trace_dir = tracefs_tracing_dir();
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

