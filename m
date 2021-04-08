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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D1AC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B43486113D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhDHIJf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhDHIJe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 04:09:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D63C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 01:09:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a7so1524414eju.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 01:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=daf1ZNAIOfCRVDLos/eCuFK+TuCL4IiPebOuux2oamQ=;
        b=HK17sthLtfww/6gsvr9W0KLhvkzW709MXXVIaAEOULD+Ivzc0dkpZRIaRVJMh//NUs
         zaT3SF4BKfGlai2Tg0OjjArdO/kMFXKilADiRGV/rQrlDR1Tzp7N+ygcfEg4zKoR98+n
         gq3oaX6TKlnZtjb99p1/jW0zDOJiwPMmKPUFUnta84pwYHcfYIdX63J3HcJJigDpuGqq
         ldGooIYHc1TpRV7dMSX49kpTj/PQe8nvHR70zcUDctQzApaMd4iG4F6bm+qm7zNjoHs5
         OCa8koePweSAGCXeLuJjogvwynh50dQiYFiF1Y3nJouGdXm5dNHit0rA+SNXq6P4VxQn
         BWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=daf1ZNAIOfCRVDLos/eCuFK+TuCL4IiPebOuux2oamQ=;
        b=GhRnzcMNqzk9GyQdcwzX/7/nCnsyWUmznIxEbi2P7NuqULrABAAK0zW+KJxZAgDxLD
         /0js7qQGOsQNWsbWKyTeDWgeJ87FRVX/R9tCwcJViRN6CR6417P+rNzvZkfUrBMyRbMJ
         FdXiCTIcrYEa5YdLOuNwNcJHt5wxvfiOZ3EiIBqGUopq4jP3u+j9P+Ts7xRhiE74frTB
         wb5hdg4ZRKwrv2TRHV1udNJaQfPHKeIxQNqotTpQtRr94d7qUHxOjLBnQW25VS2ChlOK
         Gaqms9733ls7eda+fLYu5CyqfFM6EwdPYxUHDxbrR4fXuIgeu1wMEmiIJpEEpMWccvIz
         AwWQ==
X-Gm-Message-State: AOAM530hnygqhdo4pmVJm4ct0EL2ZV6jW2mTIL1YqgiKkWpoos65Wlko
        4aJKmuP4mx/0Um0Z5oj99Lw=
X-Google-Smtp-Source: ABdhPJwDaWNVa5H6qSjOfwTJ8IYKDxtn2sIcnBzrRdseuVowIDKvROXzlrAlSBjvP7ImaDbUua8DCg==
X-Received: by 2002:a17:906:5902:: with SMTP id h2mr8605683ejq.416.1617869362407;
        Thu, 08 Apr 2021 01:09:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x1sm14009444eji.8.2021.04.08.01.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 01:09:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: Document marker APIs
Date:   Thu,  8 Apr 2021 11:09:19 +0300
Message-Id: <20210408080920.3130041-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210408080920.3130041-1-tz.stoyanov@gmail.com>
References: <20210408080920.3130041-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added man pages describing these functions:
 tracefs_marker_init()
 tracefs_marker_print()
 tracefs_marker_vprint()
 tracefs_marker_write()
 tracefs_marker_close()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-marker.txt | 127 ++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 Documentation/libtracefs-marker.txt

diff --git a/Documentation/libtracefs-marker.txt b/Documentation/libtracefs-marker.txt
new file mode 100644
index 0000000..e2673d9
--- /dev/null
+++ b/Documentation/libtracefs-marker.txt
@@ -0,0 +1,127 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_marker_init, tracefs_marker_close, tracefs_marker_print, tracefs_marker_vprint, tracefs_marker_write -
+Open, close and write data in the frace marker file.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_marker_init*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_marker_print*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_fmt_, _..._);
+int *tracefs_marker_vprint*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_fmt_, va_list _ap_);
+int *tracefs_marker_write*(struct tracefs_instance pass:[*]_instance_, void pass:[*]_data_, int _len_);
+void *tracefs_marker_close*(struct tracefs_instance pass:[*]_instance_);
+
+--
+
+DESCRIPTION
+-----------
+Set of functions to work with ftrace maker. See Documentation/trace/ftrace.rst from the Linux
+kernel tree for more information about ftrace marker functionality. All these APIs have _instance_
+as a first argument. If NULL is passed as _instance_, the top trace instance is used.
+
+The _tracefs_marker_init()_ function initializes the library for working with ftrace marker of
+the selected _instance_. It is not mandatory to call this API before working with the marker, any
+of the marker APIs will call it automatically, if the library is not yet initialized to work with
+the marker form given instance. But calling _tracefs_marker_init()_ in advance will speed up
+the other marker APIs.
+
+The _tracefs_marker_print()_ function writes a formatted string in the trace marker of the selected
+_instance_. The _fmt_ argument is a string in printf format, followed by variable arguments _..._.
+
+The _tracefs_marker_vprint()_ function writes a formatted string in the trace marker of the selected
+_instance_. The _fmt_ argument is a string in printf format, followed by list _ap_ of arguments.
+
+The _tracefs_marker_write()_ function writes a binary data in the trace marker of the selected
+_instance_. The _data_ points to the data with length _len_, that is going to be written in
+the trace marker.
+
+The _tracefs_marker_close()_ function closes the ftrace marker of the selected instance.
+
+RETURN VALUE
+------------
+The _tracefs_marker_init()_, _tracefs_marker_print()_, _tracefs_marker_vprint()_ and
+_tracefs_marker_write()_ functions return 0 if the operation is successful, or -1 in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+if (tracefs_marker_init(NULL) < 0) {
+ /* Failed to initialize the library with the ftrace marker of the top trace instance */
+}
+
+void foo_print(char *format, ...)
+{
+	va_list ap;
+	va_start(ap, format);
+	if (tracefs_marker_vprint(NULL, format, ap) < 0) {
+		/* Failed to print in the trace marker */
+	}
+	va_end(ap);
+}
+
+void foo_print_string(char *message)
+{
+	if (tracefs_marker_print(NULL, "Message from user space: %s", message) < 0) {
+		/* Failed to print in the trace marker */
+	}
+}
+
+unsigned int data = 0xdeadbeef;
+
+	if (tracefs_marker_write(NULL, &data, sizeof(data)) < 0) {
+		/* Failed to write in the trace marker */
+	}
+
+
+tracefs_marker_close();
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
+_trace-cmd(1)_,
+Documentation/trace/ftrace.rst from the Linux kernel tree
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
+
+COPYING
+-------
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.30.2

