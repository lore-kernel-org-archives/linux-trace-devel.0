Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCACC282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37762084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfDLNi1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40659 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfDLNi1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id z24so11160537wmi.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e4zoqIUhc24m0lhZmvGFYfefxJEB4lfbL7L7QxrfiEg=;
        b=kpt7NAKe2DzfWY/b/hNUVacrFfWAMtfv4Djx5bszKa6vnSUwg21vJF37O84m+rohjF
         Phaee1buCPUrZbrNwZzwxkxliyvij9yA1M7+Z7nO5CCYbw76Hmk1bCvwpV12UqHiN0Q9
         fFbg8bM6LqYs8X00CI7KtWjCreaMbK0+uXO8J/WZwvyRVZn/DVWmNR7dARUNGfIs6N94
         ahdBF9hdoe7rH7aJWcwExjQezfyvRk53BL86m4Nia1mmz3JcK3wiVPy8S9nM47D+m8WU
         FfyJ42sV27ENgkpv+heI2eFVMR+ojYNE01PdAmIXrjrkktNje80Lqi8kz2oKY74kc6l8
         SsiA==
X-Gm-Message-State: APjAAAVzpWCAM4mtG8K20LmfENcaPSCClLR4WHpVMIx6QcNcicfjhjfu
        byFTMc8SzAgYIQ/kkqpPY1U=
X-Google-Smtp-Source: APXvYqz8dR7WNWDcGWU05MmhM0vN4oVySotJL8Q7wlPXDOPvJ0tIvvf7YWtGaNxy8vcizjggk3GP1A==
X-Received: by 2002:a1c:7d42:: with SMTP id y63mr11220007wmc.113.1555076305556;
        Fri, 12 Apr 2019 06:38:25 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:24 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 14/30] tools/lib/traceevent: Man page for tep_read_number()
Date:   Fri, 12 Apr 2019 16:37:55 +0300
Message-Id: <20190412133811.15878-15-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_read_number() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-endian_read.txt             | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
new file mode 100644
index 000000000000..e64851b6e189
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_read_number - Reads a number from raw data.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, const void pass:[*]_ptr_, int _size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_read_number()_ function reads an integer from raw data, taking into
+account the endianness of the raw data and the current host. The _tep_ argument
+is the trace event parser context. The _ptr_ is a pointer to the raw data, where
+the integer is, and the _size_ is the size of the integer.
+
+RETURN VALUE
+------------
+The _tep_read_number()_ function returns the integer in the byte order of
+the current host. In case of an error, 0 is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+void process_record(struct tep_record *record)
+{
+	int offset = 24;
+	int data = tep_read_number(tep, record->data + offset, 4);
+
+	/* Read the 4 bytes at the offset 24 of data as an integer */
+}
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1

