Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF36FC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9956D206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfECJLe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41154 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfECJLe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id c12so6877874wrt.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e4zoqIUhc24m0lhZmvGFYfefxJEB4lfbL7L7QxrfiEg=;
        b=aRRH8v+G0eTb3BIkHTBTPCogYwt0Ft6QijlXWRtyxTnzGhxu8cfwScLyR9zAKoCvXW
         v0NX3Yoj0bru3A8qN4YB1XZKglrrqDmdNCVw2xCoLATS8b/9P074hndUbNZAYQwozKbp
         KQXhTUGFf2AIBJ1CJSbqxhC1e+7vkcvXsJUFoLRqJrZgwgYB+/GcSLQVykFgOULN5oA1
         1gxfEdRZ/zfghYZuL9aDprCgodEXv4B3qfoVmVjkUfePySO2/hNrk/UpIUOLDSrPdAT5
         d1VTcVup+gdztNpa0S10Z93/f3rJQE7r3kNt+11RFzSLt0Bw3+16q4TyqBWITK0L7Jza
         6ejQ==
X-Gm-Message-State: APjAAAWtYFTz5eIwuYAcCaIkWDStN/ZrazONX6TFEamXxyyojgCbTtWn
        loYLAXgs0rvFxJfCpUBUU6xEQzrL
X-Google-Smtp-Source: APXvYqwPVMWbRt3+/YRIviz5TRhOiy8W8VdYCuMfTR4g6MdgUDVyxWBN/htpw98Ts0qh7DCHsjf2uA==
X-Received: by 2002:a5d:654a:: with SMTP id z10mr6313078wrv.153.1556874692500;
        Fri, 03 May 2019 02:11:32 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:31 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 13/26] tools/lib/traceevent: Man page for tep_read_number()
Date:   Fri,  3 May 2019 12:11:06 +0300
Message-Id: <20190503091119.23399-14-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
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

